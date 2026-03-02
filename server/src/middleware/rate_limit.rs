use tower_governor::{
    governor::GovernorConfigBuilder, key_extractor::PeerIpKeyExtractor, GovernorLayer,
};

type HeaderLayer = GovernorLayer<
    PeerIpKeyExtractor,
    ::governor::middleware::StateInformationMiddleware,
    axum::body::Body,
>;

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
