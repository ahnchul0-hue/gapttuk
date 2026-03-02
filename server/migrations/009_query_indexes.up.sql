-- 009: 쿼리 최적화 인덱스

-- ① price_alerts — user_id 전체(비부분) 인덱스 + created_at 정렬
-- COUNT(*) WHERE user_id = $1 (알림 개수 제한) + SELECT * ORDER BY created_at DESC
-- 기존 idx_price_alerts_user_active는 부분 인덱스(is_active=TRUE)이므로 이 쿼리에 사용 불가
CREATE INDEX idx_price_alerts_user ON price_alerts (user_id, created_at DESC);
