#[global_allocator]
static GLOBAL: tikv_jemallocator::Jemalloc = tikv_jemallocator::Jemalloc;

use gapttuk_server::cache::AppCache;
use gapttuk_server::{api, config, crawlers, db, health_check, middleware, push, AppState};

use axum::extract::ConnectInfo;
use axum::http::{header, HeaderName, HeaderValue, Method, StatusCode};
use axum::{extract::DefaultBodyLimit, routing::get, Router};
use metrics_exporter_prometheus::{Matcher, PrometheusBuilder, PrometheusHandle};
use sentry::integrations::tower::{NewSentryLayer, SentryHttpLayer};
use std::net::{IpAddr, SocketAddr};
use std::sync::Arc;
use tokio::signal;
use tower_http::{
    compression::CompressionLayer,
    cors::CorsLayer,
    request_id::{MakeRequestUuid, PropagateRequestIdLayer, SetRequestIdLayer},
    set_header::SetResponseHeaderLayer,
    timeout::TimeoutLayer,
    trace::TraceLayer,
};

/// graceful shutdown — Ctrl+C / SIGTERM 시그널 대기.
/// 타임아웃은 main()의 `tokio::time::timeout()`으로 제어 — pool.close() 보장.
async fn shutdown_signal() {
    let ctrl_c = async {
        signal::ctrl_c()
            .await
            .expect("Failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        signal::unix::signal(signal::unix::SignalKind::terminate())
            .expect("Failed to install SIGTERM handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        () = ctrl_c => tracing::info!("Ctrl+C received, shutting down..."),
        () = terminate => tracing::info!("SIGTERM received, shutting down..."),
    }
}

/// /metrics 접근 제한 — loopback/private IP만 허용.
/// IPv6 ULA(fc00::/7) 대역도 프라이빗으로 허용.
fn is_private_ip(ip: IpAddr) -> bool {
    match ip {
        IpAddr::V4(v4) => v4.is_loopback() || v4.is_private(),
        IpAddr::V6(v6) => {
            v6.is_loopback() || {
                let seg0 = v6.segments()[0];
                seg0 & 0xfe00 == 0xfc00 // ULA fc00::/7
            }
        }
    }
}

/// /metrics 핸들러 — Prometheus 메트릭 렌더링 (private IP 전용).
async fn metrics_handler(
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    axum::Extension(handle): axum::Extension<PrometheusHandle>,
) -> Result<String, StatusCode> {
    if is_private_ip(addr.ip()) {
        Ok(handle.render())
    } else {
        Err(StatusCode::FORBIDDEN)
    }
}

/// 파티션 유지보수 — api_access_logs + price_history에 현재월 + 3개월 미래 파티션 확보.
/// 개별 파티션 생성 실패 시 나머지를 계속 시도하고, 전체 실패 건수를 반환한다.
/// api_access_logs 파티션은 90일(3개월) 초과분을 자동 삭제한다 (price_history는 영구 보존).
async fn ensure_partitions(pool: &sqlx::PgPool) -> Result<(), String> {
    let now = chrono::Utc::now().date_naive();
    let mut errors = Vec::new();

    for offset in 0..=3i32 {
        let month = now + chrono::Months::new(offset as u32);
        let start = month.format("%Y-%m-01").to_string();
        let next = (month + chrono::Months::new(1))
            .format("%Y-%m-01")
            .to_string();
        let suffix = month.format("%Y_%m").to_string();

        for table in &["api_access_logs", "price_history"] {
            // SAFETY: table은 고정 슬라이스, suffix/start/next는 chrono 날짜 포맷 전용.
            // DDL은 PostgreSQL에서 bind 파라미터 불가하므로 format! 사용.
            assert!(["api_access_logs", "price_history"].contains(table));
            assert!(suffix
                .chars()
                .all(|c| c.is_ascii_alphanumeric() || c == '_'));
            let sql = format!(
                "CREATE TABLE IF NOT EXISTS {table}_{suffix} PARTITION OF {table} \
                 FOR VALUES FROM ('{start}') TO ('{next}')"
            );
            if let Err(e) = sqlx::query(&sql).execute(pool).await {
                tracing::warn!(table = %table, suffix = %suffix, error = %e, "Partition creation failed");
                errors.push(format!("{table}_{suffix}: {e}"));
            }
        }
    }

    // api_access_logs 파티션 자동 삭제 — 90일(3개월) 이전 파티션 삭제.
    // price_history는 영구 보존하므로 삭제하지 않는다.
    let cutoff = now - chrono::Months::new(3);
    let cutoff_suffix = cutoff.format("%Y_%m").to_string();

    // pg_inherits를 통해 api_access_logs의 파티션 목록 조회
    let rows = sqlx::query_as::<_, (String,)>(
        "SELECT c.relname \
         FROM pg_inherits i \
         JOIN pg_class c ON c.oid = i.inhrelid \
         JOIN pg_class p ON p.oid = i.inhparent \
         WHERE p.relname = 'api_access_logs' \
         ORDER BY c.relname",
    )
    .fetch_all(pool)
    .await;

    match rows {
        Ok(partitions) => {
            for (partition_name,) in partitions {
                // 파티션명은 반드시 "api_access_logs_YYYY_MM" 형식이어야 함
                let Some(suffix) = partition_name.strip_prefix("api_access_logs_") else {
                    continue;
                };
                // SAFETY: suffix를 alphanumeric + '_' 로 검증
                if !suffix
                    .chars()
                    .all(|c| c.is_ascii_alphanumeric() || c == '_')
                {
                    tracing::warn!(partition = %partition_name, "Unexpected partition name format, skipping");
                    continue;
                }
                // suffix 형식 "YYYY_MM" — 사전순 비교로 cutoff 이전 여부 판단
                if suffix < cutoff_suffix.as_str() {
                    let sql = format!("DROP TABLE IF EXISTS {partition_name}");
                    match sqlx::query(&sql).execute(pool).await {
                        Ok(_) => {
                            tracing::info!(partition = %partition_name, "Old api_access_logs partition dropped")
                        }
                        Err(e) => {
                            tracing::warn!(partition = %partition_name, error = %e, "Failed to drop old api_access_logs partition");
                            errors.push(format!("drop {partition_name}: {e}"));
                        }
                    }
                }
            }
        }
        Err(e) => {
            tracing::warn!(error = %e, "Failed to query api_access_logs partitions for cleanup");
            errors.push(format!("partition_list: {e}"));
        }
    }

    // price_history 2년 초과 파티션 아카이브 (1개/cycle)
    if let Err(e) = archive_old_price_history(pool).await {
        tracing::warn!(error = %e, "price_history archival issue");
        errors.push(e);
    }

    if errors.is_empty() {
        Ok(())
    } else {
        Err(format!(
            "{} partition(s) failed: {}",
            errors.len(),
            errors.join("; ")
        ))
    }
}

/// 파티션 bound 표현식에서 TO 날짜를 추출.
/// 예: "FOR VALUES FROM ('2024-01-01') TO ('2024-02-01')" → Some(2024-02-01)
fn extract_partition_to_date(bound_expr: &str) -> Option<chrono::NaiveDate> {
    let to_idx = bound_expr.find("TO ('")?;
    let start = to_idx + 5; // "TO ('" 길이
    let end = bound_expr[start..].find('\'')? + start;
    let date_str = &bound_expr[start..end];
    // pg_get_expr는 TIMESTAMPTZ 컬럼에 대해 "2024-02-01 00:00:00+00" 형식 반환
    // — 앞 10자(YYYY-MM-DD)만 사용
    let date_part = date_str.get(..10).unwrap_or(date_str);
    chrono::NaiveDate::parse_from_str(date_part, "%Y-%m-%d").ok()
}

/// 2년 이전 price_history 파티션을 price_history_monthly로 집계 후 DROP.
/// 한 번에 1개 파티션만 처리하여 부하 분산.
async fn archive_old_price_history(pool: &sqlx::PgPool) -> Result<(), String> {
    let cutoff = chrono::Utc::now().date_naive() - chrono::Months::new(24);

    // pg_get_expr로 파티션 경계 날짜를 직접 조회 — 이름 형식에 의존하지 않음 (CR-1)
    let rows = sqlx::query_as::<_, (String, String)>(
        "SELECT c.relname, pg_get_expr(c.relpartbound, c.oid) \
         FROM pg_inherits i \
         JOIN pg_class c ON c.oid = i.inhrelid \
         JOIN pg_class p ON p.oid = i.inhparent \
         WHERE p.relname = 'price_history' \
         ORDER BY c.relname",
    )
    .fetch_all(pool)
    .await
    .map_err(|e| format!("Failed to query price_history partitions: {e}"))?;

    for (partition_name, bound_expr) in rows {
        // 파티션 경계의 TO 날짜 파싱
        let Some(to_date) = extract_partition_to_date(&bound_expr) else {
            continue; // DEFAULT 파티션 또는 파싱 불가
        };

        if to_date > cutoff {
            continue; // 2년 미만 — 보존
        }

        // 파티션 이름 안전성 검사 (SQL injection 방지)
        if !partition_name
            .chars()
            .all(|c| c.is_ascii_alphanumeric() || c == '_')
        {
            tracing::warn!(partition = %partition_name, "Unexpected partition name format");
            continue;
        }

        tracing::info!(partition = %partition_name, "Archiving old price_history partition");

        // 단일 트랜잭션으로 집계→검증→DROP 원자적 실행 (CR-3, H-5)
        let mut tx = pool
            .begin()
            .await
            .map_err(|e| format!("BEGIN failed: {e}"))?;

        // 1. price_history_monthly로 집계 (멱등: ON CONFLICT DO NOTHING)
        let aggregate_sql = format!(
            "INSERT INTO price_history_monthly \
                 (product_id, year_month, avg_price, min_price, max_price, \
                  first_price, last_price, record_count, had_stockout) \
             SELECT \
                 product_id, \
                 DATE_TRUNC('month', recorded_at)::DATE, \
                 AVG(price)::INTEGER, \
                 MIN(price), \
                 MAX(price), \
                 (ARRAY_AGG(price ORDER BY recorded_at ASC))[1], \
                 (ARRAY_AGG(price ORDER BY recorded_at DESC))[1], \
                 COUNT(*)::INTEGER, \
                 BOOL_OR(is_out_of_stock) \
             FROM \"{}\" \
             GROUP BY product_id, DATE_TRUNC('month', recorded_at)::DATE \
             ON CONFLICT (product_id, year_month) DO NOTHING",
            partition_name
        );
        if let Err(e) = sqlx::query(&aggregate_sql).execute(&mut *tx).await {
            let _ = tx.rollback().await;
            tracing::warn!(partition = %partition_name, error = %e, "Aggregation failed, skipping DROP");
            return Err(format!("Aggregation of {partition_name} failed: {e}"));
        }

        // 2. 행 수 검증 — 해당 파티션의 product만 대상 (CR-2)
        let count_sql = format!("SELECT COUNT(*)::BIGINT FROM \"{}\"", partition_name);
        let (source_count,): (i64,) = sqlx::query_as(&count_sql)
            .fetch_one(&mut *tx)
            .await
            .map_err(|e| format!("Count query failed: {e}"))?;

        let verify_sql = format!(
            "SELECT COALESCE(SUM(record_count), 0)::BIGINT \
             FROM price_history_monthly \
             WHERE product_id IN (SELECT DISTINCT product_id FROM \"{}\") \
               AND year_month >= (SELECT MIN(DATE_TRUNC('month', recorded_at)::DATE) FROM \"{}\") \
               AND year_month <= (SELECT MAX(DATE_TRUNC('month', recorded_at)::DATE) FROM \"{}\")",
            partition_name, partition_name, partition_name
        );
        let (aggregated_count,): (i64,) = sqlx::query_as(&verify_sql)
            .fetch_one(&mut *tx)
            .await
            .map_err(|e| format!("Verify query failed: {e}"))?;

        if aggregated_count < source_count {
            let _ = tx.rollback().await;
            tracing::warn!(
                partition = %partition_name,
                source = source_count,
                aggregated = aggregated_count,
                "Row count mismatch — skipping DROP"
            );
            return Err(format!(
                "{partition_name}: count mismatch {source_count} vs {aggregated_count}"
            ));
        }

        // 3. 파티션 DROP (quoted identifier — H-1)
        let drop_sql = format!("DROP TABLE IF EXISTS \"{}\"", partition_name);
        match sqlx::query(&drop_sql).execute(&mut *tx).await {
            Ok(_) => {
                // 트랜잭션 커밋 — 집계+DROP 원자적 완료
                tx.commit()
                    .await
                    .map_err(|e| format!("COMMIT failed: {e}"))?;
                tracing::info!(
                    partition = %partition_name,
                    rows_archived = source_count,
                    "Old price_history partition archived and dropped"
                );
            }
            Err(e) => {
                let _ = tx.rollback().await;
                tracing::warn!(partition = %partition_name, error = %e, "Failed to drop archived partition");
                return Err(format!("DROP {partition_name} failed: {e}"));
            }
        }

        // 1개 파티션만 처리 후 종료 (부하 분산)
        break;
    }

    Ok(())
}

#[tokio::main]
async fn main() {
    // 1. tracing 초기화
    tracing_subscriber::fmt()
        .json()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "gapttuk_server=debug,tower_http=debug".into()),
        )
        .init();

    // 2. Config 로드 + Sentry 초기화
    let config = std::sync::Arc::new(config::Config::load());
    let _sentry_guard = config.sentry_dsn.as_ref().map(|dsn| {
        sentry::init((
            dsn.as_str(),
            sentry::ClientOptions {
                release: sentry::release_name!(),
                traces_sample_rate: 0.2,
                ..Default::default()
            },
        ))
    });

    // Prometheus 메트릭 레코더 설치 — HTTP 히스토그램에 30s 버킷 추가 (TimeoutLayer 경계)
    let prometheus_handle = PrometheusBuilder::new()
        .set_buckets_for_metric(
            Matcher::Full("http_request_duration_seconds".to_string()),
            &[
                0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0, 30.0,
            ],
        )
        .expect("valid histogram buckets")
        .install_recorder()
        .expect("Failed to install Prometheus recorder");

    tracing::info!(
        env = ?config.app_env,
        host = %config.host,
        port = config.port,
        "Starting gapttuk server"
    );

    // 3. DB 연결 + 마이그레이션
    let pool = db::init_pool(&config.database_url, config.database_max_connections).await;

    // 4. 캐시 초기화
    let cache = AppCache::new();
    tracing::info!("Cache initialized (moka in-memory)");

    // 5. 푸시 클라이언트 초기화
    let http_client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(30))
        .build()
        .expect("Failed to build HTTP client");
    let push_client = Arc::new(push::PushClient::new(&config, http_client.clone()));

    // 6. 크롤링 스케줄러 (Test 환경 skip)
    if config.app_env != config::AppEnv::Test {
        let crawler_service = Arc::new(crawlers::CrawlerService::new(
            pool.clone(),
            cache.clone(),
            push_client.clone(),
            config.database_max_connections,
        ));
        if let Err(e) =
            crawlers::scheduler::start_scheduler(crawler_service, config.crawl_on_start).await
        {
            tracing::error!(error = %e, "Failed to start crawler scheduler");
        }
    } else {
        tracing::info!("Skipping crawler scheduler in Test environment");
    }

    // 7. Access log bounded channel + worker
    let (log_tx, log_rx) = tokio::sync::mpsc::channel(10_000);
    middleware::access_log::spawn_writer(pool.clone(), log_rx);

    // 8. AppState 조합
    let state = AppState {
        pool: pool.clone(),
        cache,
        config: config.clone(),
        http_client,
        push_client,
        log_tx,
    };

    // 8. Router — 레이어 순서: 마지막 .layer()가 outermost
    let x_request_id = HeaderName::from_static("x-request-id");
    let (global_governor_layer, global_governor_config) = middleware::rate_limit::global_limiter();
    let (auth_governor_layer, auth_governor_config) = middleware::rate_limit::auth_limiter();
    let (search_governor_layer, search_governor_config) = middleware::rate_limit::search_limiter();

    // CORS 설정: ALLOWED_ORIGINS 환경변수로 제어. Prod에서 미설정 시 cross-origin 전면 차단.
    let cors_layer = if config.allowed_origins.is_empty() {
        if config.app_env == config::AppEnv::Prod {
            tracing::warn!(
                "ALLOWED_ORIGINS not set in Prod — all cross-origin requests will be blocked"
            );
        }
        // Dev/Test: 전체 허용, Prod: 빈 origin 목록으로 차단
        let base = CorsLayer::new()
            .allow_methods([Method::GET, Method::POST, Method::PATCH, Method::DELETE])
            .allow_headers([header::AUTHORIZATION, header::CONTENT_TYPE]);
        if config.app_env == config::AppEnv::Prod {
            base
        } else {
            base.allow_origin(tower_http::cors::Any)
        }
    } else {
        let origins: Vec<HeaderValue> = config
            .allowed_origins
            .iter()
            .filter_map(|o| o.parse().ok())
            .collect();
        CorsLayer::new()
            .allow_origin(origins)
            .allow_methods([Method::GET, Method::POST, Method::PATCH, Method::DELETE])
            .allow_headers([header::AUTHORIZATION, header::CONTENT_TYPE])
            .allow_credentials(true)
    };

    let app = Router::new()
        .route("/health", get(health_check))
        .route("/metrics", get(metrics_handler))
        .layer(axum::Extension(prometheus_handle))
        .nest(
            "/api/v1/auth",
            api::routes::auth::router().layer(auth_governor_layer),
        )
        .nest(
            "/api/v1/products",
            api::routes::products::router(search_governor_layer),
        )
        .nest("/api/v1/devices", api::routes::devices::router())
        .nest("/api/v1/alerts", api::routes::alerts::router())
        .nest(
            "/api/v1/notifications",
            api::routes::notifications::router(),
        )
        .nest("/api/v1/predictions", api::routes::predictions::router())
        .nest("/api/v1/rewards", api::routes::rewards::router())
        // innermost → outermost 순서
        .layer(DefaultBodyLimit::max(256 * 1024)) // 256 KB — Axum 기본 2MB 대신 앱 요구에 맞게 제한
        .layer(global_governor_layer)
        .layer(axum::middleware::from_fn_with_state(
            state.clone(),
            middleware::access_log::access_log,
        ))
        .layer(axum::middleware::from_fn_with_state(
            state.clone(),
            middleware::bot_guard::bot_guard,
        ))
        .layer(SetRequestIdLayer::new(
            x_request_id.clone(),
            MakeRequestUuid,
        ))
        .layer(PropagateRequestIdLayer::new(x_request_id))
        // Security response headers
        .layer(SetResponseHeaderLayer::overriding(
            header::X_CONTENT_TYPE_OPTIONS,
            HeaderValue::from_static("nosniff"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::X_FRAME_OPTIONS,
            HeaderValue::from_static("DENY"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::REFERRER_POLICY,
            HeaderValue::from_static("strict-origin-when-cross-origin"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::STRICT_TRANSPORT_SECURITY,
            HeaderValue::from_static("max-age=63072000; includeSubDomains"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            HeaderName::from_static("permissions-policy"),
            HeaderValue::from_static("camera=(), microphone=(), geolocation=()"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            HeaderName::from_static("content-security-policy"),
            HeaderValue::from_static("default-src 'none'"),
        ))
        .layer(CompressionLayer::new())
        .layer(TimeoutLayer::with_status_code(
            axum::http::StatusCode::REQUEST_TIMEOUT,
            std::time::Duration::from_secs(30),
        ))
        .layer(cors_layer)
        .layer(TraceLayer::new_for_http())
        // Sentry 레이어: outermost — sentry_dsn 미설정 시 no-op (Hub은 항상 유효)
        // sentry_dsn이 설정된 경우에만 실제 트랜잭션/에러 캡처 활성화됨
        .layer(SentryHttpLayer::with_transaction())
        .layer(NewSentryLayer::new_from_top())
        .with_state(state.clone());

    // 9. 백그라운드 유지보수 (Test 환경 skip)
    if config.app_env != config::AppEnv::Test {
        // 9a. 파티션 유지보수 (일일)
        let partition_pool = pool.clone();
        let h_partition = tokio::spawn(async move {
            let mut interval = tokio::time::interval(std::time::Duration::from_secs(86400));
            loop {
                interval.tick().await;
                if let Err(e) = ensure_partitions(&partition_pool).await {
                    tracing::error!(error = %e, "Partition maintenance failed");
                } else {
                    tracing::info!("Partition maintenance completed");
                }
            }
        });

        // 9b. Governor rate limiter 메모리 정리 (1시간 주기)
        // 내부 HashMap에 IP별 상태가 무한 누적되므로 주기적 GC 필요.
        // 시작 직후 빈 맵 GC는 무의미하므로 interval_at으로 1시간 후부터 시작.
        let gc_period = std::time::Duration::from_secs(3600);
        let h_gc = tokio::spawn(async move {
            let mut interval =
                tokio::time::interval_at(tokio::time::Instant::now() + gc_period, gc_period);
            loop {
                interval.tick().await;
                global_governor_config.limiter().retain_recent();
                auth_governor_config.limiter().retain_recent();
                search_governor_config.limiter().retain_recent();
                tracing::debug!("Governor rate limiter GC completed");
            }
        });

        // 9c. Refresh token 정리 (6시간 주기)
        // 만료됐거나 revoke된 토큰을 주기적으로 삭제하여 테이블 비대화 방지.
        let purge_pool = pool.clone();
        let purge_period = std::time::Duration::from_secs(6 * 3600);
        let h_purge = tokio::spawn(async move {
            let mut interval =
                tokio::time::interval_at(tokio::time::Instant::now() + purge_period, purge_period);
            loop {
                interval.tick().await;
                match sqlx::query(
                    "DELETE FROM refresh_tokens WHERE revoked_at IS NOT NULL OR expires_at < NOW()",
                )
                .execute(&purge_pool)
                .await
                {
                    Ok(result) => {
                        let count = result.rows_affected();
                        if count > 0 {
                            tracing::info!(deleted = count, "Refresh token purge completed");
                        }
                    }
                    Err(e) => tracing::warn!(error = %e, "Refresh token purge failed"),
                }
            }
        });

        // 9d. 백그라운드 태스크 패닉 감시 + Sentry 보고
        // 각 태스크는 내부 loop에서 에러를 개별 처리하므로 정상적으로는 종료되지 않음.
        // 패닉 발생 시 로그 + Sentry 보고 + 메트릭 기록.
        for (name, handle) in [
            ("Partition maintenance", h_partition),
            ("Governor GC", h_gc),
            ("Token purge", h_purge),
        ] {
            tokio::spawn(async move {
                match handle.await {
                    Ok(()) => {
                        tracing::error!("{name} task exited unexpectedly");
                        metrics::counter!("background_task_exit", "task" => name, "reason" => "normal").increment(1);
                    }
                    Err(e) => {
                        tracing::error!(error = %e, "{name} task panicked — requires restart");
                        metrics::counter!("background_task_exit", "task" => name, "reason" => "panic").increment(1);
                    }
                }
            });
        }
    }

    // 10. 서버 시작
    let addr: SocketAddr = format!("{}:{}", &config.host, config.port)
        .parse()
        .expect("Invalid host:port");

    tracing::info!(%addr, "Server listening");

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .expect("Failed to bind address");

    // into_make_service_with_connect_info는 SmartIpKeyExtractor 폴백 + bot_guard/access_log에 필수
    // timeout 래퍼로 셧다운 드레인 제한 — pool.close() 실행 보장
    match tokio::time::timeout(
        std::time::Duration::from_secs(30),
        axum::serve(
            listener,
            app.into_make_service_with_connect_info::<SocketAddr>(),
        )
        .with_graceful_shutdown(shutdown_signal()),
    )
    .await
    {
        Ok(Ok(())) => tracing::info!("Server shut down gracefully"),
        Ok(Err(e)) => tracing::error!(error = %e, "Server error"),
        Err(_) => tracing::warn!("Graceful shutdown timed out after 30s"),
    }

    // 11. 정리 — 타임아웃 시에도 반드시 실행되어 DB 커넥션 정리
    pool.close().await;
    tracing::info!("Cleanup complete, exiting");
}

#[cfg(test)]
mod archive_tests {
    use super::*;

    #[test]
    fn parse_partition_bound_extracts_to_date() {
        let expr = "FOR VALUES FROM ('2024-01-01') TO ('2024-02-01')";
        let to_date = extract_partition_to_date(expr);
        assert_eq!(
            to_date,
            Some(chrono::NaiveDate::from_ymd_opt(2024, 2, 1).unwrap())
        );
    }

    #[test]
    fn parse_partition_bound_default_returns_none() {
        assert_eq!(extract_partition_to_date("DEFAULT"), None);
    }

    #[test]
    fn parse_partition_bound_malformed_returns_none() {
        assert_eq!(extract_partition_to_date("garbage"), None);
    }

    #[test]
    fn parse_partition_bound_timestamptz_format() {
        let expr = "FOR VALUES FROM ('2024-01-01 00:00:00+00') TO ('2024-02-01 00:00:00+00')";
        let to_date = extract_partition_to_date(expr);
        assert_eq!(
            to_date,
            Some(chrono::NaiveDate::from_ymd_opt(2024, 2, 1).unwrap())
        );
    }
}
