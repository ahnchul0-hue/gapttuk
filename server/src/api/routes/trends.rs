use axum::{
    extract::{Path, State},
    routing::get,
    Router,
};

use crate::api::ApiResponse;
use crate::error::AppError;
use crate::models::{CategoryTrendScore, DemographicTrendScore};
use crate::services::{demographic_trend_service, trend_data_service};
use crate::AppState;

pub fn router() -> Router<AppState> {
    Router::new()
        .route("/naver", get(get_naver_trends))
        .route("/demographic/{category}", get(get_demographic_trends))
}

/// GET /api/v1/trends/naver — 네이버 쇼핑 카테고리 트렌드 조회 (최근 6개월)
///
/// 인증 불필요 (공개 트렌드 데이터). NAVER_CLIENT_ID/SECRET 미설정 시 500.
/// 결과는 24시간 moka 캐시에 저장 — thundering herd 방어.
async fn get_naver_trends(
    State(state): State<AppState>,
) -> Result<ApiResponse<Vec<CategoryTrendScore>>, AppError> {
    let client_id = state
        .config
        .naver_client_id
        .as_deref()
        .ok_or_else(|| AppError::Internal("NAVER_CLIENT_ID 미설정".into()))?
        .to_owned();
    let client_secret = state
        .config
        .naver_client_secret
        .as_deref()
        .ok_or_else(|| AppError::Internal("NAVER_CLIENT_SECRET 미설정".into()))?
        .to_owned();
    let http_client = state.http_client.clone();

    let trends = state
        .cache
        .trend_data
        .try_get_with("default".to_string(), async move {
            trend_data_service::get_default_category_trends(
                &http_client,
                &client_id,
                &client_secret,
            )
            .await
        })
        .await
        .map_err(|e| AppError::Internal(e.to_string()))?;

    Ok(ApiResponse::ok(trends))
}

/// GET /api/v1/trends/demographic/:category — 인구통계 트렌드 조회 (연령/성별/기기).
///
/// 네이버 Datalab 5개 API 호출 (age×1 + gender×2 + device×2) → 병렬 실행.
/// 결과는 1시간 moka 캐시 저장 (D-116: moka 확장 전략).
/// NAVER_CLIENT_ID/SECRET 미설정 시 500.
async fn get_demographic_trends(
    State(state): State<AppState>,
    Path(category): Path<String>,
) -> Result<ApiResponse<Vec<DemographicTrendScore>>, AppError> {
    if !category.chars().all(|c| c.is_ascii_digit()) || category.len() > 12 || category.is_empty()
    {
        return Err(AppError::BadRequest(
            "올바르지 않은 카테고리 코드 형식 (숫자만, 최대 12자)".into(),
        ));
    }
    let client_id = state
        .config
        .naver_client_id
        .as_deref()
        .ok_or_else(|| AppError::Internal("NAVER_CLIENT_ID 미설정".into()))?
        .to_owned();
    let client_secret = state
        .config
        .naver_client_secret
        .as_deref()
        .ok_or_else(|| AppError::Internal("NAVER_CLIENT_SECRET 미설정".into()))?
        .to_owned();
    let http_client = state.http_client.clone();
    let cache_key = category.clone();

    let scores = state
        .cache
        .demographic_data
        .try_get_with(cache_key, async move {
            demographic_trend_service::get_demographic_profile(
                &http_client,
                &client_id,
                &client_secret,
                &category,
            )
            .await
        })
        .await
        .map_err(|e| AppError::Internal(e.to_string()))?;

    Ok(ApiResponse::ok(scores))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::{CategoryTrendScore, TrendPeriodData};

    fn sample_trends() -> Vec<CategoryTrendScore> {
        vec![
            CategoryTrendScore {
                category_name: "생활용품".into(),
                periods: vec![
                    TrendPeriodData {
                        period: "2025-11-01".into(),
                        ratio: 5.0,
                    },
                    TrendPeriodData {
                        period: "2025-12-01".into(),
                        ratio: 6.0,
                    },
                ],
                recent_avg: 5.5,
                mom_change: 20.0,
            },
            CategoryTrendScore {
                category_name: "디지털/가전".into(),
                periods: vec![
                    TrendPeriodData {
                        period: "2025-11-01".into(),
                        ratio: 80.0,
                    },
                    TrendPeriodData {
                        period: "2025-12-01".into(),
                        ratio: 100.0,
                    },
                ],
                recent_avg: 90.0,
                mom_change: 25.0,
            },
        ]
    }

    #[test]
    fn category_trend_score_serializes_correctly() {
        let trends = sample_trends();
        let json = serde_json::to_value(&trends).expect("직렬화 실패");
        assert_eq!(json[0]["category_name"], "생활용품");
        assert_eq!(json[0]["recent_avg"], 5.5);
        assert!((json[0]["mom_change"].as_f64().unwrap() - 20.0).abs() < 0.01);
    }

    #[test]
    fn trend_period_data_fields_present() {
        let trends = sample_trends();
        let json = serde_json::to_value(&trends).expect("직렬화 실패");
        let first_period = &json[0]["periods"][0];
        assert_eq!(first_period["period"], "2025-11-01");
        assert_eq!(first_period["ratio"], 5.0);
    }

    #[test]
    fn demographic_trend_score_serializes() {
        use crate::models::{DemographicDimension, DemographicPeriodData};
        use std::collections::HashMap;

        let score = DemographicTrendScore {
            category_code: "50000151".into(),
            dimension: DemographicDimension::Age,
            data: vec![
                DemographicPeriodData {
                    period: "2026-01-01".into(),
                    ratio: 100.0,
                    group: "40".into(),
                },
                DemographicPeriodData {
                    period: "2026-01-01".into(),
                    ratio: 26.0,
                    group: "20".into(),
                },
            ],
            group_recent_avg: HashMap::from([
                ("40".to_string(), 100.0),
                ("20".to_string(), 26.0),
            ]),
            top_group: "40".into(),
        };
        let json = serde_json::to_value(&score).expect("직렬화 실패");
        assert_eq!(json["category_code"], "50000151");
        assert_eq!(json["dimension"], "age");
        assert_eq!(json["top_group"], "40");
        assert_eq!(json["data"][0]["group"], "40");
    }
}
