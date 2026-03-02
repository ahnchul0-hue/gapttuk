use chrono::{DateTime, Utc};
use serde::Serialize;

/// user_favorites 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct UserFavorite {
    pub id: i64,
    pub user_id: i64,
    pub product_id: i64,
    pub memo: Option<String>,
    pub created_at: DateTime<Utc>,
}
