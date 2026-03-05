import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/product.dart';

void main() {
  group('Product', () {
    test('fromJson — 전체 필드', () {
      final json = {
        'id': 1,
        'shopping_mall_id': 10,
        'category_id': 3,
        'product_name': '테스트 상품',
        'product_url': 'https://example.com/product/1',
        'image_url': 'https://example.com/img.jpg',
        'current_price': 29900,
        'lowest_price': 19900,
        'highest_price': 39900,
        'average_price': 28000,
        'price_trend': 'falling',
        'buy_timing_score': 85,
        'days_since_lowest': 7,
        'drop_from_average': 12,
        'is_out_of_stock': false,
        'review_count': 150,
        'price_updated_at': '2026-03-01T12:00:00.000Z',
        'created_at': '2026-01-01T00:00:00.000Z',
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.shoppingMallId, 10);
      expect(product.categoryId, 3);
      expect(product.productName, '테스트 상품');
      expect(product.productUrl, 'https://example.com/product/1');
      expect(product.imageUrl, 'https://example.com/img.jpg');
      expect(product.currentPrice, 29900);
      expect(product.lowestPrice, 19900);
      expect(product.highestPrice, 39900);
      expect(product.averagePrice, 28000);
      expect(product.priceTrend, 'falling');
      expect(product.buyTimingScore, 85);
      expect(product.daysSinceLowest, 7);
      expect(product.dropFromAverage, 12);
      expect(product.isOutOfStock, false);
      expect(product.reviewCount, 150);
      expect(product.priceUpdatedAt, isNotNull);
      expect(product.createdAt, isNotNull);
    });

    test('fromJson — 최소 필드 (nullable 생략)', () {
      final json = {
        'id': 2,
        'product_name': '최소 상품',
      };

      final product = Product.fromJson(json);

      expect(product.id, 2);
      expect(product.productName, '최소 상품');
      expect(product.currentPrice, isNull);
      expect(product.imageUrl, isNull);
      expect(product.isOutOfStock, false); // @Default(false)
    });

    test('toJson 라운드트립', () {
      final original = Product(
        id: 3,
        productName: '라운드트립',
        currentPrice: 15000,
        priceTrend: 'rising',
      );

      final json = original.toJson();
      final restored = Product.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.productName, original.productName);
      expect(restored.currentPrice, original.currentPrice);
      expect(restored.priceTrend, original.priceTrend);
    });

    test('equality — freezed 값 비교', () {
      final a = Product(id: 1, productName: '상품');
      final b = Product(id: 1, productName: '상품');
      final c = Product(id: 2, productName: '상품');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('copyWith', () {
      final product = Product(id: 1, productName: '원본', currentPrice: 10000);
      final updated = product.copyWith(currentPrice: 8000);

      expect(updated.currentPrice, 8000);
      expect(updated.productName, '원본'); // 변경 안 됨
      expect(product.currentPrice, 10000); // 원본 불변
    });
  });

  group('AddProductResponse', () {
    test('fromJson', () {
      final json = {
        'id': 42,
        'product_name': 'URL 추가 상품',
        'product_url': 'https://coupang.com/product/42',
        'shopping_mall_id': 1,
        'is_new': true,
      };

      final response = AddProductResponse.fromJson(json);

      expect(response.id, 42);
      expect(response.productName, 'URL 추가 상품');
      expect(response.isNew, true);
    });

    test('isNew 기본값 false', () {
      final json = {
        'id': 1,
        'product_name': '기존',
        'shopping_mall_id': 1,
      };
      expect(AddProductResponse.fromJson(json).isNew, false);
    });
  });

  group('PopularSearch', () {
    test('fromJson', () {
      final json = {
        'id': 1,
        'keyword': '에어팟',
        'search_count': 500,
        'rank': 1,
        'trend': 'up',
        'updated_at': '2026-03-01T00:00:00.000Z',
      };

      final ps = PopularSearch.fromJson(json);

      expect(ps.keyword, '에어팟');
      expect(ps.searchCount, 500);
      expect(ps.rank, 1);
      expect(ps.trend, 'up');
    });
  });
}
