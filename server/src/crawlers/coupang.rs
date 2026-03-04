use std::sync::LazyLock;

use scraper::{Html, Selector};

use super::ua;

// --- 정적 CSS 셀렉터 (LazyLock) — 프로세스 수명 동안 1회만 파싱 ---
static SEL_PRICE_STRONG: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse("span.total-price > strong").unwrap());
static SEL_PRICE_TOTAL: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse("span.total-price").unwrap());
static SEL_PRICE_SALE: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse(".prod-sale-price .total-price").unwrap());
static SEL_TITLE_H1: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse("h1.prod-buy-header__title").unwrap());
static SEL_TITLE_H2: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse("h2.prod-buy-header__title").unwrap());
static SEL_IMAGE: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse("img.prod-image__detail").unwrap());
static SEL_OOS: LazyLock<Selector> =
    LazyLock::new(|| Selector::parse(".oos-label, .prod-not-find-known__text").unwrap());

/// 크롤링 결과
pub struct CrawlResult {
    pub product_id: i64,
    pub product_name: Option<String>,
    pub price: Option<i32>,
    pub is_out_of_stock: bool,
    pub image_url: Option<String>,
}

/// 크롤링 에러
#[derive(Debug, thiserror::Error)]
pub enum CrawlError {
    #[error("HTTP request failed: {0}")]
    Reqwest(#[from] reqwest::Error),

    #[error("Blocked by server (HTTP {0})")]
    Blocked(u16),

    #[error("HTTP status {0}")]
    HttpStatus(u16),

    #[error("Parse error: {0}")]
    ParseError(String),

    #[error("Possible CAPTCHA or anti-bot page (no product data found)")]
    PossibleCaptcha,

    #[error("Database error: {0}")]
    Db(#[from] sqlx::Error),
}

/// 쿠팡 상품 페이지 스크래핑.
/// 최대 `max_retries`회 exponential backoff 재시도 (5s → 15s → 45s).
pub async fn scrape_product_page(
    client: &reqwest::Client,
    product_id: i64,
    product_url: &str,
    abort_flag: &std::sync::atomic::AtomicBool,
    max_retries: u32,
) -> Result<CrawlResult, CrawlError> {
    let mut last_err = CrawlError::ParseError("no attempts made".to_string());

    for attempt in 0..=max_retries {
        // abort 확인
        if abort_flag.load(std::sync::atomic::Ordering::Relaxed) {
            return Err(CrawlError::Blocked(0));
        }

        // 재시도 대기 (첫 시도는 skip)
        if attempt > 0 {
            let delay_secs = 5u64 * 3u64.pow(attempt - 1); // 5, 15, 45
            tokio::time::sleep(std::time::Duration::from_secs(delay_secs)).await;
        }

        match fetch_and_parse(client, product_id, product_url).await {
            Ok(result) => return Ok(result),
            Err(CrawlError::Blocked(code)) => {
                tracing::warn!(product_id, code, "Blocked by Coupang — setting abort flag");
                abort_flag.store(true, std::sync::atomic::Ordering::Relaxed);
                return Err(CrawlError::Blocked(code));
            }
            Err(CrawlError::PossibleCaptcha) => {
                tracing::warn!(product_id, "CAPTCHA detected — setting abort flag");
                abort_flag.store(true, std::sync::atomic::Ordering::Relaxed);
                return Err(CrawlError::PossibleCaptcha);
            }
            Err(e) => {
                tracing::warn!(product_id, attempt, error = %e, "Scrape attempt failed");
                last_err = e;
            }
        }
    }

    Err(last_err)
}

/// 단일 요청 + HTML 파싱
async fn fetch_and_parse(
    client: &reqwest::Client,
    product_id: i64,
    product_url: &str,
) -> Result<CrawlResult, CrawlError> {
    let resp = client
        .get(product_url)
        .header("User-Agent", ua::random_ua())
        .header("Referer", "https://www.coupang.com/")
        .header("Accept-Language", "ko-KR,ko;q=0.9")
        .send()
        .await?;

    let status = resp.status().as_u16();
    if status == 403 || status == 429 {
        return Err(CrawlError::Blocked(status));
    }
    if !resp.status().is_success() {
        return Err(CrawlError::HttpStatus(status));
    }

    let html = resp.text().await?;
    let result = parse_product_html(product_id, &html)?;

    // CAPTCHA 감지: 200 응답인데 가격·상품명·품절 마커 전부 없으면 CAPTCHA 의심
    if result.price.is_none() && result.product_name.is_none() && !result.is_out_of_stock {
        metrics::counter!("crawler_captcha_suspected").increment(1);
        tracing::warn!(
            product_id,
            "Possible CAPTCHA page — no product data extracted"
        );
        return Err(CrawlError::PossibleCaptcha);
    }

    Ok(result)
}

/// HTML에서 상품 정보 파싱
fn parse_product_html(product_id: i64, html: &str) -> Result<CrawlResult, CrawlError> {
    let doc = Html::parse_document(html);

    // 가격 파싱 — 여러 셀렉터 순차 시도
    let price = parse_price(&doc);

    // 상품명
    let product_name = parse_text(&doc, &SEL_TITLE_H1).or_else(|| parse_text(&doc, &SEL_TITLE_H2));

    // 이미지 URL
    let image_url = parse_image(&doc);

    // 품절 여부
    let is_out_of_stock = check_out_of_stock(&doc);

    Ok(CrawlResult {
        product_id,
        product_name,
        price,
        is_out_of_stock,
        image_url,
    })
}

/// 가격 파싱 — 쿠팡 페이지의 다양한 가격 셀렉터 시도
fn parse_price(doc: &Html) -> Option<i32> {
    for sel in [&*SEL_PRICE_STRONG, &*SEL_PRICE_TOTAL, &*SEL_PRICE_SALE] {
        if let Some(el) = doc.select(sel).next() {
            let text: String = el.text().collect();
            if let Some(p) = extract_number(&text) {
                return Some(p);
            }
        }
    }
    None
}

/// 텍스트 추출
fn parse_text(doc: &Html, sel: &Selector) -> Option<String> {
    doc.select(sel)
        .next()
        .map(|el| el.text().collect::<String>().trim().to_string())
        .filter(|s| !s.is_empty())
}

/// 상품 이미지 URL 추출
fn parse_image(doc: &Html) -> Option<String> {
    doc.select(&SEL_IMAGE)
        .next()
        .and_then(|el| {
            el.value()
                .attr("src")
                .or_else(|| el.value().attr("data-img-src"))
        })
        .map(|s| {
            if s.starts_with("//") {
                format!("https:{s}")
            } else {
                s.to_string()
            }
        })
}

/// 품절 확인
fn check_out_of_stock(doc: &Html) -> bool {
    doc.select(&SEL_OOS).next().is_some()
}

/// 문자열에서 숫자만 추출 (콤마, 원 등 제거)
fn extract_number(text: &str) -> Option<i32> {
    let digits: String = text.chars().filter(|c| c.is_ascii_digit()).collect();
    digits.parse().ok().filter(|&n| n > 0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn extract_number_basic() {
        assert_eq!(extract_number("12,900원"), Some(12900));
        assert_eq!(extract_number("1,234,567"), Some(1234567));
        assert_eq!(extract_number(""), None);
        assert_eq!(extract_number("무료"), None);
    }

    #[test]
    fn parse_html_with_price_and_title() {
        let html = r#"
        <html><body>
            <h1 class="prod-buy-header__title">테스트 상품</h1>
            <span class="total-price"><strong>29,900</strong>원</span>
            <img class="prod-image__detail" src="//img.coupang.com/test.jpg" />
        </body></html>
        "#;
        let result = parse_product_html(1, html).unwrap();
        assert_eq!(result.product_name.as_deref(), Some("테스트 상품"));
        assert_eq!(result.price, Some(29900));
        assert_eq!(
            result.image_url.as_deref(),
            Some("https://img.coupang.com/test.jpg")
        );
        assert!(!result.is_out_of_stock);
    }

    #[test]
    fn parse_html_out_of_stock() {
        let html = r#"
        <html><body>
            <h1 class="prod-buy-header__title">품절 상품</h1>
            <div class="oos-label">일시품절</div>
        </body></html>
        "#;
        let result = parse_product_html(2, html).unwrap();
        assert!(result.is_out_of_stock);
        assert_eq!(result.price, None);
    }

    #[test]
    fn parse_html_no_price() {
        let html = r#"<html><body><h1 class="prod-buy-header__title">상품</h1></body></html>"#;
        let result = parse_product_html(3, html).unwrap();
        assert_eq!(result.price, None);
        assert!(!result.is_out_of_stock);
    }

    #[test]
    fn parse_html_image_with_data_attr() {
        let html = r#"
        <html><body>
            <img class="prod-image__detail" data-img-src="//img.coupang.com/lazy.jpg" />
        </body></html>
        "#;
        let result = parse_product_html(4, html).unwrap();
        assert_eq!(
            result.image_url.as_deref(),
            Some("https://img.coupang.com/lazy.jpg")
        );
    }

    // --- extract_number 엣지케이스 ---
    #[test]
    fn extract_number_edge_cases() {
        // 0은 필터링됨 (filter(|&n| n > 0))
        assert_eq!(extract_number("0원"), None);
        // 단일 숫자
        assert_eq!(extract_number("5"), Some(5));
        // 특수문자 혼합
        assert_eq!(extract_number("$99.50"), Some(9950));
        // 한글만
        assert_eq!(extract_number("가격미정"), None);
        // 매우 큰 수 (i32 범위 초과 시 None)
        assert_eq!(extract_number("9,999,999,999"), None); // > i32::MAX
    }

    // --- parse_product_html 추가 엣지케이스 ---
    #[test]
    fn parse_html_empty_document() {
        let result = parse_product_html(5, "<html><body></body></html>").unwrap();
        assert_eq!(result.price, None);
        assert_eq!(result.product_name, None);
        assert_eq!(result.image_url, None);
        assert!(!result.is_out_of_stock);
    }

    #[test]
    fn parse_html_h2_title_fallback() {
        let html = r#"
        <html><body>
            <h2 class="prod-buy-header__title">h2 제목</h2>
        </body></html>
        "#;
        let result = parse_product_html(6, html).unwrap();
        assert_eq!(result.product_name.as_deref(), Some("h2 제목"));
    }

    #[test]
    fn parse_html_prod_not_find_known() {
        let html = r#"
        <html><body>
            <div class="prod-not-find-known__text">찾을 수 없는 상품</div>
        </body></html>
        "#;
        let result = parse_product_html(7, html).unwrap();
        assert!(result.is_out_of_stock);
    }

    #[test]
    fn parse_html_image_with_https_src() {
        let html = r#"
        <html><body>
            <img class="prod-image__detail" src="https://img.coupang.com/full.jpg" />
        </body></html>
        "#;
        let result = parse_product_html(8, html).unwrap();
        assert_eq!(
            result.image_url.as_deref(),
            Some("https://img.coupang.com/full.jpg")
        );
    }

    #[test]
    fn parse_html_sale_price_selector() {
        let html = r#"
        <html><body>
            <div class="prod-sale-price">
                <span class="total-price">15,900원</span>
            </div>
        </body></html>
        "#;
        let result = parse_product_html(9, html).unwrap();
        assert_eq!(result.price, Some(15900));
    }

    #[test]
    fn parse_html_title_with_whitespace() {
        let html = r#"
        <html><body>
            <h1 class="prod-buy-header__title">
                공백 포함 제목
            </h1>
        </body></html>
        "#;
        let result = parse_product_html(10, html).unwrap();
        assert_eq!(result.product_name.as_deref(), Some("공백 포함 제목"));
    }

    // --- CrawlError Display ---
    #[test]
    fn crawl_error_display() {
        let blocked = CrawlError::Blocked(403);
        assert!(blocked.to_string().contains("403"));

        let http = CrawlError::HttpStatus(500);
        assert!(http.to_string().contains("500"));

        let parse = CrawlError::ParseError("missing selector".into());
        assert!(parse.to_string().contains("missing selector"));
    }

    #[test]
    fn product_id_preserved() {
        let html = r#"<html><body></body></html>"#;
        let result = parse_product_html(12345, html).unwrap();
        assert_eq!(result.product_id, 12345);
    }

    #[test]
    fn crawl_error_possible_captcha_display() {
        let err = CrawlError::PossibleCaptcha;
        assert!(err.to_string().contains("CAPTCHA"));
    }
}
