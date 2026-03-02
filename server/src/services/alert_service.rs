use serde::Deserialize;
use sqlx::PgPool;

use crate::error::AppError;
use crate::models::{AlertType, NotificationType, PriceAlert};
use crate::push::PushClient;

use super::notification_service;

// ── 상수 ────────────────────────────────────────────────

/// 사용자당 가격 알림 최대 개수
const MAX_ALERTS_PER_USER: i64 = 50;

/// NearLowest 조건: 역대 최저가 대비 이 배율 이내
const NEAR_LOWEST_THRESHOLD: f64 = 1.05;

// ── 요청 DTO ────────────────────────────────────────────

#[derive(Deserialize)]
pub struct CreatePriceAlertRequest {
    pub product_id: i64,
    pub alert_type: AlertTypeInput,
    pub target_price: Option<i32>,
}

#[derive(Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum AlertTypeInput {
    TargetPrice,
    BelowAverage,
    NearLowest,
    AllTimeLow,
}

impl AlertTypeInput {
    fn as_str(&self) -> &'static str {
        match self {
            Self::TargetPrice => "target_price",
            Self::BelowAverage => "below_average",
            Self::NearLowest => "near_lowest",
            Self::AllTimeLow => "all_time_low",
        }
    }
}

// ── CRUD ─────────────────────────────────────────────────

/// 가격 알림 생성.
pub async fn create_price_alert(
    pool: &PgPool,
    user_id: i64,
    req: &CreatePriceAlertRequest,
) -> Result<PriceAlert, AppError> {
    // TargetPrice는 target_price 필수
    if matches!(req.alert_type, AlertTypeInput::TargetPrice) && req.target_price.is_none() {
        return Err(AppError::BadRequest(
            "target_price는 target_price 알림 유형에 필수입니다".to_string(),
        ));
    }

    // 상품 존재 확인
    let exists = sqlx::query_scalar::<_, bool>("SELECT EXISTS(SELECT 1 FROM products WHERE id = $1)")
        .bind(req.product_id)
        .fetch_one(pool)
        .await?;

    if !exists {
        return Err(AppError::NotFound("상품".to_string()));
    }

    // 사용자당 알림 개수 제한 (최대 50개)
    let count = sqlx::query_scalar::<_, i64>(
        "SELECT COUNT(*) FROM price_alerts WHERE user_id = $1",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await?;

    if count >= MAX_ALERTS_PER_USER {
        return Err(AppError::BadRequest(
            format!("가격 알림은 최대 {MAX_ALERTS_PER_USER}개까지 설정할 수 있습니다"),
        ));
    }

    let alert = sqlx::query_as::<_, PriceAlert>(
        r#"
        INSERT INTO price_alerts (user_id, product_id, alert_type, target_price)
        VALUES ($1, $2, $3::TEXT, $4)
        RETURNING *
        "#,
    )
    .bind(user_id)
    .bind(req.product_id)
    .bind(req.alert_type.as_str())
    .bind(req.target_price)
    .fetch_one(pool)
    .await?;

    Ok(alert)
}

/// 사용자의 모든 가격 알림 조회.
pub async fn get_user_price_alerts(
    pool: &PgPool,
    user_id: i64,
) -> Result<Vec<PriceAlert>, AppError> {
    let alerts = sqlx::query_as::<_, PriceAlert>(
        "SELECT * FROM price_alerts WHERE user_id = $1 ORDER BY created_at DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await?;

    Ok(alerts)
}

/// 알림 삭제 (본인 소유 확인).
pub async fn delete_price_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
) -> Result<(), AppError> {
    let result = sqlx::query("DELETE FROM price_alerts WHERE id = $1 AND user_id = $2")
        .bind(alert_id)
        .bind(user_id)
        .execute(pool)
        .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("알림".to_string()));
    }
    Ok(())
}

