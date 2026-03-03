use rust_decimal::Decimal;
use sqlx::PgPool;

use crate::error::AppError;
use crate::models::{AiPrediction, PredictedAction};

/// 예측 결과 조회 -- 캐시된 유효 예측이 있으면 반환, 없으면 생성.
pub async fn get_prediction(pool: &PgPool, product_id: i64) -> Result<AiPrediction, AppError> {
    // 유효한(만료 전) 예측 확인
    let existing = sqlx::query_as::<_, AiPrediction>(
        "SELECT * FROM ai_predictions WHERE product_id = $1 AND expires_at > NOW() ORDER BY created_at DESC LIMIT 1",
    )
    .bind(product_id)
    .fetch_optional(pool)
    .await?;

    if let Some(pred) = existing {
        return Ok(pred);
    }

    generate_prediction(pool, product_id).await
}

/// 새 예측 생성 -- products 테이블의 통계 데이터로 규칙 기반 예측.
async fn generate_prediction(pool: &PgPool, product_id: i64) -> Result<AiPrediction, AppError> {
    // 상품 통계 조회
    let row = sqlx::query_as::<_, ProductStats>(
        r#"SELECT id, current_price, buy_timing_score, price_trend::TEXT as price_trend,
           days_since_lowest
           FROM products WHERE id = $1"#,
    )
    .bind(product_id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| AppError::NotFound("상품을 찾을 수 없습니다".to_string()))?;

    let score = row.buy_timing_score.unwrap_or(50) as i32;
    let trend = row.price_trend.as_deref().unwrap_or("stable");
    let days = row.days_since_lowest.unwrap_or(999);
    let current_price = row.current_price.unwrap_or(0);

    let (action, confidence) = predict_action(score, trend, days);

    let factors = serde_json::json!({
        "buy_timing_score": score,
        "price_trend": trend,
        "days_since_lowest": days,
        "model_version": "rule_v1"
    });

    let prediction = sqlx::query_as::<_, AiPrediction>(
        r#"INSERT INTO ai_predictions (product_id, predicted_action, confidence, price_at_prediction, factors, expires_at)
           VALUES ($1, $2, $3, $4, $5, NOW() + INTERVAL '24 hours')
           RETURNING *"#,
    )
    .bind(product_id)
    .bind(&action)
    .bind(confidence)
    .bind(current_price)
    .bind(factors)
    .fetch_one(pool)
    .await?;

    Ok(prediction)
}

/// 순수 함수 -- 규칙 기반 예측 로직.
fn predict_action(score: i32, trend: &str, days_since_lowest: i32) -> (PredictedAction, Decimal) {
    if score >= 70 && matches!(trend, "falling" | "stable") {
        (PredictedAction::BuyNow, Decimal::new(85, 2)) // 0.85
    } else if score < 40 || trend == "rising" {
        let conf = if trend == "rising" {
            Decimal::new(75, 2)
        } else {
            Decimal::new(70, 2)
        };
        (PredictedAction::Wait, conf)
    } else {
        let conf = if days_since_lowest < 30 {
            Decimal::new(60, 2)
        } else {
            Decimal::new(50, 2)
        };
        (PredictedAction::Neutral, conf)
    }
}

#[derive(sqlx::FromRow)]
struct ProductStats {
    #[allow(dead_code)]
    id: i64,
    current_price: Option<i32>,
    buy_timing_score: Option<i16>,
    price_trend: Option<String>,
    days_since_lowest: Option<i32>,
}

// ── 테스트 ──────────────────────────────────────────────
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_predict_buy_now() {
        let (action, conf) = predict_action(80, "falling", 5);
        assert_eq!(action, PredictedAction::BuyNow);
        assert_eq!(conf, Decimal::new(85, 2));
    }

    #[test]
    fn test_predict_buy_now_stable() {
        let (action, conf) = predict_action(70, "stable", 10);
        assert_eq!(action, PredictedAction::BuyNow);
        assert_eq!(conf, Decimal::new(85, 2));
    }

    #[test]
    fn test_predict_wait_rising() {
        let (action, conf) = predict_action(60, "rising", 10);
        assert_eq!(action, PredictedAction::Wait);
        assert_eq!(conf, Decimal::new(75, 2));
    }

    #[test]
    fn test_predict_wait_low_score() {
        let (action, conf) = predict_action(30, "stable", 20);
        assert_eq!(action, PredictedAction::Wait);
        assert_eq!(conf, Decimal::new(70, 2));
    }

    #[test]
    fn test_predict_neutral_recent() {
        let (action, conf) = predict_action(55, "stable", 10);
        assert_eq!(action, PredictedAction::Neutral);
        assert_eq!(conf, Decimal::new(60, 2));
    }

    #[test]
    fn test_predict_neutral_old() {
        let (action, conf) = predict_action(55, "stable", 45);
        assert_eq!(action, PredictedAction::Neutral);
        assert_eq!(conf, Decimal::new(50, 2));
    }

    // --- 경계값 테스트 ---

    #[test]
    fn test_predict_boundary_score_70_falling() {
        // score=70 && falling → BuyNow (정확히 경계)
        let (action, _) = predict_action(70, "falling", 5);
        assert_eq!(action, PredictedAction::BuyNow);
    }

    #[test]
    fn test_predict_boundary_score_69_falling() {
        // score=69 && falling → NOT BuyNow (경계 미만)
        let (action, _) = predict_action(69, "falling", 5);
        assert_ne!(action, PredictedAction::BuyNow);
    }

    #[test]
    fn test_predict_boundary_score_40_stable() {
        // score=40 && stable → Neutral (40은 < 40 조건 불충족)
        let (action, _) = predict_action(40, "stable", 20);
        assert_eq!(action, PredictedAction::Neutral);
    }

    #[test]
    fn test_predict_boundary_score_39_stable() {
        // score=39 && stable → Wait (39 < 40)
        let (action, _) = predict_action(39, "stable", 20);
        assert_eq!(action, PredictedAction::Wait);
    }

    #[test]
    fn test_predict_boundary_days_30() {
        // Neutral + days_since_lowest=30 → conf 0.50 (30 < 30 is false)
        let (action, conf) = predict_action(50, "stable", 30);
        assert_eq!(action, PredictedAction::Neutral);
        assert_eq!(conf, Decimal::new(50, 2));
    }

    #[test]
    fn test_predict_boundary_days_29() {
        // Neutral + days_since_lowest=29 → conf 0.60 (29 < 30)
        let (action, conf) = predict_action(50, "stable", 29);
        assert_eq!(action, PredictedAction::Neutral);
        assert_eq!(conf, Decimal::new(60, 2));
    }

    #[test]
    fn test_predict_score_70_rising_is_wait() {
        // score=70 but rising → Wait (rising overrides high score)
        let (action, _) = predict_action(70, "rising", 5);
        assert_eq!(action, PredictedAction::Wait);
    }

    #[test]
    fn test_predict_unknown_trend() {
        // unknown trend + mid score → Neutral (not rising, not falling/stable)
        let (action, _) = predict_action(55, "unknown", 20);
        assert_eq!(action, PredictedAction::Neutral);
    }
}
