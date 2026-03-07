# Phase 1: CRITICAL + HIGH 결함 수정 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** PR #1 코드 리뷰에서 발견된 CRITICAL 7건 + HIGH 5건을 수정하여 프로덕션 안전성 확보

**Architecture:** 3개 도메인 그룹(Archive/Reward/Auth)으로 분리, 각 그룹 내 TDD 방식 적용. 기존 197 Rust 테스트 전체 통과 유지.

**Tech Stack:** Rust 1.94.0, Axum, SQLx, PostgreSQL 17.9, tokio

---

## Task 1: CR-6 — add_points_and_record 음수 가드

**Files:**
- Modify: `server/src/services/reward_service.rs:10-43`
- Test: `server/src/services/reward_service.rs` (기존 tests 모듈 내)

**Step 1: 유닛 테스트 추가**

`reward_service.rs`의 `mod tests` 블록 끝에 추가:

```rust
#[test]
fn add_points_negative_amount_is_invalid() {
    // add_points_and_record는 async + DB 의존이므로 직접 테스트 어려움.
    // 대신 amount 검증 로직을 별도 함수로 추출하여 테스트.
    assert!(validate_point_amount(-1).is_err());
    assert!(validate_point_amount(0).is_err());
    assert!(validate_point_amount(1).is_ok());
    assert!(validate_point_amount(100).is_ok());
}
```

**Step 2: 검증 함수 + 가드 구현**

`reward_service.rs` 상단, `add_points_and_record` 함수 직전에:

```rust
/// 포인트 금액 유효성 검증. 0 이하는 거부.
fn validate_point_amount(amount: i32) -> Result<(), AppError> {
    if amount <= 0 {
        return Err(AppError::BadRequest(format!(
            "포인트 금액은 양수여야 합니다: {amount}"
        )));
    }
    Ok(())
}
```

`add_points_and_record` 본문 첫 줄에:

```rust
validate_point_amount(amount)?;
```

**Step 3: 테스트 실행**

Run: `cd server && cargo test --lib reward_service::tests::add_points_negative`
Expected: PASS

**Step 4: 전체 테스트 확인**

Run: `cd server && cargo test`
Expected: 197+ tests PASS (기존 전부 + 신규 1건)

**Step 5: 커밋**

```bash
git add server/src/services/reward_service.rs
git commit -m "fix(reward): CR-6 음수 amount 가드 추가"
```

---

## Task 2: CR-7 — user_points upsert 패턴

**Files:**
- Modify: `server/src/services/reward_service.rs:18-25`

**Step 1: UPDATE를 INSERT ON CONFLICT DO UPDATE로 교체**

`add_points_and_record` 내 첫 번째 SQL (line 19-25)을 교체:

```rust
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
```

**Step 2: 테스트 실행**

Run: `cd server && cargo test`
Expected: 모든 테스트 PASS

**Step 3: 커밋**

```bash
git add server/src/services/reward_service.rs
git commit -m "fix(reward): CR-7 user_points upsert 패턴으로 변경"
```

---

## Task 3: CR-4 — 신규유저 7일 기준 변경

**Files:**
- Modify: `server/src/services/reward_service.rs:150-156`

**Step 1: SQL 변경**

`daily_checkin` 함수 내 신규 유저 확인 쿼리 (line 151-156)를 교체:

```rust
// 신규 유저 여부 확인 (가입 7일 이내)
let is_new_user: bool = sqlx::query_scalar(
    "SELECT created_at > NOW() - INTERVAL '7 days' FROM users WHERE id = $1",
)
.bind(user_id)
.fetch_optional(&mut *tx)
.await?
.unwrap_or(false);
```

기존 `created_year_month` 변수와 `let is_new_user = created_year_month.as_deref() == Some(&year_month);` 두 줄 제거.

**Step 2: 테스트 실행**

Run: `cd server && cargo test`
Expected: 모든 테스트 PASS

**Step 3: 커밋**

```bash
git add server/src/services/reward_service.rs
git commit -m "fix(reward): CR-4 신규유저 기준을 가입월에서 7일로 변경"
```

---

## Task 4: CR-5 — 초대자 Stage 0 웰컴 보상 1¢

