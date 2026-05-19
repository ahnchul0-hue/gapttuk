import 'dart:async';

import 'package:gapttuk_app/models/alert.dart';
import 'package:gapttuk_app/services/alert_service.dart';

/// AlertService fake (implements) -- 플랫폼 채널(ApiClient/TokenStorage) 불필요.
///
/// [response]: getAlerts()가 반환할 데이터. 기본값 빈 AlertListResponse.
/// [error]: non-null이면 getAlerts()가 예외를 던진다.
/// [slow]: true이면 getAlerts()가 영원히 pending (로딩 상태 테스트용).
class FakeAlertService implements AlertService {
  final AlertListResponse _response;
  final Exception? _error;
  final bool _slow;

  FakeAlertService({
    AlertListResponse? response,
    Exception? error,
    bool slow = false,
  })  : _response = response ?? const AlertListResponse(),
        _error = error,
        _slow = slow;

  @override
  Future<AlertListResponse> getAlerts() async {
    if (_slow) return Completer<AlertListResponse>().future;
    if (_error != null) throw _error;
    return _response;
  }

  // -- 나머지 메서드는 테스트 대상이 아니므로 UnimplementedError --

  @override
  Future<PriceAlert> createPriceAlert({
    required int productId,
    required AlertType alertType,
    int? targetPrice,
  }) =>
      throw UnimplementedError();

  @override
  Future<CategoryAlert> createCategoryAlert({required int categoryId}) =>
      throw UnimplementedError();

  @override
  Future<KeywordAlert> createKeywordAlert({required String keyword}) =>
      throw UnimplementedError();

  @override
  Future<void> updatePriceAlert({required int id, required int targetPrice}) =>
      throw UnimplementedError();

  @override
  Future<void> updateKeywordAlert({required int id, required String keyword}) =>
      throw UnimplementedError();

  @override
  Future<PriceAlert> togglePriceAlert(int id) => throw UnimplementedError();

  @override
  Future<CategoryAlert> toggleCategoryAlert(int id) =>
      throw UnimplementedError();

  @override
  Future<KeywordAlert> toggleKeywordAlert(int id) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAlert({required String type, required int id}) =>
      throw UnimplementedError();

  @override
  Future<void> deletePriceAlert(int id) => throw UnimplementedError();

  @override
  Future<void> deleteCategoryAlert(int id) => throw UnimplementedError();

  @override
  Future<void> deleteKeywordAlert(int id) => throw UnimplementedError();
}
