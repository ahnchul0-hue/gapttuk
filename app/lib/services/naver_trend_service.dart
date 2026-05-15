import '../config/api_endpoints.dart';
import '../models/demographic_trend.dart';
import '../models/naver_trend.dart';
import 'api_client.dart';

/// 네이버 트렌드 데이터 API 호출.
/// 서버의 GET /api/v1/trends/naver + /api/v1/trends/demographic/:category 를 통해 데이터 반환.
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

  /// 카테고리 인구통계 트렌드 조회 — 연령/성별/기기 3종.
  /// [categoryCode]: 네이버 쇼핑 카테고리 코드 (예: '50000151')
  Future<List<DemographicTrend>> getDemographicTrends(
    String categoryCode,
  ) async {
    final response = await _api.dio.get(
      ApiEndpoints.demographicTrends(categoryCode),
    );
    return (response.data['data'] as List)
        .map((e) => DemographicTrend.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
