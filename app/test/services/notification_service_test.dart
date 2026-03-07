import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/notification_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late NotificationService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = NotificationService(api: mockApi);
  });

  // ─── 조회 ───────────────────────────────────────────────────────────────

  group('getNotifications', () {
    test('알림 목록 + 커서 페이지네이션', () async {
      when(() => mockDio.get(
            '/api/v1/notifications/',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': [
              {
                'id': 1,
                'user_id': 10,
                'notification_type': 'price_drop',
                'title': '가격 하락!',
                'body': '에어팟 프로가 10% 하락했습니다.',
                'is_read': false,
              },
              {
                'id': 2,
                'user_id': 10,
                'notification_type': 'all_time_low',
                'title': '역대 최저가!',
                'body': '갤럭시 버즈가 역대 최저가입니다.',
                'is_read': true,
              },
            ],
            'cursor': 'next_cursor',
            'has_more': true,
          },
        ),
      );

      final result = await service.getNotifications();

      expect(result.notifications.length, 2);
      expect(result.notifications.first.title, '가격 하락!');
      expect(result.notifications.last.isRead, true);
      expect(result.cursor, 'next_cursor');
      expect(result.hasMore, true);
    });

    test('빈 알림 목록', () async {
      when(() => mockDio.get(
            '/api/v1/notifications/',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': [],
            'cursor': null,
            'has_more': false,
          },
        ),
      );

      final result = await service.getNotifications();

      expect(result.notifications, isEmpty);
      expect(result.cursor, isNull);
      expect(result.hasMore, false);
    });

    test('커서 전달 확인', () async {
      when(() => mockDio.get(
            '/api/v1/notifications/',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': [],
            'cursor': null,
            'has_more': false,
          },
        ),
      );

      await service.getNotifications(cursor: 'abc123', limit: 10);

      verify(() => mockDio.get(
            '/api/v1/notifications/',
            queryParameters: {'limit': 10, 'cursor': 'abc123'},
          )).called(1);
    });
  });

  group('getUnreadCount', () {
    test('읽지 않은 알림 수 조회', () async {
      when(() => mockDio.get('/api/v1/notifications/unread-count')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'count': 5}
          },
        ),
      );

      final count = await service.getUnreadCount();

      expect(count, 5);
    });

    test('읽지 않은 알림 0건', () async {
      when(() => mockDio.get('/api/v1/notifications/unread-count')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'count': 0}
          },
        ),
      );

      final count = await service.getUnreadCount();

      expect(count, 0);
    });
  });

  // ─── 읽음 처리 ─────────────────────────────────────────────────────────

  group('markAsRead', () {
    test('개별 알림 읽음 처리 (void 반환)', () async {
      when(() => mockDio.patch('/api/v1/notifications/1/read')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'ok': true, 'data': null},
        ),
      );

      await service.markAsRead(1);

      verify(() => mockDio.patch('/api/v1/notifications/1/read')).called(1);
    });
  });

  group('markAllAsRead', () {
    test('전체 읽음 처리 — 갱신 건수 반환', () async {
      when(() => mockDio.patch('/api/v1/notifications/read-all')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'updated': 3}
          },
        ),
      );

      final updated = await service.markAllAsRead();

      expect(updated, 3);
    });
  });

  // ─── 삭제 ───────────────────────────────────────────────────────────────

  group('deleteNotification', () {
    test('알림 삭제 (204)', () async {
      when(() => mockDio.delete('/api/v1/notifications/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );

      await service.deleteNotification(1);

      verify(() => mockDio.delete('/api/v1/notifications/1')).called(1);
    });
  });
}
