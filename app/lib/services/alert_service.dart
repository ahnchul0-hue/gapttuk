import '../models/alert.dart';
import 'api_client.dart';

/// 알림 설정 API 호출.
class AlertService {
  final ApiClient _api;

  AlertService({required ApiClient api}) : _api = api;

  // ─── 조회 ─────────────────────────────────────────────────────────────────

  /// 전체 알림 목록 조회.
  ///
  /// GET /api/v1/alerts/
  /// 응답: { price_alerts, category_alerts, keyword_alerts }
  Future<AlertListResponse> getAlerts() async {
    final response = await _api.dio.get('/api/v1/alerts/');
    return AlertListResponse.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  // ─── 생성 ─────────────────────────────────────────────────────────────────

  /// 가격 알림 생성.
  ///
  /// POST /api/v1/alerts/price
  /// [alertType]: 'target_price' | 'below_average' | 'near_lowest' | 'all_time_low'
  /// [targetPrice]: alertType == 'target_price' 일 때 필수.
  Future<PriceAlert> createPriceAlert({
    required int productId,
    required String alertType,
    int? targetPrice,
  }) async {
    final response = await _api.dio.post(
      '/api/v1/alerts/price',
      data: {
        'product_id': productId,
        'alert_type': alertType,
        'target_price': ?targetPrice,
      },
    );
    return PriceAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 카테고리 알림 생성.
  ///
  /// POST /api/v1/alerts/category
  Future<CategoryAlert> createCategoryAlert({
    required int categoryId,
  }) async {
    final response = await _api.dio.post(
      '/api/v1/alerts/category',
      data: {'category_id': categoryId},
    );
    return CategoryAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 키워드 알림 생성.
  ///
  /// POST /api/v1/alerts/keyword
  Future<KeywordAlert> createKeywordAlert({
    required String keyword,
  }) async {
    final response = await _api.dio.post(
      '/api/v1/alerts/keyword',
      data: {'keyword': keyword},
    );
    return KeywordAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  // ─── 수정 ─────────────────────────────────────────────────────────────────

  /// 가격 알림 목표가 수정.
  ///
  /// PATCH /api/v1/alerts/price/{id}
  Future<PriceAlert> updatePriceAlert({
    required int id,
    required int targetPrice,
  }) async {
    final response = await _api.dio.patch(
      '/api/v1/alerts/price/$id',
      data: {'target_price': targetPrice},
    );
    return PriceAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 키워드 알림 키워드 수정.
  ///
  /// PATCH /api/v1/alerts/keyword/{id}
  Future<KeywordAlert> updateKeywordAlert({
    required int id,
    required String keyword,
  }) async {
    final response = await _api.dio.patch(
      '/api/v1/alerts/keyword/$id',
      data: {'keyword': keyword},
    );
    return KeywordAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  // ─── 토글 ─────────────────────────────────────────────────────────────────

  /// 가격 알림 활성/비활성 토글.
  ///
  /// PATCH /api/v1/alerts/price/{id}/toggle
  Future<PriceAlert> togglePriceAlert(int id) async {
    final response =
        await _api.dio.patch('/api/v1/alerts/price/$id/toggle');
    return PriceAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 카테고리 알림 활성/비활성 토글.
  ///
  /// PATCH /api/v1/alerts/category/{id}/toggle
  Future<CategoryAlert> toggleCategoryAlert(int id) async {
    final response =
        await _api.dio.patch('/api/v1/alerts/category/$id/toggle');
    return CategoryAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 키워드 알림 활성/비활성 토글.
  ///
  /// PATCH /api/v1/alerts/keyword/{id}/toggle
  Future<KeywordAlert> toggleKeywordAlert(int id) async {
    final response =
        await _api.dio.patch('/api/v1/alerts/keyword/$id/toggle');
    return KeywordAlert.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  // ─── 삭제 ─────────────────────────────────────────────────────────────────

  /// 알림 삭제 (204 No Content).
  ///
  /// DELETE /api/v1/alerts/{type}/{id}
  /// [type]: 'price' | 'category' | 'keyword'
  Future<void> deleteAlert({
    required String type,
    required int id,
  }) async {
    await _api.dio.delete('/api/v1/alerts/$type/$id');
  }

  /// 가격 알림 삭제.
  Future<void> deletePriceAlert(int id) => deleteAlert(type: 'price', id: id);

  /// 카테고리 알림 삭제.
  Future<void> deleteCategoryAlert(int id) =>
      deleteAlert(type: 'category', id: id);

  /// 키워드 알림 삭제.
  Future<void> deleteKeywordAlert(int id) =>
      deleteAlert(type: 'keyword', id: id);
}
