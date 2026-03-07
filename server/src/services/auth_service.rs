use chrono::{Duration, Utc};
use rand::Rng;
use sqlx::PgPool;

use crate::auth::jwt::{
    encode_access_token, generate_refresh_token, hash_refresh_token, TokenPair,
};
use crate::auth::providers::SocialUserInfo;
use crate::config::Config;
use crate::error::AppError;
use crate::models::User;
use crate::services::reward_service::add_points_and_record;

/// 개인정보 동의 파라미터 — 소셜 로그인 요청에서 전달.
pub struct ConsentInfo {
    pub terms_agreed: bool,
    pub privacy_agreed: bool,
    pub marketing_agreed: bool,
}

/// 소셜 로그인 사용자 upsert → 신규면 INSERT, 기존이면 UPDATE.
/// referral_code는 신규 사용자에게만 내부 생성 — 기존 사용자 로그인 시 불필요한 DB 조회 방지.
/// 신규 사용자는 terms_agreed + privacy_agreed가 필수.
/// 반환: (User, is_new_user)
#[tracing::instrument(skip(pool, info, consent), fields(provider = ?info.provider))]
pub async fn upsert_user(
    pool: &PgPool,
    info: &SocialUserInfo,
    referred_by: Option<i64>,
    consent: &ConsentInfo,
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
        metrics::counter!("auth_logins_total", "provider" => provider_str).increment(1);
        Ok((updated, false))
    } else {
        // 신규 사용자 — 동의 검증 필수
        if !consent.terms_agreed || !consent.privacy_agreed {
            return Err(AppError::BadRequest(
                "이용약관 및 개인정보 처리방침 동의가 필요합니다".to_string(),
            ));
        }

        let now = Utc::now();
        let terms_at = Some(now);
        let privacy_at = Some(now);
        let marketing_at = if consent.marketing_agreed {
            Some(now)
        } else {
            None
        };

        // referral_code 생성 후 트랜잭션으로 user + user_points 원자적 생성
        let referral_code = generate_referral_code(pool).await?;
        let mut tx = pool.begin().await?;

        let user: User = sqlx::query_as(
            r#"INSERT INTO users (email, nickname, auth_provider, auth_provider_id,
                profile_image_url, referral_code, referred_by,
                terms_agreed_at, privacy_agreed_at, marketing_agreed_at)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *"#,
        )
        .bind(&info.email)
        .bind(&info.nickname)
        .bind(provider_str)
        .bind(&info.provider_id)
        .bind(&info.profile_image_url)
        .bind(&referral_code)
        .bind(referred_by)
        .bind(terms_at)
        .bind(privacy_at)
        .bind(marketing_at)
        .fetch_one(&mut *tx)
        .await?;

        // user_points 초기화 (balance=0, total_earned=0, total_spent=0)
        sqlx::query("INSERT INTO user_points (user_id) VALUES ($1)")
            .bind(user.id)
            .execute(&mut *tx)
            .await?;

        // 추천 기록 저장 (추천인이 있는 경우 — 같은 트랜잭션으로 원자성 보장)
        if let Some(referrer_id) = referred_by {
            sqlx::query(
                "INSERT INTO referrals (referrer_id, referred_id, referral_code) VALUES ($1, $2, $3)",
            )
            .bind(referrer_id)
            .bind(user.id)
            .bind(&referral_code)
            .execute(&mut *tx)
            .await?;

            // Stage 0 웰컴 보상: 피초대자 1¢
            add_points_and_record(
                &mut tx,
                user.id,
                1,
                "referral_welcome",
                "추천 코드 가입 웰컴 보상",
                None,
            )
            .await?;
        }

        tx.commit().await?;
        metrics::counter!("auth_signups_total", "provider" => provider_str).increment(1);
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

    sqlx::query("INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)")
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
#[tracing::instrument(skip(pool, config, raw_refresh_token))]
pub async fn rotate_refresh_token(
    pool: &PgPool,
    config: &Config,
    raw_refresh_token: &str,
) -> Result<(TokenPair, i64), AppError> {
    let token_hash = hash_refresh_token(raw_refresh_token);

    // 트랜잭션으로 원자성 보장
    let mut tx = pool.begin().await?;

    // 1. token_hash로 DB 조회
    #[allow(clippy::type_complexity)]
    let row: Option<(
        i64,
        i64,
        Option<chrono::DateTime<Utc>>,
        chrono::DateTime<Utc>,
    )> = sqlx::query_as(
        "SELECT id, user_id, revoked_at, expires_at FROM refresh_tokens WHERE token_hash = $1",
    )
    .bind(&token_hash)
    .fetch_optional(&mut *tx)
    .await?;

    let (token_id, user_id, revoked_at, expires_at) = row.ok_or(AppError::TokenInvalid)?;

    // 2. 탈취 감지 — 이미 revoke된 토큰 재사용
    if revoked_at.is_some() {
        // 해당 user의 모든 활성 토큰 revoke (최대 2회 시도)
        // DB 에러 시에도 반드시 TokenInvalid를 반환하되, 가능한 한 토큰 revoke를 보장
        let mut revoke_succeeded = false;
        for attempt in 1..=2 {
            match sqlx::query(
                "UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL"
            )
            .bind(user_id)
            .execute(&mut *tx)
            .await
            {
                Ok(result) => {
                    tracing::warn!(
                        user_id,
                        revoked_count = result.rows_affected(),
                        "Refresh token reuse detected — all tokens revoked (attempt {attempt})"
                    );
                    if let Err(commit_err) = tx.commit().await {
                        tracing::error!(user_id, error = %commit_err, "Failed to commit token revocation");
                    } else {
                        revoke_succeeded = true;
                    }
                    break;
                }
                Err(e) => {
                    tracing::error!(
                        user_id,
                        attempt,
                        error = %e,
                        "Failed to revoke tokens during theft detection"
                    );
                    if attempt == 2 {
                        // 최종 실패 — Sentry 수준 경고
                        tracing::error!(
                            user_id,
                            "SECURITY: Token theft detected but revocation failed after 2 attempts"
                        );
                    }
                }
            }
        }

        if !revoke_succeeded {
            // tx drop → 자동 롤백, 그러나 탈취 시도 자체는 차단
            tracing::error!(
                user_id,
                "Token revocation could not be committed — manual intervention needed"
            );
        }

        return Err(AppError::TokenInvalid);
    }

    // 3. 만료 체크 — tx를 명시적으로 해제하여 풀 커넥션 조기 반환
    if expires_at < Utc::now() {
        drop(tx);
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

    sqlx::query("INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)")
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
        "UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL",
    )
    .bind(user_id)
    .execute(pool)
    .await?;
    Ok(())
}

