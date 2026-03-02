use std::env;

/// 앱 환경 구분
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum AppEnv {
    Dev,
    Test,
    Prod,
}

impl AppEnv {
    fn parse(s: &str) -> Self {
        match s.to_ascii_lowercase().as_str() {
            "prod" => Self::Prod,
            "test" => Self::Test,
            "dev" => Self::Dev,
            other => panic!("APP_ENV must be dev/test/prod, got: {other}"),
        }
    }
}

/// 전체 환경변수를 담는 설정 구조체.
/// Debug는 수동 구현 — jwt_secret, database_url 등 민감 정보를 로그에 노출하지 않음.
#[derive(Clone)]
pub struct Config {
    // --- 필수 ---
    pub database_url: String,
    pub jwt_secret: String,

    // --- 서버 ---
    pub app_env: AppEnv,
    pub host: String,
    pub port: u16,

    // --- JWT ---
    pub jwt_access_ttl_secs: u64,
    pub jwt_refresh_ttl_secs: u64,

    // --- 쿠팡파트너스 ---
    pub coupang_access_key: Option<String>,
    pub coupang_secret_key: Option<String>,

    // --- 네이버 검색 API ---
    pub naver_client_id: Option<String>,
    pub naver_client_secret: Option<String>,

    // --- 소셜 로그인 ---
    pub kakao_rest_api_key: Option<String>,
    pub google_client_id: Option<String>,
    pub apple_client_id: Option<String>,

    // --- 푸시 ---
    pub apns_key_path: Option<String>,
    pub apns_key_id: Option<String>,
    pub apns_team_id: Option<String>,
    pub fcm_service_account: Option<String>,

    // --- 모니터링 ---
    pub sentry_dsn: Option<String>,
}

impl Config {
    /// .env 파일 로드 후 환경변수에서 Config 생성.
    /// 필수 변수 누락 시 panic.
    pub fn load() -> Self {
        // .env 파일 로드 (없으면 무시)
        let _ = dotenvy::dotenv();

        let database_url = required("DATABASE_URL");
        let jwt_secret = required("JWT_SECRET");

        let app_env = AppEnv::parse(
            &env::var("APP_ENV").unwrap_or_else(|_| "dev".to_string()),
        );

        // prod 환경에서 JWT_SECRET 검증 (길이 + 플레이스홀더 차단)
        if app_env == AppEnv::Prod && jwt_secret.len() < 32 {
            panic!("JWT_SECRET must be at least 32 characters in prod");
        }
        if app_env == AppEnv::Prod && jwt_secret.contains("change-me") {
            panic!("JWT_SECRET contains placeholder value — set a real secret for prod");
        }
        if jwt_secret.len() < 32 {
            tracing::warn!("JWT_SECRET is shorter than 32 characters");
        }

        let port: u16 = env::var("PORT")
            .unwrap_or_else(|_| "8080".to_string())
            .parse()
            .expect("PORT must be a valid u16");

        if port == 0 {
            panic!("PORT must be non-zero (got 0)");
        }

        let coupang_access_key = optional("COUPANG_ACCESS_KEY");
        let coupang_secret_key = optional("COUPANG_SECRET_KEY");
        let kakao_rest_api_key = optional("KAKAO_REST_API_KEY");
        let google_client_id = optional("GOOGLE_CLIENT_ID");
        let apple_client_id = optional("APPLE_CLIENT_ID");
        let sentry_dsn = optional("SENTRY_DSN");

        // 선택 환경변수 미설정 시 경고 로그
        if coupang_access_key.is_none() || coupang_secret_key.is_none() {
            tracing::warn!("COUPANG_ACCESS_KEY / COUPANG_SECRET_KEY not set — 크롤링 API 비활성화");
        }
        if kakao_rest_api_key.is_none() {
            tracing::warn!("KAKAO_REST_API_KEY not set — 카카오 로그인 비활성화");
        }
        if sentry_dsn.is_none() {
            tracing::warn!("SENTRY_DSN not set — 에러 트래킹 비활성화");
        }

        Self {
            database_url,
            jwt_secret,
            app_env,
            host: env::var("HOST").unwrap_or_else(|_| "0.0.0.0".to_string()),
            port,
            jwt_access_ttl_secs: parse_u64("JWT_ACCESS_TTL_SECS", 1800),
            jwt_refresh_ttl_secs: parse_u64("JWT_REFRESH_TTL_SECS", 604_800),
            coupang_access_key,
            coupang_secret_key,
            naver_client_id: optional("NAVER_CLIENT_ID"),
            naver_client_secret: optional("NAVER_CLIENT_SECRET"),
            kakao_rest_api_key,
            google_client_id,
            apple_client_id,
            apns_key_path: optional("APNS_KEY_PATH"),
            apns_key_id: optional("APNS_KEY_ID"),
            apns_team_id: optional("APNS_TEAM_ID"),
            fcm_service_account: optional("FCM_SERVICE_ACCOUNT"),
            sentry_dsn,
        }
    }
}

impl std::fmt::Debug for Config {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Config")
            .field("app_env", &self.app_env)
            .field("host", &self.host)
            .field("port", &self.port)
            .field("database_url", &"[REDACTED]")
            .field("jwt_secret", &"[REDACTED]")
            .field("sentry_dsn", &self.sentry_dsn.as_ref().map(|_| "[SET]"))
            .finish_non_exhaustive()
    }
}

/// 필수 환경변수. 없거나 빈 문자열이면 panic.
fn required(key: &str) -> String {
    env::var(key)
        .ok()
        .filter(|v| !v.is_empty())
        .unwrap_or_else(|| panic!("Required env var {key} is not set"))
}

/// 선택 환경변수. 없으면 None.
fn optional(key: &str) -> Option<String> {
    env::var(key).ok().filter(|v| !v.is_empty())
}

/// u64 환경변수 파싱. 없으면 기본값 사용.
fn parse_u64(key: &str, default: u64) -> u64 {
    env::var(key)
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(default)
}
