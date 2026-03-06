import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/notification.dart';

void main() {
  group('AppNotification', () {
    test('fromJson — 전체 필드', () {
      final json = {
        'id': 1,
        'user_id': 10,
        'notification_type': 'price_drop',
        'reference_id': 100,
        'reference_type': 'price_alert',
        'title': '가격 하락!',
        'body': '에어팟 프로가 29,000원으로 떨어졌습니다.',
        'deep_link': 'gapttuk://product/100',
        'is_read': false,
        'sent_at': '2026-03-01T12:00:00.000Z',
        'read_at': null,
      };

      final notif = AppNotification.fromJson(json);

      expect(notif.id, 1);
      expect(notif.notificationType, 'price_drop');
      expect(notif.title, '가격 하락!');
      expect(notif.body, contains('에어팟'));
      expect(notif.deepLink, 'gapttuk://product/100');
      expect(notif.isRead, false);
      expect(notif.readAt, isNull);
    });

    test('isRead 기본값 false', () {
      final json = {
        'id': 2,
        'user_id': 1,
        'notification_type': 'system',
        'title': '공지',
        'body': '서비스 점검',
      };
      expect(AppNotification.fromJson(json).isRead, false);
    });

    test('body null 허용', () {
      final json = {
        'id': 4,
        'user_id': 1,
        'notification_type': 'system',
        'title': '공지',
      };
      final notif = AppNotification.fromJson(json);
      expect(notif.body, isNull);
    });

    test('읽음 처리 후 — is_read: true + read_at 설정', () {
      final json = {
        'id': 3,
        'user_id': 1,
        'notification_type': 'price_drop',
        'title': '가격 변동',
        'body': '가격이 변동되었습니다.',
        'is_read': true,
        'read_at': '2026-03-01T13:00:00.000Z',
      };

      final notif = AppNotification.fromJson(json);

      expect(notif.isRead, true);
      expect(notif.readAt, isNotNull);
    });
  });
}
