use axum::{routing::get, Router};
use gapttuk_server::{
    api, cache::AppCache, config, health_check, push::PushClient, AppState, Config,
};
use sqlx::PgPool;
use std::sync::Arc;

/// 테스트용 Config — 환경변수 없이 직접 구성.
pub fn test_config() -> Config {
    Config {
        database_url: String::new(),
        jwt_secret: "test-secret-key-at-least-32-chars-long!!".to_string(),
        database_max_connections: 5,
        app_env: config::AppEnv::Test,
        host: "127.0.0.1".to_string(),
        port: 8080,
        jwt_access_ttl_secs: 300,
        jwt_refresh_ttl_secs: 604_800,
        coupang_access_key: None,
        coupang_secret_key: None,
        naver_client_id: None,
        naver_client_secret: None,
        kakao_rest_api_key: None,
        google_client_id: None,
        apple_client_id: None,
        apns_key_path: None,
        apns_key_id: None,
        apns_team_id: None,
        fcm_service_account: None,
        allowed_origins: vec![],
        sentry_dsn: None,
        crawl_on_start: false,
    }
}

/// 테스트용 Router 조립 — bot_guard/access_log 미들웨어 제외 (ConnectInfo 불필요).
pub fn build_test_app(pool: PgPool) -> Router {
    let config = test_config();
    let http_client = reqwest::Client::new();
    let push_client = Arc::new(PushClient::new(&config, http_client.clone()));
    let cache = AppCache::new();

    let state = AppState {
        pool,
        cache,
        config: Arc::new(config),
        http_client,
        push_client,
    };

    Router::new()
        .route("/health", get(health_check))
        .nest("/api/v1/auth", api::routes::auth::router())
        .nest("/api/v1/products", {
            let (search_layer, _) = gapttuk_server::middleware::rate_limit::search_limiter();
            api::routes::products::router(search_layer)
        })
        .nest("/api/v1/devices", api::routes::devices::router())
        .nest("/api/v1/alerts", api::routes::alerts::router())
        .nest(
            "/api/v1/notifications",
            api::routes::notifications::router(),
        )
        .nest(
            "/api/v1/predictions",
            api::routes::predictions::router(),
        )
        .with_state(state)
}

/// JWT access token 발급 (테스트 인증용).
#[allow(dead_code)]
pub fn mint_token(user_id: i64) -> String {
    let config = test_config();
    let (token, _) =
        gapttuk_server::auth::jwt::encode_access_token(user_id, &config).expect("mint_token");
    token
}
