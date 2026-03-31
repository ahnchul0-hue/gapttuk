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

    testWidgets('알림 본문(body) 텍스트 표시', (tester) async {
      final notification = AppNotification(
        id: 2,
        userId: 1,
        notificationType: 'price_alert',
        title: '알림',
        body: '가격이 목표가에 도달했습니다.',
        sentAt: DateTime(2026, 3, 25),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (notifications: [notification], cursor: null, hasMore: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('가격이 목표가에 도달했습니다.'), findsOneWidget);
    });

    testWidgets('읽지 않은 알림(isRead: false) 항목 렌더링', (tester) async {
      final notification = AppNotification(
        id: 3,
        userId: 1,
        notificationType: 'keyword_alert',
        title: '키워드 알림',
        isRead: false,
        sentAt: DateTime(2026, 3, 25),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (notifications: [notification], cursor: null, hasMore: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('키워드 알림'), findsOneWidget);
    });

    testWidgets('"모두 읽음" 탭 후 스낵바 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('모두 읽음'));
      await tester.pumpAndSettle();
      expect(find.text('모든 알림을 읽음 처리했습니다.'), findsOneWidget);
    });

    testWidgets('두 개의 알림 항목 모두 제목 표시', (tester) async {
      final notifications = [
        AppNotification(
          id: 4,
          userId: 1,
          notificationType: 'price_alert',
          title: '첫 번째 알림',
          sentAt: DateTime(2026, 3, 24),
        ),
        AppNotification(
          id: 5,
          userId: 1,
          notificationType: 'system',
          title: '두 번째 알림',
          sentAt: DateTime(2026, 3, 25),
        ),
      ];
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (notifications: notifications, cursor: null, hasMore: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('첫 번째 알림'), findsOneWidget);
      expect(find.text('두 번째 알림'), findsOneWidget);
    });

    // ── Night-31 신규 ──────────────────────────────────────────────────────

    testWidgets('에러 시 "알림 내역을 불러오지 못했습니다" 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(error: Exception('서버 오류')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('알림 내역을 불러오지 못했습니다'), findsOneWidget);
    });

    testWidgets('읽음 알림(isRead: true) 항목 제목 표시', (tester) async {
      final notification = AppNotification(
        id: 6,
        userId: 1,
        notificationType: 'price_alert',
        title: '읽음 알림',
        isRead: true,
        sentAt: DateTime(2026, 3, 20),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (notifications: [notification], cursor: null, hasMore: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('읽음 알림'), findsOneWidget);
    });

    testWidgets('sentAt: 방금 전 → "방금" 시간 표시', (tester) async {
      // _formatTime: diff.inMinutes < 1 → '방금'
      final notification = AppNotification(
        id: 7,
        userId: 1,
        notificationType: 'system',
        title: '최신 알림',
        sentAt: DateTime.now(),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (notifications: [notification], cursor: null, hasMore: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('방금'), findsOneWidget);
    });

    testWidgets('sentAt: 1시간 전 → "1시간 전" 시간 표시', (tester) async {
      // _formatTime: diff.inHours < 24 → '${diff.inHours}시간 전'
      final notification = AppNotification(
        id: 8,
        userId: 1,
        notificationType: 'price_alert',
        title: '한시간 전 알림',
        sentAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeNotificationService(
            result: (notifications: [notification], cursor: null, hasMore: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('1시간 전'), findsOneWidget);
    });
  });
}
