use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};

/// 가격 추세
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum PriceTrend {
    Rising,
    Falling,
    Stable,
}

/// products 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct Product {
    pub id: i64,
    pub shopping_mall_id: i32,
    pub category_id: Option<i32>,
    #[serde(skip_serializing)]
    pub external_product_id: String,
    #[serde(skip_serializing)]
    pub vendor_item_id: Option<String>,
    pub product_name: String,
    pub product_url: Option<String>,
    pub image_url: Option<String>,
    pub current_price: Option<i32>,
    pub lowest_price: Option<i32>,
    pub highest_price: Option<i32>,
    pub average_price: Option<i32>,
    pub unit_type: Option<String>,
    pub unit_price: Option<Decimal>,
    pub rating: Option<Decimal>,
    pub review_count: Option<i32>,
    pub is_out_of_stock: bool,
    pub price_trend: Option<PriceTrend>,
    pub days_since_lowest: Option<i32>,
    pub drop_from_average: Option<i32>,
    pub buy_timing_score: Option<i16>,
    #[serde(skip_serializing)]
    pub sales_velocity: Option<Decimal>,
    pub first_tracked_at: Option<DateTime<Utc>>,
    pub price_updated_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

/// shopping_malls 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct ShoppingMall {
    pub id: i32,
    pub name: String,
    pub code: String,
    pub base_url: String,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
}

/// categories 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct Category {
    pub id: i32,
    pub name: String,
    pub slug: String,
    pub parent_id: Option<i32>,
    pub depth: i16,
    pub sort_order: i32,
    pub created_at: DateTime<Utc>,
}
