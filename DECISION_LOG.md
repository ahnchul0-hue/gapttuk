# DECISION_LOG — Night-01 Session (2026-03-04)

## Context
Sub-agent session on branch `auto/night-01-20260304_0100`.
PLAN_01.md was not found in the repository; decisions are inferred from the uncommitted diff.

---

## D-1: Service Layer Extraction for Devices

**Decision**: Extract inline SQL from `devices.rs` into `services/device_service.rs`.

**Rationale**: `alerts.rs`, `notifications.rs`, and `product_service.rs` already follow the service layer pattern. `devices.rs` was the last route file with inline `sqlx::query_as` calls, creating inconsistency.

**Trade-offs**:
- Consistency with rest of codebase ✓
- Slightly more indirection, but test isolation improves ✓
- `device_service.rs` adds `token.trim()` + length validation (1–512 bytes), fixing silent acceptance of empty/oversized tokens ✓

**Status**: IMPLEMENTED

---

## D-2: utoipa Dependency Added (Not Yet Integrated)

**Decision**: Add `utoipa = { version = "5.4.0", features = ["axum_extras"] }` to Cargo.toml without any source usage.

**Rationale**: OpenAPI documentation was listed in STEP 29 progress notes as a pending item. Adding the dependency now unblocks the next session to annotate handlers with `#[utoipa::path]` macros.

**Risk**: Dead dependency until integrated — Clippy allows with `-A dead_code`. Cargo.lock updated.

**Status**: REVERSED in STEP 35 — dependency removed as dead_code; re-add when OpenAPI integration is scheduled.

---

## D-3: Background Task Metrics (main.rs)

**Decision**: Add `metrics::counter!("background_task_exit", ...)` to the panic watcher loop.

**Rationale**: Silent task exits were invisible to Prometheus. Adding `"reason" => "normal"` vs `"reason" => "panic"` distinguishes graceful stop from crash — enabling alert rules on panic count.

**Status**: IMPLEMENTED

---

## D-4: Migration Cleanup (010_seed_shopping_malls.sql deleted)

**Decision**: Delete `server/migrations/010_seed_shopping_malls.sql` (no .up/.down suffix) from working tree.

**Rationale**: STEP 28 added the correct `.up.sql` and `.down.sql` versions but left the old unsuffixed file tracked in git. SQLx `migrate!` runs `.up.sql` files; the duplicate could cause confusion.

**Status**: STAGED FOR DELETION

---

## D-5: cargo fmt Applied

**Decision**: Run `cargo fmt` before commit.

**Rationale**: `cargo fmt --check` returned exit 1 due to line-length reformatting in `devices.rs`, `main.rs`, `auth.rs`, `products.rs`. All changes are cosmetic (no logic changes).

**Status**: APPLIED

---

# Night-02 Session (2026-03-05) — STEP 32–35

## D-6: JWT aud/iss Claims (STEP 32-2)

**Decision**: Add `aud: "gapttuk-api"` and `iss: "gapttuk-server"` to JWT Claims struct and enforce validation in `decode_access_token`.

**Rationale**: Without `aud`/`iss` validation, a token issued by any HS256 service sharing the secret could authenticate to this API (CWE-287: Improper Authentication). OWASP API Security Top 10 — API2:2023.

**Constants**: `JWT_AUDIENCE` and `JWT_ISSUER` exported from `auth/jwt.rs` for use in tests and future token consumers.

**Status**: IMPLEMENTED

---

## D-7: Kakao app_id Verification (STEP 32-1)

**Decision**: Before calling `/v2/user/me`, call `kapi.kakao.com/v1/user/access_token_info` to validate the token's `app_id` matches `KAKAO_REST_API_KEY`.

**Rationale**: Attacker could obtain a valid Kakao token from a different app and reuse it against this service. `app_id` verification ensures the token was issued for our app. Only applies when `kakao_rest_api_key` is set in config.

**Trade-off**: Extra HTTP round-trip per login. Acceptable because login is infrequent and the security benefit is significant.

**Status**: IMPLEMENTED

---

## D-8: search q.chars().count() (STEP 32-3)

**Decision**: Replace `q.len() > 100` with `q.chars().count() > 100` in `products.rs` search handler.

**Rationale**: Korean characters are 3 bytes each in UTF-8. `len()` counts bytes, not characters. A 34-character Korean query would incorrectly exceed the 100-byte limit, rejecting valid input.

**Status**: IMPLEMENTED (also already fixed in alert_service and device_service in earlier steps)

---

## D-9: Crawler UA Pool Update (STEP 32-4)

**Decision**: Update all 12 User-Agent strings to 2026-03 browser versions (Chrome 133, Firefox 135, Safari 18.3, Edge 133, Samsung Internet 27, Whale 4.30).