/// 알림 활성/비활성 토글.
pub async fn toggle_price_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
) -> Result<PriceAlert, AppError> {
    let alert = sqlx::query_as::<_, PriceAlert>(
        r#"
        UPDATE price_alerts
        SET is_active = NOT is_active, updated_at = NOW()
        WHERE id = $1 AND user_id = $2
        RETURNING *
        "#,
    )
    .bind(alert_id)
    .bind(user_id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| AppError::NotFound("알림".to_string()))?;

    Ok(alert)
}

// ── 알림 평가 ────────────────────────────────────────────

/// 상품 가격 통계 (평가용)
#[derive(sqlx::FromRow)]
struct ProductStats {
    lowest_price: Option<i32>,
    average_price: Option<i32>,
    product_name: Option<String>,
}

/// 가격 변동 시 해당 상품의 활성 알림 평가.
/// 조건 충족 시 알림 생성 + 푸시 전송.
/// 반환: 트리거된 알림 수.
pub async fn evaluate_price_alerts(
    pool: &PgPool,
    push: &PushClient,
    product_id: i64,
    new_price: i32,
) -> Result<usize, sqlx::Error> {
    // 1. 상품 통계 조회
    let stats = sqlx::query_as::<_, ProductStats>(
        "SELECT lowest_price, average_price, product_name FROM products WHERE id = $1",
    )
    .bind(product_id)
    .fetch_optional(pool)
    .await?;

    let stats = match stats {
        Some(s) => s,
        None => return Ok(0),
    };

    let product_name = stats.product_name.as_deref().unwrap_or("상품");

    // 2. 해당 상품의 활성 알림 조회 (쿨다운 1시간 체크)
    let alerts = sqlx::query_as::<_, PriceAlert>(
        r#"
        SELECT * FROM price_alerts
        WHERE product_id = $1
          AND is_active = TRUE
          AND (last_triggered_at IS NULL OR last_triggered_at < NOW() - INTERVAL '1 hour')
        "#,
    )
    .bind(product_id)
    .fetch_all(pool)
    .await?;

    let mut triggered = 0usize;
    let deep_link = format!("gapttuk://product/{}", product_id);

    for alert in &alerts {
        let should_trigger = evaluate_condition(
            &alert.alert_type,
            alert.target_price,
            new_price,
            stats.lowest_price,
            stats.average_price,
        );

        if !should_trigger {
            continue;
        }

        // 3. Atomic last_triggered_at 갱신 (TOCTOU 방어 — 동시 실행 시 중복 트리거 방지)
        let claimed = sqlx::query_scalar::<_, i64>(
            r#"
            UPDATE price_alerts
            SET last_triggered_at = NOW()
            WHERE id = $1
              AND (last_triggered_at IS NULL OR last_triggered_at < NOW() - INTERVAL '1 hour')
            RETURNING id
            "#,
        )
        .bind(alert.id)
        .fetch_optional(pool)
        .await?;

        if claimed.is_none() {
            continue; // 다른 프로세스가 이미 트리거함
        }

        // 4. 알림 생성 + 푸시 전송
        let title = format_alert_title(&alert.alert_type, product_name);
        let body = format_alert_body(&alert.alert_type, new_price, alert.target_price);

        if let Err(e) = notification_service::create_and_push(
            pool,
            push,
            alert.user_id,
            NotificationType::PriceAlert,
            alert.id,
            &title,
            &body,
            Some(&deep_link),
        )
        .await
        {
            tracing::warn!(
                alert_id = alert.id,
                user_id = alert.user_id,
                error = %e,
                "Failed to create notification for alert"
            );
        }

        triggered += 1;
    }

    if triggered > 0 {
        tracing::info!(product_id, triggered, "Price alerts evaluated");
    }

    Ok(triggered)
}

