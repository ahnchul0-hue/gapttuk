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

    // ── Night-27 신규 ──────────────────────────────────────────────────────

    testWidgets('카테고리 탭 전환 후 빈 상태 메시지 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // "카테고리" 탭 탭
      await tester.tap(find.text('카테고리'));
      await tester.pumpAndSettle();
      expect(find.textContaining('카테고리 알림이 없습니다'), findsOneWidget);
    });

    testWidgets('키워드 탭 전환 후 빈 상태 메시지 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // "키워드" 탭 탭
      await tester.tap(find.text('키워드'));
      await tester.pumpAndSettle();
      expect(find.textContaining('키워드 알림이 없습니다'), findsOneWidget);
    });

    testWidgets('키워드 알림 있을 때 키워드 텍스트 표시', (tester) async {
      const kwAlert = KeywordAlert(
        id: 1, userId: 1, keyword: '무선이어폰',
      );
      final data = AlertListResponse(keywordAlerts: [kwAlert]);
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(response: data),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('키워드'));
      await tester.pumpAndSettle();
      expect(find.text('무선이어폰'), findsOneWidget);
    });

    testWidgets('카테고리 알림 있을 때 "카테고리 #5" 표시', (tester) async {
      const catAlert = CategoryAlert(
        id: 1, userId: 1, categoryId: 5,
      );
      final data = AlertListResponse(categoryAlerts: [catAlert]);
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(response: data),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('카테고리'));
      await tester.pumpAndSettle();
      expect(find.text('카테고리 #5'), findsOneWidget);
    });

    // ── Night-32 신규 ──────────────────────────────────────────────────────

    testWidgets('AppBar "키워드 알림 추가" 아이콘 버튼 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('에러 시 "다시 시도" 버튼 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(error: Exception('서버 오류')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('가격 알림 1건 로드 후 탭 Badge 표시', (tester) async {
      final alert = PriceAlert(
        id: 1, userId: 1, productId: 100,
        alertType: 'all_time_low', isActive: true,
      );
      final data = AlertListResponse(priceAlerts: [alert]);
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(response: data),
      ));
      await tester.pumpAndSettle();
      // 탭 count > 0 → _buildTab이 Badge 위젯 렌더링
      expect(find.byType(Badge), findsAtLeastNWidgets(1));
    });

    testWidgets('CategoryAlert thresholdPercent → "%이상 할인" 텍스트 표시', (tester) async {
      const catAlert = CategoryAlert(
        id: 2, userId: 1, categoryId: 3,
        thresholdPercent: 20,
      );
      final data = AlertListResponse(categoryAlerts: [catAlert]);
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(response: data),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('카테고리'));
      await tester.pumpAndSettle();
      expect(find.textContaining('20% 이상 할인'), findsOneWidget);
    });
  });
}
