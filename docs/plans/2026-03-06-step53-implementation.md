# STEP 53 Implementation Plan: Theme Centralization + price_history Retention

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Centralize hardcoded colors into `AppColors` ThemeExtension for dark mode support, and implement a 2-year retention policy for `price_history` with monthly aggregation.

**Architecture:** Flutter `ThemeExtension<AppColors>` provides semantic colors (success, error, warning, info, neutral) that auto-switch between light/dark. Server-side `price_history_monthly` table stores compressed aggregates, with `ensure_partitions()` extended to archive old partitions.

**Tech Stack:** Flutter/Dart (ThemeExtension, Material 3), Rust/Axum (sqlx, PostgreSQL partitioning)

---

## Task 1: AppColors ThemeExtension Definition

**Files:**
- Modify: `app/lib/config/theme.dart`

**Step 1: Add AppColors class to theme.dart**

Append after `AppTheme` class (line 60):

```dart
/// Semantic colors that auto-switch between light/dark mode.
/// Usage: `final appColors = Theme.of(context).extension<AppColors>()!;`
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color neutral;
  final Color neutralLight;
  final Color neutralBorder;

  static const kakao = Color(0xFFFEE500);
  static const naver = Color(0xFF03C75A);

  const AppColors({
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.neutral,
    required this.neutralLight,
    required this.neutralBorder,
  });

  static const light = AppColors(
    success: Color(0xFF00B894),
    error: Color(0xFFD63031),
    warning: Color(0xFFE17055),
    info: Color(0xFF0984E3),
    neutral: Color(0xFF757575),     // grey.shade600
    neutralLight: Color(0xFFF5F5F5), // grey.shade100
    neutralBorder: Color(0xFFE0E0E0), // grey.shade300
  );

  static const dark = AppColors(
    success: Color(0xFF55EFC4),
    error: Color(0xFFFF7675),
    warning: Color(0xFFFDA085),
    info: Color(0xFF74B9FF),
    neutral: Color(0xFFBDBDBD),     // grey.shade400
    neutralLight: Color(0xFF424242), // grey.shade800
    neutralBorder: Color(0xFF616161), // grey.shade700
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? neutral,
    Color? neutralLight,
    Color? neutralBorder,
  }) {
    return AppColors(
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      neutral: neutral ?? this.neutral,
      neutralLight: neutralLight ?? this.neutralLight,
      neutralBorder: neutralBorder ?? this.neutralBorder,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralLight: Color.lerp(neutralLight, other.neutralLight, t)!,
      neutralBorder: Color.lerp(neutralBorder, other.neutralBorder, t)!,
    );
  }
}
```

**Step 2: Register AppColors in ThemeData**

In the `light` getter (line 11), add `extensions`:

```dart
static ThemeData get light => ThemeData(
      useMaterial3: true,
      extensions: const [AppColors.light],
      // ... rest unchanged
    );
```

In the `dark` getter (line 36), add `extensions`:

```dart
static ThemeData get dark => ThemeData(
      useMaterial3: true,
      extensions: const [AppColors.dark],
      // ... rest unchanged
    );
```

**Step 3: Run analyze**

Run: `cd app && /home/code/flutter/bin/flutter analyze`
Expected: 0 errors, 0 warnings, 0 infos

**Step 4: Commit**

```bash
git add app/lib/config/theme.dart
git commit -m "feat: AppColors ThemeExtension — semantic colors with light/dark"
```

---

## Task 2: AppColors Unit Test

**Files:**
- Create: `app/test/config/theme_test.dart`

**Step 1: Write tests**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk/config/theme.dart';

