import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/widgets/alert_type_badge.dart';

void main() {
  group('alertTypeLabel', () {
    test('target_price → 목표 가격', () {
      expect(alertTypeLabel('target_price'), '목표 가격');
    });

    test('below_average → 평균 이하', () {
      expect(alertTypeLabel('below_average'), '평균 이하');
    });

    test('near_lowest → 최저가 근접', () {
      expect(alertTypeLabel('near_lowest'), '최저가 근접');
    });

    test('all_time_low → 최저가 갱신', () {
      expect(alertTypeLabel('all_time_low'), '최저가 갱신');
    });

    test('알 수 없는 타입 → 원문 반환', () {
      expect(alertTypeLabel('unknown_type'), 'unknown_type');
    });
  });

  group('alertTypeColor', () {
    const colors = AppColors.light;

    test('target_price → info 색상', () {
      expect(alertTypeColor('target_price', colors), colors.info);
    });

    test('below_average → success 색상', () {
      expect(alertTypeColor('below_average', colors), colors.success);
    });

    test('near_lowest → warning 색상', () {
      expect(alertTypeColor('near_lowest', colors), colors.warning);
    });

    test('all_time_low → error 색상', () {
      expect(alertTypeColor('all_time_low', colors), colors.error);
    });

    test('알 수 없는 타입 → neutral 색상', () {
      expect(alertTypeColor('unknown_type', colors), colors.neutral);
    });
  });

  group('AlertTypeBadge 위젯', () {
    Widget buildBadge(String alertType) {
      return MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AlertTypeBadge(alertType: alertType),
        ),
      );
    }

    testWidgets('target_price → 목표 가격 레이블 표시', (tester) async {
      await tester.pumpWidget(buildBadge('target_price'));
      expect(find.text('목표 가격'), findsOneWidget);
    });

    testWidgets('all_time_low → 최저가 갱신 레이블 표시', (tester) async {
      await tester.pumpWidget(buildBadge('all_time_low'));
      expect(find.text('최저가 갱신'), findsOneWidget);
    });

    testWidgets('알 수 없는 타입 → 원문 표시', (tester) async {
      await tester.pumpWidget(buildBadge('custom_type'));
      expect(find.text('custom_type'), findsOneWidget);
    });
  });
}
