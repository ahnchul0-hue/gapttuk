-- migration 005: user_points 잔액 음수 방어 CHECK 추가
ALTER TABLE user_points
    ADD CONSTRAINT chk_user_points_balance CHECK (balance >= 0);
