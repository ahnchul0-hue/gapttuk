# Phase 2: Monthly Prices API + Chart Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** price_history_monthly 조회 API와 Flutter 장기 가격 추이 차트를 추가하여 2년 초과 아카이브 데이터를 사용자에게 제공

**Architecture:** 서버에 GET /products/{id}/prices/monthly 엔드포인트 추가, Flutter에 fl_chart LineChart 위젯 + Riverpod 프로바이더로 ProductDetailScreen에 통합

**Tech Stack:** Rust/Axum/SQLx (서버), Flutter/fl_chart/Riverpod (클라이언트)

---

## Task 1: 서버 — MonthlyPriceItem DTO + get_monthly_prices 서비스 함수

**Files:**
- Modify: `server/src/services/product_service.rs`

**Step 1: DTO 추가**

`product_service.rs`의 DTO 섹션 (DailyPriceAggregate 뒤)에 추가:

```rust
/// 월별 평균 가격 항목
#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct MonthlyPriceItem {
    pub year_month: chrono::NaiveDate,
    pub avg_price: i32,
}
```

**Step 2: 서비스 함수 추가**

파일 하단 (기존 함수들 뒤)에 추가:

```rust
/// 월별 평균 가격 조회 (price_history_monthly 테이블)
pub async fn get_monthly_prices(
    pool: &PgPool,
    product_id: i64,
    months: i64,
) -> Result<Vec<MonthlyPriceItem>, AppError> {
    let months = months.clamp(1, 60);
    let cutoff = chrono::Utc::now().date_naive() - chrono::Months::new(months as u32);
    let items = sqlx::query_as::<_, MonthlyPriceItem>(
        "SELECT year_month, avg_price \
         FROM price_history_monthly \
         WHERE product_id = $1 AND year_month >= $2 \
         ORDER BY year_month ASC",
    )
    .bind(product_id)
    .bind(cutoff)
    .fetch_all(pool)
    .await?;
    Ok(items)
}
```

**Step 3: 테스트 실행**

Run: `cd /home/code/gapttuk/server && cargo test`
Expected: 기존 테스트 전부 PASS (신규 함수는 DB 의존이라 통합테스트 필요)

**Step 4: 커밋**

```bash
git add server/src/services/product_service.rs
git commit -m "feat(product): MonthlyPriceItem DTO + get_monthly_prices 서비스 함수"
```

---

## Task 2: 서버 — 핸들러 + 라우트 등록

**Files:**
- Modify: `server/src/api/routes/products.rs`

**Step 1: Query DTO 추가**

`products.rs`의 기존 Query DTO 섹션 (PopularQuery 뒤)에 추가:

```rust
#[derive(Deserialize)]
pub struct MonthlyPricesQuery {
    #[serde(default = "default_monthly_months")]
    pub months: i64,
}

fn default_monthly_months() -> i64 {
    24
}
```

**Step 2: 핸들러 추가**

파일 하단 (popular 핸들러 뒤)에 추가:

```rust
/// GET /api/v1/products/{id}/prices/monthly — 월별 평균 가격 (장기 추이)
async fn prices_monthly(
    State(state): State<AppState>,
    Path(id): Path<i64>,
    Query(params): Query<MonthlyPricesQuery>,
) -> Result<ApiResponse<Vec<product_service::MonthlyPriceItem>>, AppError> {
    let items = product_service::get_monthly_prices(&state.pool, id, params.months).await?;
    Ok(ApiResponse::ok(items))
}
```

**Step 3: 라우터에 경로 추가**

`router()` 함수의 Router::new() 체인에 추가:

```rust
.route("/{id}/prices/monthly", get(prices_monthly))
```

기존 `"/{id}/prices/daily"` 라인 뒤에 추가.

**Step 4: 테스트 + fmt + clippy**

Run: `cd /home/code/gapttuk/server && cargo test && cargo fmt && cargo clippy -- -D warnings`

**Step 5: 커밋**

```bash
cd /home/code/gapttuk && git add server/src/api/routes/products.rs
git commit -m "feat(api): GET /products/{id}/prices/monthly 엔드포인트"
```

