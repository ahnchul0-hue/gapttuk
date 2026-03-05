import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/product_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late ProductService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = ProductService(api: mockApi);
  });

  group('getProduct', () {
    test('정상 응답 파싱', () async {
      when(() => mockDio.get('/api/v1/products/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 1,
              'product_name': '에어팟 프로',
              'current_price': 329000,
            }
          },
        ),
      );

      final product = await service.getProduct(1);

      expect(product.id, 1);
      expect(product.productName, '에어팟 프로');
      expect(product.currentPrice, 329000);
      verify(() => mockDio.get('/api/v1/products/1')).called(1);
    });
  });

  group('search', () {
    test('검색 결과 + 페이지네이션', () async {
      when(() => mockDio.get(
            '/api/v1/products/search',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': [
              {'id': 1, 'product_name': '결과 1'},
              {'id': 2, 'product_name': '결과 2'},
            ],
            'cursor': 'next_cursor_token',
            'has_more': true,
          },
        ),
      );

      final result = await service.search(query: '에어팟');

      expect(result.products.length, 2);
      expect(result.cursor, 'next_cursor_token');
      expect(result.hasMore, true);
    });

    test('빈 결과', () async {
      when(() => mockDio.get(
            '/api/v1/products/search',
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

      final result = await service.search(query: '존재하지않는상품');

      expect(result.products, isEmpty);
      expect(result.hasMore, false);
    });
  });

  group('addByUrl', () {
    test('URL 상품 추가', () async {
      when(() => mockDio.post(
            '/api/v1/products/url',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 42,
              'product_name': '쿠팡 상품',
              'product_url': 'https://coupang.com/42',
              'shopping_mall_id': 1,
              'is_new': true,
            }
          },
        ),
      );

      final result = await service.addByUrl('https://coupang.com/42');

      expect(result.id, 42);
      expect(result.isNew, true);
    });
  });

  group('getDailyPrices', () {
    test('7일 집계 데이터', () async {
      when(() => mockDio.get('/api/v1/products/1/prices/daily')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': List.generate(
              7,
              (i) => {
                'day_of_week': i,
                'avg_price': 20000 + i * 500,
                'sample_count': 10,
              },
            ),
          },
        ),
      );

      final prices = await service.getDailyPrices(1);

      expect(prices.length, 7);
      expect(prices.first.dayOfWeek, 0);
      expect(prices.last.dayOfWeek, 6);
    });
  });

  group('getPopularSearches', () {
    test('인기 검색어 조회', () async {
      when(() => mockDio.get(
            '/api/v1/products/popular',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': [
              {'id': 1, 'keyword': '에어팟', 'search_count': 100, 'rank': 1},
              {'id': 2, 'keyword': '갤럭시', 'search_count': 80, 'rank': 2},
            ],
          },
        ),
      );

      final searches = await service.getPopularSearches();

      expect(searches.length, 2);
      expect(searches.first.keyword, '에어팟');
    });
  });
}
