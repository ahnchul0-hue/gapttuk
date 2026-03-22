import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/alert.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/screens/alert/alert_screen.dart';
import 'package:gapttuk_app/services/alert_service.dart';

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
      home: const AlertScreen(),
    ),
  );
}

void main() {
  group('AlertScreen', () {
    testWidgets('"알림" AppBar 타이틀 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('알림'), findsOneWidget);
    });

    testWidgets('3개 탭 (가격 알림 / 카테고리 / 키워드) 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('가격 알림'), findsOneWidget);
      expect(find.text('카테고리'), findsOneWidget);
      expect(find.text('키워드'), findsOneWidget);
    });

    testWidgets('초기 로딩 중 CircularProgressIndicator 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(slow: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('빈 알림 목록 로드 후 빈 상태 메시지 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('가격 알림이 없습니다\n상품 상세에서 알림을 설정하세요'), findsOneWidget);
    });

    testWidgets('에러 시 "알림 목록을 불러오지 못했습니다" 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(error: Exception('서버 오류')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('알림 목록을 불러오지 못했습니다'), findsOneWidget);
    });

    testWidgets('가격 알림 있을 때 목표가 표시', (tester) async {
      final alert = PriceAlert(
        id: 1,
        userId: 1,
        productId: 100,
        alertType: 'target_price',
        targetPrice: 20000,
        isActive: true,
      );
      final data = AlertListResponse(priceAlerts: [alert]);
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(response: data),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('목표가'), findsOneWidget);
    });
  });
}
