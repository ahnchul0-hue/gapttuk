mod config;
mod db;

use axum::{extract::State, http::StatusCode, response::IntoResponse, routing::get, Json, Router};
use serde::Serialize;
use sqlx::PgPool;
use std::net::SocketAddr;
use tokio::signal;

/// /health 응답
#[derive(Serialize)]
struct HealthResponse {
    status: &'static str,
    db: &'static str,
}

/// GET /health — 헬스체크 (DB 연결 상태 포함)
async fn health_check(State(pool): State<PgPool>) -> impl IntoResponse {
    match sqlx::query_scalar::<_, i32>("SELECT 1")
        .fetch_one(&pool)
        .await
    {
        Ok(_) => (
            StatusCode::OK,
            Json(HealthResponse {
                status: "ok",
                db: "connected",
            }),
        ),
        Err(_) => (
            StatusCode::SERVICE_UNAVAILABLE,
            Json(HealthResponse {
                status: "error",
                db: "disconnected",
            }),
        ),
    }
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

    // 2. Sentry 초기화 (DSN 있으면)
    let config = config::Config::load();
    let _sentry_guard = config.sentry_dsn.as_ref().map(|dsn| {
        sentry::init((
            dsn.as_str(),
            sentry::ClientOptions {
                release: sentry::release_name!(),
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

    // 4. Router
    let app = Router::new()
        .route("/health", get(health_check))
        // M1-4~8에서 /api/v1/ 라우트 추가 예정
        .with_state(pool.clone());

    // 5. 서버 시작
    let addr: SocketAddr = format!("{}:{}", config.host, config.port)
        .parse()
        .expect("Invalid host:port");

    tracing::info!(%addr, "Server listening");

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .expect("Failed to bind address");

    match axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await
    {
        Ok(()) => tracing::info!("Server shut down gracefully"),
        Err(e) => tracing::error!(error = %e, "Server error"),
    }

    // 6. 정리
    pool.close().await;
    tracing::info!("Cleanup complete, exiting");
}