---

## Task 3: Flutter — API 엔드포인트 + 모델 + 서비스 메서드

**Files:**
- Modify: `app/lib/config/api_endpoints.dart`
- Create: `app/lib/models/monthly_price.dart`
- Modify: `app/lib/services/product_service.dart`

**Step 1: API 엔드포인트 추가**

`api_endpoints.dart`의 Products 섹션에 추가:

```dart
static String productMonthlyPrices(int id) => '$_v1/products/$id/prices/monthly';
```

**Step 2: 모델 생성**

```dart
// app/lib/models/monthly_price.dart
import 'package:flutter/foundation.dart';

@immutable
class MonthlyPrice {
  final DateTime yearMonth;
  final int avgPrice;

  const MonthlyPrice({required this.yearMonth, required this.avgPrice});

  factory MonthlyPrice.fromJson(Map<String, dynamic> json) {
    return MonthlyPrice(
      yearMonth: DateTime.parse(json['year_month'] as String),
      avgPrice: json['avg_price'] as int,
    );
  }
}
```

**Step 3: ProductService 메서드 추가**

`product_service.dart`에 추가:

```dart
/// 월별 평균 가격 조회 (장기 추이).
Future<List<MonthlyPrice>> getMonthlyPrices(int productId, {int months = 24}) async {
  final response = await _api.dio.get(
    ApiEndpoints.productMonthlyPrices(productId),
    queryParameters: {'months': months},
  );
  return (response.data['data'] as List)
      .map((e) => MonthlyPrice.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

import 추가: `import '../models/monthly_price.dart';`

**Step 4: flutter analyze**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos`

**Step 5: 커밋**

```bash
cd /home/code/gapttuk && git add app/lib/config/api_endpoints.dart app/lib/models/monthly_price.dart app/lib/services/product_service.dart
git commit -m "feat(flutter): MonthlyPrice 모델 + ProductService.getMonthlyPrices"
```

---

## Task 4: Flutter — Riverpod 프로바이더 + 코드 생성

**Files:**
- Modify: `app/lib/providers/product_provider.dart`

**Step 1: 프로바이더 추가**

`product_provider.dart`에 추가:

```dart
/// 월별 평균 가격 — 장기 추이 차트용.
@riverpod
Future<List<MonthlyPrice>> monthlyPrices(
  Ref ref,
  int productId,
) async {
  final service = ref.watch(productServiceProvider);
  return service.getMonthlyPrices(productId);
}
```

import 추가: `import '../models/monthly_price.dart';`

**Step 2: 코드 생성**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter pub run build_runner build --delete-conflicting-outputs`

**Step 3: flutter analyze**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos`

**Step 4: 커밋**

```bash
cd /home/code/gapttuk && git add app/lib/providers/product_provider.dart app/lib/providers/product_provider.g.dart
git commit -m "feat(flutter): monthlyPrices Riverpod 프로바이더"
```

---

## Task 5: Flutter — MonthlyPriceChart 위젯

**Files:**
- Create: `app/lib/widgets/monthly_price_chart.dart`

**Step 1: 차트 위젯 생성**

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/theme.dart';
import '../models/monthly_price.dart';

class MonthlyPriceChart extends StatelessWidget {
  final List<MonthlyPrice> prices;

