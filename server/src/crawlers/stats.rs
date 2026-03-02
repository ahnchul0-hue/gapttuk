use crate::models::PriceTrend;

/// 현재 가격과 평균 가격을 비교하여 추세 결정 (±2% 기준).
pub fn compute_trend(current_price: i32, average_price: i32) -> PriceTrend {
    if average_price == 0 {
        return PriceTrend::Stable;
    }
    let diff_pct = ((current_price - average_price) as f64 / average_price as f64) * 100.0;
    if diff_pct > 2.0 {
        PriceTrend::Rising
    } else if diff_pct < -2.0 {
        PriceTrend::Falling
    } else {
        PriceTrend::Stable
    }
}

/// buy_timing_score MVP 공식 (0~100).
///
/// ```text
/// base = 50
/// + min(30, drop_from_avg * 100 / avg)   // 평균 이하일수록 높음
/// + 20 if days_since_lowest == 0          // 현재 최저가
/// + 10 if days_since_lowest <= 3          // 최저가 근접
/// + 10 if trend == Falling                // 하락 추세
/// - 10 if trend == Rising                 // 상승 추세
/// clamp(0, 100)
/// ```
pub fn compute_buy_timing_score(
    drop_from_average: i32,
    average_price: i32,
    days_since_lowest: i32,
    trend: &PriceTrend,
) -> i16 {
    let mut score: i32 = 50;

    // 평균 대비 할인 보너스 (최대 30점)
    if average_price > 0 && drop_from_average > 0 {
        let bonus = std::cmp::min(30, drop_from_average * 100 / average_price);
        score += bonus;
    }

    // 최저가 보너스
    if days_since_lowest == 0 {
        score += 20;
    } else if days_since_lowest <= 3 {
        score += 10;
    }

    // 추세 보너스/패널티
    match trend {
        PriceTrend::Falling => score += 10,
        PriceTrend::Rising => score -= 10,
        PriceTrend::Stable => {}
    }

    score.clamp(0, 100) as i16
}

/// 크롤링 후 products 테이블 10개 필드 갱신.
/// - current_price, lowest/highest/average_price, price_trend
/// - days_since_lowest, drop_from_average, buy_timing_score
/// - is_out_of_stock, price_updated_at
pub async fn refresh_product_stats(
    pool: &sqlx::PgPool,
    product_id: i64,
    new_price: i32,
    is_out_of_stock: bool,
) -> Result<(), sqlx::Error> {
    // 1) price_history에서 30일 평균 + 최저가 기록일 조회
    let stats = sqlx::query_as::<_, PriceStats>(
        r#"
        SELECT
            AVG(price)::int AS avg_price_30d,
            (SELECT MIN(recorded_at) FROM price_history
             WHERE product_id = $1 AND price = (
                SELECT MIN(price) FROM price_history WHERE product_id = $1
             ))
            AS lowest_date
        FROM price_history ph
        WHERE product_id = $1
          AND recorded_at >= NOW() - INTERVAL '30 days'
        "#,
    )
    .bind(product_id)
    .fetch_one(pool)
    .await?;

    // 전체 기간 lowest/highest
    let all_time = sqlx::query_as::<_, AllTimeStats>(
        r#"
        SELECT
            MIN(price) AS min_price,
            MAX(price) AS max_price
        FROM price_history
        WHERE product_id = $1
        "#,
    )
    .bind(product_id)
    .fetch_one(pool)
    .await?;

    let lowest_price = all_time.min_price.unwrap_or(new_price);
    let highest_price = all_time.max_price.unwrap_or(new_price);
    let average_price = stats.avg_price_30d.unwrap_or(new_price);

    // 2) 비즈니스 로직 계산
    let trend = compute_trend(new_price, average_price);
    let drop_from_average = average_price - new_price;

    let days_since_lowest = stats
        .lowest_date
        .map(|d| (chrono::Utc::now() - d).num_days() as i32)
        .unwrap_or(0);

    let buy_timing_score =
        compute_buy_timing_score(drop_from_average, average_price, days_since_lowest, &trend);

    // 3) products 업데이트
    sqlx::query(
        r#"
        UPDATE products SET
            current_price = $2,
            lowest_price = $3,
            highest_price = $4,
            average_price = $5,
            price_trend = $6,
            days_since_lowest = $7,
            drop_from_average = $8,
            buy_timing_score = $9,
            is_out_of_stock = $10,
            price_updated_at = NOW(),
            updated_at = NOW()
        WHERE id = $1
        "#,
    )
    .bind(product_id)
    .bind(new_price)
    .bind(lowest_price)
    .bind(highest_price)
    .bind(average_price)
    .bind(&trend as &PriceTrend)
    .bind(days_since_lowest)
    .bind(drop_from_average)
    .bind(buy_timing_score)
    .bind(is_out_of_stock)
    .execute(pool)
    .await?;

    Ok(())
}

/// 30일 평균 + 최저가 기록일
#[derive(sqlx::FromRow)]
struct PriceStats {
    avg_price_30d: Option<i32>,
    lowest_date: Option<chrono::DateTime<chrono::Utc>>,
}

/// 전체 기간 최저/최고 쿼리 결과
#[derive(sqlx::FromRow)]
struct AllTimeStats {
    min_price: Option<i32>,
    max_price: Option<i32>,
}

#[cfg(test)]
mod tests {
    use super::*;

    // --- compute_trend ---
    #[test]
    fn trend_rising_when_above_2_percent() {
        assert_eq!(compute_trend(1030, 1000), PriceTrend::Rising);
    }

    #[test]
    fn trend_falling_when_below_2_percent() {
        assert_eq!(compute_trend(970, 1000), PriceTrend::Falling);
    }

    #[test]
    fn trend_stable_within_2_percent() {
        assert_eq!(compute_trend(1010, 1000), PriceTrend::Stable);
        assert_eq!(compute_trend(990, 1000), PriceTrend::Stable);
    }

    #[test]
    fn trend_stable_when_avg_zero() {
        assert_eq!(compute_trend(100, 0), PriceTrend::Stable);
    }

    // --- compute_buy_timing_score ---
    #[test]
    fn score_at_current_lowest_falling() {
        // base 50 + discount bonus + 20 (lowest) + 10 (falling) = high
        let score = compute_buy_timing_score(200, 1000, 0, &PriceTrend::Falling);
        assert_eq!(score, 100); // 50 + 20 + 20 + 10 = 100
    }

    #[test]
    fn score_no_discount_rising() {
        // base 50 + 0 (no discount) + 0 (days > 3) - 10 (rising) = 40
        let score = compute_buy_timing_score(0, 1000, 30, &PriceTrend::Rising);
        assert_eq!(score, 40);
    }

    #[test]
    fn score_near_lowest_stable() {
        // base 50 + 10 (10% discount, min(30,10)) + 10 (days<=3) + 0 = 70
        let score = compute_buy_timing_score(100, 1000, 2, &PriceTrend::Stable);
        assert_eq!(score, 70);
    }

    #[test]
    fn score_clamps_to_0_100() {
        // negative drop (price above avg) with rising trend
        let score = compute_buy_timing_score(-100, 1000, 100, &PriceTrend::Rising);
        assert_eq!(score, 40); // 50 + 0 + 0 - 10 = 40

        // max score
        let score = compute_buy_timing_score(500, 1000, 0, &PriceTrend::Falling);
        // 50 + 30(capped) + 20 + 10 = 110 → clamped to 100
        assert_eq!(score, 100);
    }
}
