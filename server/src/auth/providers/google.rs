use jsonwebtoken::{decode, Algorithm, DecodingKey, Validation};
use serde::Deserialize;
use std::sync::OnceLock;
use std::time::{Duration, Instant};
use tokio::sync::RwLock;

use super::SocialUserInfo;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::AppState;

const GOOGLE_JWKS_URL: &str = "https://www.googleapis.com/oauth2/v3/certs";

/// Google id_token의 claims
#[derive(Deserialize)]
struct GoogleClaims {
    sub: String,
    email: Option<String>,
    email_verified: Option<bool>,
    name: Option<String>,
    picture: Option<String>,
}

/// Google JWKS 응답
#[derive(Clone, Deserialize)]
struct GoogleJwks {
    keys: Vec<GoogleJwk>,
}

#[derive(Clone, Deserialize)]
struct GoogleJwk {
    kid: String,
    n: String,
    e: String,
}

// ── JWKS 캐시 (24시간 TTL, double-check locking) ──────────

struct CachedGoogleJwks {
    jwks: GoogleJwks,
    fetched_at: Instant,
}

const JWKS_CACHE_TTL: Duration = Duration::from_secs(24 * 3600);

fn google_jwks_cache() -> &'static RwLock<Option<CachedGoogleJwks>> {
    static CACHE: OnceLock<RwLock<Option<CachedGoogleJwks>>> = OnceLock::new();
    CACHE.get_or_init(|| RwLock::new(None))
}

/// Google JWKS 캐시 조회/갱신. 24시간 TTL, double-check locking으로 thundering herd 방지.
async fn get_google_jwks(client: &reqwest::Client) -> Result<GoogleJwks, AppError> {
    // Fast path: read lock
    {
        let guard = google_jwks_cache().read().await;
        if let Some(ref cached) = *guard {
            if cached.fetched_at.elapsed() < JWKS_CACHE_TTL {
                return Ok(cached.jwks.clone());
            }
        }
    }

    // Slow path: write lock + double-check
    let mut guard = google_jwks_cache().write().await;
    if let Some(ref cached) = *guard {
        if cached.fetched_at.elapsed() < JWKS_CACHE_TTL {
            return Ok(cached.jwks.clone());
        }
    }

    let jwks: GoogleJwks = client
        .get(GOOGLE_JWKS_URL)
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Google JWKS fetch failed: {e}")))?
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Google JWKS parse failed: {e}")))?;

    *guard = Some(CachedGoogleJwks {
        jwks: jwks.clone(),
        fetched_at: Instant::now(),
    });

    Ok(jwks)
}

/// Google id_token (JWT) 검증.
/// Flutter 클라이언트가 Google Sign-In에서 받은 id_token을 전달.
/// 서버는 Google의 공개키(JWKS)로 서명을 검증한다.
pub async fn verify(state: &AppState, id_token: &str) -> Result<SocialUserInfo, AppError> {
    // 1. id_token 헤더에서 kid 추출
    let header = jsonwebtoken::decode_header(id_token).map_err(|_| AppError::TokenInvalid)?;
    let kid = header.kid.ok_or(AppError::TokenInvalid)?;

    // 2. Google JWKS 가져오기 (24시간 캐싱)
    let jwks = get_google_jwks(&state.http_client).await?;

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
    // Google의 id_token audience는 클라이언트 ID — 미설정 시 토큰 재사용 공격 방지를 위해 차단
    let client_id = state.config.google_client_id.as_ref().ok_or_else(|| {
        AppError::Internal("GOOGLE_CLIENT_ID 미설정 — Google 로그인 불가".to_string())
    })?;
    validation.set_audience(&[client_id]);
    validation.set_issuer(&["accounts.google.com", "https://accounts.google.com"]);

    let token_data = decode::<GoogleClaims>(id_token, &decoding_key, &validation)
        .map_err(|_| AppError::TokenInvalid)?;

    let claims = token_data.claims;

    // 5. 이메일 인증 여부 확인
    if claims.email_verified != Some(true) {
        return Err(AppError::BadRequest(
            "이메일 인증이 완료되지 않은 구글 계정입니다".to_string(),
        ));
    }

    let email = claims
        .email
        .filter(|e| !e.is_empty())
        .ok_or(AppError::BadRequest(
            "구글 계정에서 이메일을 가져올 수 없습니다".to_string(),
        ))?;

    Ok(SocialUserInfo {
        provider: AuthProvider::Google,
        provider_id: claims.sub,
        email,
        nickname: claims.name,
        profile_image_url: claims.picture,
    })
}
