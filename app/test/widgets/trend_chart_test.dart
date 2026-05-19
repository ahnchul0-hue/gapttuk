import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/naver_trend.dart';
import 'package:gapttuk_app/widgets/trend_chart.dart';

void main() {
  Widget buildChart(List<CategoryTrend> trends) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: TrendChartWidget(trends: trends),
      ),
    );
  }

  Widget buildSummaryCard(CategoryTrend trend, {Color color = Colors.blue}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: TrendSummaryCard(trend: trend, color: color),
      ),
    );
  }

  CategoryTrend makeTrend({
    String name = '생활용품',
    double momChange = 20.0,
    double recentAvg = 5.5,
  }) {
    return CategoryTrend(
      categoryName: name,
      periods: [
        const TrendPeriodData(period: '2025-11-01', ratio: 5.0),
        const TrendPeriodData(period: '2025-12-01', ratio: 6.0),
      ],
      recentAvg: recentAvg,
      momChange: momChange,
    );
  }

  group('TrendChartWidget', () {
    testWidgets('빈 목록 → "트렌드 데이터 없음" 표시', (tester) async {
      await tester.pumpWidget(buildChart([]));
      await tester.pumpAndSettle();
      expect(find.text('트렌드 데이터 없음'), findsOneWidget);
    });

    testWidgets('정상 데이터 → LineChart 렌더링', (tester) async {
      await tester.pumpWidget(buildChart([makeTrend()]));
      await tester.pumpAndSettle();
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('범례에 카테고리명 표시', (tester) async {
      await tester.pumpWidget(
        buildChart([makeTrend(name: '디지털/가전'), makeTrend(name: '식품')]),
      );
      await tester.pumpAndSettle();
      expect(find.text('디지털/가전'), findsOneWidget);
      expect(find.text('식품'), findsOneWidget);
    });
  });

  group('TrendSummaryCard', () {
    testWidgets('momChange 양수 → trending_up 아이콘', (tester) async {
      await tester.pumpWidget(
        buildSummaryCard(makeTrend(momChange: 20.0)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.text('+20.0%'), findsOneWidget);
    });

    testWidgets('momChange 음수 → trending_down 아이콘 + 음수 텍스트', (tester) async {
      await tester.pumpWidget(
        buildSummaryCard(makeTrend(momChange: -10.5)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
      expect(find.text('-10.5%'), findsOneWidget);
    });
  });
}
