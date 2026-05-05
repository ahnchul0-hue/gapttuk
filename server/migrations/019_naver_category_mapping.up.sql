-- Migration 019: Naver 쇼핑 카테고리 매핑 테이블
-- 값뚝 내부 카테고리 ↔ 네이버 쇼핑 카테고리 코드 매핑
-- 2026-05-04 NaverSearch MCP find_category 실측 결과 기반

CREATE TABLE naver_category_mapping (
    id             SERIAL PRIMARY KEY,
    -- 내부 식별자 ('household', 'food', 'electronics')
    internal_key   TEXT        NOT NULL,
    -- 네이버 쇼핑 카테고리 코드 (find_category 반환값)
    naver_code     TEXT        NOT NULL,
    -- 네이버 카테고리 전체 경로 (레퍼런스용)
    naver_name     TEXT        NOT NULL,
    is_active      BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_naver_category_mapping UNIQUE (internal_key, naver_code)
);

COMMENT ON TABLE naver_category_mapping IS
    '값뚝 카테고리 ↔ 네이버 쇼핑 카테고리 코드 매핑 (Datalab API 파라미터용)';
COMMENT ON COLUMN naver_category_mapping.internal_key IS
    '내부 카테고리 식별자: household/food/electronics';
COMMENT ON COLUMN naver_category_mapping.naver_code IS
    '네이버 쇼핑 카테고리 코드 (예: 50000151)';

-- 초기 데이터 — 2026-05-04 find_category 실측
INSERT INTO naver_category_mapping (internal_key, naver_code, naver_name) VALUES
    ('household', '50001780', '생활/건강 > 생활용품 > 생활선물세트'),
    ('food',      '50000215', '식품 > 축산물 > 기타육류'),
    ('electronics', '50000151', '디지털/가전 > 노트북');

CREATE INDEX idx_naver_category_mapping_key
    ON naver_category_mapping (internal_key)
    WHERE is_active = TRUE;
