use std::collections::HashMap;

use chrono::Utc;
use serde::{Deserialize, Serialize};

use crate::error::AppError;

// ── Naver Datalab 인구통계 API 응답 구조 ─────────────────────

/// 인구통계 데이터 포인트 — 카테고리 트렌드와 달리 group 필드 포함.
/// 실측 구조 (2026-05-16 NaverSearch MCP):
/// age: group = "10"~"60" | gender: group = "m"/"f" | device: group = "mo"/"pc"
#[derive(Debug, Deserialize, Clone, Serialize)]
pub struct DemographicPeriodData {
    pub period: String,
    pub ratio: f64,
    pub group: String,
}

/// 인구통계 결과 항목.
/// by_age/gender/device: category 필드 사용.
/// keyword_by_age/gender: keyword 필드 사용.
#[derive(Debug, Deserialize)]
pub struct DemographicResult {
    pub title: String,
    #[serde(default)]
    pub category: Vec<String>,
    #[serde(default)]
    pub keyword: Vec<String>,
    pub data: Vec<DemographicPeriodData>,
}

/// Naver Datalab 인구통계 API 최상위 응답.
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct NaverDemographicResponse {
    pub start_date: String,
    pub end_date: String,
    pub time_unit: String,
    pub results: Vec<DemographicResult>,
}

// ── 분석 결과 ────────────────────────────────────────────────

/// 인구통계 차원.
#[derive(Debug, Clone, Serialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum DemographicDimension {
    Age,
    Gender,
    Device,
}

/// 인구통계 트렌드 분석 점수 — 단일 카테고리·단일 차원.
#[derive(Debug, Clone, Serialize)]
pub struct DemographicTrendScore {
    pub category_code: String,
    pub dimension: DemographicDimension,
    /// 모든 그룹·모든 기간 데이터 (정렬: period → group 순)
    pub data: Vec<DemographicPeriodData>,
    /// 그룹별 최근 3개월 평균 ratio
    pub group_recent_avg: HashMap<String, f64>,
    /// 가장 높은 최근 평균을 가진 그룹
    pub top_group: String,
}

// ── 공개 API ─────────────────────────────────────────────────

/// 연령별 트렌드 — 10~60대 전 연령대 한 번에 조회.
#[tracing::instrument(skip(client, naver_client_id, naver_client_secret))]
pub async fn get_age_trends(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
    category_code: &str,
) -> Result<DemographicTrendScore, AppError> {
    let (start, end) = default_date_range();
    let body = serde_json::json!({
        "startDate": start,
        "endDate": end,
        "timeUnit": "month",
        "category": category_code,
        "ages": ["10", "20", "30", "40", "50", "60"],
    });
    let result = call_demographic_api(
        client,
        naver_client_id,
        naver_client_secret,
        "https://openapi.naver.com/v1/datalab/shopping/category/age",
        &body,
    )
    .await?;
    Ok(compute_score(category_code, DemographicDimension::Age, result))
}

/// 성별 트렌드 — 남/여 2회 호출 후 병합.
#[tracing::instrument(skip(client, naver_client_id, naver_client_secret))]
pub async fn get_gender_trends(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
    category_code: &str,
) -> Result<DemographicTrendScore, AppError> {
    let (start, end) = default_date_range();
    let male_body = serde_json::json!({
        "startDate": start, "endDate": end,
        "timeUnit": "month",
        "category": category_code, "gender": "m",
    });
    let female_body = serde_json::json!({
        "startDate": start, "endDate": end,
        "timeUnit": "month",
        "category": category_code, "gender": "f",
    });
    let (male, female) = tokio::try_join!(
        call_demographic_api(
            client, naver_client_id, naver_client_secret,
            "https://openapi.naver.com/v1/datalab/shopping/category/gender",
            &male_body,
        ),
        call_demographic_api(
            client, naver_client_id, naver_client_secret,
            "https://openapi.naver.com/v1/datalab/shopping/category/gender",
            &female_body,
        ),
    )?;
    let mut merged = male;
    merged.extend(female);
    Ok(compute_score(category_code, DemographicDimension::Gender, merged))
}

/// 기기별 트렌드 — 모바일/PC 2회 호출 후 병합.
#[tracing::instrument(skip(client, naver_client_id, naver_client_secret))]
pub async fn get_device_trends(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
    category_code: &str,
) -> Result<DemographicTrendScore, AppError> {
    let (start, end) = default_date_range();
    let mobile_body = serde_json::json!({
        "startDate": start, "endDate": end,
        "timeUnit": "month",
        "category": category_code, "device": "mo",
    });
    let pc_body = serde_json::json!({
        "startDate": start, "endDate": end,
        "timeUnit": "month",
        "category": category_code, "device": "pc",
    });
    let (mobile, pc) = tokio::try_join!(
        call_demographic_api(
            client, naver_client_id, naver_client_secret,
            "https://openapi.naver.com/v1/datalab/shopping/category/device",
            &mobile_body,
        ),
        call_demographic_api(
            client, naver_client_id, naver_client_secret,
            "https://openapi.naver.com/v1/datalab/shopping/category/device",
            &pc_body,
        ),
    )?;
    let mut merged = mobile;
    merged.extend(pc);
    Ok(compute_score(category_code, DemographicDimension::Device, merged))
}

/// 연령/성별/기기 전체 프로필 — 5회 API 호출을 병렬 실행 (tokio::join!).
pub async fn get_demographic_profile(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
    category_code: &str,
) -> Result<Vec<DemographicTrendScore>, AppError> {
    let (age, gender, device) = tokio::try_join!(
        get_age_trends(client, naver_client_id, naver_client_secret, category_code),
        get_gender_trends(client, naver_client_id, naver_client_secret, category_code),
        get_device_trends(client, naver_client_id, naver_client_secret, category_code),
    )?;
    Ok(vec![age, gender, device])
}

