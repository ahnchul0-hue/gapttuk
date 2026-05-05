use axum::{routing::get, Router};

use crate::api::ApiResponse;
use crate::error::AppError;
use crate::services::trend_data_service::{self, CategoryTrendScore};
use crate::AppState;

pub fn router() -> Router<AppState> {
    Router::new().route("/naver", get(get_naver_trends))
}

/// GET /api/v1/trends/naver — 네이버 쇼핑 카테고리 트렌드 조회 (최근 6개월)
///
/// 인증 불필요 (공개 트렌드 데이터). NAVER_CLIENT_ID/SECRET 미설정 시 500.
async fn get_naver_trends() -> Result<ApiResponse<Vec<CategoryTrendScore>>, AppError> {
    let trends = trend_data_service::get_default_category_trends().await?;
    Ok(ApiResponse::ok(trends))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::services::trend_data_service::{CategoryTrendScore, TrendPeriodData};

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
}