void main() {
  group('AppColors', () {
    test('light and dark have different values', () {
      expect(AppColors.light.success, isNot(equals(AppColors.dark.success)));
      expect(AppColors.light.error, isNot(equals(AppColors.dark.error)));
      expect(AppColors.light.neutral, isNot(equals(AppColors.dark.neutral)));
    });

    test('copyWith preserves unchanged values', () {
      const original = AppColors.light;
      final modified = original.copyWith(error: Colors.pink);
      expect(modified.error, Colors.pink);
      expect(modified.success, original.success);
      expect(modified.info, original.info);
    });

    test('lerp interpolates between light and dark', () {
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);
      expect(mid.success, isNot(equals(AppColors.light.success)));
      expect(mid.success, isNot(equals(AppColors.dark.success)));
    });

    test('lerp at 0 returns start', () {
      final result = AppColors.light.lerp(AppColors.dark, 0.0);
      expect(result.success, AppColors.light.success);
    });

    test('lerp at 1 returns end', () {
      final result = AppColors.light.lerp(AppColors.dark, 1.0);
      expect(result.success, AppColors.dark.success);
    });

    test('brand colors are constant across themes', () {
      expect(AppColors.kakao, const Color(0xFFFEE500));
      expect(AppColors.naver, const Color(0xFF03C75A));
    });
  });

  group('AppTheme', () {
    test('light theme has AppColors extension', () {
      final ext = AppTheme.light.extension<AppColors>();
      expect(ext, isNotNull);
      expect(ext!.success, AppColors.light.success);
    });

    test('dark theme has AppColors extension', () {
      final ext = AppTheme.dark.extension<AppColors>();
      expect(ext, isNotNull);
      expect(ext!.success, AppColors.dark.success);
    });
  });
}
```

**Step 2: Run tests**

Run: `cd app && /home/code/flutter/bin/flutter test test/config/theme_test.dart -v`
Expected: All 8 tests pass

**Step 3: Commit**

```bash
git add app/test/config/theme_test.dart
git commit -m "test: AppColors ThemeExtension unit tests"
```

---

## Task 3: Color Replacement — Screens (batch 1: 4 files)

**Files:**
- Modify: `app/lib/screens/my/point_history_screen.dart`
- Modify: `app/lib/screens/home/home_screen.dart`
- Modify: `app/lib/widgets/product_card.dart`
- Modify: `app/lib/widgets/price_chart.dart`

**Step 1: Replace colors in each file**

Each file needs `import '../../config/theme.dart';` (if not already present) and the pattern:
```dart
final appColors = Theme.of(context).extension<AppColors>()!;
```

For StatelessWidget/ConsumerWidget, add in `build()`. For widgets without `context`, pass `appColors` as needed.

**point_history_screen.dart** (4 replacements):
- Line 101: `Colors.green` → `appColors.success` (2x: icon + text)
- Line 101: `Colors.red` → `appColors.error` (2x: icon + text)
- Add import `'../../config/theme.dart'` and `final appColors = ...` at top of `build`

**home_screen.dart** (4 replacements):
- Line 158: `Colors.red` → `appColors.error` (trending up = bad for buyer)
- Line 160: `Colors.blue` → `appColors.info` (trending down)
- Line 163: `Colors.orange` → `appColors.warning` (NEW label)
- Line 165: `Colors.grey` → `appColors.neutral` (flat trend)
- Note: `_trendIcon` needs `context` parameter added

**product_card.dart** (3 replacements):
- Line 57,115: `Colors.grey.shade200` → `appColors.neutralLight` (placeholder)
- Line 101,116: `Colors.grey` → `appColors.neutral` (flat trend icon, placeholder icon)

**price_chart.dart** (1 replacement):
- Line 101: `Colors.white` (tooltip text) — keep as-is (tooltip bg is dark)
- No changes needed here actually — all colors use AppTheme already

**Step 2: Run analyze + tests**

Run: `cd app && /home/code/flutter/bin/flutter analyze && /home/code/flutter/bin/flutter test`
Expected: 0 issues, 156+ tests pass

**Step 3: Commit**

```bash
git add app/lib/screens/my/point_history_screen.dart \
        app/lib/screens/home/home_screen.dart \
        app/lib/widgets/product_card.dart
