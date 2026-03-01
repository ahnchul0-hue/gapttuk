-- migration 004: categories 테이블 누락 컬럼 추가
-- schema-design.md §2-22에 명시된 depth, created_at 컬럼이 migration 001에서 누락됨

ALTER TABLE categories ADD COLUMN depth SMALLINT NOT NULL DEFAULT 0;
ALTER TABLE categories ADD COLUMN created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
