use chrono::{DateTime, Utc};
use serde::Serialize;
use sqlx::PgPool;

use crate::cache::AppCache;
use crate::error::AppError;
use crate::models::{PopularSearch, PriceTrend, Product};

// ── DTO ─────────────────────────────────────────────────

/// 검색 결과 경량 DTO
#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct ProductSearchItem {
    pub id: i64,
    pub product_name: String,
    pub image_url: Option<String>,
    pub current_price: Option<i32>,
    pub lowest_price: Option<i32>,
    pub is_out_of_stock: bool,
    pub price_trend: Option<PriceTrend>,
    pub buy_timing_score: Option<i16>,
    pub shopping_mall_id: i32,
}

/// 요일별 가격 집계
#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct DailyPriceAggregate {
    pub day_of_week: i32,
    pub avg_price: Option<i32>,
    pub min_price: Option<i32>,
    pub max_price: Option<i32>,
    pub sample_count: i64,
}

/// URL로 상품 추가 응답
#[derive(Debug, Serialize)]
pub struct AddProductResponse {
    pub id: i64,
    pub product_name: String,
    pub product_url: Option<String>,
    pub shopping_mall_id: i32,
    pub is_new: bool,
}

/// 쿠팡 URL에서 파싱한 상품 식별 정보
#[derive(Debug, PartialEq)]
pub struct CoupangUrlInfo {
    pub product_id: String,
    pub vendor_item_id: Option<String>,
}

// ── URL 파싱 ────────────────────────────────────────────

/// 쿠팡 상품 URL을 파싱하여 product_id와 vendor_item_id를 추출한다.
///
/// 지원 형식:
/// - `https://www.coupang.com/vp/products/{product_id}?vendorItemId={vid}`
/// - `https://www.coupang.com/vp/products/{product_id}` (vendorItemId 없음)
pub fn parse_coupang_url(url_str: &str) -> Result<CoupangUrlInfo, AppError> {
    // URL 길이 제한
    if url_str.len() > 2048 {
        return Err(AppError::BadRequest("URL은 2048자 이하여야 합니다".to_string()));
    }

    let url = reqwest::Url::parse(url_str)
        .map_err(|_| AppError::BadRequest("유효하지 않은 URL입니다".to_string()))?;

    let host = url.host_str().unwrap_or_default();
    if host != "coupang.com" && host != "www.coupang.com" && !host.ends_with(".coupang.com") {
        return Err(AppError::BadRequest(
            "현재 쿠팡 URL만 지원합니다".to_string(),
        ));
    }

    // /vp/products/{product_id} 패턴 파싱
    let segments: Vec<&str> = url.path_segments().map(|s| s.collect()).unwrap_or_default();

    // ["vp", "products", "{id}", ...]
    let product_id = segments
        .iter()
        .position(|&s| s == "products")
        .and_then(|i| segments.get(i + 1))
        .filter(|s| !s.is_empty())
        .ok_or_else(|| AppError::BadRequest("상품 ID를 URL에서 찾을 수 없습니다".to_string()))?
        .to_string();

    // vendorItemId 쿼리 파라미터
    let vendor_item_id = url
        .query_pairs()
        .find(|(k, _)| k == "vendorItemId")
        .map(|(_, v)| v.to_string());

    Ok(CoupangUrlInfo {
        product_id,
        vendor_item_id,
    })
}

// ── 서비스 함수 ─────────────────────────────────────────

/// 상품 상세 조회 (캐시 적용)
pub async fn get_product(pool: &PgPool, cache: &AppCache, id: i64) -> Result<Product, AppError> {
    // 캐시 히트 확인
    if let Some(product) = cache.products.get(&id).await {
        return Ok(product);
    }

    let product: Product = sqlx::query_as("SELECT * FROM products WHERE id = $1")
        .bind(id)
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| AppError::NotFound("상품".to_string()))?;

    // 캐시 저장
    cache.products.insert(id, product.clone()).await;

    Ok(product)
}

