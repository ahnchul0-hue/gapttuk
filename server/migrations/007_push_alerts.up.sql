-- M1-8: 푸시 알림 스키마 보완
-- category_alerts / keyword_alerts에 last_triggered_at 컬럼 추가
-- user_devices에 (user_id, device_token) UNIQUE 제약조건 + 활성 디바이스 인덱스

ALTER TABLE category_alerts ADD COLUMN last_triggered_at TIMESTAMPTZ;
ALTER TABLE keyword_alerts  ADD COLUMN last_triggered_at TIMESTAMPTZ;

ALTER TABLE user_devices
    ADD CONSTRAINT uq_user_devices_token UNIQUE (user_id, device_token);

CREATE INDEX idx_user_devices_user
    ON user_devices (user_id) WHERE push_enabled = TRUE;
