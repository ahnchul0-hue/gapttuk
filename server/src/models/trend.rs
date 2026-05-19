use std::collections::HashMap;

use serde::{Deserialize, Serialize};

// ── 카테고리 트렌드 ───────────────────────────────────────────

/// 기간별 검색 트렌드 점수 (0.0 ~ 100.0, 기간 내 최고값이 100).
#[derive(Debug, Deserialize, Clone, Serialize)]
pub struct TrendPeriodData {
    /// "2025-11-01" 형식
    pub period: String,
    /// 0.0 ~ 100.0 (기간 최고값 = 100 기준)
    pub ratio: f64,
}

/// 카테고리 트렌드 분석 점수 (서버 내부 계산 후 캐시/응답에 사용).
#[derive(Debug, Clone, Serialize)]
pub struct CategoryTrendScore {
    pub category_name: String,
    pub periods: Vec<TrendPeriodData>,
    /// 최근 3개월 평균 ratio
    pub recent_avg: f64,
    /// 직전월 대비 변화율 (%)
    pub mom_change: f64,
}

// ── 인구통계 트렌드 ───────────────────────────────────────────

/// 인구통계 데이터 포인트 — 카테고리 트렌드와 달리 group 필드 포함.
/// 실측 구조 (2026-05-16 NaverSearch MCP):
/// age: group = "10"~"60" | gender: group = "m"/"f" | device: group = "mo"/"pc"
#[derive(Debug, Deserialize, Clone, Serialize)]
pub struct DemographicPeriodData {
    pub period: String,
    pub ratio: f64,
    pub group: String,
}

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
