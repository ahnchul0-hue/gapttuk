use chrono::{Datelike, NaiveDate, Utc};
use rand::Rng;
use serde::Serialize;
use sqlx::PgPool;

use crate::error::AppError;

/// 일일 룰렛 결과 응답
#[derive(Debug, Serialize)]
pub struct CheckinResult {
    /// 당일 보상 (0 또는 1)
    pub reward_amount: i16,
    /// 이미 오늘 출석했는지
    pub already_checked_in: bool,
}

/// 센트 잔액 응답
#[derive(Debug, Serialize)]
pub struct PointsInfo {
    pub balance: i32,
    pub total_earned: i32,
    pub total_spent: i32,
}

/// 월한도 배분 확률 — 1¢=90%, 2¢=6%, 3¢=3%, 4¢=1%
/// 신규 유저(첫 달)는 1~2¢ 범위만 배정
fn assign_monthly_cap(is_new_user_first_month: bool) -> i16 {
    let r = rand::rngs::OsRng.gen_range(0u32..100);
    if is_new_user_first_month {
        // 신규 유저: 1¢(94%) 또는 2¢(6%)
        if r < 94 {
            1
        } else {
            2
        }
    } else {
        // 기존 유저: 1¢=90%, 2¢=6%, 3¢=3%, 4¢=1%
        if r < 90 {
            1
        } else if r < 96 {
            2
        } else if r < 99 {
            3
        } else {
            4
        }
    }
}

/// 룰렛 결과 판정 — 월한도 미달이면 90% 확률로 1¢ 당첨
fn spin_roulette() -> i16 {
    let r = rand::rngs::OsRng.gen_range(0u32..100);
    if r < 90 {
        1
    } else {
        0
    }
}

/// 일일 출석 룰렛 실행
///
/// - 오늘 이미 출석했으면 already_checked_in=true, reward_amount=0 반환
/// - user_monthly_checkin_caps lazy 생성 (없으면 그 달 한도 배정)
/// - earned_so_far >= monthly_cap이면 0¢ (한도 초과)
/// - 한도 미달이면 spin_roulette()으로 0 또는 1¢ 지급
/// - 모든 DB 변경은 단일 트랜잭션
pub async fn daily_checkin(pool: &PgPool, user_id: i64) -> Result<CheckinResult, AppError> {
    let today: NaiveDate = Utc::now().naive_utc().date();
    let year_month = format!("{}-{:02}", today.year(), today.month());

    let mut tx = pool.begin().await?;

    // 1. 오늘 이미 출석 여부 확인
    let existing: Option<(i64,)> =
        sqlx::query_as("SELECT id FROM daily_checkins WHERE user_id = $1 AND checkin_date = $2")
            .bind(user_id)
            .bind(today)
            .fetch_optional(&mut *tx)
            .await?;

    if existing.is_some() {
        tx.rollback().await?;
        return Ok(CheckinResult {
            reward_amount: 0,
            already_checked_in: true,
        });
    }

    // 2. 이 달 월한도 레코드 lazy 조회/생성
    let cap_row: Option<(i64, i16, i16)> = sqlx::query_as(
        "SELECT id, monthly_cap, earned_so_far FROM user_monthly_checkin_caps WHERE user_id = $1 AND year_month = $2",
    )
    .bind(user_id)
    .bind(&year_month)
    .fetch_optional(&mut *tx)
    .await?;

    let (cap_id, monthly_cap, earned_so_far) = if let Some(row) = cap_row {
        row
    } else {
        // 신규 유저 첫 달 여부 확인 (가입월 == 현재월)
        let created_year_month: Option<String> =
            sqlx::query_scalar("SELECT to_char(created_at, 'YYYY-MM') FROM users WHERE id = $1")
                .bind(user_id)
                .fetch_optional(&mut *tx)
                .await?;
        let is_new_user = created_year_month.as_deref() == Some(&year_month);
        let cap = assign_monthly_cap(is_new_user);

        let new_id: i64 = sqlx::query_scalar(
            "INSERT INTO user_monthly_checkin_caps (user_id, year_month, monthly_cap, earned_so_far) VALUES ($1, $2, $3, 0) RETURNING id",
        )
        .bind(user_id)
        .bind(&year_month)
        .bind(cap)
        .fetch_one(&mut *tx)
        .await?;
        (new_id, cap, 0i16)
    };

    // 3. 한도 초과 체크
    let reward: i16 = if earned_so_far >= monthly_cap {
        0 // 월한도 도달 — 항상 0¢
    } else {
        spin_roulette()
    };

    // 4. daily_checkins INSERT
    sqlx::query(
        "INSERT INTO daily_checkins (user_id, checkin_date, reward_amount) VALUES ($1, $2, $3)",
    )
    .bind(user_id)
    .bind(today)
    .bind(reward)
    .execute(&mut *tx)
    .await?;

    // 5. 보상이 있을 때만 잔액 + 월한도 업데이트
    if reward > 0 {
        let reward_i32 = reward as i32;

        // user_points 잔액 증가
        sqlx::query(
            "UPDATE user_points SET balance = balance + $1, total_earned = total_earned + $1, updated_at = NOW() WHERE user_id = $2",
        )
        .bind(reward_i32)
        .bind(user_id)
        .execute(&mut *tx)
        .await?;

        // point_transactions 기록
        sqlx::query(
            "INSERT INTO point_transactions (user_id, amount, transaction_type, description) VALUES ($1, $2, 'daily_checkin', '일일 출석 룰렛 보상')",
        )
        .bind(user_id)
        .bind(reward_i32)
        .execute(&mut *tx)
        .await?;

        // 월한도 earned_so_far 증가
        sqlx::query(
            "UPDATE user_monthly_checkin_caps SET earned_so_far = earned_so_far + $1 WHERE id = $2",
        )
        .bind(reward)
        .bind(cap_id)
        .execute(&mut *tx)
        .await?;
    }

    tx.commit().await?;
    Ok(CheckinResult {
        reward_amount: reward,
        already_checked_in: false,
    })
}

