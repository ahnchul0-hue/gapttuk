import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/demographic_trend.dart';
import 'package:gapttuk_app/widgets/demographic_chart.dart';

void main() {
  Widget buildChart(List<DemographicTrend> trends) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: SingleChildScrollView(
          child: DemographicChartWidget(trends: trends),
        ),
      ),
    );
  }

  DemographicTrend makeAgeTrend({String topGroup = '30'}) {
    return DemographicTrend(
      categoryCode: '50000151',
      dimension: 'age',
      data: const [
        DemographicPeriodData(period: '2026-01-01', ratio: 15.0, group: '20'),
        DemographicPeriodData(period: '2026-01-01', ratio: 40.0, group: '30'),
        DemographicPeriodData(period: '2026-01-01', ratio: 25.0, group: '40'),
      ],
      groupRecentAvg: const {'20': 15.0, '30': 40.0, '40': 25.0},
      topGroup: topGroup,
    );
  }

  DemographicTrend makeGenderTrend({String topGroup = 'f'}) {
    return DemographicTrend(
      categoryCode: '50000151',
      dimension: 'gender',
      data: const [
        DemographicPeriodData(period: '2026-01-01', ratio: 35.0, group: 'm'),
        DemographicPeriodData(period: '2026-01-01', ratio: 65.0, group: 'f'),
      ],
      groupRecentAvg: const {'m': 35.0, 'f': 65.0},
      topGroup: topGroup,
    );
  }

  DemographicTrend makeDeviceTrend({String topGroup = 'mo'}) {
    return DemographicTrend(
      categoryCode: '50000151',
      dimension: 'device',
      data: const [
        DemographicPeriodData(period: '2026-01-01', ratio: 78.0, group: 'mo'),
        DemographicPeriodData(period: '2026-01-01', ratio: 22.0, group: 'pc'),
      ],
      groupRecentAvg: const {'mo': 78.0, 'pc': 22.0},
      topGroup: topGroup,
    );
  }

  group('DemographicChartWidget', () {
    testWidgets('빈 목록 → "인구통계 데이터 없음" 표시', (tester) async {
      await tester.pumpWidget(buildChart([]));
      await tester.pumpAndSettle();
      expect(find.text('인구통계 데이터 없음'), findsOneWidget);
    });

    testWidgets('age 차원 → "연령대별 관심도" 섹션 헤더 표시', (tester) async {
      await tester.pumpWidget(buildChart([makeAgeTrend()]));
      await tester.pumpAndSettle();
      expect(find.text('연령대별 관심도'), findsOneWidget);
    });

    testWidgets('age 차원 → BarChart 렌더링', (tester) async {
      await tester.pumpWidget(buildChart([makeAgeTrend()]));
      await tester.pumpAndSettle();
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('gender 차원 → "성별 관심도" 섹션 헤더 + 남/녀 레이블 표시', (tester) async {
      await tester.pumpWidget(buildChart([makeGenderTrend()]));
      await tester.pumpAndSettle();
      expect(find.text('성별 관심도'), findsOneWidget);
      expect(find.text('남성'), findsOneWidget);
      expect(find.text('여성'), findsOneWidget);
    });

    testWidgets('gender 차원 → LinearProgressIndicator 2개 렌더링', (tester) async {
      await tester.pumpWidget(buildChart([makeGenderTrend()]));
      await tester.pumpAndSettle();
      expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    });

    testWidgets('gender 차원 → 비율 텍스트 표시 (65.0%)', (tester) async {
      await tester.pumpWidget(buildChart([makeGenderTrend()]));
      await tester.pumpAndSettle();
      expect(find.text('65.0%'), findsOneWidget);
      expect(find.text('35.0%'), findsOneWidget);
    });

    testWidgets('device 차원 → "기기별 관심도" 섹션 헤더 + 모바일/PC 레이블', (tester) async {
      await tester.pumpWidget(buildChart([makeDeviceTrend()]));
      await tester.pumpAndSettle();
      expect(find.text('기기별 관심도'), findsOneWidget);
      expect(find.text('모바일'), findsOneWidget);
      expect(find.text('PC'), findsOneWidget);
    });

    testWidgets('device 차원 → LinearProgressIndicator 2개 렌더링', (tester) async {
      await tester.pumpWidget(buildChart([makeDeviceTrend()]));
      await tester.pumpAndSettle();
      expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    });

    testWidgets('미지원 dimension → 렌더링 오류 없이 빈 위젯', (tester) async {
      final unknownTrend = DemographicTrend(
        categoryCode: '50000151',
        dimension: 'unknown',
        data: const [],
        groupRecentAvg: const {},
        topGroup: '',
      );
      await tester.pumpWidget(buildChart([unknownTrend]));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('3개 차원 모두 → 섹션 헤더 3개 모두 표시', (tester) async {
      await tester.pumpWidget(buildChart([
        makeAgeTrend(),
        makeGenderTrend(),
        makeDeviceTrend(),
      ]));
      await tester.pumpAndSettle();
      expect(find.text('연령대별 관심도'), findsOneWidget);
      expect(find.text('성별 관심도'), findsOneWidget);
      expect(find.text('기기별 관심도'), findsOneWidget);
    });
  });
}
