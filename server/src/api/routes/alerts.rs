use axum::{
    extract::{Path, State},
    routing::{delete, get, patch, post},
    Json, Router,
};
use serde::{Deserialize, Serialize};

use crate::api::{ApiResponse, Created, Deleted};
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::models::{CategoryAlert, KeywordAlert, PriceAlert};
use crate::services::alert_service::{self, CreatePriceAlertRequest};
use crate::AppState;

// ── 요청 DTO ────────────────────────────────────────────

#[derive(Deserialize)]
pub struct CreateCategoryAlertRequest {
    pub category_id: i32,
}

#[derive(Deserialize)]
pub struct CreateKeywordAlertRequest {
    pub keyword: String,
}

#[derive(Deserialize)]
pub struct UpdatePriceAlertRequest {
    pub target_price: rust_decimal::Decimal,
}

#[derive(Deserialize)]
pub struct UpdateKeywordAlertRequest {
    pub keyword: String,
}

// ── 응답 DTO ────────────────────────────────────────────

#[derive(Serialize)]
pub struct AlertListResponse {
    pub price_alerts: Vec<PriceAlert>,
    pub category_alerts: Vec<CategoryAlert>,
    pub keyword_alerts: Vec<KeywordAlert>,
}

// ── 토글 응답 (유형별 분기) ──────────────────────────────

#[derive(Serialize)]
#[serde(tag = "alert_type", rename_all = "snake_case")]
pub enum ToggleAlertResponse {
    Price(PriceAlert),
    Category(CategoryAlert),
    Keyword(KeywordAlert),
}

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/price", post(create_price_alert))
        .route("/category", post(create_category_alert))
        .route("/keyword", post(create_keyword_alert))
        .route("/", get(list_alerts))
        .route("/price/{alert_id}", patch(update_price_alert_handler))
        .route("/keyword/{alert_id}", patch(update_keyword_alert_handler))
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

/// POST /api/v1/alerts/category — 카테고리 알림 생성
async fn create_category_alert(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Json(body): Json<CreateCategoryAlertRequest>,
) -> Result<Created<CategoryAlert>, AppError> {
    let alert =
        alert_service::create_category_alert(&state.pool, claims.sub, body.category_id).await?;
    Ok(Created(alert))
}

/// POST /api/v1/alerts/keyword — 키워드 알림 생성
async fn create_keyword_alert(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Json(body): Json<CreateKeywordAlertRequest>,
) -> Result<Created<KeywordAlert>, AppError> {
    let alert = alert_service::create_keyword_alert(&state.pool, claims.sub, body.keyword).await?;
    Ok(Created(alert))
}

/// GET /api/v1/alerts — 내 알림 설정 목록 (전체 유형)
async fn list_alerts(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<AlertListResponse>, AppError> {
    let (price_alerts, category_alerts, keyword_alerts) = tokio::try_join!(
        alert_service::get_user_price_alerts(&state.pool, claims.sub),
        alert_service::get_user_category_alerts(&state.pool, claims.sub),
        alert_service::get_user_keyword_alerts(&state.pool, claims.sub),
    )?;

    Ok(ApiResponse::ok(AlertListResponse {
        price_alerts,
        category_alerts,
        keyword_alerts,
    }))
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
        "category" => {
            alert_service::delete_category_alert(&state.pool, claims.sub, alert_id).await?;
        }
        "keyword" => {
            alert_service::delete_keyword_alert(&state.pool, claims.sub, alert_id).await?;
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
) -> Result<ApiResponse<ToggleAlertResponse>, AppError> {
    match alert_type.as_str() {
        "price" => {
            let alert =
                alert_service::toggle_price_alert(&state.pool, claims.sub, alert_id).await?;
            Ok(ApiResponse::ok(ToggleAlertResponse::Price(alert)))
        }
        "category" => {
            let alert =
                alert_service::toggle_category_alert(&state.pool, claims.sub, alert_id).await?;
            Ok(ApiResponse::ok(ToggleAlertResponse::Category(alert)))
        }
        "keyword" => {
            let alert =
                alert_service::toggle_keyword_alert(&state.pool, claims.sub, alert_id).await?;
            Ok(ApiResponse::ok(ToggleAlertResponse::Keyword(alert)))
        }
        _ => Err(AppError::BadRequest(format!(
            "지원하지 않는 알림 유형: {alert_type}"
        ))),
    }
}

/// PATCH /api/v1/alerts/price/{alert_id} — 가격 알림 수정
async fn update_price_alert_handler(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(alert_id): Path<i64>,
    Json(body): Json<UpdatePriceAlertRequest>,
) -> Result<ApiResponse<&'static str>, AppError> {
    alert_service::update_price_alert(&state.pool, claims.sub, alert_id, body.target_price).await?;
    Ok(ApiResponse::ok("수정되었습니다"))
}

/// PATCH /api/v1/alerts/keyword/{alert_id} — 키워드 알림 수정
async fn update_keyword_alert_handler(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(alert_id): Path<i64>,
    Json(body): Json<UpdateKeywordAlertRequest>,
) -> Result<ApiResponse<&'static str>, AppError> {
    alert_service::update_keyword_alert(&state.pool, claims.sub, alert_id, &body.keyword).await?;
    Ok(ApiResponse::ok("수정되었습니다"))
}
