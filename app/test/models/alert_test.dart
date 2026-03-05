import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/alert.dart';

void main() {
  group('PriceAlert', () {
    test('fromJson — target_price 타입', () {
      final json = {
        'id': 1,
        'user_id': 10,
        'product_id': 100,
        'alert_type': 'target_price',
        'target_price': 25000,
        'is_active': true,
        'created_at': '2026-03-01T00:00:00.000Z',
      };

      final alert = PriceAlert.fromJson(json);

      expect(alert.id, 1);
      expect(alert.alertType, 'target_price');
      expect(alert.targetPrice, 25000);
      expect(alert.isActive, true);
    });

    test('fromJson — below_average 타입 (target_price 없음)', () {
      final json = {
        'id': 2,
        'user_id': 10,
        'product_id': 100,
        'alert_type': 'below_average',
      };

      final alert = PriceAlert.fromJson(json);

      expect(alert.alertType, 'below_average');
      expect(alert.targetPrice, isNull);
      expect(alert.isActive, true); // @Default(true)
    });
  });

  group('CategoryAlert', () {
    test('fromJson', () {
      final json = {
        'id': 3,
        'user_id': 10,
        'category_id': 5,
        'alert_condition': 'percent_drop',
        'threshold_percent': 15,
        'max_price': 50000,
        'is_active': false,
      };

      final alert = CategoryAlert.fromJson(json);

      expect(alert.categoryId, 5);
      expect(alert.alertCondition, 'percent_drop');
      expect(alert.thresholdPercent, 15);
      expect(alert.isActive, false);
    });

    test('alertCondition 기본값 any_drop', () {
      final json = {
        'id': 1,
        'user_id': 1,
        'category_id': 1,
      };
      expect(CategoryAlert.fromJson(json).alertCondition, 'any_drop');
    });
  });

  group('KeywordAlert', () {
    test('fromJson', () {
      final json = {
        'id': 5,
        'user_id': 10,
        'keyword': '아이폰',
        'category_id': 2,
        'max_price': 1000000,
        'is_active': true,
      };

      final alert = KeywordAlert.fromJson(json);

      expect(alert.keyword, '아이폰');
      expect(alert.categoryId, 2);
      expect(alert.maxPrice, 1000000);
    });
  });

  group('AlertListResponse', () {
    test('fromJson — 혼합 알림', () {
      final json = {
        'price_alerts': [
          {'id': 1, 'user_id': 1, 'product_id': 1, 'alert_type': 'target_price'},
        ],
        'category_alerts': [
          {'id': 2, 'user_id': 1, 'category_id': 1},
        ],
        'keyword_alerts': [
          {'id': 3, 'user_id': 1, 'keyword': '갤럭시'},
        ],
      };

      final response = AlertListResponse.fromJson(json);

      expect(response.priceAlerts.length, 1);
      expect(response.categoryAlerts.length, 1);
      expect(response.keywordAlerts.length, 1);
      expect(response.keywordAlerts.first.keyword, '갤럭시');
    });

    test('빈 응답 — 기본값 빈 리스트', () {
      final response = AlertListResponse.fromJson({});

      expect(response.priceAlerts, isEmpty);
      expect(response.categoryAlerts, isEmpty);
      expect(response.keywordAlerts, isEmpty);
    });
  });
}
