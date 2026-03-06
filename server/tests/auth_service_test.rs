//! auth_service 서비스 레벨 통합 테스트
//!
//! #[sqlx::test]는 각 테스트마다 독립 DB를 생성 + 마이그레이션 자동 적용.
//! 서비스 함수를 직접 호출하여 비즈니스 로직을 검증합니다.

use chrono::{Duration, Utc};
use gapttuk_server::auth::jwt::{
    decode_access_token, generate_refresh_token, hash_refresh_token,
};
use gapttuk_server::auth::providers::SocialUserInfo;
use gapttuk_server::error::AppError;
use gapttuk_server::models::AuthProvider;
use gapttuk_server::services::auth_service::{self, ConsentInfo};
use sqlx::PgPool;

mod common;

fn test_social_info(suffix: &str) -> SocialUserInfo {
    SocialUserInfo {
        provider: AuthProvider::Kakao,
        provider_id: format!("kakao_{suffix}"),
        email: format!("test_{suffix}@example.com"),
        nickname: Some(format!("유저_{suffix}")),
        profile_image_url: None,
    }
}

fn valid_consent() -> ConsentInfo {
    ConsentInfo {
        terms_agreed: true,
        privacy_agreed: true,
        marketing_agreed: false,
    }
}

// ─── upsert_user ───────────────────────────────────────────

#[sqlx::test]
async fn upsert_user_new_creates_user(pool: PgPool) {
    let info = test_social_info("new1");
    let consent = valid_consent();

    let (user, is_new) = auth_service::upsert_user(&pool, &info, None, &consent)
        .await
        .expect("upsert_user should succeed");

    assert!(is_new, "should be a new user");
    assert_eq!(user.email, "test_new1@example.com");
    assert!(user.referral_code.starts_with("GAP-"));
    assert!(user.deleted_at.is_none());
    assert!(user.terms_agreed_at.is_some());
    assert!(user.privacy_agreed_at.is_some());
    assert!(user.marketing_agreed_at.is_none());
}

#[sqlx::test]
async fn upsert_user_existing_updates_profile(pool: PgPool) {
    let info = test_social_info("exist1");
    let consent = valid_consent();

    // 첫 호출 — 신규 생성
    let (user1, is_new1) = auth_service::upsert_user(&pool, &info, None, &consent)
        .await
        .unwrap();
    assert!(is_new1);

    // 두 번째 호출 — 기존 업데이트
    let mut info2 = test_social_info("exist1");
    info2.nickname = Some("변경된닉네임".to_string());
    let (user2, is_new2) = auth_service::upsert_user(&pool, &info2, None, &consent)
        .await
        .unwrap();

    assert!(!is_new2, "should not be new user on second call");
    assert_eq!(user2.id, user1.id, "same user ID");
    assert_eq!(user2.nickname.as_deref(), Some("변경된닉네임"));
}

#[sqlx::test]
async fn upsert_user_missing_consent_rejected(pool: PgPool) {
    let info = test_social_info("noconsent");
    let no_consent = ConsentInfo {
        terms_agreed: false,
        privacy_agreed: false,
        marketing_agreed: false,
    };

    let result = auth_service::upsert_user(&pool, &info, None, &no_consent).await;
    assert!(
        matches!(result, Err(AppError::BadRequest(_))),
        "should reject without consent: {result:?}"
    );
}

