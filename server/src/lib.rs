pub mod api;
pub mod auth;
pub mod cache;
pub mod config;
pub mod crawlers;
pub mod db;
pub mod error;
pub mod middleware;
pub mod models;
pub mod push;
pub mod services;

use std::sync::Arc;

use axum::extract::State;
use axum::response::IntoResponse;
use serde::Serialize;

pub use cache::AppCache;
pub use config::Config;
pub use error::AppError;

/// 공유 애플리케이션 상태 — `State<AppState>`로 모든 핸들러에 전달.
#[derive(Clone)]
pub struct AppState {
    pub pool: sqlx::PgPool,
    pub cache: AppCache,
    pub config: Arc<Config>,
    pub http_client: reqwest::Client,
    pub push_client: Arc<push::PushClient>,
}

/// DB 헬스 상세 페이로드
#[derive(Serialize)]
pub struct DbHealth {
    pub status: &'static str,
    pub latency_ms: u64,
    pub pool_size: u32,
    pub pool_idle: u32,
}

/// /health 응답 페이로드
#[derive(Serialize)]
pub struct HealthResponse {
    pub status: &'static str,
    pub version: &'static str,
    pub db: DbHealth,
    pub cache: &'static str,
}

/// GET /health — 헬스체크 (DB + 캐시 검증)
pub async fn health_check(
    State(state): State<AppState>,
) -> axum::response::Response {
    let start = std::time::Instant::now();
    let db_ok = sqlx::query("SELECT 1").execute(&state.pool).await.is_ok();
    let latency_ms = start.elapsed().as_millis() as u64;

    let db = DbHealth {
        status: if db_ok { "connected" } else { "disconnected" },
        latency_ms,
        pool_size: state.pool.size(),
        pool_idle: state.pool.num_idle() as u32,
    };

    let cache_status = if state.cache.is_healthy() {
        state.cache.report_metrics();
        "ok"
    } else {
        "error"
    };

    let status = if db_ok { "healthy" } else { "degraded" };

    let body = HealthResponse {
        status,
        version: env!("CARGO_PKG_VERSION"),
        db,
        cache: cache_status,
    };

    axum::Json(api::ApiResponse::ok(body)).into_response()
}
