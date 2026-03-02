use axum::{extract::State, routing::{get, post}, Json, Router};
use serde::{Deserialize, Serialize};

use crate::api::{ApiResponse, Created};
use crate::auth::extractor::Auth;
use crate::auth::providers::verify_social_token;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::services::auth_service;
use crate::AppState;

// ── 요청/응답 DTO ──────────────────────────────────────

#[derive(Deserialize)]
pub struct SocialLoginRequest {
    pub access_token: String,
    pub referral_code: Option<String>,
}

#[derive(Serialize)]
pub struct AuthResponse {
    pub user: UserDto,
    pub tokens: crate::auth::jwt::TokenPair,
    pub is_new_user: bool,
}

#[derive(Serialize)]
pub struct UserDto {
    pub id: i64,
    pub email: String,
    pub nickname: Option<String>,
    pub profile_image_url: Option<String>,
    pub referral_code: String,
}

#[derive(Deserialize)]
pub struct RefreshRequest {
    pub refresh_token: String,
}

#[derive(Serialize)]
pub struct RefreshResponse {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: u64,
}

#[derive(Serialize)]
pub struct MeResponse {
    pub id: i64,
    pub email: String,
    pub nickname: Option<String>,
    pub profile_image_url: Option<String>,
    pub referral_code: String,
}

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/kakao", post(login_kakao))
        .route("/google", post(login_google))
        .route("/apple", post(login_apple))
        .route("/naver", post(login_naver))
        .route("/refresh", post(refresh))
        .route("/logout", post(logout))
        .route("/me", get(me))
}

// ── 핸들러 ─────────────────────────────────────────────

async fn login_kakao(
    State(state): State<AppState>,
    Json(body): Json<SocialLoginRequest>,
) -> Result<Created<AuthResponse>, AppError> {
    social_login(state, AuthProvider::Kakao, body).await
}

async fn login_google(
    State(state): State<AppState>,
    Json(body): Json<SocialLoginRequest>,
) -> Result<Created<AuthResponse>, AppError> {
    social_login(state, AuthProvider::Google, body).await
}

async fn login_apple(
    State(state): State<AppState>,
    Json(body): Json<SocialLoginRequest>,
) -> Result<Created<AuthResponse>, AppError> {
    social_login(state, AuthProvider::Apple, body).await
}

async fn login_naver(
    State(state): State<AppState>,
    Json(body): Json<SocialLoginRequest>,
) -> Result<Created<AuthResponse>, AppError> {
    social_login(state, AuthProvider::Naver, body).await
}

/// 공통 소셜 로그인 로직.
async fn social_login(
    state: AppState,
    provider: AuthProvider,
    body: SocialLoginRequest,
) -> Result<Created<AuthResponse>, AppError> {
    // 1. provider에서 사용자 정보 검증
    let social_info = verify_social_token(&state, &provider, &body.access_token).await?;

    // 2. 추천 코드로 추천인 조회 (있는 경우)
    let referred_by = if let Some(ref code) = body.referral_code {
        auth_service::find_referrer_by_code(&state.pool, code).await?
    } else {
        None
    };

    // 3. 추천 코드 생성 (신규 사용자용)
    let referral_code = auth_service::generate_referral_code(&state.pool).await?;

    // 4. 사용자 upsert
    let (user, is_new_user) =
        auth_service::upsert_user(&state.pool, &social_info, &referral_code, referred_by).await?;

    // 5. 추천 기록 저장 (신규 사용자 + 추천인이 있는 경우)
    if is_new_user {
        if let Some(referrer_id) = referred_by {
            if let Some(ref code) = body.referral_code {
                if let Err(e) = sqlx::query(
                    "INSERT INTO referrals (referrer_id, referred_id, referral_code) VALUES ($1, $2, $3)"
                )
                .bind(referrer_id)
                .bind(user.id)
                .bind(code.as_str())
                .execute(&state.pool)
                .await
                {
                    tracing::warn!(
                        referrer_id,
                        referred_id = user.id,
                        error = %e,
                        "Failed to insert referral record"
                    );
                }
            }
        }
    }

    // 6. 토큰 쌍 생성
    let tokens = auth_service::create_token_pair(&state.pool, &state.config, user.id).await?;

    Ok(Created(AuthResponse {
        user: UserDto {
            id: user.id,
            email: user.email,
            nickname: user.nickname,
            profile_image_url: user.profile_image_url,
            referral_code: user.referral_code,
        },
        tokens,
        is_new_user,
    }))
}

/// POST /api/v1/auth/refresh — 토큰 갱신
async fn refresh(
    State(state): State<AppState>,
    Json(body): Json<RefreshRequest>,
) -> Result<ApiResponse<RefreshResponse>, AppError> {
    let (tokens, _user_id) =
        auth_service::rotate_refresh_token(&state.pool, &state.config, &body.refresh_token)
            .await?;

    Ok(ApiResponse::ok(RefreshResponse {
        access_token: tokens.access_token,
        refresh_token: tokens.refresh_token,
        expires_in: tokens.expires_in,
    }))
}

/// POST /api/v1/auth/logout — 로그아웃 (모든 refresh token revoke)
async fn logout(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<()>, AppError> {
    auth_service::logout(&state.pool, claims.sub).await?;
    Ok(ApiResponse::ok(()))
}

/// GET /api/v1/auth/me — 내 정보
async fn me(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<MeResponse>, AppError> {
    let user: crate::models::User = sqlx::query_as(
        "SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL"
    )
    .bind(claims.sub)
    .fetch_optional(&state.pool)
    .await?
    .ok_or_else(|| AppError::NotFound("사용자".to_string()))?;

    Ok(ApiResponse::ok(MeResponse {
        id: user.id,
        email: user.email,
        nickname: user.nickname,
        profile_image_url: user.profile_image_url,
        referral_code: user.referral_code,
    }))
}
