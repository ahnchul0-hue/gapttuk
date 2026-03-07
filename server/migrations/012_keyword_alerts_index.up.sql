-- keyword_alerts.user_id 인덱스 추가 (사용자별 알림 조회 성능 개선).
CREATE INDEX IF NOT EXISTS idx_keyword_alerts_user ON keyword_alerts (user_id);
