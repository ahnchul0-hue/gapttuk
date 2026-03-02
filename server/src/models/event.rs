use chrono::{DateTime, Utc};
use serde::Serialize;

/// 이벤트 유형
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum EventType {
    Quiz,
    Roulette,
    Survey,
    Promotion,
}

/// events 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct Event {
    pub id: i64,
    pub title: String,
    pub description: Option<String>,
    pub event_type: EventType,
    pub reward_points: i32,
    pub max_participants: Option<i32>,
    pub quiz_data: Option<serde_json::Value>,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
}

/// event_participations 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct EventParticipation {
    pub id: i64,
    pub event_id: i64,
    pub user_id: i64,
    pub answer: Option<serde_json::Value>,
    pub is_correct: Option<bool>,
    pub points_earned: i32,
    pub created_at: DateTime<Utc>,
}
