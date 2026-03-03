pub mod coupang;
pub mod scheduler;
pub mod stats;
mod ua;

use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::time::Instant;

use rand::Rng;
use tokio::sync::Semaphore;
use tokio::task::JoinSet;

use crate::cache::AppCache;
use crate::push::PushClient;
use coupang::{CrawlError, CrawlResult};

/// 크롤링 주기 통계
pub struct CycleStats {
    pub total: usize,
    pub success: usize,
    pub failed: usize,
    pub skipped_no_change: usize,
    pub duration_secs: f64,
}

/// 크롤러 서비스 — 쿠팡 상품 가격 수집 + products 통계 갱신 + 알림 평가.
pub struct CrawlerService {
    pool: sqlx::PgPool,
    cache: AppCache,
    push_client: Arc<PushClient>,
    client: reqwest::Client,
    semaphore: Arc<Semaphore>,
}

impl CrawlerService {
    /// 크롤러 전용 HTTP 클라이언트로 생성 (cookie_store 활성화).
    pub fn new(pool: sqlx::PgPool, cache: AppCache, push_client: Arc<PushClient>) -> Self {
        let client = reqwest::Client::builder()
            .cookie_store(true)
            .timeout(std::time::Duration::from_secs(30))
            .build()
            .expect("Failed to build crawler HTTP client");

        Self {
            pool,
            cache,
            push_client,
            client,
            semaphore: Arc::new(Semaphore::new(8)), // CPU↑: 5→8 동시 크롤링
        }
    }

    /// 전체 크롤링 주기 실행 (분산 잠금 포함).
    /// pg_try_advisory_lock으로 동시 크롤링 방지 — 다중 인스턴스 환경에서 안전.
    pub async fn run_cycle(&self) -> CycleStats {
        let acquired: bool = sqlx::query_scalar("SELECT pg_try_advisory_lock(842937)")
            .fetch_one(&self.pool)
            .await
            .unwrap_or(false);
        if !acquired {
            tracing::info!("크롤링 잠금 획득 실패 — 다른 인스턴스가 실행 중");
            return CycleStats {
                total: 0,
                success: 0,
                failed: 0,
                skipped_no_change: 0,
                duration_secs: 0.0,
            };
        }
        let stats = self.run_cycle_inner().await;
        let _ = sqlx::query("SELECT pg_advisory_unlock(842937)")
            .execute(&self.pool)
            .await;
        stats
    }

