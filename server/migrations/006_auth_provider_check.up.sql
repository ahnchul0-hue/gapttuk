-- 006: auth_provider 열거값 CHECK 제약조건
ALTER TABLE users
    ADD CONSTRAINT chk_users_auth_provider
    CHECK (auth_provider IN ('kakao', 'google', 'apple', 'naver'));
