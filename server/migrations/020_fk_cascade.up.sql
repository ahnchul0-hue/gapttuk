-- 020: ON DELETE CASCADE 추가 — 모든 FK 제약조건에 cascade 적용
-- 사용자/상품 삭제 시 관련 레코드 자동 정리
-- NOTE: api_access_logs, price_history는 파티셔닝 테이블이라 FK 없음 (app-level 관리)

BEGIN;

------------------------------------------------------------
-- 1. users(id) 참조 FK (15건)
------------------------------------------------------------

-- user_devices.user_id → users(id)
ALTER TABLE user_devices DROP CONSTRAINT IF EXISTS user_devices_user_id_fkey;
ALTER TABLE user_devices ADD CONSTRAINT user_devices_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- user_points.user_id → users(id)
ALTER TABLE user_points DROP CONSTRAINT IF EXISTS user_points_user_id_fkey;
ALTER TABLE user_points ADD CONSTRAINT user_points_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- referrals.referrer_id → users(id)
ALTER TABLE referrals DROP CONSTRAINT IF EXISTS referrals_referrer_id_fkey;
ALTER TABLE referrals ADD CONSTRAINT referrals_referrer_id_fkey
  FOREIGN KEY (referrer_id) REFERENCES users(id) ON DELETE CASCADE;

-- referrals.referred_id → users(id)
ALTER TABLE referrals DROP CONSTRAINT IF EXISTS referrals_referred_id_fkey;
ALTER TABLE referrals ADD CONSTRAINT referrals_referred_id_fkey
  FOREIGN KEY (referred_id) REFERENCES users(id) ON DELETE CASCADE;

-- daily_checkins.user_id → users(id)
ALTER TABLE daily_checkins DROP CONSTRAINT IF EXISTS daily_checkins_user_id_fkey;
ALTER TABLE daily_checkins ADD CONSTRAINT daily_checkins_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- roulette_results.user_id → users(id)
ALTER TABLE roulette_results DROP CONSTRAINT IF EXISTS roulette_results_user_id_fkey;
ALTER TABLE roulette_results ADD CONSTRAINT roulette_results_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- point_transactions.user_id → users(id)
ALTER TABLE point_transactions DROP CONSTRAINT IF EXISTS point_transactions_user_id_fkey;
ALTER TABLE point_transactions ADD CONSTRAINT point_transactions_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- user_favorites.user_id → users(id)
ALTER TABLE user_favorites DROP CONSTRAINT IF EXISTS user_favorites_user_id_fkey;
ALTER TABLE user_favorites ADD CONSTRAINT user_favorites_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- price_alerts.user_id → users(id)
ALTER TABLE price_alerts DROP CONSTRAINT IF EXISTS price_alerts_user_id_fkey;
ALTER TABLE price_alerts ADD CONSTRAINT price_alerts_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- category_alerts.user_id → users(id)
ALTER TABLE category_alerts DROP CONSTRAINT IF EXISTS category_alerts_user_id_fkey;
ALTER TABLE category_alerts ADD CONSTRAINT category_alerts_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- keyword_alerts.user_id → users(id)
ALTER TABLE keyword_alerts DROP CONSTRAINT IF EXISTS keyword_alerts_user_id_fkey;
ALTER TABLE keyword_alerts ADD CONSTRAINT keyword_alerts_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- notifications.user_id → users(id)
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_user_id_fkey;
ALTER TABLE notifications ADD CONSTRAINT notifications_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- event_participations.user_id → users(id)
ALTER TABLE event_participations DROP CONSTRAINT IF EXISTS event_participations_user_id_fkey;
ALTER TABLE event_participations ADD CONSTRAINT event_participations_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- refresh_tokens.user_id → users(id)
ALTER TABLE refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_user_id_fkey;
ALTER TABLE refresh_tokens ADD CONSTRAINT refresh_tokens_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- user_monthly_checkin_caps.user_id → users(id) (migration 013)
ALTER TABLE user_monthly_checkin_caps DROP CONSTRAINT IF EXISTS user_monthly_checkin_caps_user_id_fkey;
ALTER TABLE user_monthly_checkin_caps ADD CONSTRAINT user_monthly_checkin_caps_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

