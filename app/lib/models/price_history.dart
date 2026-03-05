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

/// 요일별 가격 집계 — day_of_week: 0(일)~6(토), PostgreSQL EXTRACT(DOW)
@freezed
abstract class DailyPriceAggregate with _$DailyPriceAggregate {
  const factory DailyPriceAggregate({
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'avg_price') int? avgPrice,
    @JsonKey(name: 'min_price') int? minPrice,
    @JsonKey(name: 'max_price') int? maxPrice,
    @JsonKey(name: 'sample_count') @Default(0) int sampleCount,
  }) = _DailyPriceAggregate;

  factory DailyPriceAggregate.fromJson(Map<String, dynamic> json) =>
      _$DailyPriceAggregateFromJson(json);
}
