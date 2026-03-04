import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_url') required String productUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'current_price') int? currentPrice,
    @JsonKey(name: 'lowest_price') int? lowestPrice,
    @JsonKey(name: 'highest_price') int? highestPrice,
    @JsonKey(name: 'average_price') int? averagePrice,
    @JsonKey(name: 'price_trend') String? priceTrend,
    @JsonKey(name: 'buy_timing_score') int? buyTimingScore,
    @JsonKey(name: 'is_out_of_stock') @Default(false) bool isOutOfStock,
    String? source,
    String? category,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
