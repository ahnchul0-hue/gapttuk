import '../config/constants.dart';
import '../models/notification.dart';
import 'api_client.dart';

/// 알림 내역 API 호출.
class NotificationService {
  final ApiClient _api;

  NotificationService({required ApiClient api}) : _api = api;

  // ─── 조회 ─────────────────────────────────────────────────────────────────

  /// 알림 내역 목록 조회 (커서 페이지네이션).
  ///
  /// GET /api/v1/notifications/?cursor=&limit=
  Future<({List<AppNotification> notifications, String? cursor, bool hasMore})>
      getNotifications({
    String? cursor,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final response = await _api.dio.get(
      '/api/v1/notifications/',
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
    final data = response.data;
    final notifications = (data['data'] as List)
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
    return (
      notifications: notifications,
      cursor: data['cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  /// 읽지 않은 알림 수 조회.
  ///
  /// GET /api/v1/notifications/unread-count
  /// 응답: { count: int }
  Future<int> getUnreadCount() async {
    final response =
        await _api.dio.get('/api/v1/notifications/unread-count');
    return response.data['data']['count'] as int;
  }

  // ─── 읽음 처리 ────────────────────────────────────────────────────────────

  /// 개별 알림 읽음 처리.
  ///
  /// PATCH /api/v1/notifications/{id}/read
  Future<AppNotification> markAsRead(int id) async {
    final response =
        await _api.dio.patch('/api/v1/notifications/$id/read');
    return AppNotification.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 전체 알림 읽음 처리.
  ///
  /// PATCH /api/v1/notifications/read-all
  /// 응답: { updated: int } — 실제로 읽음 처리된 건수.
  Future<int> markAllAsRead() async {
    final response =
        await _api.dio.patch('/api/v1/notifications/read-all');
    return response.data['data']['updated'] as int;
  }

  // ─── 삭제 ─────────────────────────────────────────────────────────────────

  /// 알림 내역 삭제 (204 No Content).
  ///
  /// DELETE /api/v1/notifications/{id}
  Future<void> deleteNotification(int id) async {
    await _api.dio.delete('/api/v1/notifications/$id');
  }
}
