-- 010_seed_shopping_malls rollback
DELETE FROM shopping_malls WHERE code IN ('gmarket', 'auction', '11st', 'tmon', 'wemakeprice', 'ssg');