/// 키워드 검색 (ILIKE, 커서 기반 페이지네이션, 선택적 필터/정렬)
///
/// - `filter`: `"near_stockout"` | `"all_time_low"` | `"declining"` | `"under_10k"`
/// - `sort`: `"ranking"` | `"discount_rate"` | `"discount_amount"` | `"lowest_price"`
pub async fn search_products(
    pool: &PgPool,
    query: &str,
    cursor: Option<i64>,
    limit: i64,
    filter: Option<&str>,
    sort: Option<&str>,
) -> Result<Vec<ProductSearchItem>, AppError> {
    // ILIKE 와일드카드 문자 이스케이프 (%, _, \)
    let escaped = query
        .replace('\\', "\\\\")
        .replace('%', "\\%")
        .replace('_', "\\_");
    let pattern = format!("%{}%", escaped);
    let fetch_limit = limit + 1; // limit+1 패턴

    // 필터 조건 SQL 절
    // NOTE: products 테이블에는 stock_status 컬럼이 없으므로
    //       near_stockout은 buy_timing_score가 높고 재고 있는 상품으로 근사
    let filter_clause = match filter {
        Some("near_stockout") => {
            // 재고 있는 상품 중 구매 타이밍 점수가 높은(70+) 상품
            " AND is_out_of_stock = FALSE AND buy_timing_score >= 70"
        }
        Some("all_time_low") => {
            " AND current_price IS NOT NULL AND lowest_price IS NOT NULL \
              AND current_price <= lowest_price"
        }
        Some("declining") => {
            // PriceTrend::Falling — snake_case 직렬화 → 'falling'
            " AND price_trend = 'falling'"
        }
        Some("under_10k") => {
            " AND current_price IS NOT NULL AND current_price < 10000"
        }
        _ => "",
    };

    // 정렬 ORDER BY 절 (커서 기반 페이지네이션과 함께 사용할 때 id를 보조 정렬키로 추가)
    let order_clause = match sort {
        Some("discount_rate") => {
            // discount_rate 컬럼이 없으므로 (original_price - current_price) / original_price 근사
            // products 테이블에 discount_rate 컬럼이 있다면 그것을 직접 사용
            "ORDER BY (CASE WHEN highest_price IS NOT NULL AND highest_price > 0 AND current_price IS NOT NULL \
                            THEN (highest_price - current_price) \
                            ELSE 0 END) DESC, id DESC"
        }
        Some("discount_amount") => {
            "ORDER BY (CASE WHEN highest_price IS NOT NULL AND current_price IS NOT NULL \
                            THEN (highest_price - current_price) \
                            ELSE 0 END) DESC, id DESC"
        }
        Some("lowest_price") => {
            "ORDER BY current_price ASC NULLS LAST, id DESC"
        }
        _ => "ORDER BY id DESC", // "ranking" 또는 기본값
    };

    // 커서 조건: 정렬이 id DESC인 경우 id < cursor 사용.
    // discount_rate/discount_amount/lowest_price 정렬 시에는 커서를 id 기반으로 단순 처리.
    let use_cursor = cursor.is_some() && matches!(sort, None | Some("ranking"));
    let cursor_clause = if use_cursor { " AND id < $2" } else { "" };
    let param_n = if use_cursor { 3 } else { 2 };

    let sql = format!(
        "SELECT id, product_name, image_url, current_price, lowest_price,
                is_out_of_stock, price_trend, buy_timing_score, shopping_mall_id
         FROM products
         WHERE product_name ILIKE $1
         {filter_clause}
         {cursor_clause}
         {order_clause}
         LIMIT ${param_n}",
        filter_clause = filter_clause,
        cursor_clause = cursor_clause,
        order_clause = order_clause,
        param_n = param_n,
    );

    let items: Vec<ProductSearchItem> = if use_cursor {
        // 안전: use_cursor가 true이면 cursor는 반드시 Some
        sqlx::query_as(&sql)
            .bind(&pattern)
            .bind(cursor.expect("use_cursor=true이면 cursor는 Some"))
            .bind(fetch_limit)
            .fetch_all(pool)
            .await?
    } else {
        sqlx::query_as(&sql)
            .bind(&pattern)
            .bind(fetch_limit)
            .fetch_all(pool)
            .await?
    };

    Ok(items)
}

