pub mod apns;
pub mod fcm;

use crate::config::{AppEnv, Config};
use crate::models::Platform;

use apns::ApnsClient;
use fcm::FcmClient;

/// 통합 푸시 클라이언트 — Platform별 FCM/APNs dispatch.
/// 설정이 없으면 해당 채널을 None으로 유지 (graceful degradation).
pub struct PushClient {
    fcm: Option<FcmClient>,
    apns: Option<ApnsClient>,
}

impl PushClient {
    /// Config에서 설정값이 있으면 클라이언트 초기화, 없으면 None.
    pub fn new(config: &Config, http: reqwest::Client) -> Self {
        let fcm = config.fcm_service_account.as_ref().and_then(|path| {
            match FcmClient::from_service_account(path, http.clone()) {
                Ok(client) => {
                    tracing::info!("FCM client initialized");
                    Some(client)
                }
                Err(e) => {
                    tracing::warn!(error = %e, "FCM client init failed — push disabled for Android");
                    None
                }
            }
        });

        let apns = match (
            config.apns_key_path.as_ref(),
            config.apns_key_id.as_ref(),
            config.apns_team_id.as_ref(),
        ) {
            (Some(key_path), Some(key_id), Some(team_id)) => {
                let is_prod = config.app_env == AppEnv::Prod;
                match ApnsClient::new(key_path, key_id, team_id, is_prod) {
                    Ok(client) => {
                        tracing::info!("APNs client initialized");
                        Some(client)
                    }
                    Err(e) => {
                        tracing::warn!(error = %e, "APNs client init failed — push disabled for iOS");
                        None
                    }
                }
            }
            _ => {
                tracing::info!("APNs config incomplete — push disabled for iOS");
                None
            }
        };

        Self { fcm, apns }
    }

    /// Platform에 따라 FCM/APNs dispatch. 클라이언트 미설정 시 warn 로그 후 skip.
    pub async fn send(
        &self,
        platform: &Platform,
        token: &str,
        title: &str,
        body: &str,
        deep_link: Option<&str>,
    ) -> Result<(), PushError> {
        match platform {
            Platform::Android => match &self.fcm {
                Some(client) => client
                    .send(token, title, body, deep_link)
                    .await
                    .map_err(PushError::Fcm),
                None => {
                    tracing::warn!("FCM client not configured — skipping Android push");
                    Ok(())
                }
            },
            Platform::Ios => match &self.apns {
                Some(client) => client
                    .send(token, title, body, deep_link)
                    .await
                    .map_err(PushError::Apns),
                None => {
                    tracing::warn!("APNs client not configured — skipping iOS push");
                    Ok(())
                }
            },
            Platform::Web => {
                tracing::debug!("Web push not implemented — skipping");
                Ok(())
            }
        }
    }
}

#[derive(Debug, thiserror::Error)]
pub enum PushError {
    #[error(transparent)]
    Fcm(#[from] fcm::FcmError),
    #[error(transparent)]
    Apns(#[from] apns::ApnsError),
}
