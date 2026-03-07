import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/alert_service.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late AlertService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = AlertService(api: mockApi);
  });

  // ─── 조회 ───────────────────────────────────────────────────────────────

  group('getAlerts', () {
    test('3종 알림 목록 파싱', () async {
      when(() => mockDio.get('/api/v1/alerts/')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'price_alerts': [
                {
                  'id': 1,
                  'user_id': 10,
                  'product_id': 100,
                  'alert_type': 'target_price',
                  'target_price': 50000,
                  'is_active': true,
                },
              ],
              'category_alerts': [
                {
                  'id': 2,
                  'user_id': 10,
                  'category_id': 5,
                  'is_active': true,
                },
              ],
              'keyword_alerts': [
                {
                  'id': 3,
                  'user_id': 10,
                  'keyword': '에어팟',
                  'is_active': true,
                },
              ],
            }
          },
        ),
      );

      final result = await service.getAlerts();

      expect(result.priceAlerts.length, 1);
      expect(result.priceAlerts.first.alertType, 'target_price');
      expect(result.priceAlerts.first.targetPrice, 50000);
      expect(result.categoryAlerts.length, 1);
      expect(result.categoryAlerts.first.categoryId, 5);
      expect(result.keywordAlerts.length, 1);
      expect(result.keywordAlerts.first.keyword, '에어팟');
    });

    test('빈 알림 목록', () async {
      when(() => mockDio.get('/api/v1/alerts/')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'price_alerts': [],
              'category_alerts': [],
              'keyword_alerts': [],
            }
          },
        ),
      );

      final result = await service.getAlerts();

      expect(result.priceAlerts, isEmpty);
      expect(result.categoryAlerts, isEmpty);
      expect(result.keywordAlerts, isEmpty);
    });
  });

  // ─── 생성 ───────────────────────────────────────────────────────────────

  group('createPriceAlert', () {
    test('목표가 알림 생성', () async {
      when(() => mockDio.post(
            '/api/v1/alerts/price',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 10,
              'user_id': 1,
              'product_id': 42,
              'alert_type': 'target_price',
              'target_price': 30000,
              'is_active': true,
            }
          },
        ),
      );

      final alert = await service.createPriceAlert(
        productId: 42,
        alertType: 'target_price',
        targetPrice: 30000,
      );

      expect(alert.id, 10);
      expect(alert.productId, 42);
      expect(alert.alertType, 'target_price');
      expect(alert.targetPrice, 30000);
    });

    test('역대 최저가 알림 (targetPrice 없음)', () async {
      when(() => mockDio.post(
            '/api/v1/alerts/price',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 11,
              'user_id': 1,
              'product_id': 42,
              'alert_type': 'all_time_low',
              'is_active': true,
            }
          },
        ),
      );

      final alert = await service.createPriceAlert(
        productId: 42,
        alertType: 'all_time_low',
      );

      expect(alert.alertType, 'all_time_low');
      expect(alert.targetPrice, isNull);
    });
  });

  group('createCategoryAlert', () {
    test('카테고리 알림 생성', () async {
      when(() => mockDio.post(
            '/api/v1/alerts/category',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 20,
              'user_id': 1,
              'category_id': 5,
              'alert_condition': 'any_drop',
              'is_active': true,
            }
          },
        ),
      );

      final alert = await service.createCategoryAlert(categoryId: 5);

      expect(alert.id, 20);
      expect(alert.categoryId, 5);
      expect(alert.alertCondition, 'any_drop');
    });
  });

  group('createKeywordAlert', () {
    test('키워드 알림 생성', () async {
      when(() => mockDio.post(
            '/api/v1/alerts/keyword',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 30,
              'user_id': 1,
              'keyword': '갤럭시 버즈',
              'is_active': true,
            }
          },
        ),
      );

      final alert = await service.createKeywordAlert(keyword: '갤럭시 버즈');

      expect(alert.id, 30);
      expect(alert.keyword, '갤럭시 버즈');
    });
  });

  // ─── 수정 ───────────────────────────────────────────────────────────────

  group('updatePriceAlert', () {
    test('목표가 수정 (void 반환)', () async {
      when(() => mockDio.patch(
            '/api/v1/alerts/price/10',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'ok': true, 'data': '수정되었습니다'},
        ),
      );

      await service.updatePriceAlert(id: 10, targetPrice: 25000);

      verify(() => mockDio.patch(
            '/api/v1/alerts/price/10',
            data: {'target_price': 25000},
          )).called(1);
    });
  });

  group('updateKeywordAlert', () {
    test('키워드 수정 (void 반환)', () async {
      when(() => mockDio.patch(
            '/api/v1/alerts/keyword/30',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'ok': true, 'data': '수정되었습니다'},
        ),
      );

      await service.updateKeywordAlert(id: 30, keyword: '에어팟 맥스');

      verify(() => mockDio.patch(
            '/api/v1/alerts/keyword/30',
            data: {'keyword': '에어팟 맥스'},
          )).called(1);
    });
  });

  // ─── 토글 ───────────────────────────────────────────────────────────────

  group('토글', () {
    test('가격 알림 토글', () async {
      when(() => mockDio.patch('/api/v1/alerts/price/10/toggle')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 10,
              'user_id': 1,
              'product_id': 42,
              'alert_type': 'target_price',
              'is_active': false,
            }
          },
        ),
      );

      final alert = await service.togglePriceAlert(10);

      expect(alert.isActive, false);
    });

    test('카테고리 알림 토글', () async {
      when(() => mockDio.patch('/api/v1/alerts/category/20/toggle'))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 20,
              'user_id': 1,
              'category_id': 5,
              'is_active': false,
            }
          },
        ),
      );

      final alert = await service.toggleCategoryAlert(20);

      expect(alert.isActive, false);
    });

    test('키워드 알림 토글', () async {
      when(() => mockDio.patch('/api/v1/alerts/keyword/30/toggle')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 30,
              'user_id': 1,
              'keyword': '에어팟',
              'is_active': false,
            }
          },
        ),
      );

      final alert = await service.toggleKeywordAlert(30);

      expect(alert.isActive, false);
    });
  });

  // ─── 삭제 ───────────────────────────────────────────────────────────────

  group('삭제', () {
    test('가격 알림 삭제 (204)', () async {
      when(() => mockDio.delete('/api/v1/alerts/price/10')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );

      await service.deletePriceAlert(10);

      verify(() => mockDio.delete('/api/v1/alerts/price/10')).called(1);
    });

    test('카테고리 알림 삭제 (204)', () async {
      when(() => mockDio.delete('/api/v1/alerts/category/20')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );

      await service.deleteCategoryAlert(20);

      verify(() => mockDio.delete('/api/v1/alerts/category/20')).called(1);
    });

    test('키워드 알림 삭제 (204)', () async {
      when(() => mockDio.delete('/api/v1/alerts/keyword/30')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );

      await service.deleteKeywordAlert(30);

      verify(() => mockDio.delete('/api/v1/alerts/keyword/30')).called(1);
    });

    test('deleteAlert 범용 메서드', () async {
      when(() => mockDio.delete('/api/v1/alerts/price/99')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );

      await service.deleteAlert(type: 'price', id: 99);

      verify(() => mockDio.delete('/api/v1/alerts/price/99')).called(1);
    });
  });
}
