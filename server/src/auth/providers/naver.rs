use serde::Deserialize;

use super::SocialUserInfo;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::AppState;

/// 네이버 사용자 정보 API 응답
#[derive(Deserialize)]
struct NaverUserResponse {
    response: NaverProfile,
}

#[derive(Deserialize)]
struct NaverProfile {
    id: String,
    email: Option<String>,
    nickname: Option<String>,
    profile_image: Option<String>,
}

/// 네이버 access_token으로 사용자 정보 조회.
/// GET https://openapi.naver.com/v1/nid/me
pub async fn verify(state: &AppState, access_token: &str) -> Result<SocialUserInfo, AppError> {
    let resp = state
        .http_client
        .get("https://openapi.naver.com/v1/nid/me")
        .bearer_auth(access_token)
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Naver API request failed: {e}")))?;

    if !resp.status().is_success() {
        return Err(AppError::Unauthorized);
    }

    let body: NaverUserResponse = resp
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Naver response parse failed: {e}")))?;

    let profile = body.response;
    let email = profile.email.ok_or(AppError::Unauthorized)?;

    Ok(SocialUserInfo {
        provider: AuthProvider::Naver,
        provider_id: profile.id,
        email,
        nickname: profile.nickname,
        profile_image_url: profile.profile_image,
    })
}
