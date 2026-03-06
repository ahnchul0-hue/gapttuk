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
/// 5xx/네트워크 오류(Internal) 시 300ms 대기 후 1회 재시도.
pub async fn verify_social_token(
    state: &AppState,
    provider: &AuthProvider,
    access_token: &str,
) -> Result<SocialUserInfo, AppError> {
    let verify = || async {
        match provider {
            AuthProvider::Kakao => kakao::verify(state, access_token).await,
            AuthProvider::Google => google::verify(state, access_token).await,
            AuthProvider::Apple => apple::verify(state, access_token).await,
            AuthProvider::Naver => naver::verify(state, access_token).await,
        }
    };

    match verify().await {
        Err(AppError::Internal(ref msg)) => {
            tracing::warn!(provider = ?provider, error = %msg, "Social auth failed — retrying once");
            metrics::counter!("auth_provider_retries_total", "provider" => format!("{provider:?}"))
                .increment(1);
            tokio::time::sleep(std::time::Duration::from_millis(300)).await;
            verify().await
        }
        other => other,
    }
}
