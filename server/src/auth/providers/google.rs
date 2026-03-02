use serde::Deserialize;

use super::SocialUserInfo;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::AppState;

/// 구글 userinfo API 응답
#[derive(Deserialize)]
struct GoogleUserInfo {
    sub: String,
    email: Option<String>,
    email_verified: Option<bool>,
    name: Option<String>,
    picture: Option<String>,
}

/// 구글 access_token으로 사용자 정보 조회.
/// GET https://www.googleapis.com/oauth2/v3/userinfo
pub async fn verify(state: &AppState, access_token: &str) -> Result<SocialUserInfo, AppError> {
    let resp = state
        .http_client
        .get("https://www.googleapis.com/oauth2/v3/userinfo")
        .bearer_auth(access_token)
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Google API request failed: {e}")))?;

    if !resp.status().is_success() {
        return Err(AppError::Unauthorized);
    }

    let body: GoogleUserInfo = resp
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Google response parse failed: {e}")))?;

    if body.email_verified != Some(true) {
        return Err(AppError::BadRequest(
            "이메일 인증이 완료되지 않은 구글 계정입니다".to_string(),
        ));
    }

    let email = body.email.ok_or(AppError::Unauthorized)?;

    Ok(SocialUserInfo {
        provider: AuthProvider::Google,
        provider_id: body.sub,
        email,
        nickname: body.name,
        profile_image_url: body.picture,
    })
}
