use chrono::{Duration, Utc};
use rand::Rng;
use sqlx::PgPool;

use crate::auth::jwt::{encode_access_token, generate_refresh_token, hash_refresh_token, TokenPair};
use crate::auth::providers::SocialUserInfo;
use crate::config::Config;
use crate::error::AppError;
use crate::models::User;

/// 소셜 로그인 사용자 upsert → 신규면 INSERT, 기존이면 UPDATE.
/// 반환: (User, is_new_user)
pub async fn upsert_user(
    pool: &PgPool,
    info: &SocialUserInfo,
    referral_code: &str,
    referred_by: Option<i64>,
) -> Result<(User, bool), AppError> {
    // auth_provider + auth_provider_id로 기존 사용자 조회
    let provider_str = match info.provider {
        crate::models::AuthProvider::Kakao => "kakao",
        crate::models::AuthProvider::Google => "google",
        crate::models::AuthProvider::Apple => "apple",
        crate::models::AuthProvider::Naver => "naver",
    };

    let existing: Option<User> = sqlx::query_as(
        "SELECT * FROM users WHERE auth_provider = $1 AND auth_provider_id = $2 AND deleted_at IS NULL"
    )
    .bind(provider_str)
    .bind(&info.provider_id)
    .fetch_optional(pool)
    .await?;

    if let Some(user) = existing {
        // 기존 사용자 — 프로필 업데이트
        let updated: User = sqlx::query_as(
            "UPDATE users SET nickname = COALESCE($1, nickname), profile_image_url = COALESCE($2, profile_image_url), updated_at = NOW() WHERE id = $3 RETURNING *"
        )
        .bind(&info.nickname)
        .bind(&info.profile_image_url)
        .bind(user.id)
        .fetch_one(pool)
        .await?;
        Ok((updated, false))
    } else {
        // 신규 사용자 — 트랜잭션으로 user + user_points 원자적 생성
        let mut tx = pool.begin().await?;

        let user: User = sqlx::query_as(
            "INSERT INTO users (email, nickname, auth_provider, auth_provider_id, profile_image_url, referral_code, referred_by) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *"
        )
        .bind(&info.email)
        .bind(&info.nickname)
        .bind(provider_str)
        .bind(&info.provider_id)
        .bind(&info.profile_image_url)
        .bind(referral_code)
        .bind(referred_by)
        .fetch_one(&mut *tx)
        .await?;

        // user_points 초기화 (balance=0, total_earned=0, total_spent=0)
        sqlx::query("INSERT INTO user_points (user_id) VALUES ($1)")
            .bind(user.id)
            .execute(&mut *tx)
            .await?;

        tx.commit().await?;
        Ok((user, true))
    }
}

/// 새 토큰 쌍 생성 + refresh token DB 저장.
pub async fn create_token_pair(
    pool: &PgPool,
    config: &Config,
    user_id: i64,
) -> Result<TokenPair, AppError> {
    let (access_token, expires_in) = encode_access_token(user_id, config)?;
    let refresh_token = generate_refresh_token();
    let token_hash = hash_refresh_token(&refresh_token);

    let expires_at = Utc::now() + Duration::seconds(config.jwt_refresh_ttl_secs as i64);

    sqlx::query(
        "INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)"
    )
    .bind(user_id)
    .bind(&token_hash)
    .bind(expires_at)
    .execute(pool)
    .await?;

    Ok(TokenPair {
        access_token,
        refresh_token,
        expires_in,
    })
}

/// Refresh token 순환: 기존 토큰 revoke → 새 토큰 쌍 발급.
/// 탈취 감지: 이미 revoke된 토큰이 재사용되면 해당 user의 모든 토큰 revoke.
pub async fn rotate_refresh_token(
    pool: &PgPool,
    config: &Config,
    raw_refresh_token: &str,
) -> Result<(TokenPair, i64), AppError> {
    let token_hash = hash_refresh_token(raw_refresh_token);

    // 트랜잭션으로 원자성 보장
    let mut tx = pool.begin().await?;

    // 1. token_hash로 DB 조회
    let row: Option<(i64, i64, Option<chrono::DateTime<Utc>>, chrono::DateTime<Utc>)> =
        sqlx::query_as(
            "SELECT id, user_id, revoked_at, expires_at FROM refresh_tokens WHERE token_hash = $1"
        )
        .bind(&token_hash)
        .fetch_optional(&mut *tx)
        .await?;

    let (token_id, user_id, revoked_at, expires_at) = row.ok_or(AppError::TokenInvalid)?;

    // 2. 탈취 감지 — 이미 revoke된 토큰 재사용
    if revoked_at.is_some() {
        // 해당 user의 모든 활성 토큰 revoke
        sqlx::query(
            "UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL"
        )
        .bind(user_id)
        .execute(&mut *tx)
        .await?;
        tx.commit().await?;

        tracing::warn!(user_id, "Refresh token reuse detected — all tokens revoked");
        return Err(AppError::TokenInvalid);
    }

    // 3. 만료 체크
    if expires_at < Utc::now() {
        return Err(AppError::TokenExpired);
    }

    // 4. 기존 토큰 revoke
    sqlx::query("UPDATE refresh_tokens SET revoked_at = NOW() WHERE id = $1")
        .bind(token_id)
        .execute(&mut *tx)
        .await?;

    // 5. 새 토큰 발급
    let (access_token, expires_in) = encode_access_token(user_id, config)?;
    let new_refresh = generate_refresh_token();
    let new_hash = hash_refresh_token(&new_refresh);
    let new_expires = Utc::now() + Duration::seconds(config.jwt_refresh_ttl_secs as i64);

    sqlx::query(
        "INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)"
    )
    .bind(user_id)
    .bind(&new_hash)
    .bind(new_expires)
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    Ok((
        TokenPair {
            access_token,
            refresh_token: new_refresh,
            expires_in,
        },
        user_id,
    ))
}

/// 로그아웃 — 해당 user의 모든 활성 refresh token revoke.
pub async fn logout(pool: &PgPool, user_id: i64) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL"
    )
    .bind(user_id)
    .execute(pool)
    .await?;
    Ok(())
}

/// 추천 코드 생성: GAP-XXXX (영숫자 4자리).
/// 충돌 시 재생성 (최대 10회).
pub async fn generate_referral_code(pool: &PgPool) -> Result<String, AppError> {
    const CHARSET: &[u8] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    for _ in 0..10 {
        // thread_rng()는 !Send이므로 await 전에 반드시 drop
        let code = {
            let mut rng = rand::thread_rng();
            let suffix: String = (0..4)
                .map(|_| CHARSET[rng.gen_range(0..CHARSET.len())] as char)
                .collect();
            format!("GAP-{suffix}")
        };

        let exists: bool = sqlx::query_scalar(
            "SELECT EXISTS(SELECT 1 FROM users WHERE referral_code = $1)"
        )
        .bind(&code)
        .fetch_one(pool)
        .await?;

        if !exists {
            return Ok(code);
        }
    }

    Err(AppError::Internal("Failed to generate unique referral code".to_string()))
}

/// 추천 코드로 추천인 user_id 조회.
pub async fn find_referrer_by_code(
    pool: &PgPool,
    referral_code: &str,
) -> Result<Option<i64>, AppError> {
    let id: Option<i64> = sqlx::query_scalar(
        "SELECT id FROM users WHERE referral_code = $1 AND deleted_at IS NULL"
    )
    .bind(referral_code)
    .fetch_optional(pool)
    .await?;
    Ok(id)
}