/// 사용자 센트 잔액 조회
pub async fn get_points(pool: &PgPool, user_id: i64) -> Result<PointsInfo, AppError> {
    let row: Option<(i32, i32, i32)> = sqlx::query_as(
        "SELECT balance, total_earned, total_spent FROM user_points WHERE user_id = $1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await?;

    let (balance, total_earned, total_spent) = row.unwrap_or((0, 0, 0));
    Ok(PointsInfo {
        balance,
        total_earned,
        total_spent,
    })
}

/// 포인트 내역 항목
#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct PointHistoryItem {
    pub id: i64,
    pub amount: i32,
    pub transaction_type: String,
    pub description: Option<String>,
    pub created_at: chrono::DateTime<chrono::Utc>,
}

/// 포인트 내역 조회 (커서 페이지네이션)
pub async fn get_history(
    pool: &PgPool,
    user_id: i64,
    cursor: Option<i64>,
    limit: i64,
) -> Result<(Vec<PointHistoryItem>, bool), AppError> {
    let effective_limit = limit.clamp(1, 50);
    let fetch_limit = effective_limit + 1;

    let items: Vec<PointHistoryItem> = if let Some(cursor_id) = cursor {
        sqlx::query_as(
            "SELECT id, amount, transaction_type, description, created_at FROM point_transactions WHERE user_id = $1 AND id < $2 ORDER BY id DESC LIMIT $3",
        )
        .bind(user_id)
        .bind(cursor_id)
        .bind(fetch_limit)
        .fetch_all(pool)
        .await?
    } else {
        sqlx::query_as(
            "SELECT id, amount, transaction_type, description, created_at FROM point_transactions WHERE user_id = $1 ORDER BY id DESC LIMIT $2",
        )
        .bind(user_id)
        .bind(fetch_limit)
        .fetch_all(pool)
        .await?
    };

    let has_more = items.len() as i64 > effective_limit;
    let result: Vec<PointHistoryItem> = items.into_iter().take(effective_limit as usize).collect();
    Ok((result, has_more))
}

