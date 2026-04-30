import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// 가격 추세 — 서버 PriceTrend enum과 1:1 대응.
enum PriceTrend {
  @JsonValue('rising')
  rising,
  @JsonValue('falling')
  falling,
  @JsonValue('stable')
  stable,
}

/// PriceTrend → API 요청에 사용하는 snake_case 문자열 변환.
extension PriceTrendX on PriceTrend {
  String get value => switch (this) {
        PriceTrend.rising => 'rising',
        PriceTrend.falling => 'falling',
        PriceTrend.stable => 'stable',
      };
}

/// 서버 Product — 상품 상세 + 검색 결과 공용
@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    @JsonKey(name: 'shopping_mall_id') int? shoppingMallId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_url') String? productUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'current_price') int? currentPrice,
    @JsonKey(name: 'lowest_price') int? lowestPrice,
    @JsonKey(name: 'highest_price') int? highestPrice,
    @JsonKey(name: 'average_price') int? averagePrice,
    @JsonKey(name: 'price_trend') PriceTrend? priceTrend,
    @JsonKey(name: 'buy_timing_score') int? buyTimingScore,
    @JsonKey(name: 'days_since_lowest') int? daysSinceLowest,
    @JsonKey(name: 'drop_from_average') int? dropFromAverage,
    @JsonKey(name: 'is_out_of_stock') @Default(false) bool isOutOfStock,
    @JsonKey(name: 'review_count') int? reviewCount,
    @JsonKey(name: 'price_updated_at') DateTime? priceUpdatedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

/// URL로 상품 추가 응답 — POST /products/url
@freezed
abstract class AddProductResponse with _$AddProductResponse {
  const factory AddProductResponse({
    required int id,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_url') String? productUrl,
    @JsonKey(name: 'shopping_mall_id') required int shoppingMallId,
    @JsonKey(name: 'is_new') @Default(false) bool isNew,
  }) = _AddProductResponse;

  factory AddProductResponse.fromJson(Map<String, dynamic> json) =>
      _$AddProductResponseFromJson(json);
}

/// 인기 검색어
@freezed
abstract class PopularSearch with _$PopularSearch {
  const factory PopularSearch({
    required int id,
    required String keyword,
    @JsonKey(name: 'search_count') required int searchCount,
    required int rank,
    String? trend,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PopularSearch;

  factory PopularSearch.fromJson(Map<String, dynamic> json) =>
      _$PopularSearchFromJson(json);
}
