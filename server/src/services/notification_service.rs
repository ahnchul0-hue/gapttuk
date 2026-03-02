use sqlx::PgPool;

use crate::error::AppError;
use crate::models::{Notification, NotificationType, UserDevice};
use crate::push::PushClient;

/// 알림 생성 + 유저의 활성 디바이스에 푸시 전송.
/// 개별 디바이스 전송 실패는 warn 로그만 — 전체를 실패시키지 않음.
pub async fn create_and_push(
    pool: &PgPool,
    push: &PushClient,
    user_id: i64,
    ntype: NotificationType,
    reference_id: i64,
    title: &str,
    body: &str,
    deep_link: Option<&str>,
) -> Result<(), AppError> {
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

    // 3. 각 디바이스에 푸시 전송
    for device in &devices {
        if let Err(e) = push
            .send(&device.platform, &device.device_token, title, body, deep_link)
            .await
        {
            tracing::warn!(
                user_id,
                device_id = device.id,
                platform = ?device.platform,
                error = %e,
                "Push delivery failed"
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

/// 단건 읽음 처리.
pub async fn mark_as_read(
    pool: &PgPool,
    user_id: i64,
    notification_id: i64,
) -> Result<(), AppError> {
    let result = sqlx::query(
        "UPDATE notifications SET is_read = TRUE, read_at = NOW() WHERE id = $1 AND user_id = $2 AND is_read = FALSE",
    )
    .bind(notification_id)
    .bind(user_id)
    .execute(pool)
    .await?;

    if result.rows_affected() == 0 {
        // 이미 읽었거나 존재하지 않음 — 멱등성 유지
        let exists = sqlx::query_scalar::<_, bool>(
            "SELECT EXISTS(SELECT 1 FROM notifications WHERE id = $1 AND user_id = $2)",
        )
        .bind(notification_id)
        .bind(user_id)
        .fetch_one(pool)
        .await?;

        if !exists {
            return Err(AppError::NotFound("알림".to_string()));
        }
    }

    Ok(())
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