/// URL로 상품 추가 (placeholder 등록 — 실제 크롤링은 M1-6)
///
/// `INSERT ON CONFLICT DO NOTHING`으로 TOCTOU 레이스 컨디션 방지.
pub async fn add_product_by_url(
    pool: &PgPool,
    cache: &AppCache,
    url_str: &str,
) -> Result<AddProductResponse, AppError> {
    let info = parse_coupang_url(url_str)?;

    // 쿠팡 shopping_mall_id 조회
    let mall_id: i32 = sqlx::query_scalar("SELECT id FROM shopping_malls WHERE code = 'coupang'")
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| AppError::Internal("쿠팡 쇼핑몰 설정이 없습니다".to_string()))?;

    // INSERT ON CONFLICT DO NOTHING — 동시 요청에도 안전
    sqlx::query(
        "INSERT INTO products (shopping_mall_id, external_product_id, vendor_item_id, product_name, product_url)
         VALUES ($1, $2, $3, '가격 추적 대기 중', $4)
         ON CONFLICT (shopping_mall_id, external_product_id, vendor_item_id) DO NOTHING",
    )
    .bind(mall_id)
    .bind(&info.product_id)
    .bind(&info.vendor_item_id)
    .bind(url_str)
    .execute(pool)
    .await?;

    // 삽입 여부와 무관하게 조회 (ON CONFLICT DO NOTHING은 RETURNING 불가일 수 있음)
    let product: Product = sqlx::query_as(
        "SELECT * FROM products
         WHERE shopping_mall_id = $1 AND external_product_id = $2
           AND (vendor_item_id = $3 OR ($3::text IS NULL AND vendor_item_id IS NULL))",
    )
    .bind(mall_id)
    .bind(&info.product_id)
    .bind(&info.vendor_item_id)
    .fetch_one(pool)
    .await?;

    // 캐시에 상품 저장 (get_product 캐시 일관성 보장)
    cache.products.insert(product.id, product.clone()).await;

    // product_name이 placeholder면 방금 삽입된 것
    let is_new = product.product_name == "가격 추적 대기 중";

    Ok(AddProductResponse {
        id: product.id,
        product_name: product.product_name,
        product_url: product.product_url,
        shopping_mall_id: product.shopping_mall_id,
        is_new,
    })
}

/// 상품 존재 확인 — 존재하지 않으면 NotFound 반환.
async fn ensure_product_exists(pool: &PgPool, product_id: i64) -> Result<(), AppError> {
    let exists: Option<i64> = sqlx::query_scalar("SELECT id FROM products WHERE id = $1")
        .bind(product_id)
        .fetch_optional(pool)
        .await?;
    if exists.is_none() {
        return Err(AppError::NotFound("상품".to_string()));
    }
    Ok(())
}

/// 가격 이력 조회 (커서 기반 페이지네이션)
pub async fn get_price_history(
    pool: &PgPool,
    product_id: i64,
    from: Option<DateTime<Utc>>,
    to: Option<DateTime<Utc>>,
    cursor: Option<i64>,
    limit: i64,
) -> Result<Vec<crate::models::PriceHistory>, AppError> {
    ensure_product_exists(pool, product_id).await?;

    let fetch_limit = limit + 1;

    let items = sqlx::query_as::<_, crate::models::PriceHistory>(
        "SELECT id, product_id, price, is_out_of_stock, recorded_at
         FROM price_history
         WHERE product_id = $1
           AND ($2::timestamptz IS NULL OR recorded_at >= $2)
           AND ($3::timestamptz IS NULL OR recorded_at <= $3)
           AND ($4::bigint IS NULL OR id < $4)
         ORDER BY id DESC
         LIMIT $5",
    )
    .bind(product_id)
    .bind(from)
    .bind(to)
    .bind(cursor)
    .bind(fetch_limit)
    .fetch_all(pool)
    .await?;

    Ok(items)
}

