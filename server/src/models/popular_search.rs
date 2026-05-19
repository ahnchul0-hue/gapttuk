use chrono::{DateTime, Utc};
use serde::Serialize;

/// 인기 검색어 추세
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[serde(rename_all = "snake_case")]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum SearchTrend {
    Up,
    Down,
    New,
    Stable,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn search_trend_serde_snake_case() {
        assert_eq!(serde_json::to_string(&SearchTrend::Up).unwrap(), "\"up\"");
        assert_eq!(
            serde_json::to_string(&SearchTrend::Down).unwrap(),
            "\"down\""
        );
        assert_eq!(serde_json::to_string(&SearchTrend::New).unwrap(), "\"new\"");
        assert_eq!(
            serde_json::to_string(&SearchTrend::Stable).unwrap(),
            "\"stable\""
        );
    }
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
