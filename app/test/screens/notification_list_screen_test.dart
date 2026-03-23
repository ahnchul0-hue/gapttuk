import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/notification.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/screens/notification/notification_list_screen.dart';

import '../helpers/fake_notification_service.dart';

Widget _buildScreen({FakeNotificationService? service}) {
  return ProviderScope(
    overrides: [
      notificationServiceProvider.overrideWith(
        (ref) => service ?? FakeNotificationService(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const NotificationListScreen(),
    ),
  );
}

void main() {
  group('NotificationListScreen', () {
    testWidgets('"알림 내역" AppBar 타이틀 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('알림 내역'), findsOneWidget);
    });

    testWidgets('"모두 읽음" 액션 버튼 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('모두 읽음'), findsOneWidget);
    });

    testWidgets('초기 로딩 중 CircularProgressIndicator 표시', (tester) async {
      await tester.pumpWidget(
        _buildScreen(service: FakeNotificationService(slow: true)),
      );
      await tester.pump(); // initState → _loadNotifications 시작
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('빈 알림 목록 — "새로운 알림이 없습니다" 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('새로운 알림이 없습니다.'), findsOneWidget);
    });

    testWidgets('에러 시 "다시 시도" 버튼 표시', (tester) async {
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(error: Exception('서버 오류')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('알림 항목 있을 때 제목 표시', (tester) async {
      final notification = AppNotification(
        id: 1,
        userId: 1,
        notificationType: 'price_alert',
        title: '목표 가격 달성!',
        body: '추적 중인 상품의 가격이 내렸습니다.',
        sentAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (
              notifications: [notification],
              cursor: null,
              hasMore: false
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('목표 가격 달성!'), findsOneWidget);
    });
  });
}
