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

    // --- 보안 (M1-7) ---
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
            AppError::BadRequest(_) => {
                (StatusCode::BAD_REQUEST, "VALIDATION_001", self.to_string())
            }
            // SECURITY_
            AppError::Forbidden => (StatusCode::FORBIDDEN, "SECURITY_001", self.to_string()),

            // SYS_
            AppError::Internal(msg) => {
                tracing::error!(error = %msg, "Internal server error");
                sentry::capture_message(msg, sentry::Level::Error);
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

#[cfg(test)]
mod tests {
    use super::*;
    use axum::response::IntoResponse;

    #[test]
    fn token_expired_status_401() {
        let resp = AppError::TokenExpired.into_response();
        assert_eq!(resp.status(), StatusCode::UNAUTHORIZED);
    }

    #[test]
    fn token_invalid_status_401() {
        let resp = AppError::TokenInvalid.into_response();
        assert_eq!(resp.status(), StatusCode::UNAUTHORIZED);
    }

    #[test]
    fn unauthorized_status_401() {
        let resp = AppError::Unauthorized.into_response();
        assert_eq!(resp.status(), StatusCode::UNAUTHORIZED);
    }

    #[test]
    fn not_found_status_404() {
        let resp = AppError::NotFound("상품".to_string()).into_response();
        assert_eq!(resp.status(), StatusCode::NOT_FOUND);
    }

    #[test]
    fn bad_request_status_400() {
        let resp = AppError::BadRequest("잘못된 요청".to_string()).into_response();
        assert_eq!(resp.status(), StatusCode::BAD_REQUEST);
    }

    #[test]
    fn forbidden_status_403() {
        let resp = AppError::Forbidden.into_response();
        assert_eq!(resp.status(), StatusCode::FORBIDDEN);
    }

    #[test]
    fn internal_status_500() {
        let resp = AppError::Internal("crash".to_string()).into_response();
        assert_eq!(resp.status(), StatusCode::INTERNAL_SERVER_ERROR);
    }

    #[test]
    fn error_display_messages() {
        assert_eq!(AppError::TokenExpired.to_string(), "토큰이 만료되었습니다");
        assert_eq!(
            AppError::TokenInvalid.to_string(),
            "유효하지 않은 토큰입니다"
        );
        assert_eq!(
            AppError::NotFound("상품".to_string()).to_string(),
            "상품을(를) 찾을 수 없습니다"
        );
        assert_eq!(AppError::Forbidden.to_string(), "접근이 차단되었습니다");
    }
}
