import '../config/constants.dart';
import '../models/price_history.dart';
import '../models/product.dart';
import 'api_client.dart';

/// 상품 API 호출.
class ProductService {
  final ApiClient _api;

  ProductService({required ApiClient api}) : _api = api;

  /// 상품 상세 조회.
  Future<Product> getProduct(int productId) async {
    final response = await _api.dio.get('/api/v1/products/$productId');
    return Product.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// 상품 검색 (커서 페이지네이션).
  Future<({List<Product> products, String? cursor, bool hasMore})> search({
    required String query,
    String? sort,
    String? cursor,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final response = await _api.dio.get(
      '/api/v1/products/search',
      queryParameters: {
        'q': query,
        'limit': limit,
        if (sort != null) 'sort': sort,
        if (cursor != null) 'cursor': cursor,
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
  Future<Product> addByUrl(String url) async {
    final response = await _api.dio.post(
      '/api/v1/products/url',
      data: {'url': url},
    );
    return Product.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// 가격 히스토리 조회.
  Future<List<PriceHistory>> getPriceHistory(int productId) async {
    final response =
        await _api.dio.get('/api/v1/products/$productId/prices');
    return (response.data['data'] as List)
        .map((e) => PriceHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 일별 가격 집계 조회.
  Future<List<DailyPriceAggregate>> getDailyPrices(
    int productId, {
    int days = 30,
  }) async {
    final response = await _api.dio.get(
      '/api/v1/products/$productId/prices/daily',
      queryParameters: {'days': days},
    );
    return (response.data['data'] as List)
        .map((e) => DailyPriceAggregate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 인기 검색어 조회.
  Future<List<Map<String, dynamic>>> getPopularSearches() async {
    final response = await _api.dio.get('/api/v1/products/popular');
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }
}