#[sqlx::test]
async fn upsert_user_with_referral_gets_welcome_bonus(pool: PgPool) {
    // 1. 초대자 생성
    let referrer_info = test_social_info("referrer");
    let (referrer, _) = auth_service::upsert_user(&pool, &referrer_info, None, &valid_consent())
        .await
        .unwrap();

    // 2. 피초대자 생성 (referred_by = referrer.id)
    let referred_info = test_social_info("referred");
    let (referred, is_new) =
        auth_service::upsert_user(&pool, &referred_info, Some(referrer.id), &valid_consent())
            .await
            .unwrap();
    assert!(is_new);

    // 3. 피초대자 포인트 확인 (1¢ 웰컴 보상)
    let balance: Option<i32> =
        sqlx::query_scalar("SELECT balance FROM user_points WHERE user_id = $1")
            .bind(referred.id)
            .fetch_optional(&pool)
            .await
            .unwrap();
    assert_eq!(balance, Some(1), "referred user should have 1¢ welcome bonus");

    // 4. point_transactions 기록 확인
    let tx_type: Option<String> = sqlx::query_scalar(
        "SELECT transaction_type FROM point_transactions WHERE user_id = $1",
    )
    .bind(referred.id)
    .fetch_optional(&pool)
    .await
    .unwrap();
    assert_eq!(tx_type.as_deref(), Some("referral_welcome"));

    // 5. referrals 테이블 확인
    let referral_stage: Option<i16> = sqlx::query_scalar(
        "SELECT reward_stage FROM referrals WHERE referred_id = $1",
    )
    .bind(referred.id)
    .fetch_optional(&pool)
    .await
    .unwrap();
    assert_eq!(referral_stage, Some(0), "initial reward_stage should be 0");
}

// ─── create_token_pair ─────────────────────────────────────

#[sqlx::test]
async fn create_token_pair_returns_valid_tokens(pool: PgPool) {
    let info = test_social_info("token1");
    let (user, _) = auth_service::upsert_user(&pool, &info, None, &valid_consent())
        .await
        .unwrap();

    let config = common::test_config();
    let pair = auth_service::create_token_pair(&pool, &config, user.id)
        .await
        .expect("create_token_pair should succeed");

    // access_token 디코드 가능
    let claims = decode_access_token(&pair.access_token, &config)
        .expect("access token should be decodable");
    assert_eq!(claims.sub, user.id);

    // refresh_token은 비어있지 않은 hex 문자열
    assert!(!pair.refresh_token.is_empty());
    assert_eq!(pair.refresh_token.len(), 64);

    // DB에 토큰 해시가 저장되었는지 확인
    let hash = hash_refresh_token(&pair.refresh_token);
    let stored: bool =
        sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM refresh_tokens WHERE token_hash = $1)")
            .bind(&hash)
            .fetch_one(&pool)
            .await
            .unwrap();
    assert!(stored, "refresh token hash should be stored in DB");
}

// ─── rotate_refresh_token ──────────────────────────────────

#[sqlx::test]
async fn rotate_refresh_token_normal(pool: PgPool) {
    let info = test_social_info("rotate1");
    let (user, _) = auth_service::upsert_user(&pool, &info, None, &valid_consent())
        .await
        .unwrap();

    let config = common::test_config();
    let pair1 = auth_service::create_token_pair(&pool, &config, user.id)
        .await
        .unwrap();

    // rotate로 새 토큰 발급
    let (pair2, returned_user_id) =
        auth_service::rotate_refresh_token(&pool, &config, &pair1.refresh_token)
            .await
            .expect("rotate should succeed");

    assert_eq!(returned_user_id, user.id);
    assert_ne!(pair2.refresh_token, pair1.refresh_token, "new refresh token");
    // access_token은 결정적(같은 user_id + 같은 초 = 동일 JWT)이므로 유효성만 검증
    assert!(!pair2.access_token.is_empty(), "access token should be non-empty");

    // 기존 토큰은 revoke 상태
    let old_hash = hash_refresh_token(&pair1.refresh_token);
    let revoked: bool = sqlx::query_scalar(
        "SELECT revoked_at IS NOT NULL FROM refresh_tokens WHERE token_hash = $1",
    )
    .bind(&old_hash)
    .fetch_one(&pool)
    .await
    .unwrap();
    assert!(revoked, "old token should be revoked");
}

#[sqlx::test]
async fn rotate_refresh_token_expired(pool: PgPool) {
    let info = test_social_info("expired1");
    let (user, _) = auth_service::upsert_user(&pool, &info, None, &valid_consent())
        .await
        .unwrap();

    // 만료된 refresh token을 DB에 직접 삽입
    let raw_token = generate_refresh_token();
    let token_hash = hash_refresh_token(&raw_token);
    let expired_at = Utc::now() - Duration::hours(1);

    sqlx::query("INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)")
        .bind(user.id)
        .bind(&token_hash)
        .bind(expired_at)
        .execute(&pool)
        .await
        .unwrap();

    let config = common::test_config();
    let result = auth_service::rotate_refresh_token(&pool, &config, &raw_token).await;
    assert!(
        matches!(result, Err(AppError::TokenExpired)),
        "should reject expired token: {result:?}"
    );
}

