use axum::{
    extract::{Path, State},
    routing::{delete, get, patch},
    Json, Router,
};
use serde::{Deserialize, Serialize};

use crate::api::{ApiResponse, Created, Deleted};
use crate::auth::extractor::Auth;
use crate::error::AppError;
use crate::models::Platform;
use crate::services::device_service;
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

#[derive(Deserialize)]
pub struct SetPushRequest {
    pub push_enabled: bool,
}

#[derive(Serialize)]
pub struct DeviceResponse {
    pub id: i64,
    pub device_token: String,
    pub platform: Platform,
    pub push_enabled: bool,
}

impl From<crate::models::UserDevice> for DeviceResponse {
    fn from(d: crate::models::UserDevice) -> Self {
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
        .route("/", get(list_devices).post(register_device))
        .route("/{device_id}", delete(unregister_device))
        .route("/{device_id}/push", patch(toggle_push))
}

// ── 핸들러 ─────────────────────────────────────────────

/// GET /api/v1/devices — 사용자 디바이스 목록
async fn list_devices(
    State(state): State<AppState>,
    Auth(claims): Auth,
) -> Result<ApiResponse<Vec<DeviceResponse>>, AppError> {
    let devices = device_service::list_devices(&state.pool, claims.sub).await?;
    let response: Vec<DeviceResponse> = devices.into_iter().map(DeviceResponse::from).collect();
    Ok(ApiResponse::ok(response))
}

/// POST /api/v1/devices — 디바이스 등록 (ON CONFLICT → 토큰 갱신)
async fn register_device(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Json(body): Json<RegisterDeviceRequest>,
) -> Result<Created<DeviceResponse>, AppError> {
    let device = device_service::register_device(
        &state.pool,
        claims.sub,
        &body.device_token,
        body.platform.as_str(),
    )
    .await?;
    Ok(Created(DeviceResponse::from(device)))
}

/// DELETE /api/v1/devices/:device_id — 디바이스 삭제 (204 No Content)
async fn unregister_device(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(device_id): Path<i64>,
) -> Result<Deleted, AppError> {
    device_service::unregister_device(&state.pool, claims.sub, device_id).await?;
    Ok(Deleted)
}

/// PATCH /api/v1/devices/:device_id/push — push_enabled 명시적 설정
async fn toggle_push(
    State(state): State<AppState>,
    Auth(claims): Auth,
    Path(device_id): Path<i64>,
    Json(body): Json<SetPushRequest>,
) -> Result<ApiResponse<DeviceResponse>, AppError> {
    let device =
        device_service::set_push(&state.pool, claims.sub, device_id, body.push_enabled).await?;
    Ok(ApiResponse::ok(DeviceResponse::from(device)))
}
