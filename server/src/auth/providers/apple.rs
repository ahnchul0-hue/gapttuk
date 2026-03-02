use jsonwebtoken::{decode, Algorithm, DecodingKey, Validation};
use serde::Deserialize;

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
#[derive(Deserialize)]
struct AppleJwks {
    keys: Vec<AppleJwk>,
}

#[derive(Deserialize)]
struct AppleJwk {
    kid: String,
    n: String,
    e: String,
}

/// Apple id_token (JWT) 검증.
/// Flutter 클라이언트가 Sign in with Apple에서 받은 id_token을 전달.
/// 서버는 Apple의 공개키(JWKS)로 서명을 검증한다.
pub async fn verify(state: &AppState, id_token: &str) -> Result<SocialUserInfo, AppError> {
    // 1. id_token 헤더에서 kid 추출
    let header = jsonwebtoken::decode_header(id_token)
        .map_err(|_| AppError::TokenInvalid)?;
    let kid = header.kid.ok_or(AppError::TokenInvalid)?;

    // 2. Apple JWKS 가져오기
    let jwks: AppleJwks = state
        .http_client
        .get("https://appleid.apple.com/auth/keys")
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Apple JWKS fetch failed: {e}")))?
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Apple JWKS parse failed: {e}")))?;

    // 3. kid에 매칭되는 키 찾기
    let jwk = jwks
        .keys
        .iter()
        .find(|k| k.kid == kid)
        .ok_or(AppError::TokenInvalid)?;

    // 4. RSA 공개키로 id_token 검증
    let decoding_key = DecodingKey::from_rsa_components(&jwk.n, &jwk.e)
        .map_err(|_| AppError::TokenInvalid)?;

    let mut validation = Validation::new(Algorithm::RS256);
    // Apple의 id_token audience는 클라이언트 ID
    if let Some(ref client_id) = state.config.apple_client_id {
        validation.set_audience(&[client_id]);
    } else {
        validation.validate_aud = false;
    }
    validation.set_issuer(&["https://appleid.apple.com"]);

    let token_data = decode::<AppleClaims>(id_token, &decoding_key, &validation)
        .map_err(|_| AppError::TokenInvalid)?;

    let claims = token_data.claims;

    Ok(SocialUserInfo {
        provider: AuthProvider::Apple,
        provider_id: claims.sub,
        email: claims.email.unwrap_or_default(),
        nickname: None,
        profile_image_url: None,
    })
}
