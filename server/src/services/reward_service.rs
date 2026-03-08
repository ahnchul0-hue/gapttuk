use chrono::{Datelike, NaiveDate, Utc};
use rand::Rng;
use serde::Serialize;
use sqlx::{PgPool, Postgres, Transaction};

use crate::error::AppError;

/// 포인트 금액 유효성 검증. 0 이하는 거부.
fn validate_point_amount(amount: i32) -> Result<(), AppError> {
    if amount <= 0 {
        return Err(AppError::BadRequest(format!(
            "포인트 금액은 양수여야 합니다: {amount}"
        )));
    }
    Ok(())
}

/// 트랜잭션 내에서 포인트 적립 + 거래 기록을 원자적으로 수행하는 공통 함수.
/// reward_service, auth_service 등 포인트를 조작하는 모든 코드에서 이 함수를 사용.
pub async fn add_points_and_record(
    tx: &mut Transaction<'_, Postgres>,
    user_id: i64,
    amount: i32,
    transaction_type: &str,
    description: &str,
    reference_id: Option<i64>,
) -> Result<(), AppError> {
    validate_point_amount(amount)?;

    // user_points 잔액 증가 (upsert — 레코드 미존재 시 자동 생성)
    sqlx::query(
        "INSERT INTO user_points (user_id, balance, total_earned) \
         VALUES ($2, $1, $1) \
         ON CONFLICT (user_id) DO UPDATE \
         SET balance = user_points.balance + $1, \
             total_earned = user_points.total_earned + $1, \
             updated_at = NOW()",
    )
    .bind(amount)
    .bind(user_id)
    .execute(&mut **tx)
    .await?;

    // point_transactions 기록
    sqlx::query(
        "INSERT INTO point_transactions (user_id, amount, transaction_type, reference_id, description) VALUES ($1, $2, $3, $4, $5)",
    )
    .bind(user_id)
    .bind(amount)
    .bind(transaction_type)
    .bind(reference_id)
    .bind(description)
    .execute(&mut **tx)
    .await?;

    // 비즈니스 메트릭: 포인트 발행 추적
    metrics::counter!("points_issued_total", "reason" => transaction_type.to_string())
        .increment(amount as u64);

    Ok(())
}

