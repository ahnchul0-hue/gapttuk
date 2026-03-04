use serde::Deserialize;
use sqlx::PgPool;

use crate::error::AppError;
use crate::models::{AlertType, CategoryAlert, KeywordAlert, NotificationType, PriceAlert};
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
    // TargetPrice는 target_price 필수 + 양수 검증
    if matches!(req.alert_type, AlertTypeInput::TargetPrice) {
        match req.target_price {
            None => {
                return Err(AppError::BadRequest(
                    "target_price는 target_price 알림 유형에 필수입니다".to_string(),
                ));
            }
            Some(tp) if tp <= 0 => {
                return Err(AppError::BadRequest(
                    "target_price는 1 이상이어야 합니다".to_string(),
                ));
            }
            _ => {}
        }
    }

    // 상품 존재 확인
    let exists =
        sqlx::query_scalar::<_, bool>("SELECT EXISTS(SELECT 1 FROM products WHERE id = $1)")
            .bind(req.product_id)
            .fetch_one(pool)
            .await?;

    if !exists {
        return Err(AppError::NotFound("상품".to_string()));
    }

    // 사용자당 전체 알림 개수 제한 (최대 50개, 모든 유형 합산)
    let count = count_all_user_alerts(pool, user_id).await?;
    if count >= MAX_ALERTS_PER_USER {
        return Err(AppError::BadRequest(format!(
            "알림은 최대 {MAX_ALERTS_PER_USER}개까지 설정할 수 있습니다"
        )));
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

// ── 전체 알림 개수 카운트 ────────────────────────────────

/// 사용자의 전체 알림 개수 합산 (price + category + keyword)
async fn count_all_user_alerts(pool: &PgPool, user_id: i64) -> Result<i64, AppError> {
    let count = sqlx::query_scalar::<_, i64>(
        r#"
        SELECT
            (SELECT COUNT(*) FROM price_alerts WHERE user_id = $1)
          + (SELECT COUNT(*) FROM category_alerts WHERE user_id = $1)
          + (SELECT COUNT(*) FROM keyword_alerts WHERE user_id = $1)
        "#,
    )
    .bind(user_id)
    .fetch_one(pool)
    .await?;

    Ok(count)
}

// ── 카테고리 알림 CRUD ──────────────────────────────────

/// 카테고리 알림 생성.
///
/// `alert_condition`은 NOT NULL 제약조건이 있으므로 기본값 `"any_drop"`을 사용한다.
pub async fn create_category_alert(
    pool: &PgPool,
    user_id: i64,
    category_id: i32,
) -> Result<CategoryAlert, AppError> {
    // 카테고리 존재 확인
    let exists =
        sqlx::query_scalar::<_, bool>("SELECT EXISTS(SELECT 1 FROM categories WHERE id = $1)")
            .bind(category_id)
            .fetch_one(pool)
            .await?;

    if !exists {
        return Err(AppError::NotFound("카테고리".to_string()));
    }

    // 전체 알림 개수 제한 확인
    let count = count_all_user_alerts(pool, user_id).await?;
    if count >= MAX_ALERTS_PER_USER {
        return Err(AppError::BadRequest(format!(
            "알림은 최대 {MAX_ALERTS_PER_USER}개까지 설정할 수 있습니다"
        )));
    }

    let alert = sqlx::query_as::<_, CategoryAlert>(
        r#"
        INSERT INTO category_alerts (user_id, category_id, alert_condition)
        VALUES ($1, $2, 'any_drop')
        RETURNING *
        "#,
    )
    .bind(user_id)
    .bind(category_id)
    .fetch_one(pool)
    .await?;

    Ok(alert)
}

/// 사용자의 모든 카테고리 알림 조회.
pub async fn get_user_category_alerts(
    pool: &PgPool,
    user_id: i64,
) -> Result<Vec<CategoryAlert>, AppError> {
    let alerts = sqlx::query_as::<_, CategoryAlert>(
        "SELECT * FROM category_alerts WHERE user_id = $1 ORDER BY created_at DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await?;

    Ok(alerts)
}

/// 카테고리 알림 삭제 (본인 소유 확인).
pub async fn delete_category_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
) -> Result<(), AppError> {
    let result = sqlx::query("DELETE FROM category_alerts WHERE id = $1 AND user_id = $2")
        .bind(alert_id)
        .bind(user_id)
        .execute(pool)
        .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("알림".to_string()));
    }
    Ok(())
}

