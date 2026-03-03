use axum::{
    extract::{Path, State},
    routing::get,
    Router,
};

use crate::api::ApiResponse;
use crate::error::AppError;
use crate::models::AiPrediction;
use crate::services::ai_prediction_service;
use crate::AppState;

pub fn router() -> Router<AppState> {
    Router::new().route("/{product_id}", get(get_prediction))
}

/// GET /api/v1/predictions/{product_id} -- 가격 예측 조회
async fn get_prediction(
    State(state): State<AppState>,
    Path(product_id): Path<i64>,
) -> Result<ApiResponse<AiPrediction>, AppError> {
    let prediction = ai_prediction_service::get_prediction(&state.pool, product_id).await?;
    Ok(ApiResponse::ok(prediction))
}
