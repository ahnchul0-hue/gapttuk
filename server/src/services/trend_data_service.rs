use chrono::NaiveDate;
use serde::{Deserialize, Serialize};

use crate::error::AppError;
pub use crate::models::{CategoryTrendScore, TrendPeriodData};

// ── 요청 타입 ─────────────────────────────────────────────────

/// Naver Datalab 쇼핑 카테고리 트렌드 요청.
#[derive(Debug, Clone)]
pub struct TrendRequest {
    pub start_date: NaiveDate,
    pub end_date: NaiveDate,
    pub time_unit: TrendTimeUnit,
    pub categories: Vec<TrendCategory>,
}

#[derive(Debug, Clone, Copy, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum TrendTimeUnit {
    Date,
    Week,
    Month,
}

#[derive(Debug, Clone, Serialize)]
pub struct TrendCategory {
    pub name: String,
    /// 네이버 카테고리 코드 배열 (find_category에서 조회)
    pub param: Vec<String>,
}

// ── Naver Datalab API 응답 ────────────────────────────────────

/// Naver Datalab 쇼핑 카테고리 트렌드 API 응답.
/// 실측 구조 (2026-05-04 NaverSearch MCP):
/// { startDate, endDate, timeUnit, results: [...] }
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct NaverDatalabResponse {
    pub start_date: String,
    pub end_date: String,
    pub time_unit: String,
    pub results: Vec<TrendResult>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct TrendResult {
    pub title: String,
    pub category: Vec<String>,
    pub data: Vec<TrendPeriodData>,
}

// ── 공개 API ─────────────────────────────────────────────────

/// Naver Datalab 쇼핑 카테고리 트렌드 조회 + 분석 점수 계산.
///
/// 실측 인사이트 (2026-05-04, 6개월 기준):
/// - 디지털/가전: 2026-01 최고 ratio=100.0 (신학기/설)
/// - 생활용품: 2026-02 최고 ratio=7.08 (설 명절)
/// - 식품: 1.3~1.8 안정적
pub async fn get_category_trends(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
    req: TrendRequest,
) -> Result<Vec<CategoryTrendScore>, AppError> {
    let time_unit_str = match req.time_unit {
        TrendTimeUnit::Date => "date",
        TrendTimeUnit::Week => "week",
        TrendTimeUnit::Month => "month",
    };

    let body = serde_json::json!({
        "startDate": req.start_date.format("%Y-%m-%d").to_string(),
        "endDate": req.end_date.format("%Y-%m-%d").to_string(),
        "timeUnit": time_unit_str,
        "category": req.categories,
    });

    let resp = client
        .post("https://openapi.naver.com/v1/datalab/shopping/categories")
        .header("X-Naver-Client-Id", naver_client_id)
        .header("X-Naver-Client-Secret", naver_client_secret)
        .header("Content-Type", "application/json")
        .json(&body)
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Naver Datalab API 요청 실패: {e}")))?;

    if !resp.status().is_success() {
        let status = resp.status();
        let body_text = resp.text().await.unwrap_or_default();
        return Err(AppError::Internal(format!(
            "Naver Datalab API 오류 {status}: {body_text}"
        )));
    }

    let datalab_resp: NaverDatalabResponse = resp
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Naver Datalab 응답 파싱 실패: {e}")))?;

    Ok(datalab_resp
        .results
        .into_iter()
        .map(compute_trend_score)
        .collect())
}

/// 기본 3개 카테고리로 트렌드 조회 (생활용품 / 식품 / 디지털/가전).
///
/// 카테고리 코드는 2026-05-04 find_category 실측 값 사용.
pub async fn get_default_category_trends(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
) -> Result<Vec<CategoryTrendScore>, AppError> {
    use chrono::Utc;
    let today = Utc::now().date_naive();
    let six_months_ago = today - chrono::Months::new(6);

    get_category_trends(client, naver_client_id, naver_client_secret, TrendRequest {
        start_date: six_months_ago,
        end_date: today,
        time_unit: TrendTimeUnit::Month,
        categories: vec![
            TrendCategory {
                name: "생활용품".into(),
                param: vec!["50001780".into()],
            },
            TrendCategory {
                name: "식품".into(),
                param: vec!["50000215".into()],
            },
            TrendCategory {
                name: "디지털/가전".into(),
                param: vec!["50000151".into()],
            },
        ],
    })
    .await
}

// ── 내부 헬퍼 ────────────────────────────────────────────────

fn compute_trend_score(mut result: TrendResult) -> CategoryTrendScore {
    // API 응답 순서를 명시적으로 보장 — period 오름차순 정렬
    result.data.sort_by(|a, b| a.period.cmp(&b.period));
    let data = &result.data;

    let recent_avg = if data.len() >= 3 {
        let recent = &data[data.len() - 3..];
        recent.iter().map(|d| d.ratio).sum::<f64>() / 3.0
    } else if !data.is_empty() {
        data.iter().map(|d| d.ratio).sum::<f64>() / data.len() as f64
    } else {
        0.0
    };

    let mom_change = if data.len() >= 2 {
        let last = data[data.len() - 1].ratio;
        let prev = data[data.len() - 2].ratio;
        if prev > 0.0 {
            (last - prev) / prev * 100.0
        } else {
            0.0
        }
    } else {
        0.0
    };

    CategoryTrendScore {
        category_name: result.title,
        periods: result.data,
        recent_avg,
        mom_change,
    }
}

// ── 단위 테스트 ──────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn make_trend_result(ratios: &[f64]) -> TrendResult {
        TrendResult {
            title: "테스트".into(),
            category: vec!["50000001".into()],
            data: ratios
                .iter()
                .enumerate()
                .map(|(i, &r)| TrendPeriodData {
                    period: format!("2026-{:02}-01", i + 1),
                    ratio: r,
                })
                .collect(),
        }
    }

    #[test]
    fn compute_trend_score_recent_avg() {
        let result = make_trend_result(&[10.0, 20.0, 30.0, 40.0, 50.0, 60.0]);
        let score = compute_trend_score(result);
        // 최근 3개월: 40.0 + 50.0 + 60.0 = 150.0 / 3 = 50.0
        assert!((score.recent_avg - 50.0).abs() < 0.001);
    }

    #[test]
    fn compute_trend_score_mom_change() {
        // 전월 50.0 → 이번달 60.0 → 변화율 20%
        let result = make_trend_result(&[10.0, 20.0, 30.0, 40.0, 50.0, 60.0]);
        let score = compute_trend_score(result);
        assert!((score.mom_change - 20.0).abs() < 0.001);
    }

    #[test]
    fn compute_trend_score_single_period() {
        let result = make_trend_result(&[42.0]);
        let score = compute_trend_score(result);
        assert!((score.recent_avg - 42.0).abs() < 0.001);
        assert_eq!(score.mom_change, 0.0);
    }

    #[test]
    fn compute_trend_score_empty() {
        let result = make_trend_result(&[]);
        let score = compute_trend_score(result);
        assert_eq!(score.recent_avg, 0.0);
        assert_eq!(score.mom_change, 0.0);
    }
}
