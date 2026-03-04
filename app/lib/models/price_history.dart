import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_history.freezed.dart';
part 'price_history.g.dart';

@freezed
abstract class PriceHistory with _$PriceHistory {
  const factory PriceHistory({
    required int id,
    @JsonKey(name: 'product_id') required int productId,
    required int price,
    @JsonKey(name: 'is_out_of_stock') @Default(false) bool isOutOfStock,
    @JsonKey(name: 'recorded_at') required DateTime recordedAt,
  }) = _PriceHistory;

  factory PriceHistory.fromJson(Map<String, dynamic> json) =>
      _$PriceHistoryFromJson(json);
}

@freezed
abstract class DailyPriceAggregate with _$DailyPriceAggregate {
  const factory DailyPriceAggregate({
    required String date,
    @JsonKey(name: 'min_price') required int minPrice,
    @JsonKey(name: 'max_price') required int maxPrice,
    @JsonKey(name: 'avg_price') required int avgPrice,
  }) = _DailyPriceAggregate;

  factory DailyPriceAggregate.fromJson(Map<String, dynamic> json) =>
      _$DailyPriceAggregateFromJson(json);
}
