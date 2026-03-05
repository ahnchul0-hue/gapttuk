# 보상 체계 v0.8 구현 설계

> 승인일: 2026-03-06
> 근거 문서: prd.md v0.8, schema-design.md v0.8, plan.md v0.8

## 범위

M5의 핵심 3가지를 현 시점(STEP 49-53)에서 구현한다.

| 포함 | 제외 (추후) |
|------|------------|
| 포인트 잔액 관리 | 기프티콘 교환 (공급업체 API 필요) |
| 일일 출석 룰렛 + 월한도 | 이벤트/퀴즈 룰렛 (이벤트 시스템 필요) |
| 추천 단계별 보상 (Stage 0~2) | roulette_results 테이블 (daily_checkins로 충분) |
| Flutter UI (룰렛/잔액/내역) | |

## STEP 분할

### STEP 49: Migration 013 — 스키마 v0.8

```sql
-- referrals: BOOLEAN 2개 -> reward_stage SMALLINT
ALTER TABLE referrals DROP COLUMN referrer_rewarded;
ALTER TABLE referrals DROP COLUMN referred_rewarded;
ALTER TABLE referrals ADD COLUMN reward_stage SMALLINT NOT NULL DEFAULT 0;
ALTER TABLE referrals ADD CONSTRAINT chk_referrals_reward_stage
  CHECK (reward_stage BETWEEN 0 AND 2);

-- daily_checkins: streak_count/roulette_earned -> reward_amount
ALTER TABLE daily_checkins DROP COLUMN streak_count;
ALTER TABLE daily_checkins DROP COLUMN roulette_earned;
ALTER TABLE daily_checkins ADD COLUMN reward_amount SMALLINT NOT NULL DEFAULT 0;
ALTER TABLE daily_checkins DROP CONSTRAINT IF EXISTS chk_daily_checkins_streak;
ALTER TABLE daily_checkins ADD CONSTRAINT chk_daily_checkins_reward
  CHECK (reward_amount BETWEEN 0 AND 1);

-- user_monthly_checkin_caps (신규)
CREATE TABLE user_monthly_checkin_caps (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id       BIGINT NOT NULL REFERENCES users(id),
    year_month    TEXT NOT NULL,
    monthly_cap   SMALLINT NOT NULL,
    earned_so_far SMALLINT NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, year_month),
    CONSTRAINT chk_monthly_cap_range CHECK (monthly_cap BETWEEN 1 AND 4),
    CONSTRAINT chk_earned_range CHECK (earned_so_far BETWEEN 0 AND monthly_cap)
);
CREATE INDEX idx_monthly_caps_user ON user_monthly_checkin_caps(user_id, year_month);
```

down.sql: 역방향 복원 (reward_stage 제거, BOOLEAN 2개 복구, 테이블 DROP 등).

### STEP 50: Rust 모델 + PointService

**모델 파일:**
- `models/referral.rs` — Referral { id, referrer_id, referred_id, referral_code, reward_stage, created_at }
- `models/point.rs` — UserPoints, PointTransaction, TransactionType enum
- `models/checkin.rs` — DailyCheckin, UserMonthlyCheckinCap

**TransactionType enum 값:**
- daily_checkin, referral_welcome, referral_purchase_referred, referral_purchase_referrer
- signup_bonus, roulette_event, gifticon_exchange, ad_removal, admin_adjustment

**PointService** (`services/point_service.rs`):
- `get_balance(pool, user_id) -> UserPoints`
- `get_history(pool, user_id, pagination) -> PaginatedResponse<PointTransaction>`
- `add_points(tx, user_id, amount, tx_type, ref_id?, description?) -> PointTransaction`
  - 하나의 DB 트랜잭션에서: user_points UPDATE (balance, total_earned) + point_transactions INSERT

### STEP 51: CheckinService + API

**CheckinService** (`services/checkin_service.rs`):
- `daily_checkin(pool, user_id) -> CheckinResult`
  1. 중복 체크 (오늘 이미 출석?)
  2. 월한도 조회/lazy 생성 (assign_monthly_cap)
  3. earned_so_far < monthly_cap -> 1c 당첨, else 0c
  4. 트랜잭션: daily_checkins INSERT + caps UPDATE + point_service.add_points (당첨 시)
- `get_status(pool, user_id) -> CheckinStatus`
  - today_checked: bool, month_checkin_count: i32

**assign_monthly_cap 확률:**
- 기존 유저: 1c=90%, 2c=6%, 3c=3%, 4c=1%
- 신규 유저 (가입 30일 이내): 1c=94%, 2c=6% (1~2c만)

**API 엔드포인트:**
- POST /api/v1/checkin -> CheckinResult
- GET /api/v1/checkin/status -> CheckinStatus

### STEP 52: 추천 보상 강화

**auth_service.rs 확장:**
- upsert_user 내 추천 코드 가입 시: referrals INSERT + point_service.add_points(1c, referral_welcome)
- `advance_referral_stage(pool, referred_user_id, new_stage)` 함수 추가
  - Stage 0->1: 피초대자 +1c (referral_purchase_referred), 초대자 +2c (referral_purchase_referrer)
  - Stage 1->2: 피초대자 +1c, 초대자 +3c
  - referrals.reward_stage UPDATE + point_service.add_points 2회

**API 엔드포인트:**
- GET /api/v1/rewards/balance -> UserPoints
- GET /api/v1/rewards/history -> PaginatedResponse<PointTransaction>

### STEP 53: Flutter UI

**서비스:**
- `CheckinService` (Dart): dailyCheckin(), getStatus()
- `RewardService` (Dart): getBalance(), getHistory()

**화면:**
- 홈 화면에 출석 체크 버튼 + 간단한 룰렛 애니메이션 (0c/1c)
- 마이페이지에 센트 잔액 카드
- 포인트 내역 화면 (커서 페이지네이션)

**Provider:**
- checkinStatusProvider, rewardBalanceProvider, pointHistoryProvider

## 테스트 계획

| STEP | 테스트 |
|------|--------|
| 50 | point_service 유닛 5건+ (add_points, get_balance 경계값) |
| 51 | checkin_service 유닛 8건+ (중복방지, 월한도 초과, 신규유저, 확률분포) |
| 52 | referral reward 유닛 5건+ (Stage 0/1/2 전환, 중복방지) |
| 53 | Flutter 서비스 모킹 5건+ |
