-- migration 004 rollback
ALTER TABLE categories DROP COLUMN IF EXISTS created_at;
ALTER TABLE categories DROP COLUMN IF EXISTS depth;
