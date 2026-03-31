import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/price_history.dart';
import 'package:gapttuk_app/models/product.dart';
import 'package:gapttuk_app/providers/product_provider.dart';
import 'package:gapttuk_app/screens/product/product_detail_screen.dart';
import 'package:gapttuk_app/widgets/loading_skeleton.dart';

void main() {
  const productId = 42;

  const fakeProduct = Product(
    id: productId,
    productName: '테스트 이어폰',
    currentPrice: 29900,
    lowestPrice: 25000,
    highestPrice: 35000,
    averagePrice: 30000,
    isOutOfStock: false,
    priceTrend: 'falling',
    buyTimingScore: 85,
    reviewCount: 120,
  );

  Widget buildScreen({
    Future<Product>? productFuture,
    Future<List<DailyPriceAggregate>>? dailyFuture,
    Future<Map<String, dynamic>>? predictionFuture,
  }) {
    return ProviderScope(
      overrides: [
        productDetailProvider(productId).overrideWith(
          (ref) => productFuture ?? Future.value(fakeProduct),
        ),
        dailyPricesProvider(productId).overrideWith(
          (ref) => dailyFuture ?? Future.value([]),
        ),
        productPredictionProvider(productId).overrideWith(
          (ref) => predictionFuture ?? Future.value({}),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const ProductDetailScreen(productId: productId),
      ),
    );
  }

  group('ProductDetailScreen', () {
    testWidgets('"상품 상세" AppBar 타이틀 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      // AppBar는 로딩 전에도 표시됨
      expect(find.text('상품 상세'), findsOneWidget);
    });

    testWidgets('"가격 알림" FAB 항상 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('가격 알림'), findsOneWidget);
    });

    testWidgets('데이터 로드 완료 후 상품명 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('테스트 이어폰'), findsOneWidget);
    });

    testWidgets('현재 가격 ₩29,900 형식으로 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('₩29,900'), findsOneWidget);
    });

    testWidgets('로딩 중 LoadingSkeleton 표시', (tester) async {
      // Completer로 절대 완료되지 않는 Future 생성 → loading 상태 유지
      final loadingFuture = Completer<Product>().future;
      await tester.pumpWidget(buildScreen(productFuture: loadingFuture));
      await tester.pump(); // 한 프레임만 — Future가 아직 pending
      expect(find.byType(LoadingSkeleton), findsOneWidget);
    });

    testWidgets('에러 상태 시 오류 메시지 표시', (tester) async {
      // async throw: Riverpod 내부에서 예외 발생 → zone 전파 방지
      await tester.pumpWidget(ProviderScope(
        overrides: [
          productDetailProvider(productId).overrideWith(
            (ref) async { throw Exception('네트워크 오류'); },
          ),
          dailyPricesProvider(productId).overrideWith((ref) => Future.value([])),
          productPredictionProvider(productId).overrideWith((ref) => Future.value({})),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ProductDetailScreen(productId: productId),
        ),
      ));
      await tester.pumpAndSettle();
      // friendlyErrorMessage(Exception) → '오류가 발생했습니다: ...'
      expect(find.textContaining('오류'), findsAtLeastNWidgets(1));
    });

    testWidgets('품절 상품 "품절" 배지 표시', (tester) async {
      const outOfStockProduct = Product(
        id: productId,
        productName: '품절 상품',
        currentPrice: 15000,
        isOutOfStock: true,
      );
      await tester.pumpWidget(buildScreen(
        productFuture: Future.value(outOfStockProduct),
      ));
      await tester.pumpAndSettle();
      expect(find.text('품절'), findsOneWidget);
    });

    testWidgets('priceTrend falling → "하락" 칩 표시', (tester) async {
      // fakeProduct.priceTrend = 'falling' → _TrendChip → '하락'
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('하락'), findsOneWidget);
    });

    testWidgets('buyTimingScore 85 → "매수 타이밍 85점" 배지 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('매수 타이밍 85점'), findsOneWidget);
    });

    testWidgets('최저가 ₩25,000 통계 카드 표시', (tester) async {
      // fakeProduct.lowestPrice = 25000
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('₩25,000'), findsOneWidget);
    });

    testWidgets('AI 예측 buy_now → "지금 구매" 텍스트 표시', (tester) async {
      await tester.pumpWidget(buildScreen(
        predictionFuture: Future.value({
          'predicted_action': 'buy_now',
          'confidence': '0.92',
        }),
      ));
      await tester.pumpAndSettle();
      // _PredictionCard: action='buy_now' → actionText='지금 구매'
      expect(find.textContaining('지금 구매'), findsOneWidget);
    });

    // ── Night-31 신규 ──────────────────────────────────────────────────────

    testWidgets('priceTrend rising → "상승" 칩 표시', (tester) async {
      await tester.pumpWidget(buildScreen(
        productFuture: Future.value(const Product(
          id: productId,
          productName: '상승 중 상품',
          currentPrice: 30000,
          priceTrend: 'rising',
        )),
      ));
      await tester.pumpAndSettle();
      expect(find.text('상승'), findsOneWidget);
    });

    testWidgets('priceTrend stable → "안정" 칩 표시 (default 분기)', (tester) async {
      // 'stable'은 switch default(_)에 매핑 → '안정'
      await tester.pumpWidget(buildScreen(
        productFuture: Future.value(const Product(
          id: productId,
          productName: '안정 상품',
          currentPrice: 30000,
          priceTrend: 'stable',
        )),
      ));
      await tester.pumpAndSettle();
      expect(find.text('안정'), findsOneWidget);
    });

    testWidgets('최고가 ₩35,000 통계 카드 표시', (tester) async {
      // fakeProduct.highestPrice = 35000
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('₩35,000'), findsOneWidget);
    });

    testWidgets('AI 예측 wait → "대기" 텍스트 표시', (tester) async {
      await tester.pumpWidget(buildScreen(
        predictionFuture: Future.value({
          'predicted_action': 'wait',
          'confidence': '0.75',
        }),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('대기'), findsOneWidget);
    });
  });
}