git commit -m "refactor: replace hardcoded colors with AppColors (batch 1)"
```

---

## Task 4: Color Replacement — Screens (batch 2: alert + notification)

**Files:**
- Modify: `app/lib/screens/alert/alert_screen.dart`
- Modify: `app/lib/screens/notification/notification_list_screen.dart`

**Step 1: alert_screen.dart** (~14 replacements)

Add `final appColors = Theme.of(context).extension<AppColors>()!;` to `_buildBody()` and pass to builders.

Key replacements:
- `Colors.grey.shade400/600` → `appColors.neutral`
- `Colors.red` (delete swipe bg) → `appColors.error`
- `Colors.white` (delete icon) → keep `Colors.white` (on error bg)
- `Colors.blue.shade50` → `appColors.info.withAlpha(30)` (price alert avatar bg)
- `Colors.blue` → `appColors.info` (price alert icon)
- `Colors.blue.shade700` → `appColors.info` (target price text)
- `Colors.purple.shade50` → `appColors.warning.withAlpha(30)` (category avatar bg)
- `Colors.purple` → `appColors.warning` (category icon)
- `Colors.purple.shade700` → `appColors.warning` (threshold text)
- `Colors.orange.shade50` → `appColors.warning.withAlpha(30)` (keyword avatar bg)
- `Colors.orange` → `appColors.warning` (keyword icon)

Note: `_buildAlertList` is generic — pass `appColors` parameter or use context within.

**Step 2: notification_list_screen.dart** (~12 replacements)

`_NotificationListScreenState._buildBody()`:
- `Colors.red` (error icon) → `appColors.error`
- `Colors.grey.shade600` → `appColors.neutral`
- `Colors.grey` (empty state) → `appColors.neutral`

`_NotificationTile._buildTypeIcon()`:
- `Colors.blue` → `appColors.info`
- `Colors.orange` → `appColors.warning`
- `Colors.purple` → keep `Colors.purple` or map to a different semantic
- `Colors.grey` → `appColors.neutral`
- `Colors.teal` → `appColors.info` (default notification)

`_NotificationTile.build()`:
- `Colors.red` (delete swipe) → `appColors.error`
- `Colors.grey.shade600` → `appColors.neutral`
- `Colors.grey.shade500` → `appColors.neutral`

Note: `_NotificationTile` is a StatelessWidget, needs `context` in `build()` → already available.

**Step 3: Run analyze + tests**

Run: `cd app && /home/code/flutter/bin/flutter analyze && /home/code/flutter/bin/flutter test`
Expected: 0 issues, 156+ tests pass

**Step 4: Commit**

```bash
git add app/lib/screens/alert/alert_screen.dart \
        app/lib/screens/notification/notification_list_screen.dart
git commit -m "refactor: replace hardcoded colors with AppColors (batch 2)"
```

---

## Task 5: Color Replacement — Screens (batch 3: favorites + product_detail + onboarding + settings + my_page)

**Files:**
- Modify: `app/lib/screens/favorites/favorites_screen.dart`
- Modify: `app/lib/screens/product/product_detail_screen.dart`
- Modify: `app/lib/screens/onboarding/onboarding_screen.dart`
- Modify: `app/lib/screens/my/settings_screen.dart`
- Modify: `app/lib/screens/my/my_page_screen.dart`

**Step 1: favorites_screen.dart** (~9 replacements)

Key pattern — `_alertTypeBadgeColor`:
- `Colors.blue` → `appColors.info`
- `Colors.green` → `appColors.success`
- `Colors.orange` → `appColors.warning`
- `Colors.red` → `appColors.error`
- `Colors.grey` → `appColors.neutral`

Other:
- `Colors.grey.shade100/400/500/600` → `appColors.neutralLight/neutral`
- `Colors.black45` → keep (overlay on inactive cards)
- `Colors.white` → keep (badge text on colored bg)

**Step 2: product_detail_screen.dart** (~8 replacements)

- `Colors.red.shade100/300/700` (out-of-stock badge) → `appColors.error` with alpha
- `Colors.grey` (disabled color) → `appColors.neutral`
- `Colors.orange` (medium score) → `appColors.warning`

**Step 3: onboarding/settings/my_page** (~12 combined)

- `Colors.grey.shade600` → `appColors.neutral`
- `Colors.grey.shade100` → `appColors.neutralLight`
- `Colors.grey.shade300` → `appColors.neutralBorder`
- `Colors.red` (logout/withdraw) → `appColors.error`
- `Colors.amber/amber[700]` → keep (cents badge is amber branding)

**Step 4: Run analyze + tests**

Run: `cd app && /home/code/flutter/bin/flutter analyze && /home/code/flutter/bin/flutter test`
Expected: 0 issues, 156+ tests pass

**Step 5: Commit**

```bash
git add app/lib/screens/favorites/favorites_screen.dart \
        app/lib/screens/product/product_detail_screen.dart \
        app/lib/screens/onboarding/onboarding_screen.dart \
        app/lib/screens/my/settings_screen.dart \
        app/lib/screens/my/my_page_screen.dart