    /// 실제 크롤링 주기 실행 (내부 구현).
    async fn run_cycle_inner(&self) -> CycleStats {
        let start = Instant::now();

        // 1. DB에서 쿠팡 상품 전체 조회 (shopping_malls.code = 'coupang' 조인)
        let products = match sqlx::query_as::<_, ProductRow>(
            r#"
            SELECT p.id, p.product_url
            FROM products p
            JOIN shopping_malls sm ON sm.id = p.shopping_mall_id
            WHERE sm.code = 'coupang'
              AND p.product_url IS NOT NULL
            "#,
        )
        .fetch_all(&self.pool)
        .await
        {
            Ok(p) => p,
            Err(e) => {
                tracing::error!(error = %e, "Failed to fetch products for crawling");
                return CycleStats {
                    total: 0,
                    success: 0,
                    failed: 0,
                    skipped_no_change: 0,
                    duration_secs: start.elapsed().as_secs_f64(),
                };
            }
        };

        let total = products.len();
        tracing::info!(total, "Starting crawl cycle");

        // 2. 셔플 (요청 패턴 분산)
        let mut products = products;
        {
            use rand::seq::SliceRandom;
            let mut rng = rand::thread_rng();
            products.shuffle(&mut rng);
        }

        // 3. abort flag — 403/429 감지 시 전체 중단
        let abort_flag = Arc::new(AtomicBool::new(false));

        // 4. 동시 크롤링 (JoinSet + sliding window 배치)
        const BATCH_SIZE: usize = 50;
        let mut set = JoinSet::new();
        let mut success = 0usize;
        let mut failed = 0usize;
        let mut skipped = 0usize;

        for chunk in products.chunks(BATCH_SIZE) {
            for product in chunk {
                let pool = self.pool.clone();
                let cache = self.cache.clone();
                let push = self.push_client.clone();
                let client = self.client.clone();
                let sem = self.semaphore.clone();
                let abort = abort_flag.clone();
                let product_id = product.id;
                let product_url = product.product_url.clone();

                set.spawn(async move {
                    // abort 확인
                    if abort.load(Ordering::Relaxed) {
                        return ScrapeOutcome::Aborted;
                    }

                    // 랜덤 딜레이 3~10초 — permit 획득 전에 sleep하여 슬롯 낭비 방지
                    let delay = rand::thread_rng().gen_range(3..=10);
                    tokio::time::sleep(std::time::Duration::from_secs(delay)).await;

                    // Semaphore 획득 — closed 시 panic 대신 Aborted 반환
                    let _permit = match sem.acquire().await {
                        Ok(p) => p,
                        Err(_) => return ScrapeOutcome::Aborted,
                    };

                    // permit 획득 후 abort 재확인
                    if abort.load(Ordering::Relaxed) {
                        return ScrapeOutcome::Aborted;
                    }

                    let url = match &product_url {
                        Some(u) => u.as_str(),
                        None => return ScrapeOutcome::Failed,
                    };

                    match scrape_and_update(&pool, &cache, &push, &client, product_id, url, &abort)
                        .await
                    {
                        Ok(changed) => {
                            if changed {
                                ScrapeOutcome::Updated
                            } else {
                                ScrapeOutcome::NoChange
                            }
                        }
                        Err(_) => ScrapeOutcome::Failed,
                    }
                });
            }

            // 현재 배치가 절반 이하가 될 때까지 결과 수확
            while set.len() > BATCH_SIZE / 2 {
                if let Some(result) = set.join_next().await {
                    tally_outcome(result, &mut success, &mut failed, &mut skipped);
                }
            }
        }

        // 잔여 태스크 수확
        while let Some(result) = set.join_next().await {
            tally_outcome(result, &mut success, &mut failed, &mut skipped);
        }

        let stats = CycleStats {
            total,
            success,
            failed,
            skipped_no_change: skipped,
            duration_secs: start.elapsed().as_secs_f64(),
        };

        // Prometheus 메트릭 기록
        metrics::histogram!("crawler_cycle_duration_seconds").record(stats.duration_secs);
        metrics::counter!("crawler_products_total", "status" => "success")
            .increment(stats.success as u64);
        metrics::counter!("crawler_products_total", "status" => "failed")
            .increment(stats.failed as u64);
        metrics::counter!("crawler_products_total", "status" => "skipped")
            .increment(stats.skipped_no_change as u64);
        metrics::gauge!("crawler_products_tracked").set(stats.total as f64);

        tracing::info!(
            total = stats.total,
            success = stats.success,
            failed = stats.failed,
            skipped = stats.skipped_no_change,
            duration_secs = format!("{:.1}", stats.duration_secs),
            "Crawl cycle completed"
        );

        // 크롤링 완료 후 인기 검색어 자동 갱신 + 캐시 무효화
        match stats::refresh_popular_searches(&self.pool).await {
            Ok(count) => {
                self.cache
                    .popular_searches
                    .invalidate(&"top".to_string())
                    .await;
                tracing::info!(count, "Popular searches refreshed");
            }
            Err(e) => tracing::warn!(error = %e, "Popular searches refresh failed"),
        }

        stats
    }
}

