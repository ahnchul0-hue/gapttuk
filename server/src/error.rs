use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use serde::Serialize;

/// API 에러 응답 JSON 본문
#[derive(Serialize)]
struct ErrorBody {
    ok: bool,
    error: ErrorDetail,
}

#[derive(Serialize)]
struct ErrorDetail {
    code: &'static str,
    message: String,
}

/// 통합 애플리케이션 에러 타입.
/// 각 variant는 하나의 HTTP 상태 코드 + 에러 코드에 매핑된다.
#[derive(Debug, thiserror::Error)]
pub enum AppError {
    // --- 인증 (M1-4) ---
    #[error("토큰이 만료되었습니다")]
    TokenExpired,

    #[error("유효하지 않은 토큰입니다")]
    TokenInvalid,

    #[error("인증이 필요합니다")]
    Unauthorized,

    // --- 리소스 ---
    #[error("{0}을(를) 찾을 수 없습니다")]
    NotFound(String),

    #[error("{0}")]
    BadRequest(String),

    #[error("{0}")]
    Conflict(String),

    // --- 보안 (M1-7) ---
    #[error("요청이 너무 많습니다")]
    RateLimited,

    #[error("접근이 차단되었습니다")]
    Forbidden,

    // --- 시스템 ---
    #[error("내부 서버 오류")]
    Internal(String),

    #[error(transparent)]
    Sqlx(#[from] sqlx::Error),
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, code, message) = match &self {
            // AUTH_
            AppError::TokenExpired => (StatusCode::UNAUTHORIZED, "AUTH_001", self.to_string()),
            AppError::TokenInvalid => (StatusCode::UNAUTHORIZED, "AUTH_002", self.to_string()),
            AppError::Unauthorized => (StatusCode::UNAUTHORIZED, "AUTH_003", self.to_string()),

            // RESOURCE_
            AppError::NotFound(_) => (StatusCode::NOT_FOUND, "RESOURCE_001", self.to_string()),
            AppError::BadRequest(_) => (StatusCode::BAD_REQUEST, "VALIDATION_001", self.to_string()),
            AppError::Conflict(_) => (StatusCode::CONFLICT, "RESOURCE_002", self.to_string()),

            // RATE_ / SECURITY_
            AppError::RateLimited => {
                (StatusCode::TOO_MANY_REQUESTS, "RATE_001", self.to_string())
            }
            AppError::Forbidden => (StatusCode::FORBIDDEN, "SECURITY_001", self.to_string()),

            // SYS_
            AppError::Internal(msg) => {
                tracing::error!(error = %msg, "Internal server error");
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    "SYS_001",
                    "내부 서버 오류".to_string(),
                )
            }
            AppError::Sqlx(e) => {
                tracing::error!(error = %e, "Database error");
                sentry::capture_error(e);
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    "SYS_002",
                    "내부 서버 오류".to_string(),
                )
            }
        };

        let body = ErrorBody {
            ok: false,
            error: ErrorDetail { code, message },
        };

        (status, Json(body)).into_response()
    }
}
