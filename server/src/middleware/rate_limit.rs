use tower_governor::{
    governor::GovernorConfigBuilder, key_extractor::PeerIpKeyExtractor, GovernorLayer,
};

type HeaderLayer = GovernorLayer<
    PeerIpKeyExtractor,
    ::governor::middleware::StateInformationMiddleware,
    axum::body::Body,
>;

// NOTE: PeerIpKeyExtractor는 TCP 소켓의 피어 IP를 사용한다.
// 리버스 프록시(nginx/ALB) 뒤에 배포 시, 모든 클라이언트가 프록시 IP로 인식되어
// 동일 버킷을 공유하게 된다. 프록시 배포 시 SmartIpKeyExtractor 또는
// X-Forwarded-For를 검증하는 커스텀 KeyExtractor로 교체해야 한다.

/// 전역 Rate Limiter — 60 req/min per IP.
/// `per_second(1)` = 1초마다 토큰 1개 보충, `burst_size(60)` = 최대 60개 누적.
pub fn global_limiter() -> HeaderLayer {
    let config = GovernorConfigBuilder::default()
        .per_second(1)
        .burst_size(60)
        .use_headers()
        .finish()
        .expect("valid governor config");
    GovernorLayer::new(config)
}

/// 검색 전용 Rate Limiter — 10 req/min per IP.
/// `per_second(6)` = 6초마다 토큰 1개, `burst_size(10)` = 최대 10개 누적.
pub fn search_limiter() -> HeaderLayer {
    let config = GovernorConfigBuilder::default()
        .per_second(6)
        .burst_size(10)
        .use_headers()
        .finish()
        .expect("valid governor config");
    GovernorLayer::new(config)
}
