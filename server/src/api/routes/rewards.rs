use axum::{
    extract::State,
    routing::{get, post},
    Router,
};

use crate::api::ApiResponse;
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::services::reward_service::{self, CheckinResult, PointsInfo};
use crate::AppState;

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/checkin", post(checkin))
        .route("/points", get(get_points))
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