git commit -m "refactor: replace hardcoded colors with AppColors (batch 3)"
```

---

## Task 6: login_screen Brand Colors → AppColors.kakao/naver

**Files:**
- Modify: `app/lib/screens/auth/login_screen.dart`

**Step 1: Replace brand color literals only**

- Line 161: `const Color(0xFFFEE500)` → `AppColors.kakao`
- Line 194: `const Color(0xFF03C75A)` → `AppColors.naver`
- Line 153: `Colors.grey` → `appColors.neutral` (subtitle)
- Do NOT change `Colors.white`, `Colors.black`, `Colors.black87` — brand guidelines

**Step 2: Run analyze + tests**

Run: `cd app && /home/code/flutter/bin/flutter analyze && /home/code/flutter/bin/flutter test`

**Step 3: Commit**

```bash
git add app/lib/screens/auth/login_screen.dart
git commit -m "refactor: login screen brand colors → AppColors constants"
```

---

## Task 7: Migration 017 — price_history_monthly Table

**Files:**
- Create: `server/migrations/017_price_history_monthly.up.sql`
- Create: `server/migrations/017_price_history_monthly.down.sql`

**Step 1: Write migration UP**

```sql
-- 017: price_history 2년 보존 정책 — 월별 집계 테이블
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
```

**Step 2: Write migration DOWN**

```sql
DROP TABLE IF EXISTS price_history_monthly;
```

**Step 3: Verify migration applies**

Run: `cd server && cargo sqlx migrate run`
Expected: Applied 017_price_history_monthly

**Step 4: Commit**

```bash
git add server/migrations/017_price_history_monthly.up.sql \
        server/migrations/017_price_history_monthly.down.sql
