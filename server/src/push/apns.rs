use a2::{
    Client, ClientConfig, DefaultNotificationBuilder, Endpoint, NotificationBuilder,
    NotificationOptions, Priority,
};
use std::fs::File;

/// APNs 클라이언트 — a2 크레이트 기반 P8 토큰 인증.
pub struct ApnsClient {
    client: Client,
    topic: String,
}

impl ApnsClient {
    /// P8 키 파일 + key_id + team_id로 초기화.
    /// `topic`은 앱 번들 ID (e.g. "com.gapttuk.app").
    pub fn new(
        key_path: &str,
        key_id: &str,
        team_id: &str,
        is_production: bool,
    ) -> Result<Self, ApnsError> {
        let mut key_file = File::open(key_path)
            .map_err(|e| ApnsError::Config(format!("Cannot open P8 key: {e}")))?;

        let config = ClientConfig {
            endpoint: if is_production {
                Endpoint::Production
            } else {
                Endpoint::Sandbox
            },
            ..Default::default()
        };

        let client = Client::token(&mut key_file, key_id, team_id, config)
            .map_err(|e| ApnsError::Config(format!("APNs client init failed: {e}")))?;

        Ok(Self {
            client,
            topic: "com.gapttuk.app".to_string(),
        })
    }

    /// 푸시 전송.
    pub async fn send(
        &self,
        device_token: &str,
        title: &str,
        body: &str,
        deep_link: Option<&str>,
    ) -> Result<(), ApnsError> {
        let mut builder = DefaultNotificationBuilder::new()
            .set_title(title)
            .set_body(body)
            .set_sound("default");

        if let Some(link) = deep_link {
            builder = builder.set_mutable_content();
            // deep_link를 custom data로 전달
            let _ = link; // a2의 DefaultNotificationBuilder에서 custom data는 payload에 직접 추가
        }

        let options = NotificationOptions {
            apns_topic: Some(&self.topic),
            apns_priority: Some(Priority::High),
            ..Default::default()
        };

        let mut payload = builder.build(device_token, options);

        // deep_link를 커스텀 데이터로 추가
        if let Some(link) = deep_link {
            payload.add_custom_data("deep_link", &link)
                .map_err(|e| ApnsError::Send(format!("Failed to add deep_link: {e}")))?;
        }

        let response = self
            .client
            .send(payload)
            .await
            .map_err(|e| ApnsError::Send(format!("APNs send failed: {e}")))?;

        if response.code != 200 {
            return Err(ApnsError::Send(format!(
                "APNs error {}: {:?}",
                response.code, response.error
            )));
        }

        Ok(())
    }
}

#[derive(Debug, thiserror::Error)]
pub enum ApnsError {
    #[error("APNs config error: {0}")]
    Config(String),
    #[error("APNs send error: {0}")]
    Send(String),
}
