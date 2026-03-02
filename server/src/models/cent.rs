use chrono::{DateTime, Utc};
use serde::Serialize;

/// 센트(¢) 거래 유형
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum TransactionType {
    RouletteCheckin,
    RouletteEvent,
    ReferralReward,
    ReferralWelcome,
    SignupBonus,
    GifticonExchange,
    AdRemoval,
    AdminAdjustment,
}

/// user_points 테이블 — 센트(¢) 잔액
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct UserPoints {
    pub id: i64,
    pub user_id: i64,
    pub balance: i32,
    pub total_earned: i32,
    pub total_spent: i32,
    pub updated_at: DateTime<Utc>,
}

/// point_transactions 테이블 — 센트(¢) 거래 이력
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct PointTransaction {
    pub id: i64,
    pub user_id: i64,
    pub amount: i32,
    pub transaction_type: TransactionType,
    pub reference_id: Option<i64>,
    pub reference_type: Option<String>,
    pub description: Option<String>,
    pub created_at: DateTime<Utc>,
}
