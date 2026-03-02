use chrono::{DateTime, NaiveDate, Utc};
use rust_decimal::Decimal;
use serde::Serialize;

/// AI 예측 행동
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum PredictedAction {
    BuyNow,
    Wait,
    Neutral,
}

/// ai_predictions 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct AiPrediction {
    pub id: i64,
    pub product_id: i64,
    pub predicted_action: PredictedAction,
    pub confidence: Decimal,
    pub predicted_lowest_price: Option<i32>,
    pub predicted_lowest_date: Option<NaiveDate>,
    pub price_at_prediction: i32,
    pub factors: Option<serde_json::Value>,
    pub created_at: DateTime<Utc>,
    pub expires_at: DateTime<Utc>,
}
