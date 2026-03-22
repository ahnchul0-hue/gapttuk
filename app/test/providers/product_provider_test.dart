import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/price_history.dart';
import 'package:gapttuk_app/models/product.dart';
import 'package:gapttuk_app/providers/product_provider.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/product_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

class MockProductService extends Mock implements ProductService {}

ProviderContainer buildContainer(ProductService mockService) {
  return ProviderContainer(
    overrides: [
      productServiceProvider.overrideWith((_) => mockService),
    ],
  );
}

void main() {
  late MockProductService mockService;

  setUp(() {
    mockService = MockProductService();
  });

  tearDown(() {
    reset(mockService);
  });

  group('productDetailProvider', () {
    test('getProduct 성공 시 Product 반환', () async {
      const product = Product(id: 1, productName: '에어팟 프로');
      when(() => mockService.getProduct(1)).thenAnswer((_) async => product);

      final container = buildContainer(mockService);
      addTearDown(container.dispose);

      final result = await container.read(productDetailProvider(1).future);
      expect(result.id, 1);
      expect(result.productName, '에어팟 프로');
      verify(() => mockService.getProduct(1)).called(1);
    });

    test('getProduct mock 호출 확인', () async {
      const product = Product(id: 2, productName: '갤럭시 버즈');
      when(() => mockService.getProduct(2)).thenAnswer((_) async => product);

      final container = buildContainer(mockService);
      addTearDown(container.dispose);

      final result = await container.read(productDetailProvider(2).future);
      expect(result.productName, '갤럭시 버즈');
      verify(() => mockService.getProduct(2)).called(1);
    });
  });

  group('dailyPricesProvider', () {
    test('getDailyPrices 성공 시 목록 반환', () async {
      final prices = [
        DailyPriceAggregate(
          dayOfWeek: 1,
          avgPrice: 320000,
          minPrice: 300000,
          maxPrice: 340000,
          sampleCount: 5,
        ),
      ];
      when(() => mockService.getDailyPrices(1)).thenAnswer((_) async => prices);

      final container = buildContainer(mockService);
      addTearDown(container.dispose);

      final result = await container.read(dailyPricesProvider(1).future);
      expect(result.length, 1);
      expect(result.first.avgPrice, 320000);
    });
  });

  group('popularSearchesProvider', () {
    test('getPopularSearches 성공 시 목록 반환', () async {
      final searches = [
        PopularSearch(rank: 1, keyword: '아이폰 15', id: 1, searchCount: 100),
        PopularSearch(rank: 2, keyword: '갤럭시 S24', id: 2, searchCount: 80),
      ];
      when(() => mockService.getPopularSearches())
          .thenAnswer((_) async => searches);

      final container = buildContainer(mockService);
      addTearDown(container.dispose);

      final result = await container.read(popularSearchesProvider.future);
      expect(result.length, 2);
      expect(result.first.keyword, '아이폰 15');
    });

    test('getPopularSearches 빈 목록 반환', () async {
      when(() => mockService.getPopularSearches()).thenAnswer((_) async => []);

      final container = buildContainer(mockService);
      addTearDown(container.dispose);

      final result = await container.read(popularSearchesProvider.future);
      expect(result, isEmpty);
    });
  });
}
