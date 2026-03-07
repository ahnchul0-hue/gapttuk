use std::net::SocketAddr;

use axum::{
    extract::{ConnectInfo, Request, State},
    middleware::Next,
    response::Response,
};
use ipnetwork::IpNetwork;

use crate::error::AppError;
use crate::AppState;

/// 프록시 환경에서 실제 클라이언트 IP를 추출.
/// SmartIpKeyExtractor와 동일한 로직: X-Forwarded-For → X-Real-Ip → ConnectInfo 폴백.
/// `trusted_proxies`가 비어 있으면 XFF를 무조건 신뢰 (개발 호환).
/// 설정되어 있으면 직접 연결 IP가 신뢰 프록시에 해당할 때만 XFF를 신뢰.
pub(crate) fn extract_client_ip(
    req: &Request,
    fallback: std::net::IpAddr,
    trusted_proxies: &[IpNetwork],
) -> std::net::IpAddr {
    // Empty trusted_proxies = trust all (dev compat)
    let trust_xff =
        trusted_proxies.is_empty() || trusted_proxies.iter().any(|net| net.contains(fallback));

    if trust_xff {
        // X-Forwarded-For: 첫 번째 IP (클라이언트 원본)
        if let Some(xff) = req
            .headers()
            .get("x-forwarded-for")
            .and_then(|v| v.to_str().ok())
        {
            if let Some(first) = xff.split(',').next() {
                if let Ok(ip) = first.trim().parse::<std::net::IpAddr>() {
                    return ip;
                }
            }
        }
        // X-Real-Ip 폴백
        if let Some(xri) = req.headers().get("x-real-ip").and_then(|v| v.to_str().ok()) {
            if let Ok(ip) = xri.trim().parse::<std::net::IpAddr>() {
                return ip;
            }
        }
    }
    fallback
}

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

    let client_ip = extract_client_ip(&req, addr.ip(), &state.config.trusted_proxies);
    let ip = client_ip.to_string();

    // 1. UA 필수 확인 + 블랙리스트
    let ua = req
        .headers()
        .get(axum::http::header::USER_AGENT)
        .and_then(|v| v.to_str().ok())
        .ok_or_else(|| {
            tracing::info!(ip = %ip, "Missing User-Agent header — blocked");
            metrics::counter!("bot_guard_blocks_total", "reason" => "no_ua").increment(1);
            AppError::Forbidden
        })?;

    if is_bot_ua(ua) {
        tracing::info!(ip = %ip, user_agent = %ua, "Bot UA blocked");
        metrics::counter!("bot_guard_blocks_total", "reason" => "ua").increment(1);
        return Err(AppError::Forbidden);
    }

    // 2. 캐시 확인 + DB 조회 (moka get_with: 동일 키 동시 요청 합체)
    let ip_net: IpNetwork = client_ip.into();
    let pool = state.pool.clone();
    let ip_for_log = ip_net.to_string();
    let is_blocked = state
        .cache
        .blocked_ips
        .get_with(ip, async {
            match sqlx::query_scalar::<_, bool>(
                "SELECT EXISTS(
                    SELECT 1 FROM blocked_ips
                    WHERE ip_address = $1
                      AND (blocked_until IS NULL OR blocked_until > NOW())
                )",
            )
            .bind(ip_net)
            .fetch_one(&pool)
            .await
            {
                Ok(blocked) => blocked,
                Err(e) => {
                    tracing::error!(
                        error = %e,
                        ip = %ip_for_log,
                        "Bot guard DB query failed — failing open (security degraded)"
                    );
                    false // fail-open: DB 오류 시 차단하지 않음 (가용성 우선)
                }
            }
        })
        .await;

    if is_blocked {
        metrics::counter!("bot_guard_blocks_total", "reason" => "ip").increment(1);
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
        "headlesschrome",
        "phantomjs",
        "selenium",
        "puppeteer",
        "playwright",
        "axios/",
        "node-fetch",
        "httpx",
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

    #[test]
    fn extract_client_ip_xff() {
        let mut req = Request::builder()
            .uri("/test")
            .body(axum::body::Body::empty())
            .unwrap();
        req.headers_mut()
            .insert("x-forwarded-for", "1.2.3.4, 10.0.0.1".parse().unwrap());
        let fallback: std::net::IpAddr = "127.0.0.1".parse().unwrap();
        assert_eq!(
            extract_client_ip(&req, fallback, &[]),
            "1.2.3.4".parse::<std::net::IpAddr>().unwrap()
        );
    }

    #[test]
    fn extract_client_ip_x_real_ip() {
        let mut req = Request::builder()
            .uri("/test")
            .body(axum::body::Body::empty())
            .unwrap();
        req.headers_mut()
            .insert("x-real-ip", "5.6.7.8".parse().unwrap());
        let fallback: std::net::IpAddr = "127.0.0.1".parse().unwrap();
        assert_eq!(
            extract_client_ip(&req, fallback, &[]),
            "5.6.7.8".parse::<std::net::IpAddr>().unwrap()
        );
    }

    #[test]
    fn extract_client_ip_fallback() {
        let req = Request::builder()
            .uri("/test")
            .body(axum::body::Body::empty())
            .unwrap();
        let fallback: std::net::IpAddr = "192.168.1.1".parse().unwrap();
        assert_eq!(extract_client_ip(&req, fallback, &[]), fallback);
    }

    #[test]
    fn extract_client_ip_untrusted_proxy_ignores_xff() {
        let mut req = Request::builder()
            .uri("/test")
            .body(axum::body::Body::empty())
            .unwrap();
        req.headers_mut()
            .insert("x-forwarded-for", "1.2.3.4".parse().unwrap());
        let fallback: std::net::IpAddr = "192.168.1.1".parse().unwrap();
        let trusted = vec!["10.0.0.0/8".parse::<IpNetwork>().unwrap()];
        assert_eq!(extract_client_ip(&req, fallback, &trusted), fallback);
    }

    #[test]
    fn extract_client_ip_trusted_proxy_uses_xff() {
        let mut req = Request::builder()
            .uri("/test")
            .body(axum::body::Body::empty())
            .unwrap();
        req.headers_mut()
            .insert("x-forwarded-for", "1.2.3.4".parse().unwrap());
        let fallback: std::net::IpAddr = "10.0.0.1".parse().unwrap();
        let trusted = vec!["10.0.0.0/8".parse::<IpNetwork>().unwrap()];
        assert_eq!(
            extract_client_ip(&req, fallback, &trusted),
            "1.2.3.4".parse::<std::net::IpAddr>().unwrap()
        );
    }
}
