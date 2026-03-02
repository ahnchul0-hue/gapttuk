use std::net::SocketAddr;

use axum::{
    extract::{ConnectInfo, Request, State},
    middleware::Next,
    response::Response,
};
use ipnetwork::IpNetwork;

use crate::AppState;

/// Access Log 미들웨어 — 요청/응답 정보를 `api_access_logs`에 비동기 INSERT.
/// `tokio::spawn`으로 fire-and-forget하여 요청 흐름을 차단하지 않는다.
pub async fn access_log(
    State(state): State<AppState>,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    req: Request,
    next: Next,
) -> Response {
    // /health는 LB 헬스체크로 빈번 — 로그 노이즈 방지
    if req.uri().path() == "/health" {
        return next.run(req).await;
    }

    let start = std::time::Instant::now();
    let method = req.method().to_string();
    let endpoint = req.uri().path().to_string();
    let user_agent = req
        .headers()
        .get(axum::http::header::USER_AGENT)
        .and_then(|v| v.to_str().ok())
        .map(|s| s.to_string());

    let response = next.run(req).await;

    let status_code = response.status().as_u16() as i16;
    let elapsed_ms = start.elapsed().as_millis().min(i32::MAX as u128) as i32;
    let ip_net: IpNetwork = addr.ip().into();
    let pool = state.pool.clone();

    tokio::spawn(async move {
        if let Err(e) = sqlx::query(
            "INSERT INTO api_access_logs (ip_address, endpoint, method, status_code, user_agent, response_time_ms, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, NOW())",
        )
        .bind(ip_net)
        .bind(&endpoint)
        .bind(&method)
        .bind(status_code)
        .bind(&user_agent)
        .bind(elapsed_ms)
        .execute(&pool)
        .await
        {
            tracing::warn!(error = %e, endpoint = %endpoint, "Failed to insert access log");
        }
    });

    response
}
