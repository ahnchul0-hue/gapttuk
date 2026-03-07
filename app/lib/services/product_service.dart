import '../config/api_endpoints.dart';
import '../config/constants.dart';
import '../models/monthly_price.dart';
import '../models/price_history.dart';
import '../models/product.dart';
import 'api_client.dart';

/// 상품 API 호출.
class ProductService {
  final ApiClient _api;

  ProductService({required ApiClient api}) : _api = api;

  /// 상품 상세 조회.
  Future<Product> getProduct(int productId) async {
    final response = await _api.dio.get(ApiEndpoints.product(productId));
    return Product.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// 상품 검색 (커서 페이지네이션).
  Future<({List<Product> products, String? cursor, bool hasMore})> search({
    required String query,
    String? sort,
    String? filter,
    String? cursor,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final response = await _api.dio.get(
      ApiEndpoints.productSearch,
      queryParameters: {
        'q': query,
        'limit': limit,
        'sort': ?sort,
        'filter': ?filter,
        'cursor': ?cursor,
      },
    );
    final data = response.data;
    final products = (data['data'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    return (
      products: products,
      cursor: data['cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  /// URL로 상품 추가/조회.
  Future<AddProductResponse> addByUrl(String url) async {
    final response = await _api.dio.post(
      ApiEndpoints.productUrl,
      data: {'url': url},
    );
    return AddProductResponse.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// 가격 히스토리 조회 (커서 페이지네이션).
  Future<({List<PriceHistory> prices, String? cursor, bool hasMore})>
      getPriceHistory(
    int productId, {
    String? from,
    String? to,
    String? cursor,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final response = await _api.dio.get(
      ApiEndpoints.productPrices(productId),
      queryParameters: {
        'limit': limit,
        'from': ?from,
        'to': ?to,
        'cursor': ?cursor,
      },
    );
    final data = response.data;
    final prices = (data['data'] as List)
        .map((e) => PriceHistory.fromJson(e as Map<String, dynamic>))
        .toList();
    return (
      prices: prices,
      cursor: data['cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  /// 요일별 가격 집계 조회.
  Future<List<DailyPriceAggregate>> getDailyPrices(int productId) async {
    final response =
        await _api.dio.get(ApiEndpoints.productDailyPrices(productId));
    return (response.data['data'] as List)
        .map((e) => DailyPriceAggregate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 월별 평균 가격 조회 (장기 추이).
  Future<List<MonthlyPrice>> getMonthlyPrices(int productId, {int months = 24}) async {
    final response = await _api.dio.get(
      ApiEndpoints.productMonthlyPrices(productId),
      queryParameters: {'months': months},
    );
    return (response.data['data'] as List)
        .map((e) => MonthlyPrice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 인기 검색어 조회.
  Future<List<PopularSearch>> getPopularSearches({int limit = 10}) async {
    final response = await _api.dio.get(
      ApiEndpoints.productPopular,
      queryParameters: {'limit': limit},
    );
    return (response.data['data'] as List)
        .map((e) => PopularSearch.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
