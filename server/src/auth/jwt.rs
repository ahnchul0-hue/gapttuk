use jsonwebtoken::{decode, encode, DecodingKey, EncodingKey, Header, Validation};
use rand::Rng;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

use crate::config::Config;
use crate::error::AppError;

/// JWT audience — 토큰 수신자 식별.
pub const JWT_AUDIENCE: &str = "gapttuk-api";
/// JWT issuer — 토큰 발급자 식별.
pub const JWT_ISSUER: &str = "gapttuk-server";

/// JWT claims (access token 페이로드)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Claims {
    /// user.id
    pub sub: i64,
    /// expiration (Unix timestamp)
    pub exp: i64,
    /// issued at (Unix timestamp)
    pub iat: i64,
    /// audience (CWE-287 대응: 크로스-서비스 토큰 재사용 방지)
    pub aud: String,
    /// issuer
    pub iss: String,
}

/// 로그인/갱신 시 발급되는 토큰 쌍
#[derive(Debug, Serialize)]
pub struct TokenPair {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: u64,
}

/// JWT access token 발급.
pub fn encode_access_token(user_id: i64, config: &Config) -> Result<(String, u64), AppError> {
    let now = chrono::Utc::now().timestamp();
    let ttl = config.jwt_access_ttl_secs;
    let claims = Claims {
        sub: user_id,
        exp: now + ttl as i64,
        iat: now,
        aud: JWT_AUDIENCE.to_string(),
        iss: JWT_ISSUER.to_string(),
    };
    let token = encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(config.jwt_secret.as_bytes()),
    )
    .map_err(|e| AppError::Internal(format!("JWT encode failed: {e}")))?;
    Ok((token, ttl))
}

/// JWT access token 검증 + Claims 추출.
/// aud/iss claim을 반드시 검증하여 크로스-서비스 토큰 재사용을 차단.
pub fn decode_access_token(token: &str, config: &Config) -> Result<Claims, AppError> {
    let mut validation = Validation::new(jsonwebtoken::Algorithm::HS256);
    validation.set_audience(&[JWT_AUDIENCE]);
    validation.set_issuer(&[JWT_ISSUER]);

    let token_data = decode::<Claims>(
        token,
        &DecodingKey::from_secret(config.jwt_secret.as_bytes()),
        &validation,
    )
    .map_err(|e| match e.kind() {
        jsonwebtoken::errors::ErrorKind::ExpiredSignature => AppError::TokenExpired,
        _ => AppError::TokenInvalid,
    })?;
    Ok(token_data.claims)
}

/// 불투명 refresh token 생성 (32바이트 = 64자 hex).
pub fn generate_refresh_token() -> String {
    let mut rng = rand::thread_rng();
    let bytes: [u8; 32] = rng.gen();
    hex::encode(bytes)
}

/// Refresh token → SHA-256 해시 (DB 저장용).
pub fn hash_refresh_token(token: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(token.as_bytes());
    hex::encode(hasher.finalize())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_config() -> Config {
        crate::config::test_config()
    }

    #[test]
    fn test_encode_decode_access_token() {
        let config = test_config();
        let (token, ttl) = encode_access_token(42, &config).unwrap();
        assert_eq!(ttl, 300);

        let claims = decode_access_token(&token, &config).unwrap();
        assert_eq!(claims.sub, 42);
    }

    #[test]
    fn test_expired_token() {
        let config = test_config();
        // 만료 시간을 과거로 설정하여 토큰 생성
        let now = chrono::Utc::now().timestamp();
        let claims = Claims {
            sub: 1,
            exp: now - 100, // 100초 전에 만료
            iat: now - 200,
            aud: JWT_AUDIENCE.to_string(),
            iss: JWT_ISSUER.to_string(),
        };
        let token = encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(config.jwt_secret.as_bytes()),
        )
        .unwrap();

        let result = decode_access_token(&token, &config);
        assert!(matches!(result, Err(AppError::TokenExpired)));
    }

    #[test]
    fn test_invalid_secret() {
        let config = test_config();
        let (token, _) = encode_access_token(1, &config).unwrap();

        let mut wrong_config = test_config();
        wrong_config.jwt_secret = "wrong-secret-that-is-also-32-chars-long!!".to_string();

        let result = decode_access_token(&token, &wrong_config);
        assert!(matches!(result, Err(AppError::TokenInvalid)));
    }

    #[test]
    fn test_invalid_token_format() {
        let config = test_config();
        let result = decode_access_token("not-a-jwt-token", &config);
        assert!(matches!(result, Err(AppError::TokenInvalid)));
    }

    #[test]
    fn test_refresh_token_hash_deterministic() {
        let token = "abcdef1234567890";
        let hash1 = hash_refresh_token(token);
        let hash2 = hash_refresh_token(token);
        assert_eq!(hash1, hash2);
    }

    #[test]
    fn test_refresh_token_uniqueness() {
        let t1 = generate_refresh_token();
        let t2 = generate_refresh_token();
        assert_ne!(t1, t2);
        assert_eq!(t1.len(), 64); // 32바이트 = 64 hex chars
    }

    // --- 경계값 테스트 ---

    #[test]
    fn test_empty_token_is_invalid() {
        let config = test_config();
        let result = decode_access_token("", &config);
        assert!(matches!(result, Err(AppError::TokenInvalid)));
    }

    #[test]
    fn test_large_user_id() {
        let config = test_config();
        let user_id = i64::MAX;
        let (token, _) = encode_access_token(user_id, &config).unwrap();
        let claims = decode_access_token(&token, &config).unwrap();
        assert_eq!(claims.sub, user_id);
    }

    #[test]
    fn test_zero_user_id() {
        let config = test_config();
        let (token, _) = encode_access_token(0, &config).unwrap();
        let claims = decode_access_token(&token, &config).unwrap();
        assert_eq!(claims.sub, 0);
    }

    #[test]
    fn test_claims_iat_is_set() {
        let config = test_config();
        let (token, _) = encode_access_token(1, &config).unwrap();
        let claims = decode_access_token(&token, &config).unwrap();
        // iat는 현재 시간 근처 (±5초)
        let now = chrono::Utc::now().timestamp();
        assert!((claims.iat - now).abs() < 5);
    }

    #[test]
    fn test_custom_ttl() {
        let mut config = test_config();
        config.jwt_access_ttl_secs = 60; // 1분
        let (_, ttl) = encode_access_token(1, &config).unwrap();
        assert_eq!(ttl, 60);
    }

    #[test]
    fn test_refresh_token_is_hex() {
        let token = generate_refresh_token();
        assert!(token.chars().all(|c| c.is_ascii_hexdigit()));
    }

    #[test]
    fn test_hash_different_tokens_produce_different_hashes() {
        let hash1 = hash_refresh_token("token_a");
        let hash2 = hash_refresh_token("token_b");
        assert_ne!(hash1, hash2);
    }

    #[test]
    fn test_hash_is_64_hex_chars() {
        let hash = hash_refresh_token("any_token");
        assert_eq!(hash.len(), 64); // SHA-256 = 32바이트 = 64 hex
        assert!(hash.chars().all(|c| c.is_ascii_hexdigit()));
    }

    #[test]
    fn test_malformed_jwt_with_dots() {
        let config = test_config();
        let result = decode_access_token("a.b.c", &config);
        assert!(matches!(result, Err(AppError::TokenInvalid)));
    }
}
