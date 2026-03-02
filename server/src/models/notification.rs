use chrono::{DateTime, Utc};
use serde::Serialize;

/// 알림 유형
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum NotificationType {
    PriceAlert,
    CategoryAlert,
    KeywordAlert,
    Referral,
    Event,
    System,
}

/// notifications 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct Notification {
    pub id: i64,
    pub user_id: i64,
    pub notification_type: NotificationType,
    pub reference_id: Option<i64>,
    pub reference_type: Option<String>,
    pub title: String,
    pub body: Option<String>,
    pub deep_link: Option<String>,
    pub is_read: bool,
    pub sent_at: DateTime<Utc>,
    pub read_at: Option<DateTime<Utc>>,
}
