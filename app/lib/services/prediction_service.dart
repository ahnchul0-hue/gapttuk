import 'api_client.dart';

class PredictionService {
  final ApiClient _api;

  PredictionService({required ApiClient api}) : _api = api;

  /// AI 가격 예측 조회.
  Future<Map<String, dynamic>> getPrediction(int productId) async {
    final response = await _api.dio.get('/api/v1/predictions/$productId');
    return response.data['data'] as Map<String, dynamic>;
  }
}
