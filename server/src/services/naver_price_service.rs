use serde::Deserialize;
use std::sync::OnceLock;

use crate::error::AppError;

// ── Naver Shopping API 응답 구조체 ──────────────────────────

/// Naver Shopping API 검색 응답 최상위.
/// 실측 구조 (2026-05-04 NaverSearch MCP):
/// { lastBuildDate, total, start, display, items: [...] }
#[derive(Debug, Deserialize)]
pub(crate) struct NaverShopResponse {
    pub total: u64,
    pub start: u32,
    pub display: u32,
    pub items: Vec<NaverShopItem>,
}

/// 개별 상품 항목 — camelCase JSON.
#[derive(Debug, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub(crate) struct NaverShopItem {
    /// 상품명 (HTML 태그 포함, 예: "농심 <b>신라면</b>")
    pub title: String,
    pub link: String,
    pub image: String,
    /// 최저가 (빈 문자열 가능)
    pub lprice: String,
    /// 최고가 (빈 문자열 가능, 대부분 비어 있음)
    pub hprice: String,
    pub mall_name: String,
    /// 네이버 쇼핑 내부 상품 ID
    pub product_id: String,
    /// "1" = 가격비교 카탈로그 (복수 판매자), "2" = 개별 판매자
    pub product_type: String,
    pub brand: String,
    pub maker: String,
    pub category1: String,
    pub category2: String,
    pub category3: String,
    pub category4: String,
}

// ── 내부 파싱 결과 ───────────────────────────────────────────

/// Naver 상품 검색 결과 (파싱 완료, 가격 i32 변환).
#[derive(Debug, Clone)]
pub struct ParsedNaverPrice {
    pub product_id: String,
    /// HTML 태그 제거된 상품명
    pub product_name: String,
    /// 최저가 (원, None = 가격 정보 없음)
    pub lowest_price: Option<i32>,
    /// 최고가 (원)
    pub highest_price: Option<i32>,
    pub mall_name: String,
    pub brand: String,
    pub maker: String,
    pub image_url: String,
    pub detail_url: String,
    pub category: NaverCategory,
    /// true = 가격비교 카탈로그 (여러 판매자 비교 가능), false = 단일 판매자
    pub is_catalog: bool,
}

#[derive(Debug, Clone)]
pub struct NaverCategory {
    pub level1: String,
    pub level2: String,
    pub level3: String,
    pub level4: String,
}

// ── HTTP 클라이언트 싱글톤 ────────────────────────────────────

/// OnceLock으로 reqwest::Client 전역 싱글톤 — 연결 풀 재사용.
static NAVER_CLIENT: OnceLock<reqwest::Client> = OnceLock::new();

fn naver_client() -> &'static reqwest::Client {
    NAVER_CLIENT.get_or_init(|| {
        reqwest::Client::builder()
            .timeout(std::time::Duration::from_secs(10))
            .build()
            .expect("reqwest Client 초기화 실패")
    })
}

// ── 공개 API ─────────────────────────────────────────────────

/// Naver Shopping 상품 검색.
///
/// 환경변수 `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET` 필수.
/// `display`: 반환 결과 수 (기본 10, 최대 100)
/// `start`: 시작 위치 (기본 1, 최대 1000)
pub async fn search_naver_shop(
    query: &str,
    display: Option<u32>,
    start: Option<u32>,
) -> Result<Vec<ParsedNaverPrice>, AppError> {
    let (client_id, client_secret) = naver_credentials()?;

    let resp = naver_client()
        .get("https://openapi.naver.com/v1/search/shop.json")
        .header("X-Naver-Client-Id", &client_id)
        .header("X-Naver-Client-Secret", &client_secret)
        .query(&[
            ("query", query.to_owned()),
            ("display", display.unwrap_or(10).to_string()),
            ("start", start.unwrap_or(1).to_string()),
            ("sort", "sim".to_owned()),
        ])
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Naver Shop API 요청 실패: {e}")))?;

    if !resp.status().is_success() {
        let status = resp.status();
        let body = resp.text().await.unwrap_or_default();
        return Err(AppError::Internal(format!(
            "Naver Shop API 오류 {status}: {body}"
        )));
    }

    let shop_resp: NaverShopResponse = resp
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Naver Shop 응답 파싱 실패: {e}")))?;

    Ok(shop_resp.items.into_iter().map(parse_item).collect())
}

