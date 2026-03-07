import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/prediction_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late PredictionService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = PredictionService(api: mockApi);
  });

  group('getPrediction', () {
    test('AI 예측 조회 — buy_now', () async {
      when(() => mockDio.get('/api/v1/predictions/42')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'product_id': 42,
              'action': 'buy_now',
              'confidence': 85,
              'trend': 'falling',
              'buy_timing_score': 92,
              'reason': '최근 30일간 하락 추세이며 역대 최저가에 근접합니다.',
            }
          },
        ),
      );

      final prediction = await service.getPrediction(42);

      expect(prediction['product_id'], 42);
      expect(prediction['action'], 'buy_now');
      expect(prediction['confidence'], 85);
      expect(prediction['trend'], 'falling');
    });

    test('AI 예측 조회 — wait', () async {
      when(() => mockDio.get('/api/v1/predictions/99')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'product_id': 99,
              'action': 'wait',
              'confidence': 70,
              'trend': 'rising',
              'buy_timing_score': 35,
              'reason': '가격이 상승 중입니다. 하락을 기다리세요.',
            }
          },
        ),
      );

      final prediction = await service.getPrediction(99);

      expect(prediction['action'], 'wait');
      expect(prediction['trend'], 'rising');
      expect(prediction['buy_timing_score'], 35);
    });
  });
}
