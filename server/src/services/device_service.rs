use sqlx::PgPool;

use crate::error::AppError;
use crate::models::UserDevice;

/// 사용자 디바이스 목록 조회.
pub async fn list_devices(pool: &PgPool, user_id: i64) -> Result<Vec<UserDevice>, AppError> {
    let devices = sqlx::query_as::<_, UserDevice>(
        "SELECT * FROM user_devices WHERE user_id = $1 ORDER BY created_at DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await?;
    Ok(devices)
}

/// device_token 검증: trim 후 1~512바이트.
fn validate_device_token(raw: &str) -> Result<&str, AppError> {
    let token = raw.trim();
    if token.is_empty() || token.len() > 512 {
        return Err(AppError::BadRequest(
            "device_token은 1~512자여야 합니다".to_string(),
        ));
    }
    Ok(token)
}

/// 디바이스 등록 (ON CONFLICT → 토큰 갱신).
pub async fn register_device(
    pool: &PgPool,
    user_id: i64,
    device_token: &str,
    platform: &str,
) -> Result<UserDevice, AppError> {
    let token = validate_device_token(device_token)?;

    let device = sqlx::query_as::<_, UserDevice>(
        r#"
        INSERT INTO user_devices (user_id, device_token, platform)
        VALUES ($1, $2, $3::TEXT)
        ON CONFLICT (user_id, device_token)
        DO UPDATE SET platform = EXCLUDED.platform, updated_at = NOW()
        RETURNING *
        "#,
    )
    .bind(user_id)
    .bind(token)
    .bind(platform)
    .fetch_one(pool)
    .await?;
    Ok(device)
}

/// 디바이스 삭제.
pub async fn unregister_device(
    pool: &PgPool,
    user_id: i64,
    device_id: i64,
) -> Result<(), AppError> {
    let result = sqlx::query("DELETE FROM user_devices WHERE id = $1 AND user_id = $2")
        .bind(device_id)
        .bind(user_id)
        .execute(pool)
        .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("디바이스".to_string()));
    }
    Ok(())
}

/// push_enabled 명시적 설정.
pub async fn set_push(
    pool: &PgPool,
    user_id: i64,
    device_id: i64,
    push_enabled: bool,
) -> Result<UserDevice, AppError> {
    let device = sqlx::query_as::<_, UserDevice>(
        r#"
        UPDATE user_devices
        SET push_enabled = $3, updated_at = NOW()
        WHERE id = $1 AND user_id = $2
        RETURNING *
        "#,
    )
    .bind(device_id)
    .bind(user_id)
    .bind(push_enabled)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| AppError::NotFound("디바이스".to_string()))?;
    Ok(device)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn validate_token_normal() {
        assert_eq!(validate_device_token("abc123").unwrap(), "abc123");
    }

    #[test]
    fn validate_token_trims_whitespace() {
        assert_eq!(validate_device_token("  abc  ").unwrap(), "abc");
    }

    #[test]
    fn validate_token_empty_rejected() {
        assert!(validate_device_token("").is_err());
    }

    #[test]
    fn validate_token_whitespace_only_rejected() {
        assert!(validate_device_token("   ").is_err());
    }

    #[test]
    fn validate_token_512_bytes_ok() {
        let token = "a".repeat(512);
        assert!(validate_device_token(&token).is_ok());
    }

    #[test]
    fn validate_token_513_bytes_rejected() {
        let token = "a".repeat(513);
        assert!(validate_device_token(&token).is_err());
    }
}