**Files:**
- Modify: `server/src/services/auth_service.rs:117-127`

**Step 1: 초대자 보상 추가**

`auth_service.rs` line 126 (`add_points_and_record` for 피초대자) 뒤에 추가:

```rust
// Stage 0 웰컴 보상: 초대자 1¢
add_points_and_record(
    &mut tx,
    referrer_id,
    1,
    "referral_welcome_referrer",
    "추천인 웰컴 보상",
    None,
)
.await?;
```

**Step 2: H-3 명시 주석 추가**

기존 피초대자 보상 위에 주석 추가:

```rust
// Stage 0 웰컴 보상: 피초대자 1¢
// NOTE(H-3): Stage 0→1 전환 시 추가 1¢는 process_referral_purchase()에서 별도 지급.
//            웰컴(1¢) + 첫구매(1¢) = 총 2¢는 설계 의도.
```

**Step 3: 테스트 실행**

Run: `cd server && cargo test`
Expected: 모든 테스트 PASS

**Step 4: 커밋**

```bash
git add server/src/services/auth_service.rs
git commit -m "fix(auth): CR-5 초대자 Stage 0 웰컴 보상 1¢ 추가"
```

---

## Task 5: H-4 — HistoryParams.limit 핸들러 검증

**Files:**
- Modify: `server/src/api/routes/rewards.rs:52-57`

**Step 1: 핸들러에서 limit clamp 적용**

`get_history` 핸들러 (line 52-58)의 `params.limit` 처리 변경:

```rust
let limit = params.limit.unwrap_or(20).clamp(1, 50);
let (items, has_more) = reward_service::get_history(
    &state.pool,
    claims.sub,
    params.cursor,
    limit,
)
.await?;
```

**Step 2: 테스트 실행**

Run: `cd server && cargo test`
Expected: 모든 테스트 PASS

**Step 3: 커밋**

```bash
git add server/src/api/routes/rewards.rs
git commit -m "fix(api): H-4 history limit 핸들러 레벨 clamp(1,50)"
```

---

## Task 6: H-2 — rotate_refresh_token aborted tx 수정

**Files:**
- Modify: `server/src/services/auth_service.rs:191-243`

**Step 1: tx 재사용 제거 — pool 직접 사용**

탈취 감지 블록 (line 191-243)을 교체:

```rust
if revoked_at.is_some() {
    // tx를 먼저 롤백 (aborted state 방지)
    let _ = tx.rollback().await;

    // pool에서 직접 실행 — 멱등 UPDATE이므로 트랜잭션 불필요
    for attempt in 1..=2 {
        match sqlx::query(
            "UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL",
        )
        .bind(user_id)
        .execute(pool)
        .await
        {
            Ok(result) => {
                tracing::warn!(
                    user_id,
                    revoked_count = result.rows_affected(),
                    "Refresh token reuse detected — all tokens revoked (attempt {attempt})"
                );
                break;
            }
            Err(e) => {
                tracing::error!(
                    user_id,
                    attempt,
                    error = %e,
                    "Failed to revoke tokens during theft detection"
                );
                if attempt == 2 {
                    tracing::error!(
                        user_id,
                        "SECURITY: Token theft detected but revocation failed after 2 attempts"
                    );
                }
            }
        }
    }

    return Err(AppError::TokenInvalid);
}
```

**Step 2: 테스트 실행**

Run: `cd server && cargo test`
Expected: 모든 테스트 PASS

**Step 3: 커밋**

```bash
git add server/src/services/auth_service.rs
git commit -m "fix(auth): H-2 rotate_refresh_token pool 직접 실행으로 변경"
```

---

## Task 7: 그룹 A — archive_old_price_history 전면 개선 (CR-1, CR-2, CR-3, H-1, H-5)

**Files:**
- Modify: `server/src/main.rs:181-289`

**Step 1: 파티션 경계 파싱 유닛 테스트 추가**

`main.rs` 하단 또는 별도 테스트 모듈에:

