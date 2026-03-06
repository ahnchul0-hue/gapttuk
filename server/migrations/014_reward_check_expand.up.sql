-- migration 014: 보상 CHECK 제약 확장 + 데이터 무결성 보강
--
-- 1. daily_checkins.reward_amount: IN (0, 1) → BETWEEN 0 AND 4
--    이벤트 룰렛(0~2¢) 및 향후 보상 확장 대비
-- 2. referrals.reward_stage 기존 데이터 마이그레이션 가이드 주석
--    (프로덕션 데이터가 있을 경우 013 적용 전 아래 쿼리 선행 실행 필요)
--
-- NOTE: 프로덕션 배포 시 013 마이그레이션 전에 다음을 실행해야 합니다:
--   UPDATE referrals SET reward_stage = CASE
--     WHEN referrer_rewarded AND referred_rewarded THEN 2
--     WHEN referrer_rewarded OR referred_rewarded THEN 1
--     ELSE 0
--   END;
------------------------------------------------------------

-- 1. daily_checkins CHECK 확장: IN (0, 1) → BETWEEN 0 AND 4
ALTER TABLE daily_checkins DROP CONSTRAINT IF EXISTS chk_daily_checkin_reward;
ALTER TABLE daily_checkins
    ADD CONSTRAINT chk_daily_checkin_reward
    CHECK (reward_amount BETWEEN 0 AND 4);

-- 2. referral_code 고유성 인덱스 (추천 코드 충돌 방지 강화)
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_referral_code
    ON users (referral_code)
    WHERE referral_code IS NOT NULL AND deleted_at IS NULL;
