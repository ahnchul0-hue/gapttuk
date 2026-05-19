-- products vendor_item_id NULL 포함 UNIQUE — NULLS NOT DISTINCT 적용 (PostgreSQL 15+)
-- vendor_item_id가 NULL인 동일 (mall, external_id) 조합의 중복 삽입 방지
ALTER TABLE products
    DROP CONSTRAINT IF EXISTS products_shopping_mall_id_external_product_id_vendor_item_id_key;

ALTER TABLE products
    ADD CONSTRAINT products_uq_mall_external_vendor
    UNIQUE NULLS NOT DISTINCT (shopping_mall_id, external_product_id, vendor_item_id);