/// 단일 상품 스크래핑 + DB 갱신 + 알림 평가.
/// 가격 변동이 있으면 `true`, 없으면 `false` 반환.
async fn scrape_and_update(
    pool: &sqlx::PgPool,
    cache: &AppCache,
    push: &PushClient,
    client: &reqwest::Client,
    product_id: i64,
    product_url: &str,
    abort_flag: &AtomicBool,
) -> Result<bool, CrawlError> {
    // 1. 스크래핑 (3회 재시도)
    let result =
        coupang::scrape_product_page(client, product_id, product_url, abort_flag, 2).await?;

    // 2. 가격이 없으면 품절 처리만
    let new_price = match result.price {
        Some(p) => p,
        None if result.is_out_of_stock => {
            // 품절 상태만 업데이트
            sqlx::query(
                "UPDATE products SET is_out_of_stock = true, updated_at = NOW() WHERE id = $1",
            )
            .bind(product_id)
            .execute(pool)
            .await?;
            cache.products.invalidate(&product_id).await;
            return Ok(true);
        }
        None => return Ok(false), // 파싱 실패 — skip
    };

    // 3. 현재 가격 조회
    let current =
        sqlx::query_scalar::<_, Option<i32>>("SELECT current_price FROM products WHERE id = $1")
            .bind(product_id)
            .fetch_one(pool)
            .await?;

    let price_changed = current != Some(new_price);

    // 4. 가격 변동 시에만 price_history INSERT
    if price_changed {
        sqlx::query(
            "INSERT INTO price_history (product_id, price, is_out_of_stock) VALUES ($1, $2, $3)",
        )
        .bind(product_id)
        .bind(new_price)
        .bind(result.is_out_of_stock)
        .execute(pool)
        .await?;
    }

    // 5. 가격 변동 시 알림 평가 — 반드시 stats 갱신 전에 실행!
    //    stats::refresh_product_stats()가 lowest_price/average_price를 업데이트하면
    //    AllTimeLow/BelowAverage 조건이 정상 작동하지 않는다.
    if price_changed {
        if let Err(e) =
            crate::services::alert_service::evaluate_price_alerts(pool, push, product_id, new_price)
                .await
        {
            tracing::warn!(product_id, error = %e, "Alert evaluation failed");
        }
    }

    // 6. 상품명/이미지 업데이트 (크롤링에서 얻은 값이 있으면)
    update_product_metadata(pool, &result).await?;

    // 7. 통계 갱신 (10개 필드) — 알림 평가 이후에 실행
    stats::refresh_product_stats(pool, product_id, new_price, result.is_out_of_stock).await?;

    // 8. 캐시 즉시 무효화
    cache.products.invalidate(&product_id).await;

    Ok(price_changed)
}

/// 상품명, 이미지 URL 업데이트 (크롤링 결과가 있을 때).
/// COALESCE로 단일 쿼리 — NULL 파라미터는 기존 값 유지.
async fn update_product_metadata(
    pool: &sqlx::PgPool,
    result: &CrawlResult,
) -> Result<(), sqlx::Error> {
    if result.product_name.is_none() && result.image_url.is_none() {
        return Ok(());
    }

    sqlx::query(
        "UPDATE products SET product_name = COALESCE($2, product_name), image_url = COALESCE($3, image_url), updated_at = NOW() WHERE id = $1",
    )
    .bind(result.product_id)
    .bind(&result.product_name)
    .bind(&result.image_url)
    .execute(pool)
    .await?;

    Ok(())
}

/// JoinSet 결과를 집계 카운터에 반영
fn tally_outcome(
    result: Result<ScrapeOutcome, tokio::task::JoinError>,
    success: &mut usize,
    failed: &mut usize,
    skipped: &mut usize,
) {
    match result {
        Ok(ScrapeOutcome::Updated) => *success += 1,
        Ok(ScrapeOutcome::NoChange) => *skipped += 1,
        Ok(ScrapeOutcome::Failed) | Ok(ScrapeOutcome::Aborted) | Err(_) => *failed += 1,
    }
}

/// 크롤링 결과 분류
enum ScrapeOutcome {
    Updated,
    NoChange,
    Failed,
    Aborted,
}

/// DB 상품 행 (크롤링용 최소 필드)
#[derive(sqlx::FromRow)]
struct ProductRow {
    id: i64,
    product_url: Option<String>,
}
