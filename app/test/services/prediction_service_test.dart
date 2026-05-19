import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/prediction_result.dart';
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
              'predicted_action': 'buy_now',
              'confidence': '0.85',
            }
          },
        ),
      );

      final prediction = await service.getPrediction(42);

      expect(prediction?.predictedAction, PredictionAction.buyNow);
      expect(prediction?.confidence, closeTo(0.85, 0.001));
    });

    test('AI 예측 조회 — wait', () async {
      when(() => mockDio.get('/api/v1/predictions/99')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'predicted_action': 'wait',
              'confidence': '0.70',
            }
          },
        ),
      );

      final prediction = await service.getPrediction(99);

      expect(prediction?.predictedAction, PredictionAction.wait);
      expect(prediction?.confidence, closeTo(0.70, 0.001));
    });

    test('예측 데이터 없으면 null 반환', () async {
      when(() => mockDio.get('/api/v1/predictions/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'data': {}},
        ),
      );

      final prediction = await service.getPrediction(1);

      expect(prediction, isNull);
    });
  });
}
