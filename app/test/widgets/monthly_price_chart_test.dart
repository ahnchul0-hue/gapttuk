import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/monthly_price.dart';
import 'package:gapttuk_app/widgets/monthly_price_chart.dart';

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
