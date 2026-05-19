import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/price_history.dart';
import 'package:gapttuk_app/providers/product_provider.dart';
import 'package:gapttuk_app/widgets/price_chart.dart';

void main() {
  const productId = 1;

  Widget buildChart(Future<List<DailyPriceAggregate>> future) {
    return ProviderScope(
      overrides: [
        dailyPricesProvider(productId).overrideWith((_) => future),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: PriceChart(productId: productId),
        ),
      ),
    );
  }

  group('PriceChart', () {
    testWidgets('로딩 중 CircularProgressIndicator 표시', (tester) async {
      // Completer로 영구 미완료 Future 생성
      final completer = Completer<List<DailyPriceAggregate>>();
      await tester.pumpWidget(buildChart(completer.future));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('빈 목록 → "가격 데이터가 없습니다" 표시', (tester) async {
      await tester.pumpWidget(buildChart(Future.value([])));
      await tester.pumpAndSettle();
      expect(find.text('가격 데이터가 없습니다'), findsOneWidget);
    });

    testWidgets('avgPrice 전부 null → "평균 가격 데이터가 없습니다" 표시', (tester) async {
      final prices = [
        DailyPriceAggregate(
          dayOfWeek: 1,
          avgPrice: null,
          minPrice: 10000,
          maxPrice: 20000,
          sampleCount: 3,
        ),
      ];
      await tester.pumpWidget(buildChart(Future.value(prices)));
      await tester.pumpAndSettle();
      expect(find.text('평균 가격 데이터가 없습니다'), findsOneWidget);
    });

    testWidgets('에러 상태 → 에러 메시지 표시', (tester) async {
      await tester.pumpWidget(
        buildChart(Future(() async {
          throw Exception('네트워크 오류');
        })),
      );
      await tester.pumpAndSettle();
      // friendlyErrorMessage가 에러 텍스트를 변환해 표시
      expect(find.byType(Text), findsAtLeast(1));
    });

    testWidgets('정상 데이터 → LineChart 렌더링', (tester) async {
      final prices = [
        DailyPriceAggregate(
          dayOfWeek: 1,
          avgPrice: 320000,
          minPrice: 300000,
          maxPrice: 340000,
          sampleCount: 5,
        ),
        DailyPriceAggregate(
          dayOfWeek: 3,
          avgPrice: 310000,
          minPrice: 295000,
          maxPrice: 330000,
          sampleCount: 4,
        ),
      ];
      await tester.pumpWidget(buildChart(Future.value(prices)));
      await tester.pumpAndSettle();
      expect(find.byType(LineChart), findsOneWidget);
    });
  });
}