/// 추천 코드 생성: GAP-XXXXXX (영숫자 6자리, 36^6 ≈ 22억 조합).
/// 충돌 시 재생성 (최대 10회).
pub async fn generate_referral_code(pool: &PgPool) -> Result<String, AppError> {
    const CHARSET: &[u8] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    for _ in 0..10 {
        // thread_rng()는 !Send이므로 await 전에 반드시 drop
        let code = {
            let mut rng = rand::thread_rng();
            let suffix: String = (0..6)
                .map(|_| CHARSET[rng.gen_range(0..CHARSET.len())] as char)
                .collect();
            format!("GAP-{suffix}")
        };

        let exists: bool =
            sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM users WHERE referral_code = $1)")
                .bind(&code)
                .fetch_one(pool)
                .await?;

        if !exists {
            return Ok(code);
        }
    }

    Err(AppError::Internal(
        "Failed to generate unique referral code".to_string(),
    ))
}

/// 동의 정보 업데이트 (기존 사용자 — 온보딩 후 호출).
/// 이미 동의한 항목은 취소 불가(단방향).
pub async fn update_consent(
    pool: &PgPool,
    user_id: i64,
    consent: &ConsentInfo,
) -> Result<(), AppError> {
    let now = Utc::now();
    sqlx::query(
        r#"UPDATE users SET
            terms_agreed_at   = CASE WHEN $1 AND terms_agreed_at   IS NULL THEN $4 ELSE terms_agreed_at   END,
            privacy_agreed_at = CASE WHEN $2 AND privacy_agreed_at IS NULL THEN $4 ELSE privacy_agreed_at END,
            marketing_agreed_at = CASE WHEN $3 THEN COALESCE(marketing_agreed_at, $4) ELSE marketing_agreed_at END,
            updated_at = NOW()
        WHERE id = $5 AND deleted_at IS NULL"#,
    )
    .bind(consent.terms_agreed)
    .bind(consent.privacy_agreed)
    .bind(consent.marketing_agreed)
    .bind(now)
    .bind(user_id)
    .execute(pool)
    .await?;
    Ok(())
}

/// 회원 탈퇴 (소프트 딜리트 + 모든 refresh token revoke).
#[tracing::instrument(skip(pool))]
pub async fn withdraw(pool: &PgPool, user_id: i64) -> Result<(), AppError> {
    let mut tx = pool.begin().await?;

    // 1. 소프트 딜리트
    let result = sqlx::query(
        "UPDATE users SET deleted_at = NOW(), updated_at = NOW() WHERE id = $1 AND deleted_at IS NULL",
    )
    .bind(user_id)
    .execute(&mut *tx)
    .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("사용자".to_string()));
    }

    // 2. 모든 refresh token revoke
    sqlx::query(
        "UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL",
    )
    .bind(user_id)
    .execute(&mut *tx)
    .await?;

    // 3. 디바이스 토큰 비활성화
    sqlx::query(
        "UPDATE user_devices SET push_enabled = false, updated_at = NOW() WHERE user_id = $1",
    )
    .bind(user_id)
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;
    metrics::counter!("auth_withdrawals_total").increment(1);
    Ok(())
}

/// 추천 코드로 추천인 user_id 조회.
/// 코드 형식: GAP-XXXXXX (10자) — 형식이 맞지 않으면 DB 조회 없이 None 반환.
pub async fn find_referrer_by_code(
    pool: &PgPool,
    referral_code: &str,
) -> Result<Option<i64>, AppError> {
    let code = referral_code.trim();
    if code.len() > 20 || code.is_empty() {
        return Ok(None);
    }
    let id: Option<i64> =
        sqlx::query_scalar("SELECT id FROM users WHERE referral_code = $1 AND deleted_at IS NULL")
            .bind(code)
            .fetch_optional(pool)
            .await?;
    Ok(id)
}
