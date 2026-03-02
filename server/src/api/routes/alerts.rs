use axum::{
    extract::{Path, State},
    routing::{delete, get, patch, post},
    Json, Router,
};
use serde::Serialize;

use crate::api::{ApiResponse, Created, Deleted};
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::models::PriceAlert;
use crate::services::alert_service::{self, CreatePriceAlertRequest};
use crate::AppState;

// ── 응답 DTO ────────────────────────────────────────────

#[derive(Serialize)]
pub struct AlertListResponse {
    pub price_alerts: Vec<PriceAlert>,
}

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/price", post(create_price_alert))
        .route("/", get(list_alerts))
        .route("/{alert_type}/{alert_id}", delete(delete_alert))
        .route("/{alert_type}/{alert_id}/toggle", patch(toggle_alert))
}

// ── 핸들러 ─────────────────────────────────────────────

/// POST /api/v1/alerts/price — 가격 알림 생성
async fn create_price_alert(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Json(body): Json<CreatePriceAlertRequest>,
) -> Result<Created<PriceAlert>, AppError> {
    let alert = alert_service::create_price_alert(&state.pool, claims.sub, &body).await?;
    Ok(Created(alert))
}

/// GET /api/v1/alerts — 내 알림 설정 목록
async fn list_alerts(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<AlertListResponse>, AppError> {
    let price_alerts = alert_service::get_user_price_alerts(&state.pool, claims.sub).await?;

    Ok(ApiResponse::ok(AlertListResponse { price_alerts }))
}

/// DELETE /api/v1/alerts/:alert_type/:alert_id — 알림 삭제 (204 No Content)
async fn delete_alert(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path((alert_type, alert_id)): Path<(String, i64)>,
) -> Result<Deleted, AppError> {
    match alert_type.as_str() {
        "price" => {
            alert_service::delete_price_alert(&state.pool, claims.sub, alert_id).await?;
        }
        _ => {
            return Err(AppError::BadRequest(format!(
                "지원하지 않는 알림 유형: {alert_type}"
            )));
        }
    }

    Ok(Deleted)
}

/// PATCH /api/v1/alerts/:alert_type/:alert_id/toggle — 알림 토글
async fn toggle_alert(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path((alert_type, alert_id)): Path<(String, i64)>,
) -> Result<ApiResponse<PriceAlert>, AppError> {
    match alert_type.as_str() {
        "price" => {
            let alert =
                alert_service::toggle_price_alert(&state.pool, claims.sub, alert_id).await?;
            Ok(ApiResponse::ok(alert))
        }
        _ => Err(AppError::BadRequest(format!(
            "지원하지 않는 알림 유형: {alert_type}"
        ))),
    }
}
