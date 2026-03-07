-- 017: price_history 2년 보존 정책 — 월별 집계 테이블
-- 2년 초과 price_history 파티션을 집계 후 DROP할 때 데이터를 보존하는 아카이브 테이블.
-- UNIQUE (product_id, year_month) + ON CONFLICT DO NOTHING으로 멱등 집계 보장.
CREATE TABLE price_history_monthly (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id   BIGINT NOT NULL REFERENCES products(id),
    year_month   DATE NOT NULL,
    avg_price    INTEGER NOT NULL,
    min_price    INTEGER NOT NULL,
    max_price    INTEGER NOT NULL,
    first_price  INTEGER NOT NULL,
    last_price   INTEGER NOT NULL,
    record_count INTEGER NOT NULL CHECK (record_count > 0),
    had_stockout BOOLEAN NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (product_id, year_month)
);

CREATE INDEX idx_phm_product_month
    ON price_history_monthly (product_id, year_month DESC);
