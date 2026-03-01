-- 002_seed_data.sql 롤백
-- CASCADE: products 등 FK 참조 테이블이 존재할 경우에도 안전하게 삭제

TRUNCATE categories, shopping_malls CASCADE;