git commit -m "migration: 017 price_history_monthly aggregation table"
```

---

## Task 8: Archive Logic in ensure_partitions()

**Files:**
- Modify: `server/src/main.rs` (ensure_partitions function, ~line 79-171)

**Step 1: Add archive_old_price_history function**

After `ensure_partitions()`, add a new helper:

```rust
/// 2년 이전 price_history 파티션을 price_history_monthly로 집계 후 DROP.
/// 한 번에 1개 파티션만 처리하여 부하 분산.
async fn archive_old_price_history(pool: &sqlx::PgPool) -> Result<(), String> {
    let cutoff = chrono::Utc::now().date_naive() - chrono::Months::new(24);
    let cutoff_suffix = cutoff.format("%Y_%m").to_string();

    // price_history 파티션 목록 조회
    let rows = sqlx::query_as::<_, (String,)>(
        "SELECT c.relname \
         FROM pg_inherits i \
         JOIN pg_class c ON c.oid = i.inhrelid \
         JOIN pg_class p ON p.oid = i.inhparent \
         WHERE p.relname = 'price_history' \
         ORDER BY c.relname",
    )
    .fetch_all(pool)
    .await
    .map_err(|e| format!("Failed to query price_history partitions: {e}"))?;

    for (partition_name,) in rows {
        let Some(suffix) = partition_name.strip_prefix("price_history_") else {
            continue;
        };
        if !suffix.chars().all(|c| c.is_ascii_alphanumeric() || c == '_') {
            tracing::warn!(partition = %partition_name, "Unexpected partition name format");
            continue;
        }
        if suffix >= cutoff_suffix.as_str() {
            continue; // Not old enough
        }

        tracing::info!(partition = %partition_name, "Archiving old price_history partition");

        // 1. Aggregate into price_history_monthly
        let aggregate_sql = format!(
            "INSERT INTO price_history_monthly \
                 (product_id, year_month, avg_price, min_price, max_price, \
                  first_price, last_price, record_count, had_stockout) \
             SELECT \
                 product_id, \
                 DATE_TRUNC('month', recorded_at)::DATE, \
                 AVG(price)::INTEGER, \
                 MIN(price), \
                 MAX(price), \
                 (ARRAY_AGG(price ORDER BY recorded_at ASC))[1], \
                 (ARRAY_AGG(price ORDER BY recorded_at DESC))[1], \
                 COUNT(*)::INTEGER, \
                 BOOL_OR(is_out_of_stock) \
             FROM {partition_name} \
             GROUP BY product_id, DATE_TRUNC('month', recorded_at)::DATE \
             ON CONFLICT (product_id, year_month) DO NOTHING"
        );
        if let Err(e) = sqlx::query(&aggregate_sql).execute(pool).await {
            tracing::warn!(partition = %partition_name, error = %e, "Aggregation failed, skipping DROP");
            return Err(format!("Aggregation of {partition_name} failed: {e}"));
        }

        // 2. Verify row counts
        let count_sql = format!("SELECT COUNT(*)::BIGINT FROM {partition_name}");
        let (source_count,): (i64,) = sqlx::query_as(&count_sql)
            .fetch_one(pool)
            .await
            .map_err(|e| format!("Count query failed: {e}"))?;

        let verify_sql = format!(
            "SELECT COALESCE(SUM(record_count), 0)::BIGINT \
             FROM price_history_monthly \
             WHERE year_month >= (SELECT MIN(DATE_TRUNC('month', recorded_at)::DATE) FROM {partition_name}) \
               AND year_month <= (SELECT MAX(DATE_TRUNC('month', recorded_at)::DATE) FROM {partition_name})"
        );
        let (aggregated_count,): (i64,) = sqlx::query_as(&verify_sql)
            .fetch_one(pool)
            .await
            .map_err(|e| format!("Verify query failed: {e}"))?;

        if aggregated_count < source_count {
            tracing::warn!(
                partition = %partition_name,
                source = source_count,
                aggregated = aggregated_count,
                "Row count mismatch — skipping DROP"
            );
            return Err(format!("{partition_name}: count mismatch {source_count} vs {aggregated_count}"));
        }

        // 3. DROP partition
        let drop_sql = format!("DROP TABLE IF EXISTS {partition_name}");
        match sqlx::query(&drop_sql).execute(pool).await {
            Ok(_) => {
                tracing::info!(
                    partition = %partition_name,
                    rows_archived = source_count,
                    "Old price_history partition archived and dropped"
                );
            }
            Err(e) => {
                tracing::warn!(partition = %partition_name, error = %e, "Failed to drop archived partition");
                return Err(format!("DROP {partition_name} failed: {e}"));
            }
        }

        // Process only one partition per cycle
        break;
    }

    Ok(())
}
```

**Step 2: Call from ensure_partitions**

At the end of `ensure_partitions()`, before the final `if errors.is_empty()` block (~line 162), add:

```rust
    // price_history 2년 초과 파티션 아카이브 (1개/cycle)
    if let Err(e) = archive_old_price_history(pool).await {
        tracing::warn!(error = %e, "price_history archival issue");
        errors.push(e);
    }
```

**Step 3: Run cargo check + existing tests**

Run: `cd server && cargo check && cargo test`
Expected: Compiles, 197 tests pass

**Step 4: Commit**

```bash
git add server/src/main.rs
git commit -m "feat: price_history 2-year retention — monthly aggregation + partition DROP"
```

---

## Task 9: Regression Tests

**Files:** No new files

**Step 1: Run full Flutter test suite**

Run: `cd app && /home/code/flutter/bin/flutter test`
Expected: 156+ tests pass (including new theme tests)

**Step 2: Run full server test suite**

Run: `cd server && cargo test`
Expected: 197 tests pass

**Step 3: Run Flutter analyze**

Run: `cd app && /home/code/flutter/bin/flutter analyze`
Expected: 0 errors, 0 warnings, 0 infos

**Step 4: Run Clippy**

Run: `cd server && cargo clippy -- -D warnings`
Expected: 0 warnings

---

## Task 10: Final Commit

**Step 1: Squash or create summary commit**

```bash
git add -A
git commit -m "STEP 53: 테마 중앙화 + price_history 2년 보존 정책

- AppColors ThemeExtension: 7 semantic colors (success/error/warning/info/neutral/neutralLight/neutralBorder)
- Light/Dark auto-switch via Theme.of(context).extension<AppColors>()
- ~70 hardcoded Colors.xxx replaced across 11 files
- Brand colors (kakao/naver) centralized as static constants
- Migration 017: price_history_monthly aggregation table
- ensure_partitions extended: 2-year+ partitions → monthly aggregate → DROP
- Safety: row count verification before DROP, 1 partition per cycle
- Tests: AppColors 8 unit tests + full regression (197 server + 156+ Flutter)

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

> Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
