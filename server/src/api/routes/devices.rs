use axum::{
    extract::{Path, State},
    routing::{delete, patch, post},
    Json, Router,
};
use serde::{Deserialize, Serialize};

use crate::api::{ApiResponse, Created};
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::models::{Platform, UserDevice};
use crate::AppState;

// ── 요청/응답 DTO ──────────────────────────────────────

#[derive(Deserialize)]
pub struct RegisterDeviceRequest {
    pub device_token: String,
    pub platform: PlatformInput,
}

#[derive(Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum PlatformInput {
    Android,
    Ios,
    Web,
}

impl PlatformInput {
    fn as_str(&self) -> &'static str {
        match self {
            Self::Android => "android",
            Self::Ios => "ios",
            Self::Web => "web",
        }
    }
}

#[derive(Serialize)]
pub struct DeviceResponse {
    pub id: i64,
    pub device_token: String,
    pub platform: Platform,
    pub push_enabled: bool,
}

impl From<UserDevice> for DeviceResponse {
    fn from(d: UserDevice) -> Self {
        Self {
            id: d.id,
            device_token: d.device_token,
            platform: d.platform,
            push_enabled: d.push_enabled,
        }
    }
}

// ── 라우터 ─────────────────────────────────────────────

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/", post(register_device))
        .route("/{device_id}", delete(unregister_device))
        .route("/{device_id}/push", patch(toggle_push))
}

// ── 핸들러 ─────────────────────────────────────────────

/// POST /api/v1/devices — 디바이스 등록 (ON CONFLICT → 토큰 갱신)
async fn register_device(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Json(body): Json<RegisterDeviceRequest>,
) -> Result<Created<DeviceResponse>, AppError> {
    if body.device_token.is_empty() || body.device_token.len() > 512 {
        return Err(AppError::BadRequest(
            "device_token은 1~512자여야 합니다".to_string(),
        ));
    }

    let device = sqlx::query_as::<_, UserDevice>(
        r#"
        INSERT INTO user_devices (user_id, device_token, platform)
        VALUES ($1, $2, $3::TEXT)
        ON CONFLICT (user_id, device_token)
        DO UPDATE SET platform = EXCLUDED.platform, updated_at = NOW()
        RETURNING *
        "#,
    )
    .bind(claims.sub)
    .bind(&body.device_token)
    .bind(body.platform.as_str())
    .fetch_one(&state.pool)
    .await?;

    Ok(Created(DeviceResponse::from(device)))
}

/// DELETE /api/v1/devices/:device_id — 디바이스 삭제
async fn unregister_device(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(device_id): Path<i64>,
) -> Result<ApiResponse<()>, AppError> {
    let result =
        sqlx::query("DELETE FROM user_devices WHERE id = $1 AND user_id = $2")
            .bind(device_id)
            .bind(claims.sub)
            .execute(&state.pool)
            .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("디바이스".to_string()));
    }

    Ok(ApiResponse::ok(()))
}

/// PATCH /api/v1/devices/:device_id/push — push_enabled 토글
async fn toggle_push(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(device_id): Path<i64>,
) -> Result<ApiResponse<DeviceResponse>, AppError> {
    let device = sqlx::query_as::<_, UserDevice>(
        r#"
        UPDATE user_devices
        SET push_enabled = NOT push_enabled, updated_at = NOW()
        WHERE id = $1 AND user_id = $2
        RETURNING *
        "#,
    )
    .bind(device_id)
    .bind(claims.sub)
    .fetch_optional(&state.pool)
    .await?
    .ok_or_else(|| AppError::NotFound("디바이스".to_string()))?;

    Ok(ApiResponse::ok(DeviceResponse::from(device)))
}
