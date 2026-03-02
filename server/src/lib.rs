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
use serde::Serialize;

pub use cache::AppCache;
pub use config::Config;
pub use error::AppError;

/// 공유 애플리케이션 상태 — `State<AppState>`로 모든 핸들러에 전달.
#[derive(Clone)]
pub struct AppState {
    pub pool: sqlx::PgPool,
    pub cache: AppCache,
    pub config: Config,
    pub http_client: reqwest::Client,
    pub push_client: Arc<push::PushClient>,
}

/// /health 응답 페이로드
#[derive(Serialize)]
pub struct HealthResponse {
    pub status: &'static str,
    pub db: &'static str,
    pub cache: &'static str,
}

/// GET /health — 헬스체크 (DB + 캐시 검증)
pub async fn health_check(
    State(state): State<AppState>,
) -> Result<api::ApiResponse<HealthResponse>, AppError> {
    sqlx::query_scalar::<_, i32>("SELECT 1")
        .fetch_one(&state.pool)
        .await?;

    let cache_status = if state.cache.is_healthy() {
        state.cache.report_metrics();
        "connected"
    } else {
        "error"
    };

    Ok(api::ApiResponse::ok(HealthResponse {
        status: "ok",
        db: "connected",
        cache: cache_status,
    }))
}
