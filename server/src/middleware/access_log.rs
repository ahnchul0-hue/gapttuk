use std::net::SocketAddr;

use axum::{
    extract::{ConnectInfo, Request, State},
    middleware::Next,
    response::Response,
};
use ipnetwork::IpNetwork;

use crate::AppState;

/// Bounded channel을 통해 백그라운드 워커에 전달되는 access log 엔트리.
pub struct AccessLogEntry {
    pub ip: IpNetwork,
    pub user_id: Option<i64>,
    pub endpoint: String,
    pub method: String,
    pub status_code: i16,
    pub user_agent: Option<String>,
    pub response_time_ms: i32,
}

/// 백그라운드 access log 워커 시작.
/// channel이 닫히면 (shutdown) 자동 종료.
pub fn spawn_writer(pool: sqlx::PgPool, mut rx: tokio::sync::mpsc::Receiver<AccessLogEntry>) {
    tokio::spawn(async move {
        while let Some(entry) = rx.recv().await {
            if let Err(e) = sqlx::query(
                "INSERT INTO api_access_logs (ip_address, user_id, endpoint, method, status_code, user_agent, response_time_ms, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())",
            )
            .bind(entry.ip)
            .bind(entry.user_id)
            .bind(&entry.endpoint)
            .bind(&entry.method)
            .bind(entry.status_code)
            .bind(&entry.user_agent)
            .bind(entry.response_time_ms)
            .execute(&pool)
            .await
            {
                tracing::warn!(error = %e, endpoint = %entry.endpoint, "Failed to insert access log");
            }
        }
        tracing::info!("Access log writer shut down");
    });
}

/// Access Log 미들웨어 — bounded channel로 백그라운드 워커에 전달.
/// 채널이 가득 차면 로그를 드랍하여 요청 흐름을 절대 차단하지 않는다.
pub async fn access_log(
    State(state): State<AppState>,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    req: Request,
    next: Next,
) -> Response {
    // /health, /metrics는 인프라 트래픽 — 로그 + 메트릭 노이즈 방지
    let path = req.uri().path();
    if path == "/health" || path == "/metrics" {
        return next.run(req).await;
    }

    let start = std::time::Instant::now();
    let client_ip =
        super::bot_guard::extract_client_ip(&req, addr.ip(), &state.config.trusted_proxies);
    let method = req.method().to_string();
    let raw_path = req.uri().path().to_string();
    // 메트릭용: MatchedPath로 정규화 (카디널리티 폭발 방지)
    let matched_endpoint = req
        .extensions()
        .get::<axum::extract::MatchedPath>()
        .map(|p| p.as_str().to_string())
        .unwrap_or_else(|| raw_path.clone());
    let user_agent = req
        .headers()
        .get(axum::http::header::USER_AGENT)
        .and_then(|v| v.to_str().ok())
        .map(|s| s.to_string());

    // JWT에서 user_id 추출 (인증되지 않은 요청은 None)
    let user_id: Option<i64> = req
        .headers()
        .get(axum::http::header::AUTHORIZATION)
        .and_then(|v| v.to_str().ok())
        .and_then(|h| h.strip_prefix("Bearer "))
        .and_then(|t| crate::auth::jwt::decode_access_token(t, &state.config).ok())
        .map(|c| c.sub);

    let response = next.run(req).await;

    let elapsed = start.elapsed();
    let status_code = response.status().as_u16() as i16;
    let elapsed_ms = elapsed.as_millis().min(i32::MAX as u128) as i32;

    // Prometheus 메트릭 — 정규화된 endpoint 사용 (카디널리티 폭발 방지)
    metrics::counter!("http_requests_total",
        "method" => method.clone(),
        "endpoint" => matched_endpoint.clone(),
        "status" => status_code.to_string(),
    )
    .increment(1);
    metrics::histogram!("http_request_duration_seconds",
        "method" => method.clone(),
        "endpoint" => matched_endpoint.clone(),
    )
    .record(elapsed.as_secs_f64());

    let ip_net: IpNetwork = client_ip.into();

    // Bounded channel — 가득 차면 로그 드랍 (요청 차단 방지)
    if state
        .log_tx
        .try_send(AccessLogEntry {
            ip: ip_net,
            user_id,
            endpoint: matched_endpoint,
            method,
            status_code,
            user_agent,
            response_time_ms: elapsed_ms,
        })
        .is_err()
    {
        metrics::counter!("access_log_dropped_total").increment(1);
    }

    response
}
