use chrono::{DateTime, Utc};
use serde::Serialize;

/// 가격 알림 유형
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum AlertType {
    TargetPrice,
    BelowAverage,
    NearLowest,
    AllTimeLow,
}

/// price_alerts 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct PriceAlert {
    pub id: i64,
    pub user_id: i64,
    pub product_id: i64,
    pub alert_type: AlertType,
    pub target_price: Option<i32>,
    pub is_active: bool,
    pub last_triggered_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}