/// 일일 룰렛 결과 응답
#[derive(Debug, Serialize)]
pub struct CheckinResult {
    /// 당일 보상 (0 또는 1)
    pub reward_amount: i16,
    /// 이미 오늘 출석했는지
    pub already_checked_in: bool,
    /// 체크인 후 현재 잔액 (추가 API 호출 없이 클라이언트 갱신용)
    pub new_balance: i32,
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
#[tracing::instrument(skip(pool))]
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
        // 이미 출석 — 현재 잔액만 조회 후 반환
        let balance: i32 = sqlx::query_scalar("SELECT balance FROM user_points WHERE user_id = $1")
            .bind(user_id)
            .fetch_optional(&mut *tx)
            .await?
            .unwrap_or(0);
        tx.rollback().await?;
        metrics::counter!("checkins_total", "result" => "already").increment(1);
        return Ok(CheckinResult {
            reward_amount: 0,
            already_checked_in: true,
            new_balance: balance,
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
        // 신규 유저 여부 확인 (가입 7일 이내)
        let is_new_user: bool = sqlx::query_scalar(
            "SELECT created_at > NOW() - INTERVAL '7 days' FROM users WHERE id = $1",
        )
        .bind(user_id)
        .fetch_optional(&mut *tx)
        .await?
        .unwrap_or(false);
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
        add_points_and_record(
            &mut tx,
            user_id,
            reward as i32,
            "daily_checkin",
            "일일 출석 룰렛 보상",
            None,
        )
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

    // commit 후 최신 잔액 조회
    let new_balance: i32 = sqlx::query_scalar("SELECT balance FROM user_points WHERE user_id = $1")
        .bind(user_id)
        .fetch_optional(pool)
        .await?
        .unwrap_or(0);

    // 비즈니스 메트릭: 출석 체크인 결과
    let result_label = if reward > 0 { "reward" } else { "miss" };
    metrics::counter!("checkins_total", "result" => result_label).increment(1);

    Ok(CheckinResult {
        reward_amount: reward,
        already_checked_in: false,
        new_balance,
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

/// 리퍼럴 현황 응답
#[derive(Debug, Serialize)]
pub struct ReferralStats {
    pub referral_code: Option<String>,
    pub total_referred: i64,
    pub total_earned_cents: i32,
    pub referrals: Vec<ReferralItem>,
}

/// 개별 리퍼럴 항목
#[derive(Debug, Serialize)]
pub struct ReferralItem {
    pub referred_nickname: Option<String>,
    pub reward_stage: i16,
    pub earned_cents: i32,
    pub created_at: chrono::DateTime<chrono::Utc>,
}

/// 사용자의 리퍼럴 현황을 조회.
pub async fn get_referral_stats(pool: &PgPool, user_id: i64) -> Result<ReferralStats, AppError> {
    // 1. 사용자 referral_code 조회
    let referral_code: Option<String> =
        sqlx::query_scalar("SELECT referral_code FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await?
            .flatten();

    // 2. 리퍼럴 목록 + 각 리퍼럴별 획득 센트
    let rows: Vec<(Option<String>, i16, i32, chrono::DateTime<chrono::Utc>)> = sqlx::query_as(
        "SELECT u.nickname, r.reward_stage, \
             COALESCE((\
                 SELECT SUM(pt.amount)::INT FROM point_transactions pt \
                 WHERE pt.user_id = $1 \
                 AND pt.reference_id = r.id \
                 AND pt.transaction_type LIKE 'referral_%'\
             ), 0) AS earned_cents, \
             r.created_at \
         FROM referrals r \
         JOIN users u ON u.id = r.referred_id \
         WHERE r.referrer_id = $1 \
         ORDER BY r.created_at DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await?;

    let referrals: Vec<ReferralItem> = rows
        .into_iter()
        .map(|(nickname, stage, cents, created)| ReferralItem {
            referred_nickname: nickname,
            reward_stage: stage,
            earned_cents: cents,
            created_at: created,
        })
        .collect();

    let total_referred = referrals.len() as i64;
    let total_earned_cents: i32 = referrals.iter().map(|r| r.earned_cents).sum();

    Ok(ReferralStats {
        referral_code,
        total_referred,
        total_earned_cents,
        referrals,
    })
}

/// 추천 보상 단계 처리 — 구매 확인 이벤트 발생 시 호출
///
/// - Stage 0 → 1 (1만원 이상 첫 구매): 피초대자 +1¢, 초대자 2¢
/// - Stage 1 → 2 (1만원 이상 두번째 구매): 피초대자 +1¢, 초대자 3¢
/// - Stage 2 이미 완료면 no-op
#[tracing::instrument(skip(pool))]
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
    add_points_and_record(
        &mut tx,
        referrer_id,
        referrer_reward,
        "referral_purchase_referrer",
        "추천 보상 — 피초대자 구매",
        Some(referral_id),
    )
    .await?;

    // 피초대자 보상
    add_points_and_record(
        &mut tx,
        referred_user_id,
        referred_reward,
        "referral_purchase_referred",
        "추천 보상 — 구매 달성",
        Some(referral_id),
    )
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
            new_balance: 10,
        };
        assert!(r.already_checked_in);
        assert_eq!(r.reward_amount, 0);
        assert_eq!(r.new_balance, 10);
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
                new_balance: 5,
            };
            assert!((0..=1).contains(&r.reward_amount));
            assert!(!r.already_checked_in);
            assert_eq!(r.new_balance, 5);
        }
    }

    #[test]
    fn add_points_negative_amount_is_invalid() {
        assert!(validate_point_amount(-1).is_err());
        assert!(validate_point_amount(0).is_err());
        assert!(validate_point_amount(1).is_ok());
        assert!(validate_point_amount(100).is_ok());
    }
}