**Rationale**: Stale UAs from 2024 increase CAPTCHA detection risk. Browser UAs are typically 6-12 months ahead of server versions used by bots.

**Status**: IMPLEMENTED

---

## D-10: IPv6 ULA Detection (STEP 32-5)

**Decision**: Add `fc00::/7` (IPv6 ULA) detection to `is_private_ip()` in `main.rs`.

**Rationale**: IPv6 Unique Local Addresses (RFC 4193) are private but `Ipv6Addr::is_loopback()` only matches `::1`. Without this, a request from `fd00::1` (a private IPv6 address) could access `/metrics`.

**Status**: IMPLEMENTED

---

## D-11: Dynamic Crawler Semaphore (STEP 33-1)

**Decision**: Replace hardcoded `Semaphore::new(8)` with `((db_max_connections * 0.6) as usize).clamp(2, 8)`.

**Rationale**: With `DATABASE_MAX_CONNECTIONS=5` (default), 8 concurrent crawlers could exhaust the pool. Dynamic calculation reserves 40% of the pool for API requests.

**Status**: IMPLEMENTED — `CrawlerService::new()` now takes `db_max_connections: u32`

---

## D-12: Partition Pruning for price_history (STEP 33-2)

**Decision**: Add `AND recorded_at >= NOW() - INTERVAL '1 year'` to the MIN(recorded_at) subquery in `refresh_product_stats` and `refresh_product_stats_with_metadata`.

**Rationale**: Without a time bound, PostgreSQL scans all partitions to find the minimum date. With the bound, it prunes to the last 2 partitions at most. Lowest-price events older than 1 year are edge cases that don't affect user-visible buy signals.

**Status**: IMPLEMENTED

---

## D-13: Single-Query Upsert for add_product_by_url (STEP 33-3)

**Decision**: Replace INSERT-DO-NOTHING + separate SELECT with `INSERT … ON CONFLICT DO UPDATE SET updated_at = NOW() RETURNING *`.

**Rationale**: Two-query approach had a TOCTOU gap and doubled DB round-trips. `DO UPDATE` ensures RETURNING always returns a row (both insert and conflict paths). `updated_at = NOW()` is a no-op semantically but required to satisfy PostgreSQL's RETURNING constraint on conflict paths.

**Status**: IMPLEMENTED

---

## D-14: Lazy ensure_product_exists (STEP 33-4)

**Decision**: Remove upfront `ensure_product_exists()` calls from `get_price_history` and `get_daily_price_aggregates`. Check existence only when the result set is empty AND cursor is None.

**Rationale**: >99% of requests are for valid products that have data. The existence check was wasted for these cases. The lazy check still returns 404 for invalid product IDs on first page requests.

**Status**: IMPLEMENTED

---

## D-15: validate_device_token Pure Function (STEP 34-1)

**Decision**: Extract the `trim` + length validation logic from `register_device` into a standalone `validate_device_token(raw: &str) -> Result<&str, AppError>` function.

**Rationale**: Pure functions are testable without a database. Enables 6 unit tests to run in ~0ms. Pattern follows `alert_service` where validate functions are extracted for testability.

**Status**: IMPLEMENTED — 6 tests added, total: 147

---

## D-16: Cursor Pagination for All Sort Modes (STEP 34-2)

**Decision**: Remove `matches!(sort, None | Some("ranking"))` restriction on cursor use. All sort modes now use `AND id < $2`.

**Rationale**: All ORDER BY clauses include `id DESC` as a secondary sort key, which guarantees stable ordering and prevents duplicates. The old restriction meant non-ranking sorts returned all results on page 1 (ignoring cursor), breaking pagination.

**Trade-off**: Non-id sorts may skip items when prices change between pages (cursor is `id`-based, not value-based). Documented in comment. Acceptable for this use case.

**Status**: IMPLEMENTED

---

## D-17: utoipa Dead Dependency Removed (STEP 35-1)

**Decision**: Remove `utoipa = "5.4.0"` from Cargo.toml.

**Rationale**: Added in STEP 31 but never used in source. Dead dependencies increase compile time and surface area. Re-add when OpenAPI annotation work is explicitly scheduled.

**Status**: IMPLEMENTED

---

## D-18: JWT_ACCESS_TTL_SECS Default Changed

**Decision**: Change `.env.example` default from `1800` (30 min) to `300` (5 min).

**Rationale**: Shorter access token TTL reduces the window for token misuse. Refresh tokens (7 days) handle session continuity. 5 minutes is industry standard for high-security APIs.

**Status**: IMPLEMENTED (example only — production value set via environment)
