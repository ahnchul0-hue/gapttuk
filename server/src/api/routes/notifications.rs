use axum::{
    extract::{Path, Query, State},
    routing::{get, patch},
    Router,
};
use serde::Serialize;

use crate::api::pagination::{PaginatedResponse, PaginationParams};
use crate::api::ApiResponse;
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::models::Notification;
use crate::services::notification_service;
use crate::AppState;

// ── 응답 DTO ────────────────────────────────────────────

#[derive(Serialize)]
pub struct MarkAllReadResponse {
    pub updated: u64,
}

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/", get(list_notifications))
        .route("/{id}/read", patch(mark_read))
        .route("/read-all", patch(mark_all_read))
}

// ── 핸들러 ─────────────────────────────────────────────

/// GET /api/v1/notifications — 내 알림 목록 (커서 기반 페이지네이션)
async fn list_notifications(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Query(params): Query<PaginationParams>,
) -> Result<PaginatedResponse<Notification>, AppError> {
    let cursor = params.cursor.as_deref().and_then(|c| c.parse::<i64>().ok());
    let limit = params.effective_limit();

    let notifications =
        notification_service::get_user_notifications(&state.pool, claims.sub, cursor, limit)
            .await?;

    Ok(PaginatedResponse::new(notifications, limit, |n| {
        n.id.to_string()
    }))
}

/// PATCH /api/v1/notifications/:id/read — 단건 읽음 처리
async fn mark_read(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(id): Path<i64>,
) -> Result<ApiResponse<()>, AppError> {
    notification_service::mark_as_read(&state.pool, claims.sub, id).await?;
    Ok(ApiResponse::ok(()))
}

/// PATCH /api/v1/notifications/read-all — 전체 읽음 처리
async fn mark_all_read(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<MarkAllReadResponse>, AppError> {
    let updated = notification_service::mark_all_read(&state.pool, claims.sub).await?;
    Ok(ApiResponse::ok(MarkAllReadResponse { updated }))
}
