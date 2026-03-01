-- 003: 스키마 보강 — CHECK 제약조건 + 누락 인덱스 + users.point_balance 이중 저장 해소
-- 전수 검토 결과 반영 (47건 이슈 중 스키마 관련)

------------------------------------------------------------
-- 1. CHECK 제약조건 추가 (11건)
------------------------------------------------------------

-- products: 가격 >= 0
ALTER TABLE products
    ADD CONSTRAINT chk_products_current_price CHECK (current_price >= 0),
    ADD CONSTRAINT chk_products_lowest_price CHECK (lowest_price >= 0),
    ADD CONSTRAINT chk_products_highest_price CHECK (highest_price >= 0),
    ADD CONSTRAINT chk_products_average_price CHECK (average_price >= 0);

-- products: buy_timing_score 0~100
ALTER TABLE products
    ADD CONSTRAINT chk_products_buy_timing_score CHECK (buy_timing_score BETWEEN 0 AND 100);

-- ai_predictions: confidence 0.00~1.00
ALTER TABLE ai_predictions
    ADD CONSTRAINT chk_ai_predictions_confidence CHECK (confidence BETWEEN 0.00 AND 1.00);

-- events: starts_at < ends_at
ALTER TABLE events
    ADD CONSTRAINT chk_events_date_range CHECK (starts_at < ends_at);

-- card_discounts: valid_from <= valid_until (둘 다 NULL이면 OK)
ALTER TABLE card_discounts
    ADD CONSTRAINT chk_card_discounts_date_range
    CHECK (valid_from IS NULL OR valid_until IS NULL OR valid_from <= valid_until);

-- card_discounts: discount_value > 0
ALTER TABLE card_discounts
    ADD CONSTRAINT chk_card_discounts_discount_value CHECK (discount_value > 0);

-- daily_checkins: streak_count >= 1
ALTER TABLE daily_checkins
    ADD CONSTRAINT chk_daily_checkins_streak CHECK (streak_count >= 1);

-- price_history: price >= 0
ALTER TABLE price_history
    ADD CONSTRAINT chk_price_history_price CHECK (price >= 0);

------------------------------------------------------------
-- 2. 누락 인덱스 추가 (5건)
------------------------------------------------------------

-- "내 알림 목록" — category_alerts를 user_id로 조회
CREATE INDEX idx_category_alerts_user ON category_alerts (user_id);

-- "참여 이벤트" — event_participations를 user_id로 조회
CREATE INDEX idx_event_participations_user ON event_participations (user_id);

-- 하위 카테고리 조회 — categories의 parent_id 탐색
CREATE INDEX idx_categories_parent ON categories (parent_id);

-- "내 가격 알림" — 활성 알림만 user_id로 조회
CREATE INDEX idx_price_alerts_user_active ON price_alerts (user_id) WHERE is_active = TRUE;

-- soft delete 필터 — 활성 사용자 빠른 조회
CREATE INDEX idx_users_active ON users (id) WHERE deleted_at IS NULL;

------------------------------------------------------------
-- 3. users.point_balance 이중 저장 해소
--    users 테이블에 point_balance 컬럼이 없으므로 (v0.5에서 설계 시 제거)
--    추가 DDL 불필요. user_points.balance가 SSOT.
------------------------------------------------------------
-- (no-op: users.point_balance 컬럼은 001_initial_schema에서 이미 미생성)
