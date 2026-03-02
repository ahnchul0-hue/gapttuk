use std::sync::Arc;

use axum::http::StatusCode;
use axum::response::IntoResponse;
use tower_governor::{
    governor::{GovernorConfig, GovernorConfigBuilder},
    key_extractor::SmartIpKeyExtractor,
    GovernorError, GovernorLayer,
};

type Middleware = ::governor::middleware::StateInformationMiddleware;
type HeaderLayer = GovernorLayer<SmartIpKeyExtractor, Middleware, axum::body::Body>;

/// 전역 Rate Limiter — 60 req/min per IP.
/// `per_second(1)` = 1초마다 토큰 1개 보충, `burst_size(60)` = 최대 60개 누적.
/// `Arc<GovernorConfig>`도 함께 반환하여 주기적 메모리 정리(`retain_recent`)에 사용.
/// SmartIpKeyExtractor: Forwarded/X-Forwarded-For 우선, 없으면 ConnectInfo 폴백.
pub fn global_limiter() -> (
    HeaderLayer,
    Arc<GovernorConfig<SmartIpKeyExtractor, Middleware>>,
) {
    let config = Arc::new(
        GovernorConfigBuilder::default()
            .key_extractor(SmartIpKeyExtractor)
            .per_second(1)
            .burst_size(60)
            .use_headers()
            .finish()
            .expect("valid governor config"),
    );
    let layer = GovernorLayer::new(config.clone()).error_handler(json_error_response);
    (layer, config)
}

/// 검색 전용 Rate Limiter — 10 req/min per IP.
/// `per_second(6)` = 6초마다 토큰 1개, `burst_size(10)` = 최대 10개 누적.
/// SmartIpKeyExtractor로 프록시 환경에서도 실제 클라이언트 IP 기반 제한.
pub fn search_limiter() -> HeaderLayer {
    let config = GovernorConfigBuilder::default()
        .key_extractor(SmartIpKeyExtractor)
        .per_second(6)
        .burst_size(10)
        .use_headers()
        .finish()
        .expect("valid governor config");
    GovernorLayer::new(config).error_handler(json_error_response)
}

/// 인증 전용 Rate Limiter — 15 req/min per IP (브루트포스 방지).
/// `per_second(4)` = 4초마다 토큰 1개, `burst_size(3)` = 최대 3개 누적.
/// SmartIpKeyExtractor로 프록시 환경에서도 실제 클라이언트 IP 기반 제한.
pub fn auth_limiter() -> HeaderLayer {
    let config = GovernorConfigBuilder::default()
        .key_extractor(SmartIpKeyExtractor)
        .per_second(4)
        .burst_size(3)
        .use_headers()
        .finish()
        .expect("valid governor config");
    GovernorLayer::new(config).error_handler(json_error_response)
}

/// GovernorError를 AppError JSON 포맷으로 변환.
/// 기본 tower_governor 응답은 plain text이므로 커스텀 핸들러가 필수.
fn json_error_response(err: GovernorError) -> axum::http::Response<axum::body::Body> {
    match err {
        GovernorError::TooManyRequests { headers, .. } => {
            let body = axum::Json(serde_json::json!({
                "ok": false,
                "error": {
                    "code": "RATE_001",
                    "message": "요청이 너무 많습니다"
                }
            }));
            let mut response = (StatusCode::TOO_MANY_REQUESTS, body).into_response();
            if let Some(h) = headers {
                response.headers_mut().extend(h);
            }
            response
        }
        GovernorError::UnableToExtractKey => {
            let body = axum::Json(serde_json::json!({
                "ok": false,
                "error": {
                    "code": "SYS_001",
                    "message": "내부 서버 오류"
                }
            }));
            (StatusCode::INTERNAL_SERVER_ERROR, body).into_response()
        }
        GovernorError::Other { code, msg, headers } => {
            let body = axum::Json(serde_json::json!({
                "ok": false,
                "error": {
                    "code": "RATE_001",
                    "message": msg.unwrap_or_default()
                }
            }));
            let mut response = (code, body).into_response();
            if let Some(h) = headers {
                response.headers_mut().extend(h);
            }
            response
        }
    }
}
