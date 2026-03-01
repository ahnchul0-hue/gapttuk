-- 001_initial_schema.sql 롤백 (생성 역순 DROP)

-- self-referencing FK 제거
ALTER TABLE categories DROP CONSTRAINT IF EXISTS fk_categories_parent;
ALTER TABLE users DROP CONSTRAINT IF EXISTS fk_users_referred_by;

-- 5단계
DROP TABLE IF EXISTS event_participations;

-- 4단계
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS keyword_alerts;
DROP TABLE IF EXISTS category_alerts;
DROP TABLE IF EXISTS price_alerts;

-- 3단계
DROP TABLE IF EXISTS user_favorites;
DROP TABLE IF EXISTS card_discounts;
DROP TABLE IF EXISTS ai_predictions;
DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS products;

-- 2단계
DROP TABLE IF EXISTS api_access_logs;
DROP TABLE IF EXISTS point_transactions;
DROP TABLE IF EXISTS roulette_results;
DROP TABLE IF EXISTS daily_checkins;
DROP TABLE IF EXISTS referrals;
DROP TABLE IF EXISTS user_points;
DROP TABLE IF EXISTS user_devices;
DROP TABLE IF EXISTS users;

-- 1단계
DROP TABLE IF EXISTS blocked_ips;
DROP TABLE IF EXISTS popular_searches;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS shopping_malls;