/// 추천 보상 단계 처리 — 구매 확인 이벤트 발생 시 호출
///
/// - Stage 0 → 1 (1만원 이상 첫 구매): 피초대자 +1¢, 초대자 2¢
/// - Stage 1 → 2 (1만원 이상 두번째 구매): 피초대자 +1¢, 초대자 3¢
/// - Stage 2 이미 완료면 no-op
pub async fn process_referral_purchase(
    pool: &PgPool,
    referred_user_id: i64,
    purchase_amount: i32,
) -> Result<(), AppError> {
    const MIN_PURCHASE: i32 = 10_000;
    if purchase_amount < MIN_PURCHASE {
        return Ok(());
    }

    let mut tx = pool.begin().await?;

    // 추천 레코드 조회 (referred_id = 구매한 사용자)
    let referral: Option<(i64, i64, i16)> = sqlx::query_as(
        "SELECT id, referrer_id, reward_stage FROM referrals WHERE referred_id = $1 FOR UPDATE",
    )
    .bind(referred_user_id)
    .fetch_optional(&mut *tx)
    .await?;

    let (referral_id, referrer_id, reward_stage) = match referral {
        Some(r) => r,
        None => {
            tx.rollback().await?;
            return Ok(()); // 추천인 없음
        }
    };

    let (next_stage, referrer_reward, referred_reward) = match reward_stage {
        0 => (1i16, 2i32, 1i32), // Stage 0→1: 초대자 2¢, 피초대자 1¢
        1 => (2i16, 3i32, 1i32), // Stage 1→2: 초대자 3¢, 피초대자 1¢
        _ => {
            tx.rollback().await?;
            return Ok(()); // 이미 Stage 2 완료
        }
    };

    // reward_stage 업데이트
    sqlx::query("UPDATE referrals SET reward_stage = $1 WHERE id = $2")
        .bind(next_stage)
        .bind(referral_id)
        .execute(&mut *tx)
        .await?;

    // 초대자 보상
    sqlx::query(
        "UPDATE user_points SET balance = balance + $1, total_earned = total_earned + $1, updated_at = NOW() WHERE user_id = $2",
    )
    .bind(referrer_reward)
    .bind(referrer_id)
    .execute(&mut *tx)
    .await?;
    sqlx::query(
        "INSERT INTO point_transactions (user_id, amount, transaction_type, reference_id, description) VALUES ($1, $2, 'referral_purchase_referrer', $3, '추천 보상 — 피초대자 구매')",
    )
    .bind(referrer_id)
    .bind(referrer_reward)
    .bind(referral_id)
    .execute(&mut *tx)
    .await?;

    // 피초대자 보상
    sqlx::query(
        "UPDATE user_points SET balance = balance + $1, total_earned = total_earned + $1, updated_at = NOW() WHERE user_id = $2",
    )
    .bind(referred_reward)
    .bind(referred_user_id)
    .execute(&mut *tx)
    .await?;
    sqlx::query(
        "INSERT INTO point_transactions (user_id, amount, transaction_type, reference_id, description) VALUES ($1, $2, 'referral_purchase_referred', $3, '추천 보상 — 구매 달성')",
    )
    .bind(referred_user_id)
    .bind(referred_reward)
    .bind(referral_id)
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;
    Ok(())
}

// ─── 단위 테스트 ──────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn assign_monthly_cap_new_user_range() {
        // 신규 유저는 1 또는 2만 가능
        for _ in 0..200 {
            let cap = assign_monthly_cap(true);
            assert!(cap == 1 || cap == 2, "new user cap out of range: {cap}");
        }
    }

    #[test]
    fn assign_monthly_cap_regular_user_range() {
        // 일반 유저는 1~4 범위
        for _ in 0..200 {
            let cap = assign_monthly_cap(false);
            assert!(
                (1..=4).contains(&cap),
                "regular user cap out of range: {cap}"
            );
        }
    }

    #[test]
    fn spin_roulette_range() {
        // 결과는 0 또는 1만 가능
        for _ in 0..200 {
            let r = spin_roulette();
            assert!(r == 0 || r == 1, "roulette out of range: {r}");
        }
    }

    #[test]
    fn checkin_result_already_flag() {
        let r = CheckinResult {
            reward_amount: 0,
            already_checked_in: true,
        };
        assert!(r.already_checked_in);
        assert_eq!(r.reward_amount, 0);
    }

    #[test]
    fn assign_monthly_cap_distribution_bias() {
        // 1000회 반복 시 대부분 1¢ 배정 확인 (90%)
        let ones = (0..1000)
            .map(|_| assign_monthly_cap(false))
            .filter(|&c| c == 1)
            .count();
        assert!(ones > 800, "expected >80% ones, got {ones}/1000");
    }

    #[test]
    fn assign_monthly_cap_new_user_never_above_2() {
        for _ in 0..500 {
            let cap = assign_monthly_cap(true);
            assert!(cap <= 2, "new user got cap {cap} > 2");
        }
    }

    #[test]
    fn spin_roulette_mostly_wins() {
        // 90% 확률로 1¢ — 1000회 시 800+ 확인
        let wins = (0..1000)
            .map(|_| spin_roulette())
            .filter(|&r| r == 1)
            .count();
        assert!(wins > 800, "expected >80% wins, got {wins}/1000");
    }

    #[test]
    fn points_info_zero_defaults() {
        let info = PointsInfo {
            balance: 0,
            total_earned: 0,
            total_spent: 0,
        };
        assert_eq!(info.balance, 0);
        assert_eq!(info.total_earned, 0);
        assert_eq!(info.total_spent, 0);
    }

    #[test]
    fn checkin_result_reward_values() {
        for amount in [0i16, 1] {
            let r = CheckinResult {
                reward_amount: amount,
                already_checked_in: false,
            };
            assert!((0..=1).contains(&r.reward_amount));
            assert!(!r.already_checked_in);
        }
    }
}
