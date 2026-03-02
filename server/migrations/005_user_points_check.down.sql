-- 005 rollback
ALTER TABLE user_points DROP CONSTRAINT IF EXISTS chk_user_points_balance;