// ── 내부 헬퍼 ────────────────────────────────────────────────

fn naver_credentials() -> Result<(String, String), AppError> {
    let id = std::env::var("NAVER_CLIENT_ID")
        .map_err(|_| AppError::Internal("NAVER_CLIENT_ID 환경변수 미설정".into()))?;
    let secret = std::env::var("NAVER_CLIENT_SECRET")
        .map_err(|_| AppError::Internal("NAVER_CLIENT_SECRET 환경변수 미설정".into()))?;
    Ok((id, secret))
}

fn parse_item(item: NaverShopItem) -> ParsedNaverPrice {
    ParsedNaverPrice {
        product_id: item.product_id,
        product_name: strip_html_tags(&item.title),
        lowest_price: parse_price_str(&item.lprice),
        highest_price: parse_price_str(&item.hprice),
        mall_name: item.mall_name,
        brand: item.brand,
        maker: item.maker,
        image_url: item.image,
        detail_url: item.link,
        category: NaverCategory {
            level1: item.category1,
            level2: item.category2,
            level3: item.category3,
            level4: item.category4,
        },
        is_catalog: item.product_type == "1",
    }
}

/// 가격 문자열 → i32 (빈 문자열 → None, 파싱 실패 → None).
fn parse_price_str(s: &str) -> Option<i32> {
    let trimmed = s.trim();
    if trimmed.is_empty() {
        return None;
    }
    trimmed.parse::<i32>().ok()
}

/// HTML 태그 제거 (<b>검색어</b> → 검색어).
/// Naver API는 검색어 강조를 위해 <b> 태그를 삽입한다.
fn strip_html_tags(s: &str) -> String {
    let mut result = String::with_capacity(s.len());
    let mut in_tag = false;
    for ch in s.chars() {
        match ch {
            '<' => in_tag = true,
            '>' => in_tag = false,
            c if !in_tag => result.push(c),
            _ => {}
        }
    }
    result
}

// ── 단위 테스트 ──────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn strip_html_removes_bold_tags() {
        assert_eq!(strip_html_tags("농심 <b>신라면</b>"), "농심 신라면");
        assert_eq!(strip_html_tags("<b>라면</b>/면류"), "라면/면류");
        assert_eq!(strip_html_tags("순수텍스트"), "순수텍스트");
    }

    #[test]
    fn parse_price_str_cases() {
        assert_eq!(parse_price_str("26250"), Some(26250));
        assert_eq!(parse_price_str(""), None);
        assert_eq!(parse_price_str("  "), None);
        assert_eq!(parse_price_str("abc"), None);
        assert_eq!(parse_price_str("3650"), Some(3650));
    }

    #[test]
    fn parse_item_sets_is_catalog() {
        let catalog_item = NaverShopItem {
            title: "<b>상품</b>".into(),
            link: "https://example.com".into(),
            image: "".into(),
            lprice: "10000".into(),
            hprice: "".into(),
            mall_name: "네이버".into(),
            product_id: "123".into(),
            product_type: "1".into(),
            brand: "".into(),
            maker: "".into(),
            category1: "식품".into(),
            category2: "라면/면류".into(),
            category3: "라면".into(),
            category4: "봉지라면".into(),
        };
        let parsed = parse_item(catalog_item);
        assert!(parsed.is_catalog);
        assert_eq!(parsed.product_name, "상품");
        assert_eq!(parsed.lowest_price, Some(10000));
    }
}
