use chrono::{DateTime, Utc};
use serde::Serialize;

/// 소셜 인증 제공자
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum AuthProvider {
    Kakao,
    Google,
    Apple,
    Naver,
}

/// 디바이스 플랫폼
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum Platform {
    Android,
    Ios,
    Web,
}

/// users 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct User {
    pub id: i64,
    pub email: String,
    pub nickname: Option<String>,
    pub auth_provider: AuthProvider,
    pub auth_provider_id: String,
    pub profile_image_url: Option<String>,
    pub referral_code: String,
    pub referred_by: Option<i64>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: Option<DateTime<Utc>>,
}

/// user_devices 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct UserDevice {
    pub id: i64,
    pub user_id: i64,
    pub device_token: String,
    pub platform: Platform,
    pub push_enabled: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}
