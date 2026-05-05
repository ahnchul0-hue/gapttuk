import '../config/api_endpoints.dart';
import '../models/naver_trend.dart';
import 'api_client.dart';

/// 네이버 트렌드 데이터 API 호출.
/// 서버의 GET /api/v1/trends/naver 엔드포인트를 통해 Naver Datalab 데이터를 반환.
class NaverTrendService {
  final ApiClient _api;

  NaverTrendService({required ApiClient api}) : _api = api;

  /// 기본 3개 카테고리(생활용품/식품/가전) 6개월 트렌드 조회.
  Future<List<CategoryTrend>> getCategoryTrends() async {
    final response = await _api.dio.get(ApiEndpoints.naverTrends);
    return (response.data['data'] as List)
        .map((e) => CategoryTrend.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
