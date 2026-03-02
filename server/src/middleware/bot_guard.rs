use std::net::SocketAddr;

use axum::{
    extract::{ConnectInfo, Request, State},
    middleware::Next,
    response::Response,
};
use ipnetwork::IpNetwork;

use crate::error::AppError;
use crate::AppState;

/// 봇 차단 미들웨어 — blocked_ips DB/캐시 + UA 블랙리스트.
/// `/health` 엔드포인트는 스킵한다.
pub async fn bot_guard(
    State(state): State<AppState>,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    req: Request,
    next: Next,
) -> Result<Response, AppError> {
    // /health는 보안 체크 불필요
    if req.uri().path() == "/health" {
        return Ok(next.run(req).await);
    }

    let ip = addr.ip().to_string();

    // 1. UA 블랙리스트
    if let Some(ua) = req
        .headers()
        .get(axum::http::header::USER_AGENT)
        .and_then(|v| v.to_str().ok())
    {
        if is_bot_ua(ua) {
            tracing::info!(ip = %ip, user_agent = %ua, "Bot UA blocked");
            return Err(AppError::Forbidden);
        }
    }

    // 2. 캐시 확인 + DB 조회 (moka get_with: 동일 키 동시 요청 합체)
    let ip_net: IpNetwork = addr.ip().into();
    let pool = state.pool.clone();
    let is_blocked = state
        .cache
        .blocked_ips
        .get_with(ip, async {
            sqlx::query_scalar::<_, bool>(
                "SELECT EXISTS(
                    SELECT 1 FROM blocked_ips
                    WHERE ip_address = $1
                      AND (blocked_until IS NULL OR blocked_until > NOW())
                )",
            )
            .bind(ip_net)
            .fetch_one(&pool)
            .await
            .unwrap_or(false)
        })
        .await;

    if is_blocked {
        return Err(AppError::Forbidden);
    }

    Ok(next.run(req).await)
}

/// 알려진 봇/스크래퍼 User-Agent 패턴 매칭 (case-insensitive).
fn is_bot_ua(ua: &str) -> bool {
    let ua_lower = ua.to_ascii_lowercase();
    const BOT_PATTERNS: &[&str] = &[
        "bot",
        "crawler",
        "spider",
        "scraper",
        "python-requests",
        "curl/",
        "wget/",
        "go-http-client",
        "java/",
        "httpclient",
        "libwww-perl",
        "mechanize",
        "scrapy",
    ];
    BOT_PATTERNS.iter().any(|p| ua_lower.contains(p))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn blocks_known_bot_user_agents() {
        assert!(is_bot_ua("Mozilla/5.0 (compatible; Googlebot/2.1)"));
        assert!(is_bot_ua("python-requests/2.28.0"));
        assert!(is_bot_ua("curl/7.88.1"));
        assert!(is_bot_ua("Scrapy/2.8.0"));
    }

    #[test]
    fn allows_normal_user_agents() {
        assert!(!is_bot_ua("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0)"));
        assert!(!is_bot_ua("Mozilla/5.0 (Linux; Android 13) Chrome/112"));
        assert!(!is_bot_ua("gapttuk/1.0.0 Dart/3.2"));
    }

    #[test]
    fn case_insensitive_matching() {
        assert!(is_bot_ua("MyBOT/1.0"));
        assert!(is_bot_ua("CRAWLER-THING"));
        assert!(is_bot_ua("Python-Requests/2.31"));
    }
}