```rust
#[cfg(test)]
mod archive_tests {
    use super::*;

    #[test]
    fn parse_partition_bound_extracts_to_date() {
        let expr = "FOR VALUES FROM ('2024-01-01') TO ('2024-02-01')";
        let to_date = extract_partition_to_date(expr);
        assert_eq!(
            to_date,
            Some(chrono::NaiveDate::from_ymd_opt(2024, 2, 1).unwrap())
        );
    }

    #[test]
    fn parse_partition_bound_default_returns_none() {
        assert_eq!(extract_partition_to_date("DEFAULT"), None);
    }

    #[test]
    fn parse_partition_bound_malformed_returns_none() {
        assert_eq!(extract_partition_to_date("garbage"), None);
    }
}
```

**Step 2: 테스트 실행 — 실패 확인**

Run: `cd server && cargo test archive_tests`
Expected: FAIL — `extract_partition_to_date` 미정의

**Step 3: 파싱 함수 구현**

`archive_old_price_history` 직전에:

```rust
/// 파티션 bound 표현식에서 TO 날짜를 추출.
/// 예: "FOR VALUES FROM ('2024-01-01') TO ('2024-02-01')" → Some(2024-02-01)
fn extract_partition_to_date(bound_expr: &str) -> Option<chrono::NaiveDate> {
    let to_idx = bound_expr.find("TO ('")?;
    let start = to_idx + 5; // "TO ('" 길이
    let end = bound_expr[start..].find('\'')? + start;
    chrono::NaiveDate::parse_from_str(&bound_expr[start..end], "%Y-%m-%d").ok()
}
```

**Step 4: 테스트 실행 — 통과 확인**

Run: `cd server && cargo test archive_tests`
Expected: 3 tests PASS

**Step 5: archive_old_price_history 전면 교체**

