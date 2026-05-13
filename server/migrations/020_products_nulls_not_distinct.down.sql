-- 020 rollback: NULLS NOT DISTINCT 제약 제거 후 기존 UNIQUE 복원
ALTER TABLE products
    DROP CONSTRAINT IF EXISTS products_uq_mall_external_vendor;

ALTER TABLE products
    ADD CONSTRAINT products_shopping_mall_id_external_product_id_vendor_item_id_key
    UNIQUE (shopping_mall_id, external_product_id, vendor_item_id);
