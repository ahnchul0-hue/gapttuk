import 'dart:async';

import 'package:gapttuk_app/models/notification.dart';
import 'package:gapttuk_app/services/notification_service.dart';

typedef NotifResult = ({
  List<AppNotification> notifications,
  String? cursor,
  bool hasMore
});

/// NotificationService fake (implements) — ApiClient 불필요.
///
/// [result]: getNotifications()가 반환할 데이터.
/// [error]: non-null이면 getNotifications()가 예외를 던진다.
/// [slow]: true이면 getNotifications()가 영원히 pending (로딩 상태 테스트용).
class FakeNotificationService implements NotificationService {
  final NotifResult _result;
  final Exception? _error;
  final bool _slow;

  FakeNotificationService({
    NotifResult? result,
    Exception? error,
    bool slow = false,
  })  : _result =
            result ?? (notifications: [], cursor: null, hasMore: false),
        _error = error,
        _slow = slow;

  @override
  Future<NotifResult> getNotifications({String? cursor, int limit = 20}) async {
    if (_slow) return Completer<NotifResult>().future;
    if (_error != null) throw _error;
    return _result;
  }

  @override
  Future<int> getUnreadCount() async => 0;

  @override
  Future<void> markAsRead(int id) async {}

  @override
  Future<int> markAllAsRead() async => 0;

  @override
  Future<void> deleteNotification(int id) async {}
}
