import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/alert.dart';
import 'package:gapttuk_app/widgets/alert_type_badge.dart';

void main() {
  group('alertTypeLabel', () {
    test('targetPrice → 목표 가격', () {
      expect(alertTypeLabel(AlertType.targetPrice), '목표 가격');
    });

    test('belowAverage → 평균 이하', () {
      expect(alertTypeLabel(AlertType.belowAverage), '평균 이하');
    });

    test('nearLowest → 최저가 근접', () {
      expect(alertTypeLabel(AlertType.nearLowest), '최저가 근접');
    });

    test('allTimeLow → 최저가 갱신', () {
      expect(alertTypeLabel(AlertType.allTimeLow), '최저가 갱신');
    });
  });

  group('alertTypeColor', () {
    const colors = AppColors.light;

    test('targetPrice → info 색상', () {
      expect(alertTypeColor(AlertType.targetPrice, colors), colors.info);
    });

    test('belowAverage → success 색상', () {
      expect(alertTypeColor(AlertType.belowAverage, colors), colors.success);
    });

    test('nearLowest → warning 색상', () {
      expect(alertTypeColor(AlertType.nearLowest, colors), colors.warning);
    });

    test('allTimeLow → error 색상', () {
      expect(alertTypeColor(AlertType.allTimeLow, colors), colors.error);
    });
  });

  group('AlertType.value (API 직렬화)', () {
    test('targetPrice.value == target_price', () {
      expect(AlertType.targetPrice.value, 'target_price');
    });

    test('belowAverage.value == below_average', () {
      expect(AlertType.belowAverage.value, 'below_average');
    });

    test('nearLowest.value == near_lowest', () {
      expect(AlertType.nearLowest.value, 'near_lowest');
    });

    test('allTimeLow.value == all_time_low', () {
      expect(AlertType.allTimeLow.value, 'all_time_low');
    });
  });

  group('AlertTypeBadge 위젯', () {
    Widget buildBadge(AlertType alertType) {
      return MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AlertTypeBadge(alertType: alertType),
        ),
      );
    }

    testWidgets('targetPrice → 목표 가격 레이블 표시', (tester) async {
      await tester.pumpWidget(buildBadge(AlertType.targetPrice));
      expect(find.text('목표 가격'), findsOneWidget);
    });

    testWidgets('allTimeLow → 최저가 갱신 레이블 표시', (tester) async {
      await tester.pumpWidget(buildBadge(AlertType.allTimeLow));
      expect(find.text('최저가 갱신'), findsOneWidget);
    });

    testWidgets('belowAverage → 평균 이하 레이블 표시', (tester) async {
      await tester.pumpWidget(buildBadge(AlertType.belowAverage));
      expect(find.text('평균 이하'), findsOneWidget);
    });

    testWidgets('nearLowest → 최저가 근접 레이블 표시', (tester) async {
      await tester.pumpWidget(buildBadge(AlertType.nearLowest));
      expect(find.text('최저가 근접'), findsOneWidget);
    });
  });
}