// ── 내부 헬퍼 ────────────────────────────────────────────────

fn default_date_range() -> (String, String) {
    let today = Utc::now().date_naive();
    let six_months_ago = today - chrono::Months::new(6);
    (
        six_months_ago.format("%Y-%m-%d").to_string(),
        today.format("%Y-%m-%d").to_string(),
    )
}

async fn call_demographic_api(
    client: &reqwest::Client,
    naver_client_id: &str,
    naver_client_secret: &str,
    url: &str,
    body: &serde_json::Value,
) -> Result<Vec<DemographicPeriodData>, AppError> {
    let resp = client
        .post(url)
        .header("X-Naver-Client-Id", naver_client_id)
        .header("X-Naver-Client-Secret", naver_client_secret)
        .header("Content-Type", "application/json")
        .json(body)
        .send()
        .await
        .map_err(|e| AppError::Internal(format!("Naver Demographic API 요청 실패: {e}")))?;

    if !resp.status().is_success() {
        let status = resp.status();
        let body_text = resp.text().await.unwrap_or_default();
        return Err(AppError::Internal(format!(
            "Naver Demographic API 오류 {status}: {body_text}"
        )));
    }

    let demographic_resp: NaverDemographicResponse = resp
        .json()
        .await
        .map_err(|e| AppError::Internal(format!("Naver Demographic 응답 파싱 실패: {e}")))?;

    Ok(demographic_resp
        .results
        .into_iter()
        .flat_map(|r| r.data)
        .collect())
}

fn compute_score(
    category_code: &str,
    dimension: DemographicDimension,
    mut data: Vec<DemographicPeriodData>,
) -> DemographicTrendScore {
    // API 응답 순서를 명시적으로 보장 — period → group 정렬
    data.sort_by(|a, b| a.period.cmp(&b.period).then(a.group.cmp(&b.group)));
    let group_recent_avg = compute_group_recent_avgs(&data);
    let top_group = group_recent_avg
        .iter()
        .max_by(|a, b| a.1.partial_cmp(b.1).unwrap_or(std::cmp::Ordering::Equal))
        .map(|(k, _)| k.clone())
        .unwrap_or_else(|| {
            tracing::warn!(category_code, "인구통계 데이터 없음 — top_group 빈 문자열 반환");
            String::new()
        });

    DemographicTrendScore {
        category_code: category_code.to_owned(),
        dimension,
        data,
        group_recent_avg,
        top_group,
    }
}

/// 그룹별 최근 3개 기간 평균 ratio 계산.
fn compute_group_recent_avgs(data: &[DemographicPeriodData]) -> HashMap<String, f64> {
    let mut by_group: HashMap<&str, Vec<f64>> = HashMap::new();
    for d in data {
        by_group.entry(d.group.as_str()).or_default().push(d.ratio);
    }

    by_group
        .into_iter()
        .map(|(group, ratios)| {
            let recent = if ratios.len() >= 3 {
                &ratios[ratios.len() - 3..]
            } else {
                ratios.as_slice()
            };
            let avg = recent.iter().sum::<f64>() / recent.len() as f64;
            (group.to_owned(), avg)
        })
        .collect()
}

// ── 단위 테스트 ──────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn make_data(entries: &[(&str, f64, &str)]) -> Vec<DemographicPeriodData> {
        entries
            .iter()
            .map(|(p, r, g)| DemographicPeriodData {
                period: p.to_string(),
                ratio: *r,
                group: g.to_string(),
            })
            .collect()
    }

    #[test]
    fn compute_group_recent_avgs_age() {
        let data = make_data(&[
            ("2025-11-01", 10.0, "20"),
            ("2025-12-01", 20.0, "20"),
            ("2026-01-01", 30.0, "20"),
            ("2025-11-01", 50.0, "40"),
            ("2025-12-01", 60.0, "40"),
            ("2026-01-01", 70.0, "40"),
        ]);
        let avgs = compute_group_recent_avgs(&data);
        assert!((avgs["20"] - 20.0).abs() < 0.01);
        assert!((avgs["40"] - 60.0).abs() < 0.01);
    }

    #[test]
    fn compute_score_top_group() {
        let data = make_data(&[
            ("2025-11-01", 10.0, "m"),
            ("2025-12-01", 20.0, "m"),
            ("2026-01-01", 30.0, "m"),
            ("2025-11-01", 60.0, "f"),
            ("2025-12-01", 70.0, "f"),
            ("2026-01-01", 80.0, "f"),
        ]);
        let score = compute_score("50000151", DemographicDimension::Gender, data);
        assert_eq!(score.top_group, "f");
        assert!((score.group_recent_avg["f"] - 70.0).abs() < 0.01);
    }

    #[test]
    fn compute_score_device_merging() {
        let data = make_data(&[
            ("2026-01-01", 90.0, "mo"),
            ("2026-01-01", 60.0, "pc"),
        ]);
        let score = compute_score("50000151", DemographicDimension::Device, data);
        assert_eq!(score.data.len(), 2);
        assert_eq!(score.top_group, "mo");
    }

    #[test]
    fn demographic_trend_score_serializes() {
        let data = make_data(&[
            ("2026-01-01", 80.0, "40"),
            ("2026-01-01", 50.0, "30"),
        ]);
        let score = compute_score("50001780", DemographicDimension::Age, data);
        let json = serde_json::to_value(&score).expect("직렬화 실패");
        assert_eq!(json["category_code"], "50001780");
        assert_eq!(json["dimension"], "age");
        assert_eq!(json["top_group"], "40");
    }
}
