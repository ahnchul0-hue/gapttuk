import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/reward_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late RewardService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = RewardService(api: mockApi);
  });

  group('checkin', () {
    test('당첨 시 rewardAmount 1 반환', () async {
      when(() => mockDio.post('/api/v1/rewards/checkin')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'reward_amount': 1, 'already_checked_in': false}
          },
        ),
      );

      final result = await service.checkin();

      expect(result.rewardAmount, 1);
      expect(result.alreadyCheckedIn, false);
    });

    test('이미 출석 시 alreadyCheckedIn true', () async {
      when(() => mockDio.post('/api/v1/rewards/checkin')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'reward_amount': 0, 'already_checked_in': true}
          },
        ),
      );

      final result = await service.checkin();

      expect(result.alreadyCheckedIn, true);
      expect(result.rewardAmount, 0);
    });

    test('미당첨 시 rewardAmount 0', () async {
      when(() => mockDio.post('/api/v1/rewards/checkin')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'reward_amount': 0, 'already_checked_in': false}
          },
        ),
      );

      final result = await service.checkin();

      expect(result.rewardAmount, 0);
      expect(result.alreadyCheckedIn, false);
    });
  });

  group('getPoints', () {
    test('잔액 조회 성공', () async {
      when(() => mockDio.get('/api/v1/rewards/points')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'balance': 5, 'total_earned': 10, 'total_spent': 5}
          },
        ),
      );

      final result = await service.getPoints();

      expect(result.balance, 5);
      expect(result.totalEarned, 10);
      expect(result.totalSpent, 5);
    });

    test('잔액 0 기본값', () async {
      when(() => mockDio.get('/api/v1/rewards/points')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {'balance': 0, 'total_earned': 0, 'total_spent': 0}
          },
        ),
      );

      final result = await service.getPoints();

      expect(result.balance, 0);
    });
  });

  group('getHistory', () {
    test('내역 조회 성공', () async {
      when(() => mockDio.get(
            '/api/v1/rewards/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'items': [
                {
                  'id': 1,
                  'amount': 1,
                  'transaction_type': 'daily_checkin',
                  'description': '일일 출석 룰렛 보상',
                  'created_at': '2026-03-06T00:00:00Z',
                }
              ],
              'has_more': false,
            }
          },
        ),
      );

      final result = await service.getHistory();

      expect(result.items.length, 1);
      expect(result.items.first.transactionType, 'daily_checkin');
      expect(result.hasMore, false);
    });

    test('빈 결과', () async {
      when(() => mockDio.get(
            '/api/v1/rewards/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'items': [],
              'has_more': false,
            }
          },
        ),
      );

      final result = await service.getHistory();

      expect(result.items, isEmpty);
      expect(result.hasMore, false);
    });
  });
}
