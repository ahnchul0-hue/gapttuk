import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/alert.dart';
import 'package:gapttuk_app/providers/product_provider.dart';
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

Widget _buildScreenWithProduct({
  required AlertService service,
  required int productId,
}) {
  return ProviderScope(
    overrides: [
      alertServiceProvider.overrideWithValue(service),
      productDetailProvider(productId).overrideWith(
        (ref) async { throw Exception('not found'); },
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

    // ── Night-27 신규 ──────────────────────────────────────────────────────

    testWidgets('에러 시 "즐겨찾기를 불러오지 못했습니다" 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(error: Exception('네트워크 오류')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('즐겨찾기를 불러오지 못했습니다'), findsOneWidget);
    });

    testWidgets('에러 시 "다시 시도" 버튼 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(
        service: FakeAlertService(error: Exception('서버 오류')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('알림 1개 있을 때 AppBar 카운트 배지 "1개" 표시', (tester) async {
      const alert = PriceAlert(
        id: 1, userId: 1, productId: 100,
        alertType: 'target_price', targetPrice: 20000,
      );
      final service = FakeAlertService(
        response: const AlertListResponse(priceAlerts: [alert]),
      );
      await tester.pumpWidget(_buildScreenWithProduct(
        service: service,
        productId: 100,
      ));
      await tester.pumpAndSettle();
      expect(find.text('1개'), findsOneWidget);
    });

    testWidgets('알림 1개 있을 때 상품 폴백 텍스트 "상품 #100" 표시', (tester) async {
      const alert = PriceAlert(
        id: 1, userId: 1, productId: 100,
        alertType: 'all_time_low',
      );
      final service = FakeAlertService(
        response: const AlertListResponse(priceAlerts: [alert]),
      );
      await tester.pumpWidget(_buildScreenWithProduct(
        service: service,
        productId: 100,
      ));
      await tester.pumpAndSettle();
      expect(find.text('상품 #100'), findsOneWidget);
    });
  });
}
