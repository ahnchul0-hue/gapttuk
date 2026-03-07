-- migration 014 rollback

DROP INDEX IF EXISTS idx_users_referral_code;

ALTER TABLE daily_checkins DROP CONSTRAINT IF EXISTS chk_daily_checkin_reward;
ALTER TABLE daily_checkins
    ADD CONSTRAINT chk_daily_checkin_reward
    CHECK (reward_amount IN (0, 1));
