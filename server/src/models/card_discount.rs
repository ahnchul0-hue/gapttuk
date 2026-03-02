use chrono::{DateTime, NaiveDate, Utc};
use serde::Serialize;

/// 카드 종류
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum CardType {
    Credit,
    Check,
    Membership,
}

/// 할인 유형
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum DiscountType {
    Percent,
    FixedAmount,
}

/// card_discounts 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct CardDiscount {
    pub id: i64,
    pub product_id: i64,
    pub card_name: String,
    pub card_type: CardType,
    pub discount_type: DiscountType,
    pub discount_value: i32,
    pub discounted_price: Option<i32>,
    pub min_purchase: Option<i32>,
    pub valid_from: Option<NaiveDate>,
    pub valid_until: Option<NaiveDate>,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}
