# PR #1 코드 리뷰 후속 작업

> 생성: 2026-03-07, PR #1 머지 후 후속 PR로 처리

---

## CRITICAL (7건)

### CR-1: 파티션 이름 형식 불일치
- **파일**: `server/src/main.rs:198`
- **문제**: 초기 파티션(`price_history_202603`) vs 이후(`price_history_2026_03`), 사전순 비교에서 초기 파티션 영구 미처리
- **수정**: 파티션 경계 날짜를 `pg_get_expr()`로 직접 조회하거나, 001 migration 파티션 이름 정규화

### CR-2: 검증 쿼리 범위 오류
- **파일**: `server/src/main.rs:228,243`
- **문제**: `ON CONFLICT DO NOTHING` + 다른 product 집계가 카운트에 포함 -> 불완전 집계 후 DROP 가능
- **수정**: `verify_sql`에 `product_id IN (SELECT DISTINCT product_id FROM {partition})` 추가

### CR-3: 집계-검증-DROP 비원자적
- **파일**: `server/src/main.rs:211~283`
- **문제**: 3단계가 별도 쿼리로 실행, 중간 데이터 유입 시 집계 누락
- **수정**: 단일 트랜잭션으로 묶기 (PostgreSQL DDL도 트랜잭션 지원)

### CR-4: 신규유저 우대 기준 불일치
- **파일**: `server/src/services/reward_service.rs:151`
- **문제**: 설계 "가입 7일 이내" vs 코드 "가입월 동일"
- **수정**: `to_char(created_at, 'YYYY-MM')` -> `created_at > NOW() - INTERVAL '7 days'`

### CR-5: Stage 0 초대자 보상 (비즈니스 확인 필요)
- **파일**: `server/src/services/auth_service.rs:117`
- **문제**: 피초대자만 1c 지급, 초대자는 Stage 1까지 무보상
- **판단**: 설계 의도 확인 후 결정

### CR-6: add_points_and_record 음수 미검증
- **파일**: `server/src/services/reward_service.rs:10,41`
- **문제**: 음수 amount -> `as u64` 변환 시 메트릭 왜곡 (4294967295)
- **수정**: `if amount <= 0 { return Err(...) }` 가드 추가

### CR-7: user_points 레코드 미존재 시 불일치
- **파일**: `server/src/services/reward_service.rs:18`
- **문제**: UPDATE 0 rows + INSERT 거래기록 = 잔액/기록 불일치
- **수정**: `rows_affected()` 확인 또는 upsert 패턴

---

## HIGH (5건)

| # | 항목 | 파일 |
|---|------|------|
| H-1 | DROP SQL quoted identifier 미사용 | `main.rs:270` |
| H-2 | `rotate_refresh_token` 재시도 시 같은 tx 재사용 (aborted tx) | `auth_service.rs:191` |
| H-3 | Stage 0->1 웰컴 + 첫구매 이중 지급 의도 확인 | `reward_service.rs:296` |
| H-4 | `HistoryParams.limit` 핸들러 레벨 입력 검증 없음 | `rewards.rs:53` |
| H-5 | DROP 재시도 시 `ON CONFLICT DO NOTHING` 신규 데이터 집계 누락 | `main.rs:228` |

---

## MEDIUM (9건)

| # | 항목 |
|---|------|
| M-1 | Access log 단일 INSERT -> 배치 고려 |
| M-2 | `AppColors.lerp` 불필요한 타입 체크 |
| M-3 | `find_referrer_by_code` 형식 검증 (GAP- 접두사) |
| M-4 | `daily_checkin` caps INSERT ON CONFLICT 미사용 |
| M-5 | Flutter `PointHistoryItem.fromJson` null 안전성 |
| M-6 | `notification.body` nullable 하위 호환성 |
| M-7 | `verify_social_token` 결정론적 에러 재시도 |
| M-8 | 신규유저 월한도 확률 94%/6% 설계 근거 명시 |
| M-9 | `daily_checkins.reward_amount` CHECK 0~4 과잉 |
