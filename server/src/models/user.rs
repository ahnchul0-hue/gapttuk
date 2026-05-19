use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

/// 소셜 인증 제공자
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, sqlx::Type)]
#[serde(rename_all = "snake_case")]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum AuthProvider {
    Kakao,
    Google,
    Apple,
    Naver,
}

/// 디바이스 플랫폼
#[derive(Debug, Clone, PartialEq, Eq, Serialize, sqlx::Type)]
#[serde(rename_all = "snake_case")]
#[sqlx(type_name = "TEXT", rename_all = "snake_case")]
pub enum Platform {
    Android,
    Ios,
    Web,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn auth_provider_serde_snake_case() {
        assert_eq!(
            serde_json::to_string(&AuthProvider::Kakao).unwrap(),
            "\"kakao\""
        );
        assert_eq!(
            serde_json::to_string(&AuthProvider::Google).unwrap(),
            "\"google\""
        );
        assert_eq!(
            serde_json::to_string(&AuthProvider::Apple).unwrap(),
            "\"apple\""
        );
        assert_eq!(
            serde_json::to_string(&AuthProvider::Naver).unwrap(),
            "\"naver\""
        );
    }

    #[test]
    fn platform_serde_snake_case() {
        assert_eq!(
            serde_json::to_string(&Platform::Android).unwrap(),
            "\"android\""
        );
        assert_eq!(serde_json::to_string(&Platform::Ios).unwrap(), "\"ios\"");
        assert_eq!(serde_json::to_string(&Platform::Web).unwrap(), "\"web\"");
    }
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
    pub terms_agreed_at: Option<DateTime<Utc>>,
    pub privacy_agreed_at: Option<DateTime<Utc>>,
    pub marketing_agreed_at: Option<DateTime<Utc>>,
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
