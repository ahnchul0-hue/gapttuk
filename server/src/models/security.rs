use chrono::{DateTime, Utc};
use ipnetwork::IpNetwork;
use serde::Serialize;

/// api_access_logs 테이블 (파티셔닝: RANGE by created_at)
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct ApiAccessLog {
    pub id: i64,
    pub ip_address: IpNetwork,
    pub user_id: Option<i64>,
    pub endpoint: String,
    pub method: String,
    pub status_code: i16,
    pub user_agent: Option<String>,
    pub response_time_ms: Option<i32>,
    pub created_at: DateTime<Utc>,
}

/// blocked_ips 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct BlockedIp {
    pub id: i32,
    pub ip_address: IpNetwork,
    pub reason: String,
    pub blocked_until: Option<DateTime<Utc>>,
    pub hit_count: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

/// refresh_tokens 테이블
#[derive(Debug, Clone, sqlx::FromRow, Serialize)]
pub struct RefreshToken {
    pub id: i64,
    pub user_id: i64,
    pub token_hash: String,
    pub expires_at: DateTime<Utc>,
    pub revoked_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
}