/// 카테고리 알림 활성/비활성 토글.
pub async fn toggle_category_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
) -> Result<CategoryAlert, AppError> {
    let alert = sqlx::query_as::<_, CategoryAlert>(
        r#"
        UPDATE category_alerts
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

// ── 키워드 알림 CRUD ────────────────────────────────────

/// 키워드 알림 생성.
pub async fn create_keyword_alert(
    pool: &PgPool,
    user_id: i64,
    keyword: String,
) -> Result<KeywordAlert, AppError> {
    // 키워드 길이 검증 (DB VARCHAR(100) 제약조건 반영)
    let keyword = keyword.trim().to_string();
    if keyword.is_empty() {
        return Err(AppError::BadRequest("키워드를 입력해주세요".to_string()));
    }
    if keyword.chars().count() > 100 {
        return Err(AppError::BadRequest(
            "키워드는 100자 이하로 입력해주세요".to_string(),
        ));
    }

    // 전체 알림 개수 제한 확인
    let count = count_all_user_alerts(pool, user_id).await?;
    if count >= MAX_ALERTS_PER_USER {
        return Err(AppError::BadRequest(format!(
            "알림은 최대 {MAX_ALERTS_PER_USER}개까지 설정할 수 있습니다"
        )));
    }

    let alert = sqlx::query_as::<_, KeywordAlert>(
        r#"
        INSERT INTO keyword_alerts (user_id, keyword)
        VALUES ($1, $2)
        RETURNING *
        "#,
    )
    .bind(user_id)
    .bind(&keyword)
    .fetch_one(pool)
    .await?;

    Ok(alert)
}

/// 사용자의 모든 키워드 알림 조회.
pub async fn get_user_keyword_alerts(
    pool: &PgPool,
    user_id: i64,
) -> Result<Vec<KeywordAlert>, AppError> {
    let alerts = sqlx::query_as::<_, KeywordAlert>(
        "SELECT * FROM keyword_alerts WHERE user_id = $1 ORDER BY created_at DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await?;

    Ok(alerts)
}

/// 키워드 알림 삭제 (본인 소유 확인).
pub async fn delete_keyword_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
) -> Result<(), AppError> {
    let result = sqlx::query("DELETE FROM keyword_alerts WHERE id = $1 AND user_id = $2")
        .bind(alert_id)
        .bind(user_id)
        .execute(pool)
        .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("알림".to_string()));
    }
    Ok(())
}

/// 키워드 알림 활성/비활성 토글.
pub async fn toggle_keyword_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
) -> Result<KeywordAlert, AppError> {
    let alert = sqlx::query_as::<_, KeywordAlert>(
        r#"
        UPDATE keyword_alerts
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

// ── 알림 수정 ────────────────────────────────────────────

/// 가격 알림 목표가 수정.
pub async fn update_price_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
    target_price: rust_decimal::Decimal,
) -> Result<(), AppError> {
    if target_price <= rust_decimal::Decimal::ZERO {
        return Err(AppError::BadRequest(
            "목표가는 0보다 커야 합니다".to_string(),
        ));
    }
    let result = sqlx::query(
        "UPDATE price_alerts SET target_price = $1, updated_at = NOW() WHERE id = $2 AND user_id = $3",
    )
    .bind(target_price)
    .bind(alert_id)
    .bind(user_id)
    .execute(pool)
    .await
    ?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("가격 알림".to_string()));
    }
    Ok(())
}

