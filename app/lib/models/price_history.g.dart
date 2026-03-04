// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceHistory _$PriceHistoryFromJson(Map<String, dynamic> json) =>
    _PriceHistory(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      isOutOfStock: json['is_out_of_stock'] as bool? ?? false,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );

Map<String, dynamic> _$PriceHistoryToJson(_PriceHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'price': instance.price,
      'is_out_of_stock': instance.isOutOfStock,
      'recorded_at': instance.recordedAt.toIso8601String(),
    };

_DailyPriceAggregate _$DailyPriceAggregateFromJson(Map<String, dynamic> json) =>
    _DailyPriceAggregate(
      date: json['date'] as String,
      minPrice: (json['min_price'] as num).toInt(),
      maxPrice: (json['max_price'] as num).toInt(),
      avgPrice: (json['avg_price'] as num).toInt(),
    );

Map<String, dynamic> _$DailyPriceAggregateToJson(
  _DailyPriceAggregate instance,
) => <String, dynamic>{
  'date': instance.date,
  'min_price': instance.minPrice,
  'max_price': instance.maxPrice,
  'avg_price': instance.avgPrice,
};
