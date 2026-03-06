-- point_transactions 커서 페이지네이션 최적화
-- 쿼리: WHERE user_id = $1 AND id < $2 ORDER BY id DESC LIMIT $3
-- 기존 인덱스 (user_id, created_at DESC)는 id 기반 커서에 비효율
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_point_transactions_user_cursor
    ON point_transactions (user_id, id DESC);
