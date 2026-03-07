-- migration 013 rollback

DROP TABLE IF EXISTS user_monthly_checkin_caps;

ALTER TABLE daily_checkins DROP CONSTRAINT IF EXISTS chk_daily_checkin_reward;
ALTER TABLE daily_checkins DROP COLUMN IF EXISTS reward_amount;
ALTER TABLE daily_checkins ADD COLUMN IF NOT EXISTS streak_count INTEGER NOT NULL DEFAULT 1;
ALTER TABLE daily_checkins ADD COLUMN IF NOT EXISTS roulette_earned BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE referrals DROP CONSTRAINT IF EXISTS chk_referrals_reward_stage;
ALTER TABLE referrals DROP COLUMN IF EXISTS reward_stage;
ALTER TABLE referrals ADD COLUMN IF NOT EXISTS referrer_rewarded BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE referrals ADD COLUMN IF NOT EXISTS referred_rewarded BOOLEAN NOT NULL DEFAULT FALSE;
