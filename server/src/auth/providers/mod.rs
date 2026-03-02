pub mod apple;
pub mod google;
pub mod kakao;
pub mod naver;

use crate::error::AppError;
use crate::models::AuthProvider;
use crate::AppState;

/// 소셜 provider에서 받아온 사용자 정보
#[derive(Debug)]
pub struct SocialUserInfo {
    pub provider: AuthProvider,
    pub provider_id: String,
    pub email: String,
    pub nickname: Option<String>,
    pub profile_image_url: Option<String>,
}

/// 소셜 provider access_token을 검증하고 사용자 정보를 가져온다.
pub async fn verify_social_token(
    state: &AppState,
    provider: &AuthProvider,
    access_token: &str,
) -> Result<SocialUserInfo, AppError> {
    match provider {
        AuthProvider::Kakao => kakao::verify(state, access_token).await,
        AuthProvider::Google => google::verify(state, access_token).await,
        AuthProvider::Apple => apple::verify(state, access_token).await,
        AuthProvider::Naver => naver::verify(state, access_token).await,
    }
}
