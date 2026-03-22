import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/screens/favorites/favorites_screen.dart';
import 'package:gapttuk_app/services/alert_service.dart';
import 'package:gapttuk_app/widgets/alert_type_badge.dart';

import '../helpers/fake_alert_service.dart';

Widget _buildScreen({AlertService? service}) {
  return ProviderScope(
    overrides: [
      alertServiceProvider.overrideWithValue(
        service ?? FakeAlertService(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const FavoritesScreen(),
    ),
  );
}

void main() {
  group('FavoritesScreen', () {
    testWidgets('"즐겨찾기" AppBar 타이틀 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('즐겨찾기'), findsOneWidget);
    });

    testWidgets('초기 로딩 중 CircularProgressIndicator 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(slow: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('가격 알림 없을 때 빈 상태 메시지 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('가격 알림을 설정하면 여기에 표시됩니다'), findsOneWidget);
    });

    testWidgets('빈 상태에서 "상품 검색하러 가기" 버튼 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('상품 검색하러 가기'), findsOneWidget);
    });

    testWidgets('alertTypeLabel 한글 변환 정확성', (tester) async {
      expect(alertTypeLabel('target_price'), equals('목표 가격'));
      expect(alertTypeLabel('all_time_low'), equals('최저가 갱신'));
      expect(alertTypeLabel('unknown_type'), equals('unknown_type'));
    });
  });
}
