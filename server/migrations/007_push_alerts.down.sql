-- M1-8 rollback
DROP INDEX IF EXISTS idx_user_devices_user;
ALTER TABLE user_devices DROP CONSTRAINT IF EXISTS uq_user_devices_token;
ALTER TABLE keyword_alerts  DROP COLUMN IF EXISTS last_triggered_at;
ALTER TABLE category_alerts DROP COLUMN IF EXISTS last_triggered_at;
