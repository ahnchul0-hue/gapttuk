pub mod pagination;

use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use serde::Serialize;

/// 통합 성공 응답 래퍼.
/// 핸들러는 `Result<ApiResponse<T>, AppError>`를 반환한다.
#[derive(Serialize)]
pub struct ApiResponse<T: Serialize> {
    ok: bool,
    data: T,
}

impl<T: Serialize> ApiResponse<T> {
    /// 데이터를 성공 응답으로 래핑.
    pub fn ok(data: T) -> Self {
        Self { ok: true, data }
    }
}

impl<T: Serialize> IntoResponse for ApiResponse<T> {
    fn into_response(self) -> Response {
        (StatusCode::OK, Json(self)).into_response()
    }
}

/// 201 Created 응답 (POST 엔드포인트용).
pub struct Created<T: Serialize>(pub T);

impl<T: Serialize> IntoResponse for Created<T> {
    fn into_response(self) -> Response {
        let body = ApiResponse {
            ok: true,
            data: self.0,
        };
        (StatusCode::CREATED, Json(body)).into_response()
    }
}