  const MonthlyPriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.length < 2) return const SizedBox.shrink();

    final priceFormat = NumberFormat('#,###', 'ko_KR');
    final monthFormat = DateFormat('yy.MM');

    final spots = prices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.avgPrice.toDouble());
    }).toList();

    final minY = prices.map((p) => p.avgPrice).reduce((a, b) => a < b ? a : b).toDouble() * 0.9;
    final maxY = prices.map((p) => p.avgPrice).reduce((a, b) => a > b ? a : b).toDouble() * 1.1;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, _) => Text(
                  priceFormat.format(value.round()),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (prices.length / 4).ceilToDouble().clamp(1, double.infinity),
                getTitlesWidget: (value, _) {
                  final idx = value.round();
                  if (idx < 0 || idx >= prices.length) return const SizedBox.shrink();
                  return Text(
                    monthFormat.format(prices[idx].yearMonth),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final idx = s.x.round();
                if (idx < 0 || idx >= prices.length) return null;
                final p = prices[idx];
                return LineTooltipItem(
                  '${monthFormat.format(p.yearMonth)}\n₩${priceFormat.format(p.avgPrice)}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.2,
              color: AppTheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primary.withAlpha(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 2: flutter analyze**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos`

**Step 3: 커밋**

```bash
cd /home/code/gapttuk && git add app/lib/widgets/monthly_price_chart.dart
git commit -m "feat(flutter): MonthlyPriceChart 위젯 (fl_chart LineChart)"
```

---

## Task 6: Flutter — ProductDetailScreen에 차트 통합

**Files:**
- Modify: `app/lib/screens/product/product_detail_screen.dart`

**Step 1: import 추가**

```dart
import '../../widgets/monthly_price_chart.dart';
import '../../models/monthly_price.dart';
```

**Step 2: 차트 섹션 추가**

ProductDetailScreen의 ListView children에서 기존 가격 차트(PriceChart) 섹션 뒤에 추가:

```dart
// 장기 가격 추이 (월별)
const SizedBox(height: 24),
Text('장기 가격 추이', style: Theme.of(context).textTheme.titleMedium),
const SizedBox(height: 8),
Consumer(
  builder: (context, ref, _) {
    final monthlyAsync = ref.watch(monthlyPricesProvider(productId));
    return monthlyAsync.when(
      data: (prices) => MonthlyPriceChart(prices: prices),
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  },
),
```

import 추가: `import '../../providers/product_provider.dart';` (이미 존재하면 생략)

**Step 3: flutter analyze + test**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 4: 커밋**

```bash
cd /home/code/gapttuk && git add app/lib/screens/product/product_detail_screen.dart
git commit -m "feat(flutter): ProductDetailScreen에 장기 가격 추이 차트 통합"
```

---

## Task 7: 테스트 — MonthlyPriceChart 위젯 테스트

**Files:**
- Create: `app/test/widgets/monthly_price_chart_test.dart`

**Step 1: 위젯 테스트**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk/config/theme.dart';
import 'package:gapttuk/models/monthly_price.dart';
import 'package:gapttuk/widgets/monthly_price_chart.dart';

void main() {
  testWidgets('데이터 2개 미만이면 차트 미표시', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: MonthlyPriceChart(prices: []),
        ),
      ),
    );
    expect(find.byType(MonthlyPriceChart), findsOneWidget);
    // SizedBox.shrink으로 빈 화면
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('데이터 충분하면 차트 표시', (tester) async {
    final prices = List.generate(
      6,
      (i) => MonthlyPrice(
        yearMonth: DateTime(2025, 1 + i),
        avgPrice: 10000 + i * 500,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MonthlyPriceChart(prices: prices),
        ),
      ),
    );
    // 200 높이 SizedBox가 있어야 함
    final sizedBox = tester.widget<SizedBox>(
      find.byType(SizedBox).first,
    );
    expect(sizedBox.height, 200);
  });
}
```

**Step 2: 테스트 실행**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter test test/widgets/monthly_price_chart_test.dart`
Expected: 2 tests PASS

**Step 3: 전체 테스트**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter test`
Expected: 166+ tests PASS

**Step 4: 커밋**

```bash
cd /home/code/gapttuk && git add app/test/widgets/monthly_price_chart_test.dart
git commit -m "test(flutter): MonthlyPriceChart 위젯 테스트 2건"
```

---

## Task 8: 최종 검증 + PR

**Step 1: 서버 전체 테스트**

Run: `cd /home/code/gapttuk/server && cargo test && cargo fmt --check && cargo clippy -- -D warnings`

**Step 2: Flutter 전체 테스트**

Run: `cd /home/code/gapttuk/app && /home/code/flutter/bin/flutter analyze --no-fatal-infos && /home/code/flutter/bin/flutter test`

**Step 3: PR 생성**

```bash
git push -u origin feat/phase2-monthly-prices
# 브라우저에서 PR 생성
```
