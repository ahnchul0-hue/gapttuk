use axum::{
    extract::State,
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use serde::{Deserialize, Serialize};

use crate::api::{ApiResponse, Created};
use crate::auth::extractor::Auth;
use crate::auth::providers::verify_social_token;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::services::auth_service::{self, ConsentInfo};
use crate::AppState;

// ── 요청/응답 DTO ──────────────────────────────────────

#[derive(Deserialize)]
pub struct SocialLoginRequest {
    pub access_token: String,
    pub referral_code: Option<String>,
    /// 이용약관 동의 (신규 가입 시 필수)
    #[serde(default)]
    pub terms_agreed: bool,
    /// 개인정보 처리방침 동의 (신규 가입 시 필수)
    #[serde(default)]
    pub privacy_agreed: bool,
    /// 마케팅 수신 동의 (선택)
    #[serde(default)]
    pub marketing_agreed: bool,
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
) -> Result<axum::response::Response, AppError> {
    social_login(state, AuthProvider::Kakao, body).await
}

/// Google 전용 요청 DTO — id_token (OIDC JWT) 기반
#[derive(Deserialize)]
struct GoogleLoginRequest {
    id_token: String,
    referral_code: Option<String>,
    #[serde(default)]
    terms_agreed: bool,
    #[serde(default)]
    privacy_agreed: bool,
    #[serde(default)]
    marketing_agreed: bool,
}

async fn login_google(
    State(state): State<AppState>,
    Json(body): Json<GoogleLoginRequest>,
) -> Result<axum::response::Response, AppError> {
    // 0. 입력 검증
    let token = body.id_token.trim();
    if token.is_empty() {
        return Err(AppError::BadRequest("id_token이 비어있습니다".to_string()));
    }
    if token.len() > 4096 {
        return Err(AppError::BadRequest("id_token이 너무 깁니다".to_string()));
    }

    // 1. Google id_token (JWT/OIDC) 검증
    let social_info = crate::auth::providers::google::verify(&state, token).await?;

    // 2. 추천 코드로 추천인 조회 (있는 경우)
    let referred_by = if let Some(ref code) = body.referral_code {
        auth_service::find_referrer_by_code(&state.pool, code).await?
    } else {
        None
    };

    let consent = ConsentInfo {
        terms_agreed: body.terms_agreed,
        privacy_agreed: body.privacy_agreed,
        marketing_agreed: body.marketing_agreed,
    };

    // 3. 사용자 upsert
    let (user, is_new_user) =
        auth_service::upsert_user(&state.pool, &social_info, referred_by, &consent).await?;

    // 4. 토큰 쌍 생성
    let tokens = auth_service::create_token_pair(&state.pool, &state.config, user.id).await?;

    let auth_response = AuthResponse {
        user: UserDto {
            id: user.id,
            email: user.email,
            nickname: user.nickname,
            profile_image_url: user.profile_image_url,
            referral_code: user.referral_code,
        },
        tokens,
        is_new_user,
    };

    // 신규 사용자 → 201 Created, 기존 사용자 → 200 OK
    if is_new_user {
        Ok(Created(auth_response).into_response())
    } else {
        Ok(ApiResponse::ok(auth_response).into_response())
    }
}

async fn login_apple(
    State(state): State<AppState>,
    Json(body): Json<SocialLoginRequest>,
) -> Result<axum::response::Response, AppError> {
    social_login(state, AuthProvider::Apple, body).await
}

async fn login_naver(
    State(state): State<AppState>,
    Json(body): Json<SocialLoginRequest>,
) -> Result<axum::response::Response, AppError> {
    social_login(state, AuthProvider::Naver, body).await
}

/// 공통 소셜 로그인 로직.
/// 신규 사용자 → 201 Created, 기존 사용자 → 200 OK.
async fn social_login(
    state: AppState,
    provider: AuthProvider,
    body: SocialLoginRequest,
) -> Result<axum::response::Response, AppError> {
    // 0. 입력 검증
    let token = body.access_token.trim();
    if token.is_empty() {
        return Err(AppError::BadRequest(
            "access_token이 비어있습니다".to_string(),
        ));
    }
    if token.len() > 4096 {
        return Err(AppError::BadRequest(
            "access_token이 너무 깁니다".to_string(),
        ));
    }

    // 1. provider에서 사용자 정보 검증
    let social_info = verify_social_token(&state, &provider, token).await?;

    // 2. 추천 코드로 추천인 조회 (있는 경우)
    let referred_by = if let Some(ref code) = body.referral_code {
        auth_service::find_referrer_by_code(&state.pool, code).await?
    } else {
        None
    };

    let consent = ConsentInfo {
        terms_agreed: body.terms_agreed,
        privacy_agreed: body.privacy_agreed,
        marketing_agreed: body.marketing_agreed,
    };

    // 3. 사용자 upsert (신규 시 referral_code 생성 + user_points + referrals도 트랜잭션 내 원자적 생성)
    let (user, is_new_user) =
        auth_service::upsert_user(&state.pool, &social_info, referred_by, &consent).await?;

    // 5. 토큰 쌍 생성
    let tokens = auth_service::create_token_pair(&state.pool, &state.config, user.id).await?;

    let auth_response = AuthResponse {
        user: UserDto {
            id: user.id,
            email: user.email,
            nickname: user.nickname,
            profile_image_url: user.profile_image_url,
            referral_code: user.referral_code,
        },
        tokens,
        is_new_user,
    };

    // 신규 사용자 → 201 Created, 기존 사용자 → 200 OK
    if is_new_user {
        Ok(Created(auth_response).into_response())
    } else {
        Ok(ApiResponse::ok(auth_response).into_response())
    }
}

/// POST /api/v1/auth/refresh — 토큰 갱신
async fn refresh(
    State(state): State<AppState>,
    Json(body): Json<RefreshRequest>,
) -> Result<ApiResponse<RefreshResponse>, AppError> {
    // 입력 검증
    let token = body.refresh_token.trim();
    if token.is_empty() {
        return Err(AppError::BadRequest(
            "리프레시 토큰을 입력해주세요".to_string(),
        ));
    }
    if token.len() > 512 {
        return Err(AppError::BadRequest(
            "유효하지 않은 리프레시 토큰입니다".to_string(),
        ));
    }

    let (tokens, _user_id) =
        auth_service::rotate_refresh_token(&state.pool, &state.config, token).await?;

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
    let user: crate::models::User =
        sqlx::query_as("SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL")
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
