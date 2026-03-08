use axum::{
    extract::{Query, State},
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};

use crate::api::ApiResponse;
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::services::reward_service::{
    self, CheckinResult, PointHistoryItem, PointsInfo, ReferralStats,
};
use crate::AppState;

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/checkin", post(checkin))
        .route("/points", get(get_points))
        .route("/history", get(get_history))
        .route("/referrals", get(get_referrals))
}

// ── 핸들러 ─────────────────────────────────────────────

/// POST /api/v1/rewards/checkin — 오늘의 출석 룰렛 실행
///
/// - 하루 1회 제한 (이미 출석 시 already_checked_in=true)
/// - 보상: 0¢ 또는 1¢ (월한도/룰렛 결과에 따라)
async fn checkin(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<CheckinResult>, AppError> {
    let result = reward_service::daily_checkin(&state.pool, claims.sub).await?;
    Ok(ApiResponse::ok(result))
}

/// GET /api/v1/rewards/points — 내 센트 잔액 조회
async fn get_points(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<PointsInfo>, AppError> {
    let info = reward_service::get_points(&state.pool, claims.sub).await?;
    Ok(ApiResponse::ok(info))
}

/// GET /api/v1/rewards/history — 포인트 내역 (커서 페이지네이션)
async fn get_history(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Query(params): Query<HistoryParams>,
) -> Result<ApiResponse<HistoryResponse>, AppError> {
    let limit = params.limit.unwrap_or(20).clamp(1, 50);
    let (items, has_more) =
        reward_service::get_history(&state.pool, claims.sub, params.cursor, limit).await?;
    Ok(ApiResponse::ok(HistoryResponse { items, has_more }))
}

/// GET /api/v1/rewards/referrals — 내 추천 현황 조회
async fn get_referrals(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<ReferralStats>, AppError> {
    let stats = reward_service::get_referral_stats(&state.pool, claims.sub).await?;
    Ok(ApiResponse::ok(stats))
}

#[derive(Deserialize)]
struct HistoryParams {
    cursor: Option<i64>,
    limit: Option<i64>,
}

#[derive(Serialize)]
struct HistoryResponse {
    items: Vec<PointHistoryItem>,
    has_more: bool,
}
