use chrono::{DateTime, Utc};
use serde::Serialize;

/// 인기 검색어 추세
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum SearchTrend {
    Up,
    Down,
    New,
    Stable,
}

/// popular_searches 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct PopularSearch {
    pub id: i32,
    pub keyword: String,
    pub search_count: i32,
    pub rank: i16,
    pub trend: Option<SearchTrend>,
    pub updated_at: DateTime<Utc>,
}
