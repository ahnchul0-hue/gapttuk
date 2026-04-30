import '../config/api_endpoints.dart';
import '../models/prediction_result.dart';
import 'api_client.dart';

class PredictionService {
  final ApiClient _api;

  PredictionService({required ApiClient api}) : _api = api;

  /// AI 가격 예측 조회. 예측 데이터 없으면 null 반환.
  Future<PredictionResult?> getPrediction(int productId) async {
    final response = await _api.dio.get(ApiEndpoints.prediction(productId));
    final data = Map<String, dynamic>.from(response.data['data'] as Map);
    if (data.isEmpty) return null;
    return PredictionResult.fromJson(data);
  }
}