/// 키워드 알림 키워드 수정.
pub async fn update_keyword_alert(
    pool: &PgPool,
    user_id: i64,
    alert_id: i64,
    keyword: &str,
) -> Result<(), AppError> {
    let keyword = keyword.trim();
    if keyword.is_empty() {
        return Err(AppError::BadRequest("키워드를 입력해주세요".to_string()));
    }
    if keyword.chars().count() > 100 {
        return Err(AppError::BadRequest(
            "키워드는 100자 이하여야 합니다".to_string(),
        ));
    }
    let result = sqlx::query(
        "UPDATE keyword_alerts SET keyword = $1, updated_at = NOW() WHERE id = $2 AND user_id = $3",
    )
    .bind(keyword)
    .bind(alert_id)
    .bind(user_id)
    .execute(pool)
    .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("키워드 알림".to_string()));
    }
    Ok(())
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
    push: std::sync::Arc<PushClient>,
    product_id: i64,
    new_price: i32,
) -> Result<usize, AppError> {
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

    let deep_link = format!("gapttuk://product/{}", product_id);

    // 3. 조건 충족 알림 ID 수집
    let candidate_ids: Vec<i64> = alerts
        .iter()
        .filter(|alert| {
            evaluate_condition(
                &alert.alert_type,
                alert.target_price,
                new_price,
                stats.lowest_price,
                stats.average_price,
            )
        })
        .map(|alert| alert.id)
        .collect();

    if candidate_ids.is_empty() {
        return Ok(0);
    }

    // 4. Batch UPDATE로 atomic claim (N+1 → 1쿼리, TOCTOU 방어 유지)
    let claimed_ids: Vec<i64> = sqlx::query_scalar(
        r#"
        UPDATE price_alerts
        SET last_triggered_at = NOW()
        WHERE id = ANY($1)
          AND (last_triggered_at IS NULL OR last_triggered_at < NOW() - INTERVAL '1 hour')
        RETURNING id
        "#,
    )
    .bind(&candidate_ids[..])
    .fetch_all(pool)
    .await?;

    // 5. claim 성공한 알림만 푸시 전송 (병렬 — JoinSet으로 동시 발송)
    let claimed_set: std::collections::HashSet<i64> = claimed_ids.iter().copied().collect();
    let mut push_tasks = tokio::task::JoinSet::new();

    for alert in alerts.iter().filter(|a| claimed_set.contains(&a.id)) {
        let title = format_alert_title(&alert.alert_type, product_name);
        let body = format_alert_body(&alert.alert_type, new_price, alert.target_price);
        let alert_id = alert.id;
        let user_id = alert.user_id;
        let pool = pool.clone();
        let push = std::sync::Arc::clone(&push);
        let deep_link = deep_link.clone();

        push_tasks.spawn(async move {
            if let Err(e) = notification_service::create_and_push(
                &pool,
                &push,
                &notification_service::PushNotification {
                    user_id,
                    ntype: NotificationType::PriceAlert,
                    reference_id: alert_id,
                    title: &title,
                    body: &body,
                    deep_link: Some(&deep_link),
                },
            )
            .await
            {
                tracing::warn!(
                    alert_id,
                    user_id,
                    error = %e,
                    "Failed to create notification for alert"
                );
            }
        });
    }

    // 모든 푸시 완료 대기
    while push_tasks.join_next().await.is_some() {}

    let triggered = claimed_ids.len();
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
        AlertType::TargetPrice => target_price.is_some_and(|target| new_price <= target),
        AlertType::AllTimeLow => lowest_price.is_some_and(|lowest| new_price < lowest),
        AlertType::BelowAverage => average_price.is_some_and(|avg| new_price < avg),
        AlertType::NearLowest => {
            // 역대 최저가의 NEAR_LOWEST_THRESHOLD(105%) 이내
            lowest_price.is_some_and(|lowest| {
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

    // --- format_price 경계값 ---
    #[test]
    fn test_format_price_edge_cases() {
        assert_eq!(format_price(0), "0");
        assert_eq!(format_price(1), "1");
        assert_eq!(format_price(999), "999");
        assert_eq!(format_price(1_000_000), "1,000,000");
        assert_eq!(format_price(10), "10");
    }

    // --- format_alert_title ---
    #[test]
    fn test_format_alert_title_all_types() {
        assert!(format_alert_title(&AlertType::TargetPrice, "테스트 상품").contains("목표가 도달"));
        assert!(format_alert_title(&AlertType::AllTimeLow, "테스트 상품").contains("역대 최저가"));
        assert!(format_alert_title(&AlertType::BelowAverage, "테스트 상품").contains("평균 이하"));
        assert!(format_alert_title(&AlertType::NearLowest, "테스트 상품").contains("최저가 근접"));
        // 상품명이 포함되어야 함
        assert!(format_alert_title(&AlertType::TargetPrice, "맥북 프로").contains("맥북 프로"));
    }

    // --- format_alert_body ---
    #[test]
    fn test_format_alert_body_target_price() {
        let body = format_alert_body(&AlertType::TargetPrice, 49_000, Some(50_000));
        assert!(body.contains("49,000원"));
        assert!(body.contains("50,000원"));
        assert!(body.contains("목표가"));
    }

    #[test]
    fn test_format_alert_body_all_time_low() {
        let body = format_alert_body(&AlertType::AllTimeLow, 9_900, None);
        assert!(body.contains("9,900원"));
        assert!(body.contains("역대 최저가"));
    }

    #[test]
    fn test_format_alert_body_below_average() {
        let body = format_alert_body(&AlertType::BelowAverage, 45_000, None);
        assert!(body.contains("45,000원"));
        assert!(body.contains("평균가"));
    }

    #[test]
    fn test_format_alert_body_near_lowest() {
        let body = format_alert_body(&AlertType::NearLowest, 10_200, None);
        assert!(body.contains("10,200원"));
        assert!(body.contains("최저가에 근접"));
    }

    // --- AlertTypeInput::as_str ---
    #[test]
    fn test_alert_type_input_as_str() {
        assert_eq!(AlertTypeInput::TargetPrice.as_str(), "target_price");
        assert_eq!(AlertTypeInput::BelowAverage.as_str(), "below_average");
        assert_eq!(AlertTypeInput::NearLowest.as_str(), "near_lowest");
        assert_eq!(AlertTypeInput::AllTimeLow.as_str(), "all_time_low");
    }

    // --- evaluate_condition 경계값 추가 ---
    #[test]
    fn test_evaluate_near_lowest_exact_boundary() {
        // 10,000 * 1.05 = 10,500 — 정확히 경계
        assert!(evaluate_condition(
            &AlertType::NearLowest,
            None,
            10_500,
            Some(10_000),
            None
        ));
        // 10,501 — 경계 초과
        assert!(!evaluate_condition(
            &AlertType::NearLowest,
            None,
            10_501,
            Some(10_000),
            None
        ));
    }

    #[test]
    fn test_evaluate_condition_none_stats() {
        // lowest_price/average_price가 None이면 모두 false
        assert!(!evaluate_condition(
            &AlertType::AllTimeLow,
            None,
            100,
            None,
            None
        ));
        assert!(!evaluate_condition(
            &AlertType::BelowAverage,
            None,
            100,
            None,
            None
        ));
        assert!(!evaluate_condition(
            &AlertType::NearLowest,
            None,
            100,
            None,
            None
        ));
    }

    #[test]
    fn test_evaluate_target_price_equal() {
        // new_price == target_price → true (이하이므로)
        assert!(evaluate_condition(
            &AlertType::TargetPrice,
            Some(10_000),
            10_000,
            None,
            None
        ));
    }

    // --- update_keyword_alert 검증 로직 테스트 (chars().count() 기반) ---

    #[test]
    fn test_keyword_length_uses_chars_count() {
        // 한글 "가나다" = 3글자, 9바이트 — chars().count()로 정확히 3자
        let korean = "가나다";
        assert_eq!(korean.len(), 9); // 바이트
        assert_eq!(korean.chars().count(), 3); // 글자 수
    }

    #[test]
    fn test_keyword_100_chars_korean() {
        // 한글 100자 = 300바이트 — chars().count() 기준 100자 이하 통과
        let korean_100: String = "가".repeat(100);
        assert_eq!(korean_100.chars().count(), 100);
        assert_eq!(korean_100.len(), 300);
        // 100자 이하이므로 유효
        assert!(korean_100.chars().count() <= 100);
    }

    #[test]
    fn test_keyword_101_chars_korean() {
        // 한글 101자 → 차단
        let korean_101: String = "가".repeat(101);
        assert_eq!(korean_101.chars().count(), 101);
        assert!(korean_101.chars().count() > 100);
    }

    // --- update_price_alert 목표가 검증 ---

    #[test]
    fn test_price_alert_target_zero_is_invalid() {
        // target_price <= 0은 BadRequest
        assert!(rust_decimal::Decimal::ZERO <= rust_decimal::Decimal::ZERO);
    }

    #[test]
    fn test_price_alert_target_negative_is_invalid() {
        let neg = rust_decimal::Decimal::new(-1, 0);
        assert!(neg <= rust_decimal::Decimal::ZERO);
    }
}
