-- TTL 클린업용 인덱스 — 오래된 레코드 효율적 삭제 지원
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications (sent_at);
CREATE INDEX IF NOT EXISTS idx_roulette_results_created_at ON roulette_results (created_at);
CREATE INDEX IF NOT EXISTS idx_point_transactions_created_at ON point_transactions (created_at);