#[sqlx::test]
async fn rotate_refresh_token_theft_detection(pool: PgPool) {
    let info = test_social_info("theft1");
    let (user, _) = auth_service::upsert_user(&pool, &info, None, &valid_consent())
        .await
        .unwrap();

    let config = common::test_config();

    // 토큰 2개 생성 (pair1은 정상 사용, pair2는 예비)
    let pair1 = auth_service::create_token_pair(&pool, &config, user.id)
        .await
        .unwrap();

    // pair1으로 정상 rotate → pair1 revoke됨
    let (_pair2, _) = auth_service::rotate_refresh_token(&pool, &config, &pair1.refresh_token)
        .await
        .unwrap();

    // 공격자가 pair1(이미 revoke됨)을 재사용 시도
    let result = auth_service::rotate_refresh_token(&pool, &config, &pair1.refresh_token).await;
    assert!(
        matches!(result, Err(AppError::TokenInvalid)),
        "reused revoked token should be rejected: {result:?}"
    );

    // 모든 토큰이 revoke되었는지 확인
    let active_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM refresh_tokens WHERE user_id = $1 AND revoked_at IS NULL",
    )
    .bind(user.id)
    .fetch_one(&pool)
    .await
    .unwrap();
    assert_eq!(active_count, 0, "all tokens should be revoked after theft detection");
}

// ─── logout ────────────────────────────────────────────────

#[sqlx::test]
async fn logout_revokes_all_tokens(pool: PgPool) {
    let info = test_social_info("logout1");
    let (user, _) = auth_service::upsert_user(&pool, &info, None, &valid_consent())
        .await
        .unwrap();

    let config = common::test_config();

    // 토큰 3개 생성
    for _ in 0..3 {
        auth_service::create_token_pair(&pool, &config, user.id)
            .await
            .unwrap();
    }

    auth_service::logout(&pool, user.id).await.unwrap();

    let active: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM refresh_tokens WHERE user_id = $1 AND revoked_at IS NULL",
    )
    .bind(user.id)
    .fetch_one(&pool)
    .await
    .unwrap();
    assert_eq!(active, 0, "all tokens should be revoked after logout");
}

// ─── generate_referral_code ────────────────────────────────

#[sqlx::test]
async fn generate_referral_code_format(pool: PgPool) {
    let code = auth_service::generate_referral_code(&pool).await.unwrap();
    assert!(code.starts_with("GAP-"), "code should start with GAP-: {code}");
    assert_eq!(code.len(), 10, "GAP- + 6 chars = 10: {code}");

    let suffix = &code[4..];
    assert!(
        suffix.chars().all(|c| c.is_ascii_alphanumeric()),
        "suffix should be alphanumeric: {suffix}"
    );
}

// ─── withdraw ──────────────────────────────────────────────

#[sqlx::test]
async fn withdraw_soft_deletes_user(pool: PgPool) {
    let info = test_social_info("withdraw1");
    let (user, _) = auth_service::upsert_user(&pool, &info, None, &valid_consent())
        .await
        .unwrap();

    let config = common::test_config();
    auth_service::create_token_pair(&pool, &config, user.id)
        .await
        .unwrap();

    auth_service::withdraw(&pool, user.id).await.unwrap();

    // 소프트 딜리트 확인
    let deleted: bool =
        sqlx::query_scalar("SELECT deleted_at IS NOT NULL FROM users WHERE id = $1")
            .bind(user.id)
            .fetch_one(&pool)
            .await
            .unwrap();
    assert!(deleted, "user should be soft-deleted");

    // 모든 토큰 revoke 확인
    let active: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM refresh_tokens WHERE user_id = $1 AND revoked_at IS NULL",
    )
    .bind(user.id)
    .fetch_one(&pool)
    .await
    .unwrap();
    assert_eq!(active, 0);

    // 중복 탈퇴 → NotFound
    let result = auth_service::withdraw(&pool, user.id).await;
    assert!(
        matches!(result, Err(AppError::NotFound(_))),
        "double withdraw should fail: {result:?}"
    );
}