```rust
async fn archive_old_price_history(pool: &sqlx::PgPool) -> Result<(), String> {
    let cutoff = chrono::Utc::now().date_naive() - chrono::Months::new(24);

    // pg_get_expr로 파티션 경계 날짜를 직접 조회 — 이름 형식에 의존하지 않음 (CR-1)
    let rows = sqlx::query_as::<_, (String, String)>(
        "SELECT c.relname, pg_get_expr(c.relpartbound, c.oid) \
         FROM pg_inherits i \
         JOIN pg_class c ON c.oid = i.inhrelid \
         JOIN pg_class p ON p.oid = i.inhparent \
         WHERE p.relname = 'price_history' \
         ORDER BY c.relname",
    )
    .fetch_all(pool)
    .await
    .map_err(|e| format!("Failed to query price_history partitions: {e}"))?;

    for (partition_name, bound_expr) in rows {
        // 파티션 경계의 TO 날짜 파싱
        let Some(to_date) = extract_partition_to_date(&bound_expr) else {
            continue; // DEFAULT 파티션 또는 파싱 불가
        };

        if to_date > cutoff {
            continue; // 2년 미만 — 보존
        }

        // 파티션 이름 안전성 검사 (SQL injection 방지)
        if !partition_name
            .chars()
            .all(|c| c.is_ascii_alphanumeric() || c == '_')
        {
            tracing::warn!(partition = %partition_name, "Unexpected partition name format");
            continue;
        }

        tracing::info!(partition = %partition_name, "Archiving old price_history partition");

        // 단일 트랜잭션으로 집계→검증→DROP 원자적 실행 (CR-3, H-5)
        let mut tx = pool.begin().await.map_err(|e| format!("BEGIN failed: {e}"))?;

        // 1. price_history_monthly로 집계 (멱등: ON CONFLICT DO NOTHING)
        let aggregate_sql = format!(
            "INSERT INTO price_history_monthly \
                 (product_id, year_month, avg_price, min_price, max_price, \
                  first_price, last_price, record_count, had_stockout) \
             SELECT \
                 product_id, \
                 DATE_TRUNC('month', recorded_at)::DATE, \
                 AVG(price)::INTEGER, \
                 MIN(price), \
                 MAX(price), \
                 (ARRAY_AGG(price ORDER BY recorded_at ASC))[1], \
                 (ARRAY_AGG(price ORDER BY recorded_at DESC))[1], \
                 COUNT(*)::INTEGER, \
                 BOOL_OR(is_out_of_stock) \
             FROM \"{}\" \
             GROUP BY product_id, DATE_TRUNC('month', recorded_at)::DATE \
             ON CONFLICT (product_id, year_month) DO NOTHING",
            partition_name
        );
        if let Err(e) = sqlx::query(&aggregate_sql).execute(&mut *tx).await {
            let _ = tx.rollback().await;
            tracing::warn!(partition = %partition_name, error = %e, "Aggregation failed, skipping DROP");
            return Err(format!("Aggregation of {partition_name} failed: {e}"));
        }

        // 2. 행 수 검증 — 해당 파티션의 product만 대상 (CR-2)
        let count_sql = format!("SELECT COUNT(*)::BIGINT FROM \"{}\"", partition_name);
        let (source_count,): (i64,) = sqlx::query_as(&count_sql)
            .fetch_one(&mut *tx)
            .await
            .map_err(|e| format!("Count query failed: {e}"))?;

        let verify_sql = format!(
            "SELECT COALESCE(SUM(record_count), 0)::BIGINT \
             FROM price_history_monthly \
             WHERE product_id IN (SELECT DISTINCT product_id FROM \"{}\") \
               AND year_month >= (SELECT MIN(DATE_TRUNC('month', recorded_at)::DATE) FROM \"{}\") \
               AND year_month <= (SELECT MAX(DATE_TRUNC('month', recorded_at)::DATE) FROM \"{}\")",
            partition_name, partition_name, partition_name
        );
        let (aggregated_count,): (i64,) = sqlx::query_as(&verify_sql)
            .fetch_one(&mut *tx)
            .await
            .map_err(|e| format!("Verify query failed: {e}"))?;

        if aggregated_count < source_count {
            let _ = tx.rollback().await;
            tracing::warn!(
                partition = %partition_name,
                source = source_count,
                aggregated = aggregated_count,
                "Row count mismatch — skipping DROP"
            );
            return Err(format!(
                "{partition_name}: count mismatch {source_count} vs {aggregated_count}"
            ));
        }

        // 3. 파티션 DROP (quoted identifier — H-1)
        let drop_sql = format!("DROP TABLE IF EXISTS \"{}\"", partition_name);
        match sqlx::query(&drop_sql).execute(&mut *tx).await {
            Ok(_) => {
                // 트랜잭션 커밋 — 집계+DROP 원자적 완료
                tx.commit().await.map_err(|e| format!("COMMIT failed: {e}"))?;
                tracing::info!(
                    partition = %partition_name,
                    rows_archived = source_count,
                    "Old price_history partition archived and dropped"
                );
            }
            Err(e) => {
                let _ = tx.rollback().await;
                tracing::warn!(partition = %partition_name, error = %e, "Failed to drop archived partition");
                return Err(format!("DROP {partition_name} failed: {e}"));
            }
        }

        // 1개 파티션만 처리 후 종료 (부하 분산)
        break;
    }

    Ok(())
}
```

**Step 6: 전체 테스트 실행**

Run: `cd server && cargo test`
Expected: 200+ tests PASS

**Step 7: cargo fmt + clippy**

Run: `cd server && cargo fmt && cargo clippy -- -D warnings`
Expected: 0 warnings

**Step 8: 커밋**

```bash
git add server/src/main.rs
git commit -m "fix(archive): CR-1/2/3 + H-1/5 파티션 아카이브 원자적 트랜잭션화"
```

---

## Task 8: 최종 검증 + PR

**Step 1: 전체 Rust 테스트**

Run: `cd server && cargo test`
Expected: 전체 PASS

**Step 2: Flutter 테스트 (변경 없지만 회귀 확인)**

Run: `cd app && /home/code/flutter/bin/flutter test`
Expected: 164 tests PASS

**Step 3: cargo fmt + clippy**

Run: `cd server && cargo fmt --check && cargo clippy -- -D warnings`
Expected: 0 issues

**Step 4: REVIEW_FOLLOWUP.md 상태 업데이트**

각 CRITICAL/HIGH 항목에 완료 표시 추가.

**Step 5: PR 생성**

```bash
git push origin main
```

또는 별도 브랜치로:

```bash
git checkout -b fix/phase1-critical-high
git push -u origin fix/phase1-critical-high
gh pr create --title "fix: Phase 1 CRITICAL 7건 + HIGH 5건 수정" --body "..."
```
