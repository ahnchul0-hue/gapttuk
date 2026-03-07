-- migration 013: 보상 체계 v0.8 — referrals/daily_checkins 스키마 개정 + user_monthly_checkin_caps 신규
-- v0.7 → v0.8: 추천 단계별 구매 기반 보상, 일일 룰렛 모델

------------------------------------------------------------
-- 1. referrals 테이블 v0.8 개정
--    referrer_rewarded/referred_rewarded BOOLEAN 2개 제거
--    reward_stage SMALLINT(0~2) 단일 진행 상태로 교체
------------------------------------------------------------

ALTER TABLE referrals DROP COLUMN IF EXISTS referrer_rewarded;
ALTER TABLE referrals DROP COLUMN IF EXISTS referred_rewarded;

ALTER TABLE referrals
    ADD COLUMN reward_stage SMALLINT NOT NULL DEFAULT 0;

ALTER TABLE referrals
    ADD CONSTRAINT chk_referrals_reward_stage
    CHECK (reward_stage BETWEEN 0 AND 2);

------------------------------------------------------------
-- 2. daily_checkins 테이블 v0.8 개정
--    streak_count/roulette_earned 제거 → reward_amount 추가
------------------------------------------------------------

ALTER TABLE daily_checkins DROP COLUMN IF EXISTS streak_count;
ALTER TABLE daily_checkins DROP COLUMN IF EXISTS roulette_earned;

ALTER TABLE daily_checkins
    ADD COLUMN reward_amount SMALLINT NOT NULL DEFAULT 0;

ALTER TABLE daily_checkins
    ADD CONSTRAINT chk_daily_checkin_reward
    CHECK (reward_amount IN (0, 1));

------------------------------------------------------------
-- 3. user_monthly_checkin_caps 테이블 신규
--    유저별 숨겨진 월별 출석 한도 (1~4¢)
------------------------------------------------------------

CREATE TABLE user_monthly_checkin_caps (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        BIGINT NOT NULL REFERENCES users(id),
    year_month     TEXT NOT NULL,
    monthly_cap    SMALLINT NOT NULL,
    earned_so_far  SMALLINT NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, year_month)
);

ALTER TABLE user_monthly_checkin_caps
    ADD CONSTRAINT chk_monthly_cap_range
    CHECK (monthly_cap BETWEEN 1 AND 4);

ALTER TABLE user_monthly_checkin_caps
    ADD CONSTRAINT chk_earned_range
    CHECK (earned_so_far >= 0 AND earned_so_far <= monthly_cap);

CREATE INDEX idx_monthly_caps_user_month
    ON user_monthly_checkin_caps (user_id, year_month);
