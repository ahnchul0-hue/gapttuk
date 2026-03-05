import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/price_history.dart';

void main() {
  group('PriceHistory', () {
    test('fromJson', () {
      final json = {
        'id': 1,
        'product_id': 100,
        'price': 29900,
        'is_out_of_stock': false,
        'recorded_at': '2026-03-01T06:00:00.000Z',
      };

      final ph = PriceHistory.fromJson(json);

      expect(ph.id, 1);
      expect(ph.productId, 100);
      expect(ph.price, 29900);
      expect(ph.isOutOfStock, false);
      expect(ph.recordedAt.year, 2026);
    });

    test('품절 상태', () {
      final json = {
        'id': 2,
        'product_id': 100,
        'price': 0,
        'is_out_of_stock': true,
        'recorded_at': '2026-03-02T06:00:00.000Z',
      };

      expect(PriceHistory.fromJson(json).isOutOfStock, true);
    });

    test('toJson 라운드트립', () {
      final original = PriceHistory(
        id: 3,
        productId: 50,
        price: 15000,
        recordedAt: DateTime.utc(2026, 3, 1),
      );

      final restored = PriceHistory.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.price, original.price);
      expect(restored.recordedAt, original.recordedAt);
    });
  });

  group('DailyPriceAggregate', () {
    test('fromJson — 일요일(0)', () {
      final json = {
        'day_of_week': 0,
        'avg_price': 25000,
        'min_price': 20000,
        'max_price': 30000,
        'sample_count': 12,
      };

      final agg = DailyPriceAggregate.fromJson(json);

      expect(agg.dayOfWeek, 0);
      expect(agg.avgPrice, 25000);
      expect(agg.minPrice, 20000);
      expect(agg.maxPrice, 30000);
      expect(agg.sampleCount, 12);
    });

    test('sampleCount 기본값 0', () {
      final json = {'day_of_week': 6};
      expect(DailyPriceAggregate.fromJson(json).sampleCount, 0);
    });

    test('7일 전체 요일 파싱', () {
      final days = List.generate(
        7,
        (i) => DailyPriceAggregate.fromJson({
          'day_of_week': i,
          'avg_price': 10000 + i * 1000,
        }),
      );

      expect(days.length, 7);
      expect(days.first.dayOfWeek, 0); // 일요일
      expect(days.last.dayOfWeek, 6); // 토요일
    });
  });
}
