use std::sync::Arc;
use std::time::{Duration, Instant};

use serde::{Deserialize, Serialize};
use tokio::sync::RwLock;

/// FCM v1 HTTP API 클라이언트.
/// service account JSON → JWT RS256 서명 → OAuth2 토큰 교환 → 푸시 전송.
pub struct FcmClient {
    project_id: String,
    client_email: String,
    private_key: String,
    token_uri: String,
    http: reqwest::Client,
    cached_token: Arc<RwLock<Option<CachedToken>>>,
}

struct CachedToken {
    access_token: String,
    expires_at: Instant,
}

#[derive(Deserialize)]
struct ServiceAccount {
    project_id: String,
    client_email: String,
    private_key: String,
    token_uri: String,
}

#[derive(Serialize)]
struct OAuthRequest {
    grant_type: &'static str,
    assertion: String,
}

#[derive(Deserialize)]
struct OAuthResponse {
    access_token: String,
    expires_in: u64,
}

#[derive(Serialize)]
struct FcmRequest {
    message: FcmMessage,
}

#[derive(Serialize)]
struct FcmMessage {
    token: String,
    notification: FcmNotification,
    #[serde(skip_serializing_if = "Option::is_none")]
    data: Option<std::collections::HashMap<String, String>>,
}

#[derive(Serialize)]
struct FcmNotification {
    title: String,
    body: String,
}

impl FcmClient {
    /// service account JSON 파일 경로에서 초기화.
    pub fn from_service_account(path: &str, http: reqwest::Client) -> Result<Self, FcmError> {
        let content = std::fs::read_to_string(path)
            .map_err(|e| FcmError::Config(format!("Cannot read service account: {e}")))?;
        let sa: ServiceAccount = serde_json::from_str(&content)
            .map_err(|e| FcmError::Config(format!("Invalid service account JSON: {e}")))?;

        Ok(Self {
            project_id: sa.project_id,
            client_email: sa.client_email,
            private_key: sa.private_key,
            token_uri: sa.token_uri,
            http,
            cached_token: Arc::new(RwLock::new(None)),
        })
    }

    /// 푸시 전송. 내부적으로 OAuth2 토큰을 캐싱/갱신.
    pub async fn send(
        &self,
        device_token: &str,
        title: &str,
        body: &str,
        deep_link: Option<&str>,
    ) -> Result<(), FcmError> {
        let access_token = self.get_access_token().await?;

        let data = deep_link.map(|link| {
            let mut m = std::collections::HashMap::new();
            m.insert("deep_link".to_string(), link.to_string());
            m
        });

        let req = FcmRequest {
            message: FcmMessage {
                token: device_token.to_string(),
                notification: FcmNotification {
                    title: title.to_string(),
                    body: body.to_string(),
                },
                data,
            },
        };

        let url = format!(
            "https://fcm.googleapis.com/v1/projects/{}/messages:send",
            self.project_id
        );

        let resp = self
            .http
            .post(&url)
            .bearer_auth(&access_token)
            .json(&req)
            .send()
            .await
            .map_err(|e| FcmError::Send(e.to_string()))?;

        if !resp.status().is_success() {
            let status = resp.status();
            let body = resp.text().await.unwrap_or_default();

            // 404 = UNREGISTERED / NOT_FOUND — 토큰이 영구 무효
            if status == reqwest::StatusCode::NOT_FOUND {
                return Err(FcmError::InvalidToken(format!("FCM {status}: {body}")));
            }

            return Err(FcmError::Send(format!("FCM {status}: {body}")));
        }

        Ok(())
    }

    /// OAuth2 access token 획득 (캐싱, 만료 5분 전 갱신).
    /// Double-check 패턴으로 thundering herd 방지.
    async fn get_access_token(&self) -> Result<String, FcmError> {
        // Fast path: read lock으로 캐시 확인
        {
            let guard = self.cached_token.read().await;
            if let Some(ref cached) = *guard {
                if Instant::now() + Duration::from_secs(300) < cached.expires_at {
                    return Ok(cached.access_token.clone());
                }
            }
        }

        // Slow path: write lock 획득 후 다시 확인 (다른 태스크가 이미 갱신했을 수 있음)
        let mut guard = self.cached_token.write().await;
        if let Some(ref cached) = *guard {
            if Instant::now() + Duration::from_secs(300) < cached.expires_at {
                return Ok(cached.access_token.clone());
            }
        }

        // 새 토큰 발급 (write lock 보유 중 — 단일 교환만 발생)
        let token = self.exchange_token().await?;
        let expires_at = Instant::now() + Duration::from_secs(token.expires_in);
        let access_token = token.access_token.clone();

        *guard = Some(CachedToken {
            access_token: token.access_token,
            expires_at,
        });

        Ok(access_token)
    }

    /// self-signed JWT → OAuth2 token exchange.
    async fn exchange_token(&self) -> Result<OAuthResponse, FcmError> {
        let now = chrono::Utc::now().timestamp();
        let claims = serde_json::json!({
            "iss": self.client_email,
            "scope": "https://www.googleapis.com/auth/firebase.messaging",
            "aud": self.token_uri,
            "iat": now,
            "exp": now + 3600,
        });

        let encoding_key =
            jsonwebtoken::EncodingKey::from_rsa_pem(self.private_key.as_bytes())
                .map_err(|e| FcmError::Config(format!("Invalid RSA key: {e}")))?;

        let header = jsonwebtoken::Header::new(jsonwebtoken::Algorithm::RS256);
        let jwt = jsonwebtoken::encode(&header, &claims, &encoding_key)
            .map_err(|e| FcmError::Config(format!("JWT encode failed: {e}")))?;

        let resp = self
            .http
            .post(&self.token_uri)
            .form(&OAuthRequest {
                grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
                assertion: jwt,
            })
            .send()
            .await
            .map_err(|e| FcmError::Send(format!("OAuth2 exchange failed: {e}")))?;

        if !resp.status().is_success() {
            let status = resp.status();
            let body = resp.text().await.unwrap_or_default();
            return Err(FcmError::Send(format!("OAuth2 {status}: {body}")));
        }

        resp.json::<OAuthResponse>()
            .await
            .map_err(|e| FcmError::Send(format!("OAuth2 parse failed: {e}")))
    }
}

#[derive(Debug, thiserror::Error)]
pub enum FcmError {
    #[error("FCM config error: {0}")]
    Config(String),
    #[error("FCM send error: {0}")]
    Send(String),
    /// 디바이스 토큰이 영구 무효 — UNREGISTERED(404) 또는 NOT_FOUND.
    /// 호출자는 해당 토큰을 DB에서 비활성화해야 한다.
    #[error("FCM invalid token: {0}")]
    InvalidToken(String),
}
