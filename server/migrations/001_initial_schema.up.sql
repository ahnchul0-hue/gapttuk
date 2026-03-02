-- 값뚝 초기 스키마: 24개 테이블 + 23개 인덱스 + 파티셔닝
-- FK 의존성 순서에 따라 생성

------------------------------------------------------------
-- 1단계: 독립 테이블 (FK 없음)
------------------------------------------------------------

-- ① shopping_malls
CREATE TABLE shopping_malls (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT NOT NULL,
    code        TEXT UNIQUE NOT NULL,
    base_url    TEXT NOT NULL,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ② categories (parent_id FK는 후처리)
CREATE TABLE categories (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT NOT NULL,
    slug        TEXT UNIQUE NOT NULL,
    parent_id   INTEGER,
    sort_order  INTEGER NOT NULL DEFAULT 0
);

-- ③ events
CREATE TABLE events (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title             TEXT NOT NULL,
    description       TEXT,
    event_type        TEXT NOT NULL,
    reward_points     INTEGER NOT NULL DEFAULT 0,
    max_participants  INTEGER,
    quiz_data         JSONB,
    starts_at         TIMESTAMPTZ NOT NULL,
    ends_at           TIMESTAMPTZ NOT NULL,
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ④ popular_searches
CREATE TABLE popular_searches (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    keyword       TEXT NOT NULL,
    search_count  INTEGER NOT NULL DEFAULT 0,
    rank          SMALLINT NOT NULL,
    trend         TEXT,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑤ blocked_ips
CREATE TABLE blocked_ips (
    id             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ip_address     INET UNIQUE NOT NULL,
    reason         TEXT NOT NULL,
    blocked_until  TIMESTAMPTZ,
    hit_count      INTEGER NOT NULL DEFAULT 1,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

------------------------------------------------------------
-- 2단계: users + users 참조 테이블
------------------------------------------------------------

-- ⑥ users (referred_by FK는 후처리)
CREATE TABLE users (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email             TEXT UNIQUE NOT NULL,
    nickname          TEXT,
    auth_provider     TEXT NOT NULL,
    auth_provider_id  TEXT NOT NULL,
    profile_image_url TEXT,
    referral_code     TEXT UNIQUE NOT NULL,
    referred_by       BIGINT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at        TIMESTAMPTZ,
    UNIQUE (auth_provider, auth_provider_id)
);

-- ⑦ user_devices
CREATE TABLE user_devices (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id       BIGINT NOT NULL REFERENCES users(id),
    device_token  TEXT NOT NULL,
    platform      TEXT NOT NULL,
    push_enabled  BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑧ user_points
CREATE TABLE user_points (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id       BIGINT UNIQUE NOT NULL REFERENCES users(id),
    balance       INTEGER NOT NULL DEFAULT 0,
    total_earned  INTEGER NOT NULL DEFAULT 0,
    total_spent   INTEGER NOT NULL DEFAULT 0,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑨ referrals
CREATE TABLE referrals (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    referrer_id       BIGINT NOT NULL REFERENCES users(id),
    referred_id       BIGINT UNIQUE NOT NULL REFERENCES users(id),
    referral_code     TEXT NOT NULL,
    referrer_rewarded BOOLEAN NOT NULL DEFAULT FALSE,
    referred_rewarded BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑩ daily_checkins
CREATE TABLE daily_checkins (
    id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          BIGINT NOT NULL REFERENCES users(id),
    checkin_date     DATE NOT NULL,
    streak_count     INTEGER NOT NULL DEFAULT 1,
    roulette_earned  BOOLEAN NOT NULL DEFAULT FALSE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, checkin_date)
);

-- ⑪ roulette_results
CREATE TABLE roulette_results (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        BIGINT NOT NULL REFERENCES users(id),
    roulette_type  TEXT NOT NULL,
    reference_id   BIGINT,
    is_winner      BOOLEAN NOT NULL,
    reward_amount  INTEGER NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑫ point_transactions
CREATE TABLE point_transactions (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id           BIGINT NOT NULL REFERENCES users(id),
    amount            INTEGER NOT NULL,
    transaction_type  TEXT NOT NULL,
    reference_id      BIGINT,
    reference_type    TEXT,
    description       TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑬ api_access_logs (파티셔닝 — RANGE by created_at)
-- NOTE: user_id FK 미적용 — 파티셔닝 테이블의 FK는 app-level에서 관리 (schema-design.md §1 참조)
CREATE TABLE api_access_logs (
    id               BIGINT GENERATED ALWAYS AS IDENTITY,
    ip_address       INET NOT NULL,
    user_id          BIGINT,
    endpoint         TEXT NOT NULL,
    method           TEXT NOT NULL,
    status_code      SMALLINT NOT NULL,
    user_agent       TEXT,
    response_time_ms INTEGER,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- api_access_logs 초기 파티션 (현재 월 + 향후 3개월)
CREATE TABLE api_access_logs_202603 PARTITION OF api_access_logs
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE api_access_logs_202604 PARTITION OF api_access_logs
    FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');
CREATE TABLE api_access_logs_202605 PARTITION OF api_access_logs
    FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE api_access_logs_202606 PARTITION OF api_access_logs
    FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');

------------------------------------------------------------
-- 3단계: products + 관련 테이블
------------------------------------------------------------

-- ⑭ products
CREATE TABLE products (
    id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shopping_mall_id     INTEGER NOT NULL REFERENCES shopping_malls(id),
    category_id          INTEGER REFERENCES categories(id),
    external_product_id  TEXT NOT NULL,
    vendor_item_id       TEXT,
    product_name         TEXT NOT NULL,
    product_url          TEXT,
    image_url            TEXT,
    current_price        INTEGER,
    lowest_price         INTEGER,
    highest_price        INTEGER,
    average_price        INTEGER,
    unit_type            TEXT,
    unit_price           NUMERIC(12, 2),
    rating               NUMERIC(3, 1),
    review_count         INTEGER DEFAULT 0,
    is_out_of_stock      BOOLEAN NOT NULL DEFAULT FALSE,
    price_trend          TEXT,
    days_since_lowest    INTEGER,
    drop_from_average    INTEGER,
    buy_timing_score     SMALLINT,
    sales_velocity       NUMERIC(8, 2),
    first_tracked_at     TIMESTAMPTZ,
    price_updated_at     TIMESTAMPTZ,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (shopping_mall_id, external_product_id, vendor_item_id)
);

-- ⑮ price_history (파티셔닝 — RANGE by recorded_at)
-- NOTE: product_id FK 미적용 — 파티셔닝 테이블의 FK는 app-level에서 관리 (schema-design.md §1 참조)
CREATE TABLE price_history (
    id               BIGINT GENERATED ALWAYS AS IDENTITY,
    product_id       BIGINT NOT NULL,
    price            INTEGER NOT NULL,
    is_out_of_stock  BOOLEAN NOT NULL DEFAULT FALSE,
    recorded_at      TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);

-- price_history 초기 파티션
CREATE TABLE price_history_202603 PARTITION OF price_history
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE price_history_202604 PARTITION OF price_history
    FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');
CREATE TABLE price_history_202605 PARTITION OF price_history
    FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE price_history_202606 PARTITION OF price_history
    FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');

-- ⑯ ai_predictions
CREATE TABLE ai_predictions (
    id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id            BIGINT NOT NULL REFERENCES products(id),
    predicted_action      TEXT NOT NULL,
    confidence            NUMERIC(3, 2) NOT NULL,
    predicted_lowest_price INTEGER,
    predicted_lowest_date  DATE,
    price_at_prediction   INTEGER NOT NULL,
    factors               JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at            TIMESTAMPTZ NOT NULL
);

-- ⑰ card_discounts
CREATE TABLE card_discounts (
    id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id       BIGINT NOT NULL REFERENCES products(id),
    card_name        TEXT NOT NULL,
    card_type        TEXT NOT NULL,
    discount_type    TEXT NOT NULL,
    discount_value   INTEGER NOT NULL,
    discounted_price INTEGER,
    min_purchase     INTEGER,
    valid_from       DATE,
    valid_until      DATE,
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑱ user_favorites
CREATE TABLE user_favorites (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id),
    product_id  BIGINT NOT NULL REFERENCES products(id),
    memo        TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, product_id)
);

------------------------------------------------------------
-- 4단계: 알림 테이블
------------------------------------------------------------

-- ⑲ price_alerts
CREATE TABLE price_alerts (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id           BIGINT NOT NULL REFERENCES users(id),
    product_id        BIGINT NOT NULL REFERENCES products(id),
    alert_type        TEXT NOT NULL,
    target_price      INTEGER,
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,
    last_triggered_at TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ⑳ category_alerts
CREATE TABLE category_alerts (
    id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id            BIGINT NOT NULL REFERENCES users(id),
    category_id        INTEGER NOT NULL REFERENCES categories(id),
    alert_condition    TEXT NOT NULL,
    threshold_percent  INTEGER,
    max_price          INTEGER,
    is_active          BOOLEAN NOT NULL DEFAULT TRUE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ㉑ keyword_alerts
CREATE TABLE keyword_alerts (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id      BIGINT NOT NULL REFERENCES users(id),
    keyword      TEXT NOT NULL,
    category_id  INTEGER REFERENCES categories(id),
    max_price    INTEGER,
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ㉒ notifications
CREATE TABLE notifications (
    id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id            BIGINT NOT NULL REFERENCES users(id),
    notification_type  TEXT NOT NULL,
    reference_id       BIGINT,
    reference_type     TEXT,
    title              TEXT NOT NULL,
    body               TEXT,
    deep_link          TEXT,
    is_read            BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    read_at            TIMESTAMPTZ
);

------------------------------------------------------------
-- 5단계: 이벤트 참여
------------------------------------------------------------

-- ㉓ event_participations
CREATE TABLE event_participations (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id      BIGINT NOT NULL REFERENCES events(id),
    user_id       BIGINT NOT NULL REFERENCES users(id),
    answer        JSONB,
    is_correct    BOOLEAN,
    points_earned INTEGER NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (event_id, user_id)
);

------------------------------------------------------------
-- 6단계: 인증 (refresh tokens)
------------------------------------------------------------

-- ㉔ refresh_tokens
CREATE TABLE refresh_tokens (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id),
    token_hash  TEXT UNIQUE NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    revoked_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

------------------------------------------------------------
-- 후처리: self-referencing FK
------------------------------------------------------------

ALTER TABLE categories
    ADD CONSTRAINT fk_categories_parent
    FOREIGN KEY (parent_id) REFERENCES categories(id);

ALTER TABLE users
    ADD CONSTRAINT fk_users_referred_by
    FOREIGN KEY (referred_by) REFERENCES users(id);

------------------------------------------------------------
-- 인덱스 (23개)
------------------------------------------------------------

-- 기존 (v0.1)
CREATE INDEX idx_products_mall_external ON products (shopping_mall_id, external_product_id, vendor_item_id);
CREATE INDEX idx_products_category ON products (category_id, current_price);
CREATE INDEX idx_products_trend ON products (price_trend, is_out_of_stock);
CREATE INDEX idx_products_timing ON products (buy_timing_score);
CREATE INDEX idx_price_history_product_time ON price_history (product_id, recorded_at DESC);
CREATE INDEX idx_price_alerts_product_active ON price_alerts (product_id) WHERE is_active = TRUE;
CREATE INDEX idx_keyword_alerts_active ON keyword_alerts (keyword) WHERE is_active = TRUE;
CREATE INDEX idx_notifications_user_unread ON notifications (user_id, is_read, sent_at DESC);
CREATE INDEX idx_users_auth ON users (auth_provider, auth_provider_id);
CREATE INDEX idx_user_favorites_user ON user_favorites (user_id, created_at DESC);

-- 신규 (v0.2+)
CREATE INDEX idx_users_referral_code ON users (referral_code);
CREATE INDEX idx_ai_predictions_product ON ai_predictions (product_id, expires_at DESC);
CREATE INDEX idx_card_discounts_product ON card_discounts (product_id) WHERE is_active = TRUE;
CREATE INDEX idx_category_alerts_cat ON category_alerts (category_id) WHERE is_active = TRUE;
CREATE INDEX idx_daily_checkins_user ON daily_checkins (user_id, checkin_date DESC);
CREATE INDEX idx_point_transactions_user ON point_transactions (user_id, created_at DESC);
CREATE INDEX idx_referrals_referrer ON referrals (referrer_id);
CREATE INDEX idx_roulette_user_type ON roulette_results (user_id, roulette_type, created_at DESC);
CREATE INDEX idx_popular_searches_rank ON popular_searches (rank);
CREATE INDEX idx_access_logs_ip_time ON api_access_logs (ip_address, created_at DESC);
CREATE INDEX idx_access_logs_status_time ON api_access_logs (status_code, created_at DESC) WHERE status_code = 429;
CREATE INDEX idx_blocked_ips_addr ON blocked_ips (ip_address);
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens (user_id);
