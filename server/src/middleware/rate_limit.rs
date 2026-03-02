use std::sync::Arc;

use axum::http::StatusCode;
use axum::response::IntoResponse;
use tower_governor::{
    governor::{GovernorConfig, GovernorConfigBuilder},
    key_extractor::PeerIpKeyExtractor,
    GovernorError, GovernorLayer,
};

type Middleware = ::governor::middleware::StateInformationMiddleware;
type HeaderLayer = GovernorLayer<PeerIpKeyExtractor, Middleware, axum::body::Body>;

// NOTE: PeerIpKeyExtractor는 TCP 소켓의 피어 IP를 사용한다.
// 리버스 프록시(nginx/ALB) 뒤에 배포 시, 모든 클라이언트가 프록시 IP로 인식되어
// 동일 버킷을 공유하게 된다. 프록시 배포 시 SmartIpKeyExtractor 또는
// X-Forwarded-For를 검증하는 커스텀 KeyExtractor로 교체해야 한다.

/// 전역 Rate Limiter — 60 req/min per IP.
/// `per_second(1)` = 1초마다 토큰 1개 보충, `burst_size(60)` = 최대 60개 누적.
/// `Arc<GovernorConfig>`도 함께 반환하여 주기적 메모리 정리(`retain_recent`)에 사용.
pub fn global_limiter() -> (HeaderLayer, Arc<GovernorConfig<PeerIpKeyExtractor, Middleware>>) {
    let config = Arc::new(
        GovernorConfigBuilder::default()
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
/// 호출 시마다 독립 state가 생성되므로, 서버 시작 시 한 번만 호출해야 한다.
pub fn search_limiter() -> HeaderLayer {
    let config = GovernorConfigBuilder::default()
        .per_second(6)
        .burst_size(10)
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
        GovernorError::Other {
            code,
            msg,
            headers,
        } => {
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
