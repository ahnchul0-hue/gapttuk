use sqlx::PgPool;

use crate::error::AppError;
use crate::models::{Notification, NotificationType, UserDevice};
use crate::push::PushClient;

/// 푸시 알림 전송 요청 파라미터.
pub struct PushNotification<'a> {
    pub user_id: i64,
    pub ntype: NotificationType,
    pub reference_id: i64,
    pub title: &'a str,
    pub body: &'a str,
    pub deep_link: Option<&'a str>,
}

/// 알림 생성 + 유저의 활성 디바이스에 푸시 전송.
/// 개별 디바이스 전송 실패는 warn 로그만 — 전체를 실패시키지 않음.
pub async fn create_and_push(
    pool: &PgPool,
    push: &PushClient,
    notif: &PushNotification<'_>,
) -> Result<(), AppError> {
    let PushNotification {
        user_id,
        ref ntype,
        reference_id,
        title,
        body,
        deep_link,
    } = *notif;
    // 1. notifications INSERT (reference_type = notification_type for filtering)
    sqlx::query(
        r#"
        INSERT INTO notifications (user_id, notification_type, reference_id, reference_type, title, body, deep_link)
        VALUES ($1, $2::TEXT, $3, $4, $5, $6, $7)
        "#,
    )
    .bind(user_id)
    .bind(ntype.as_str())
    .bind(reference_id)
    .bind(ntype.as_str())
    .bind(title)
    .bind(body)
    .bind(deep_link)
    .execute(pool)
    .await?;

    // 2. 활성 디바이스 조회
    let devices = sqlx::query_as::<_, UserDevice>(
        "SELECT * FROM user_devices WHERE user_id = $1 AND push_enabled = TRUE",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await?;

    // 3. 각 디바이스에 푸시 전송 — 무효 토큰은 수집 후 배치 비활성화
    let mut invalid_device_ids: Vec<i64> = Vec::new();
    for device in &devices {
        if let Err(e) = push
            .send(
                &device.platform,
                &device.device_token,
                title,
                body,
                deep_link,
            )
            .await
        {
            if e.is_invalid_token() {
                tracing::info!(
                    device_id = device.id,
                    platform = ?device.platform,
                    "Device token invalid — will deactivate"
                );
                invalid_device_ids.push(device.id);
            } else {
                tracing::warn!(
                    user_id,
                    device_id = device.id,
                    platform = ?device.platform,
                    error = %e,
                    "Push delivery failed"
                );
            }
        }
    }

    // 4. 무효 디바이스 배치 비활성화 (N회 UPDATE → 1회)
    if !invalid_device_ids.is_empty() {
        if let Err(e) = sqlx::query(
            "UPDATE user_devices SET push_enabled = FALSE, updated_at = NOW() WHERE id = ANY($1)",
        )
        .bind(&invalid_device_ids[..])
        .execute(pool)
        .await
        {
            tracing::error!(
                error = %e,
                device_ids = ?invalid_device_ids,
                "Failed to deactivate invalid device tokens — tokens will continue receiving failed pushes"
            );
        }
    }

    Ok(())
}

/// 사용자의 알림 목록 조회 (최신순, 페이지네이션).
pub async fn get_user_notifications(
    pool: &PgPool,
    user_id: i64,
    cursor: Option<i64>,
    limit: i64,
) -> Result<Vec<Notification>, AppError> {
    let notifications = if let Some(cursor_id) = cursor {
        sqlx::query_as::<_, Notification>(
            r#"
            SELECT * FROM notifications
            WHERE user_id = $1 AND id < $2
            ORDER BY id DESC
            LIMIT $3
            "#,
        )
        .bind(user_id)
        .bind(cursor_id)
        .bind(limit + 1)
        .fetch_all(pool)
        .await?
    } else {
        sqlx::query_as::<_, Notification>(
            r#"
            SELECT * FROM notifications
            WHERE user_id = $1
            ORDER BY id DESC
            LIMIT $2
            "#,
        )
        .bind(user_id)
        .bind(limit + 1)
        .fetch_all(pool)
        .await?
    };

    Ok(notifications)
}

/// 단건 읽음 처리 — CTE로 UPDATE + 존재 확인을 단일 쿼리로 수행.
pub async fn mark_as_read(
    pool: &PgPool,
    user_id: i64,
    notification_id: i64,
) -> Result<(), AppError> {
    let row: (i64, i64) = sqlx::query_as(
        r#"
        WITH do_update AS (
            UPDATE notifications SET is_read = TRUE, read_at = NOW()
            WHERE id = $1 AND user_id = $2 AND is_read = FALSE
            RETURNING id
        )
        SELECT
            (SELECT COUNT(*) FROM notifications WHERE id = $1 AND user_id = $2) AS found,
            (SELECT COUNT(*) FROM do_update) AS updated
        "#,
    )
    .bind(notification_id)
    .bind(user_id)
    .fetch_one(pool)
    .await?;

    if row.0 == 0 {
        return Err(AppError::NotFound("알림".to_string()));
    }
    // row.1 == 0이면 이미 읽은 상태 — 멱등성 유지

    Ok(())
}

/// 알림 삭제 — 해당 사용자의 알림만 삭제 가능.
pub async fn delete_notification(pool: &PgPool, user_id: i64, notification_id: i64) -> Result<(), AppError> {
    let result = sqlx::query("DELETE FROM notifications WHERE id = $1 AND user_id = $2")
        .bind(notification_id)
        .bind(user_id)
        .execute(pool)
        .await?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("알림".to_string()));
    }
    Ok(())
}

