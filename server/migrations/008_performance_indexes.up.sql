-- 008: 성능 인덱스 + pg_trgm + 토큰 정리용 인덱스

-- ① pg_trgm 확장 + 상품명 ILIKE 검색용 GIN 인덱스
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_products_name_trgm ON products USING GIN (product_name gin_trgm_ops);

-- ② 알림 목록 커서 기반 페이지네이션용 복합 인덱스
CREATE INDEX idx_notifications_user_cursor ON notifications (user_id, id DESC);

-- ③ 만료/폐기 refresh_tokens 정리용 부분 인덱스
CREATE INDEX idx_refresh_tokens_expired ON refresh_tokens (expires_at)
    WHERE revoked_at IS NULL;
