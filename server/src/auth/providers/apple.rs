use jsonwebtoken::{decode, Algorithm, DecodingKey, Validation};
use serde::Deserialize;
use std::sync::OnceLock;
use std::time::{Duration, Instant};
use tokio::sync::RwLock;

use super::SocialUserInfo;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::AppState;

/// Apple id_token의 claims
#[derive(Deserialize)]
struct AppleClaims {
    sub: String,
    email: Option<String>,
}

/// Apple JWKS 응답
#[derive(Clone, Deserialize)]
struct AppleJwks {
    keys: Vec<AppleJwk>,
}

#[derive(Clone, Deserialize)]
struct AppleJwk {
    kid: String,
    n: String,
    e: String,
}

// ── JWKS 캐시 (24시간 TTL, double-check locking) ──────────

struct CachedJwks {
    jwks: AppleJwks,
    fetched_at: Instant,
}

const JWKS_CACHE_TTL: Duration = Duration::from_secs(24 * 3600);

fn jwks_cache() -> &'static RwLock<Option<CachedJwks>> {
    static CACHE: OnceLock<RwLock<Option<CachedJwks>>> = OnceLock::new();
    CACHE.get_or_init(|| RwLock::new(None))
}

/// Apple JWKS 캐시 조회/갱신. 24시간 TTL, double-check locking으로 thundering herd 방지.
async fn get_apple_jwks(client: &reqwest::Client) -> Result<AppleJwks, AppError> {
    // Fast path: read lock
    {
        let guard = jwks_cache().read().await;
        if let Some(ref cached) = *guard {
            if cached.fetched_at.elapsed() < JWKS_CACHE_TTL {
                return Ok(cached.jwks.clone());
            }
        }
    }

    // Slow path: write lock + double-check
    let mut guard = jwks_cache().write().await;
    if let Some(ref cached) = *guard {
        if cached.fetched_at.elapsed() < JWKS_CACHE_TTL {
            return Ok(cached.jwks.clone());
        }
    }

    let response = client
        .get("https://appleid.apple.com/auth/keys")
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Apple JWKS fetch failed: {e}")))?
        .error_for_status()
        .map_err(|e| AppError::Internal(format!("Apple JWKS HTTP error: {e}")))?;

    let jwks: AppleJwks = response
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Apple JWKS parse failed: {e}")))?;

    if jwks.keys.is_empty() {
        return Err(AppError::Internal(
            "Apple JWKS returned empty key set".to_string(),
        ));
    }

    *guard = Some(CachedJwks {
        jwks: jwks.clone(),
        fetched_at: Instant::now(),
    });

    Ok(jwks)
}

/// Apple id_token (JWT) 검증.
/// Flutter 클라이언트가 Sign in with Apple에서 받은 id_token을 전달.
/// 서버는 Apple의 공개키(JWKS)로 서명을 검증한다.
pub async fn verify(state: &AppState, id_token: &str) -> Result<SocialUserInfo, AppError> {
    // 1. id_token 헤더에서 kid 추출
    let header = jsonwebtoken::decode_header(id_token).map_err(|_| AppError::TokenInvalid)?;
    let kid = header.kid.ok_or(AppError::TokenInvalid)?;

    // 2. Apple JWKS 가져오기 (24시간 캐싱)
    let jwks = get_apple_jwks(&state.http_client).await?;

    // 3. kid에 매칭되는 키 찾기
    let jwk = jwks
        .keys
        .iter()
        .find(|k| k.kid == kid)
        .ok_or(AppError::TokenInvalid)?;

    // 4. RSA 공개키로 id_token 검증
    let decoding_key =
        DecodingKey::from_rsa_components(&jwk.n, &jwk.e).map_err(|_| AppError::TokenInvalid)?;

    let mut validation = Validation::new(Algorithm::RS256);
    // Apple의 id_token audience는 클라이언트 ID — 미설정 시 토큰 재사용 공격 방지를 위해 차단
    let client_id = state.config.apple_client_id.as_ref().ok_or_else(|| {
        AppError::Internal("APPLE_CLIENT_ID 미설정 — Apple 로그인 불가".to_string())
    })?;
    validation.set_audience(&[client_id]);
    validation.set_issuer(&["https://appleid.apple.com"]);

    let token_data = decode::<AppleClaims>(id_token, &decoding_key, &validation).map_err(|e| {
        tracing::warn!(error = %e, "Apple id_token decode failed");
        match e.kind() {
            jsonwebtoken::errors::ErrorKind::ExpiredSignature => AppError::TokenExpired,
            _ => AppError::TokenInvalid,
        }
    })?;

    let claims = token_data.claims;

    Ok(SocialUserInfo {
        provider: AuthProvider::Apple,
        provider_id: claims.sub,
        email: claims
            .email
            .filter(|e| !e.is_empty())
            .ok_or(AppError::BadRequest(
                "Apple 계정에서 이메일을 가져올 수 없습니다. 이메일 공유를 허용해 주세요."
                    .to_string(),
            ))?,
        nickname: None,
        profile_image_url: None,
    })
}
