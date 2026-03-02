-- 006 down: auth_provider CHECK 제약조건 제거
ALTER TABLE users
    DROP CONSTRAINT IF EXISTS chk_users_auth_provider;
