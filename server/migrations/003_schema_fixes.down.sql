-- 003_schema_fixes 롤백

------------------------------------------------------------
-- 3. users.point_balance — 복원 불필요 (no-op)
------------------------------------------------------------

------------------------------------------------------------
-- 2. 인덱스 제거
------------------------------------------------------------
DROP INDEX IF EXISTS idx_users_active;
DROP INDEX IF EXISTS idx_price_alerts_user_active;
DROP INDEX IF EXISTS idx_categories_parent;
DROP INDEX IF EXISTS idx_event_participations_user;
DROP INDEX IF EXISTS idx_category_alerts_user;

------------------------------------------------------------
-- 1. CHECK 제약조건 제거
------------------------------------------------------------
ALTER TABLE price_history DROP CONSTRAINT IF EXISTS chk_price_history_price;
ALTER TABLE daily_checkins DROP CONSTRAINT IF EXISTS chk_daily_checkins_streak;
ALTER TABLE card_discounts DROP CONSTRAINT IF EXISTS chk_card_discounts_discount_value;
ALTER TABLE card_discounts DROP CONSTRAINT IF EXISTS chk_card_discounts_date_range;
ALTER TABLE events DROP CONSTRAINT IF EXISTS chk_events_date_range;
ALTER TABLE ai_predictions DROP CONSTRAINT IF EXISTS chk_ai_predictions_confidence;
ALTER TABLE products DROP CONSTRAINT IF EXISTS chk_products_buy_timing_score;
ALTER TABLE products DROP CONSTRAINT IF EXISTS chk_products_average_price;
ALTER TABLE products DROP CONSTRAINT IF EXISTS chk_products_highest_price;
ALTER TABLE products DROP CONSTRAINT IF EXISTS chk_products_lowest_price;
ALTER TABLE products DROP CONSTRAINT IF EXISTS chk_products_current_price;
