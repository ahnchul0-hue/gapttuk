mod api;
mod auth;
mod cache;
mod config;
mod crawlers;
mod db;
mod error;
mod middleware;
mod models;
mod services;

use api::ApiResponse;
use cache::AppCache;
use config::Config;
use error::AppError;

use axum::{extract::State, routing::get, Router};
use serde::Serialize;
use std::net::SocketAddr;
use tokio::signal;
use tower_http::{
    request_id::{MakeRequestUuid, PropagateRequestIdLayer, SetRequestIdLayer},
    trace::TraceLayer,
};

use axum::http::HeaderName;

/// 공유 애플리케이션 상태 — `State<AppState>`로 모든 핸들러에 전달.
#[derive(Clone)]
pub struct AppState {
    pub pool: sqlx::PgPool,
    pub cache: AppCache,
    pub config: Config,
    pub http_client: reqwest::Client,
}

/// /health 응답 페이로드
#[derive(Serialize)]
struct HealthResponse {
    status: &'static str,
    db: &'static str,
    cache: &'static str,
}

/// GET /health — 헬스체크 (DB + 캐시 검증)
async fn health_check(
    State(state): State<AppState>,
) -> Result<ApiResponse<HealthResponse>, AppError> {
    // DB 연결 확인
    sqlx::query_scalar::<_, i32>("SELECT 1")
        .fetch_one(&state.pool)
        .await?;

    // 캐시 가동 확인 — 비즈니스 캐시를 오염시키지 않고 entry_count()로 검증
    let cache_status = if state.cache.is_healthy() {
        "connected"
    } else {
        "error"
    };

    Ok(ApiResponse::ok(HealthResponse {
        status: "ok",
        db: "connected",
        cache: cache_status,
    }))
}

/// graceful shutdown — Ctrl+C / SIGTERM 대기 + 30초 드레인 타임아웃
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

    // 신호 수신 후 30초 watchdog — 드레인이 끝나지 않으면 강제 종료
    tokio::spawn(async {
        tokio::time::sleep(std::time::Duration::from_secs(30)).await;
        tracing::warn!("Graceful shutdown timed out after 30s, forcing exit");
        std::process::exit(1);
    });
}

/// 파티션 유지보수 — api_access_logs + price_history에 현재월 + 3개월 미래 파티션 확보.
/// 개별 파티션 생성 실패 시 나머지를 계속 시도하고, 전체 실패 건수를 반환한다.
async fn ensure_partitions(pool: &sqlx::PgPool) -> Result<(), String> {
    let now = chrono::Utc::now().date_naive();
    let mut errors = Vec::new();

    for offset in 0..=3i32 {
        let month = now + chrono::Months::new(offset as u32);
        let start = month.format("%Y-%m-01").to_string();
        let next = (month + chrono::Months::new(1)).format("%Y-%m-01").to_string();
        let suffix = month.format("%Y_%m").to_string();

        for table in &["api_access_logs", "price_history"] {
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

    if errors.is_empty() {
        Ok(())
    } else {
        Err(format!("{} partition(s) failed: {}", errors.len(), errors.join("; ")))
    }
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
    let config = config::Config::load();
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

    tracing::info!(
        env = ?config.app_env,
        host = %config.host,
        port = config.port,
        "Starting gapttuk server"
    );

    // 3. DB 연결 + 마이그레이션
    let pool = db::init_pool(&config.database_url).await;

    // 4. 캐시 초기화
    let cache = AppCache::new();
    tracing::info!("Cache initialized (moka in-memory)");

    // 5. 크롤링 스케줄러 (Test 환경 skip)
    if config.app_env != config::AppEnv::Test {
        let crawler_service = std::sync::Arc::new(crawlers::CrawlerService::new(
            pool.clone(),
            cache.clone(),
        ));
        if let Err(e) = crawlers::scheduler::start_scheduler(crawler_service).await {
            tracing::error!(error = %e, "Failed to start crawler scheduler");
        }
    } else {
        tracing::info!("Skipping crawler scheduler in Test environment");
    }

    // 6. AppState 조합
    let http_client = reqwest::Client::new();
    let state = AppState {
        pool: pool.clone(),
        cache,
        config: config.clone(),
        http_client,
    };

    // 7. Router — 레이어 순서: 마지막 .layer()가 outermost
    let x_request_id = HeaderName::from_static("x-request-id");
    let (global_governor_layer, global_governor_config) =
        middleware::rate_limit::global_limiter();

    let app = Router::new()
        .route("/health", get(health_check))
        .nest("/api/v1/auth", api::routes::auth::router())
        .nest("/api/v1/products", api::routes::products::router())
        // innermost → outermost 순서
        .layer(global_governor_layer)
        .layer(axum::middleware::from_fn_with_state(
            state.clone(),
            middleware::bot_guard::bot_guard,
        ))
        .layer(axum::middleware::from_fn_with_state(
            state.clone(),
            middleware::access_log::access_log,
        ))
        .layer(SetRequestIdLayer::new(
            x_request_id.clone(),
            MakeRequestUuid,
        ))
        .layer(PropagateRequestIdLayer::new(x_request_id))
        .layer(TraceLayer::new_for_http())
        .with_state(state.clone());

    // 8. 백그라운드 유지보수 (Test 환경 skip)
    if config.app_env != config::AppEnv::Test {
        // 8a. 파티션 유지보수 (일일)
        let partition_pool = pool.clone();
        tokio::spawn(async move {
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

        // 8b. Governor rate limiter 메모리 정리 (1시간 주기)
        // 내부 HashMap에 IP별 상태가 무한 누적되므로 주기적 GC 필요.
        tokio::spawn(async move {
            let mut interval = tokio::time::interval(std::time::Duration::from_secs(3600));
            loop {
                interval.tick().await;
                global_governor_config.limiter().retain_recent();
                tracing::debug!("Governor rate limiter GC completed");
            }
        });
    }

    // 9. 서버 시작
    let addr: SocketAddr = format!("{}:{}", &config.host, config.port)
        .parse()
        .expect("Invalid host:port");

    tracing::info!(%addr, "Server listening");

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .expect("Failed to bind address");

    // into_make_service_with_connect_info는 tower_governor PeerIpKeyExtractor에 필수
    match axum::serve(
        listener,
        app.into_make_service_with_connect_info::<SocketAddr>(),
    )
    .with_graceful_shutdown(shutdown_signal())
    .await
    {
        Ok(()) => tracing::info!("Server shut down gracefully"),
        Err(e) => tracing::error!(error = %e, "Server error"),
    }

    // 10. 정리
    pool.close().await;
    tracing::info!("Cleanup complete, exiting");
}