/// AlertType별 조건 평가.
fn evaluate_condition(
    alert_type: &AlertType,
    target_price: Option<i32>,
    new_price: i32,
    lowest_price: Option<i32>,
    average_price: Option<i32>,
) -> bool {
    match alert_type {
        AlertType::TargetPrice => {
            target_price.map_or(false, |target| new_price <= target)
        }
        AlertType::AllTimeLow => {
            lowest_price.map_or(false, |lowest| new_price < lowest)
        }
        AlertType::BelowAverage => {
            average_price.map_or(false, |avg| new_price < avg)
        }
        AlertType::NearLowest => {
            // 역대 최저가의 NEAR_LOWEST_THRESHOLD(105%) 이내
            lowest_price.map_or(false, |lowest| {
                let threshold = (lowest as f64 * NEAR_LOWEST_THRESHOLD) as i32;
                new_price <= threshold
            })
        }
    }
}

fn format_alert_title(alert_type: &AlertType, product_name: &str) -> String {
    let prefix = match alert_type {
        AlertType::TargetPrice => "🎯 목표가 도달",
        AlertType::AllTimeLow => "🔥 역대 최저가",
        AlertType::BelowAverage => "📉 평균 이하",
        AlertType::NearLowest => "💡 최저가 근접",
    };
    format!("{prefix} — {product_name}")
}

fn format_alert_body(alert_type: &AlertType, new_price: i32, target_price: Option<i32>) -> String {
    let formatted = format_price(new_price);
    match alert_type {
        AlertType::TargetPrice => {
            let target = target_price.map(format_price).unwrap_or_default();
            format!("현재가 {formatted}원 — 목표가 {target}원 이하로 떨어졌어요!")
        }
        AlertType::AllTimeLow => {
            format!("현재가 {formatted}원 — 역대 최저가를 갱신했어요!")
        }
        AlertType::BelowAverage => {
            format!("현재가 {formatted}원 — 평균가보다 저렴해요!")
        }
        AlertType::NearLowest => {
            format!("현재가 {formatted}원 — 역대 최저가에 근접했어요!")
        }
    }
}

fn format_price(price: i32) -> String {
    let s = price.to_string();
    let mut result = String::new();
    for (i, c) in s.chars().rev().enumerate() {
        if i > 0 && i % 3 == 0 {
            result.push(',');
        }
        result.push(c);
    }
    result.chars().rev().collect()
}

// ── 테스트 ──────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_evaluate_target_price() {
        assert!(evaluate_condition(
            &AlertType::TargetPrice,
            Some(50_000),
            49_000,
            None,
            None
        ));
        assert!(evaluate_condition(
            &AlertType::TargetPrice,
            Some(50_000),
            50_000,
            None,
            None
        ));
        assert!(!evaluate_condition(
            &AlertType::TargetPrice,
            Some(50_000),
            51_000,
            None,
            None
        ));
        // target_price 없으면 false
        assert!(!evaluate_condition(
            &AlertType::TargetPrice,
            None,
            49_000,
            None,
            None
        ));
    }

    #[test]
    fn test_evaluate_all_time_low() {
        assert!(evaluate_condition(
            &AlertType::AllTimeLow,
            None,
            9_000,
            Some(10_000),
            None
        ));
        // 같은 가격이면 false (미만이어야 함)
        assert!(!evaluate_condition(
            &AlertType::AllTimeLow,
            None,
            10_000,
            Some(10_000),
            None
        ));
    }

    #[test]
    fn test_evaluate_below_average() {
        assert!(evaluate_condition(
            &AlertType::BelowAverage,
            None,
            49_000,
            None,
            Some(50_000)
        ));
        assert!(!evaluate_condition(
            &AlertType::BelowAverage,
            None,
            50_000,
            None,
            Some(50_000)
        ));
    }

    #[test]
    fn test_evaluate_near_lowest() {
        // 10,000 * 1.05 = 10,500 이내
        assert!(evaluate_condition(
            &AlertType::NearLowest,
            None,
            10_500,
            Some(10_000),
            None
        ));
        assert!(!evaluate_condition(
            &AlertType::NearLowest,
            None,
            10_600,
            Some(10_000),
            None
        ));
    }

    #[test]
    fn test_format_price() {
        assert_eq!(format_price(1_000), "1,000");
        assert_eq!(format_price(50_000), "50,000");
        assert_eq!(format_price(1_234_567), "1,234,567");
        assert_eq!(format_price(100), "100");
    }
}