/// 요일별 가격 집계 (최대 7행)
pub async fn get_daily_price_aggregates(
    pool: &PgPool,
    product_id: i64,
) -> Result<Vec<DailyPriceAggregate>, AppError> {
    ensure_product_exists(pool, product_id).await?;

    let aggregates: Vec<DailyPriceAggregate> = sqlx::query_as(
        "SELECT EXTRACT(DOW FROM recorded_at)::int AS day_of_week,
                AVG(price)::int AS avg_price,
                MIN(price) AS min_price,
                MAX(price) AS max_price,
                COUNT(*) AS sample_count
         FROM price_history
         WHERE product_id = $1
         GROUP BY day_of_week
         ORDER BY day_of_week",
    )
    .bind(product_id)
    .fetch_all(pool)
    .await?;

    Ok(aggregates)
}

/// 인기 검색어 조회 (캐시 적용).
/// DB에서는 항상 최대 50건을 캐시하고, 응답 시 limit으로 잘라냄.
const POPULAR_SEARCHES_CACHE_MAX: i32 = 50;

pub async fn get_popular_searches(
    pool: &PgPool,
    cache: &AppCache,
    limit: i32,
) -> Result<Vec<PopularSearch>, AppError> {
    let cache_key = "top".to_string();
    if let Some(cached) = cache.popular_searches.get(&cache_key).await {
        return Ok(cached.into_iter().take(limit as usize).collect());
    }

    let items: Vec<PopularSearch> =
        sqlx::query_as("SELECT * FROM popular_searches ORDER BY rank ASC LIMIT $1")
            .bind(POPULAR_SEARCHES_CACHE_MAX)
            .fetch_all(pool)
            .await?;

    cache
        .popular_searches
        .insert(cache_key, items.clone())
        .await;

    Ok(items.into_iter().take(limit as usize).collect())
}

// ── 테스트 ──────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_coupang_url_full() {
        let url = "https://www.coupang.com/vp/products/123456?vendorItemId=789";
        let info = parse_coupang_url(url).unwrap();
        assert_eq!(
            info,
            CoupangUrlInfo {
                product_id: "123456".to_string(),
                vendor_item_id: Some("789".to_string()),
            }
        );
    }

    #[test]
    fn parse_coupang_url_no_vendor() {
        let url = "https://www.coupang.com/vp/products/123456";
        let info = parse_coupang_url(url).unwrap();
        assert_eq!(
            info,
            CoupangUrlInfo {
                product_id: "123456".to_string(),
                vendor_item_id: None,
            }
        );
    }

    #[test]
    fn parse_coupang_url_invalid_host() {
        let url = "https://www.naver.com/products/123";
        let result = parse_coupang_url(url);
        assert!(result.is_err());
    }

    #[test]
    fn parse_coupang_url_no_product_id() {
        let url = "https://www.coupang.com/vp/products/";
        let result = parse_coupang_url(url);
        assert!(result.is_err());
    }

    #[test]
    fn test_evil_coupang_domain_rejected() {
        let url = "https://evilcoupang.com/vp/products/123";
        let result = parse_coupang_url(url);
        assert!(result.is_err());
    }

    #[test]
    fn test_url_too_long() {
        // 2049자 URL 생성
        let long_path = "a".repeat(2049 - "https://www.coupang.com/".len());
        let url = format!("https://www.coupang.com/{}", long_path);
        assert!(url.len() > 2048);
        let result = parse_coupang_url(&url);
        assert!(result.is_err());
        // 에러 메시지 확인
        let err_msg = format!("{}", result.unwrap_err());
        assert!(err_msg.contains("2048"));
    }
}
