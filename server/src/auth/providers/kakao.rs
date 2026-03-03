use serde::Deserialize;

use super::SocialUserInfo;
use crate::error::AppError;
use crate::models::AuthProvider;
use crate::AppState;

/// 카카오 사용자 정보 API 응답
#[derive(Deserialize)]
struct KakaoUserResponse {
    id: i64,
    kakao_account: Option<KakaoAccount>,
}

#[derive(Deserialize)]
struct KakaoAccount {
    email: Option<String>,
    profile: Option<KakaoProfile>,
}

#[derive(Deserialize)]
struct KakaoProfile {
    nickname: Option<String>,
    profile_image_url: Option<String>,
}

/// 카카오 access_token으로 사용자 정보 조회.
/// POST https://kapi.kakao.com/v2/user/me
pub async fn verify(state: &AppState, access_token: &str) -> Result<SocialUserInfo, AppError> {
    let resp = state
        .http_client
        .get("https://kapi.kakao.com/v2/user/me")
        .bearer_auth(access_token)
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Kakao API request failed: {e}")))?;

    let status = resp.status();
    if status.is_server_error() || status == reqwest::StatusCode::TOO_MANY_REQUESTS {
        return Err(AppError::Internal(format!(
            "Kakao API unavailable (HTTP {status})"
        )));
    }
    if !status.is_success() {
        return Err(AppError::Unauthorized);
    }

    let body: KakaoUserResponse = resp
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Kakao response parse failed: {e}")))?;

    let account = body.kakao_account.ok_or(AppError::Unauthorized)?;
    let email = account.email.ok_or(AppError::Unauthorized)?;
    let profile = account.profile;

    Ok(SocialUserInfo {
        provider: AuthProvider::Kakao,
        provider_id: body.id.to_string(),
        email,
        nickname: profile.as_ref().and_then(|p| p.nickname.clone()),
        profile_image_url: profile.as_ref().and_then(|p| p.profile_image_url.clone()),
    })
}