/// 읽지 않은 알림 수 조회.
pub async fn get_unread_count(pool: &PgPool, user_id: i64) -> Result<i64, AppError> {
    let count: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND is_read = false")
        .bind(user_id)
        .fetch_one(pool)
        .await?;
    Ok(count.0)
}

/// 전체 읽음 처리.
pub async fn mark_all_read(pool: &PgPool, user_id: i64) -> Result<u64, AppError> {
    let result = sqlx::query(
        "UPDATE notifications SET is_read = TRUE, read_at = NOW() WHERE user_id = $1 AND is_read = FALSE",
    )
    .bind(user_id)
    .execute(pool)
    .await?;

    Ok(result.rows_affected())
}

// NotificationType → DB TEXT 변환 헬퍼
impl NotificationType {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::PriceAlert => "price_alert",
            Self::CategoryAlert => "category_alert",
            Self::KeywordAlert => "keyword_alert",
            Self::Referral => "referral",
            Self::Event => "event",
            Self::System => "system",
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn notification_type_as_str_all_variants() {
        assert_eq!(NotificationType::PriceAlert.as_str(), "price_alert");
        assert_eq!(NotificationType::CategoryAlert.as_str(), "category_alert");
        assert_eq!(NotificationType::KeywordAlert.as_str(), "keyword_alert");
        assert_eq!(NotificationType::Referral.as_str(), "referral");
        assert_eq!(NotificationType::Event.as_str(), "event");
        assert_eq!(NotificationType::System.as_str(), "system");
    }

    #[test]
    fn push_notification_struct_construction() {
        let notif = PushNotification {
            user_id: 42,
            ntype: NotificationType::PriceAlert,
            reference_id: 100,
            title: "테스트 제목",
            body: "테스트 내용",
            deep_link: Some("gapttuk://product/1"),
        };
        assert_eq!(notif.user_id, 42);
        assert_eq!(notif.reference_id, 100);
        assert_eq!(notif.deep_link, Some("gapttuk://product/1"));
    }

    #[test]
    fn push_notification_without_deep_link() {
        let notif = PushNotification {
            user_id: 1,
            ntype: NotificationType::System,
            reference_id: 0,
            title: "시스템 알림",
            body: "서버 점검 안내",
            deep_link: None,
        };
        assert!(notif.deep_link.is_none());
        assert_eq!(notif.ntype.as_str(), "system");
    }
}