------------------------------------------------------------
-- 2. users 자기참조 FK (1건)
------------------------------------------------------------

-- users.referred_by → users(id) (명시적 이름: fk_users_referred_by)
ALTER TABLE users DROP CONSTRAINT IF EXISTS fk_users_referred_by;
ALTER TABLE users ADD CONSTRAINT fk_users_referred_by
  FOREIGN KEY (referred_by) REFERENCES users(id) ON DELETE SET NULL;

------------------------------------------------------------
-- 3. products(id) 참조 FK (5건)
------------------------------------------------------------

-- ai_predictions.product_id → products(id)
ALTER TABLE ai_predictions DROP CONSTRAINT IF EXISTS ai_predictions_product_id_fkey;
ALTER TABLE ai_predictions ADD CONSTRAINT ai_predictions_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- card_discounts.product_id → products(id)
ALTER TABLE card_discounts DROP CONSTRAINT IF EXISTS card_discounts_product_id_fkey;
ALTER TABLE card_discounts ADD CONSTRAINT card_discounts_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- user_favorites.product_id → products(id)
ALTER TABLE user_favorites DROP CONSTRAINT IF EXISTS user_favorites_product_id_fkey;
ALTER TABLE user_favorites ADD CONSTRAINT user_favorites_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- price_alerts.product_id → products(id)
ALTER TABLE price_alerts DROP CONSTRAINT IF EXISTS price_alerts_product_id_fkey;
ALTER TABLE price_alerts ADD CONSTRAINT price_alerts_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- price_history_monthly.product_id → products(id) (migration 017)
ALTER TABLE price_history_monthly DROP CONSTRAINT IF EXISTS price_history_monthly_product_id_fkey;
ALTER TABLE price_history_monthly ADD CONSTRAINT price_history_monthly_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

------------------------------------------------------------
-- 4. shopping_malls(id) 참조 FK (1건)
------------------------------------------------------------

-- products.shopping_mall_id → shopping_malls(id)
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_shopping_mall_id_fkey;
ALTER TABLE products ADD CONSTRAINT products_shopping_mall_id_fkey
  FOREIGN KEY (shopping_mall_id) REFERENCES shopping_malls(id) ON DELETE CASCADE;

------------------------------------------------------------
-- 5. categories(id) 참조 FK (4건)
------------------------------------------------------------

-- categories.parent_id → categories(id) (명시적 이름: fk_categories_parent)
ALTER TABLE categories DROP CONSTRAINT IF EXISTS fk_categories_parent;
ALTER TABLE categories ADD CONSTRAINT fk_categories_parent
  FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL;

-- products.category_id → categories(id)
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE products ADD CONSTRAINT products_category_id_fkey
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

-- category_alerts.category_id → categories(id)
ALTER TABLE category_alerts DROP CONSTRAINT IF EXISTS category_alerts_category_id_fkey;
ALTER TABLE category_alerts ADD CONSTRAINT category_alerts_category_id_fkey
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;

-- keyword_alerts.category_id → categories(id)
ALTER TABLE keyword_alerts DROP CONSTRAINT IF EXISTS keyword_alerts_category_id_fkey;
ALTER TABLE keyword_alerts ADD CONSTRAINT keyword_alerts_category_id_fkey
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

------------------------------------------------------------
-- 6. events(id) 참조 FK (1건)
------------------------------------------------------------

-- event_participations.event_id → events(id)
ALTER TABLE event_participations DROP CONSTRAINT IF EXISTS event_participations_event_id_fkey;
ALTER TABLE event_participations ADD CONSTRAINT event_participations_event_id_fkey
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE;

COMMIT;
