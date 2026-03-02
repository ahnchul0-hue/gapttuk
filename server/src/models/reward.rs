use chrono::{DateTime, NaiveDate, Utc};
use serde::Serialize;

/// 룰렛 유형
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum RouletteType {
    Checkin,
    Event,
    Quiz,
}

/// referrals 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct Referral {
    pub id: i64,
    pub referrer_id: i64,
    pub referred_id: i64,
    pub referral_code: String,
    pub referrer_rewarded: bool,
    pub referred_rewarded: bool,
    pub created_at: DateTime<Utc>,
}

/// daily_checkins 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct DailyCheckin {
    pub id: i64,
    pub user_id: i64,
    pub checkin_date: NaiveDate,
    pub streak_count: i32,
    pub roulette_earned: bool,
    pub created_at: DateTime<Utc>,
}

/// roulette_results 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct RouletteResult {
    pub id: i64,
    pub user_id: i64,
    pub roulette_type: RouletteType,
    pub reference_id: Option<i64>,
    pub is_winner: bool,
    pub reward_amount: i32,
    pub created_at: DateTime<Utc>,
}
