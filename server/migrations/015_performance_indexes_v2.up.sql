-- H-1: price_alerts 복합 인덱스 (크롤링 시 알림 평가 최적화)
CREATE INDEX IF NOT EXISTS idx_price_alerts_active_trigger
    ON price_alerts (product_id, is_active, last_triggered_at)
    WHERE is_active = TRUE;

-- H-2: user_devices 부분 인덱스 (푸시 발송 시 활성 디바이스 조회)
CREATE INDEX IF NOT EXISTS idx_user_devices_push_active
    ON user_devices (user_id, push_enabled)
    WHERE push_enabled = TRUE;
