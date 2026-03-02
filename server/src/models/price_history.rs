use chrono::{DateTime, Utc};
use serde::Serialize;

/// price_history 테이블 (파티셔닝: RANGE by recorded_at)
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct PriceHistory {
    pub id: i64,
    pub product_id: i64,
    pub price: i32,
    pub is_out_of_stock: bool,
    pub recorded_at: DateTime<Utc>,
}
