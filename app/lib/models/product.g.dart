// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  productName: json['product_name'] as String,
  productUrl: json['product_url'] as String,
  imageUrl: json['image_url'] as String?,
  currentPrice: (json['current_price'] as num?)?.toInt(),
  lowestPrice: (json['lowest_price'] as num?)?.toInt(),
  highestPrice: (json['highest_price'] as num?)?.toInt(),
  averagePrice: (json['average_price'] as num?)?.toInt(),
  priceTrend: json['price_trend'] as String?,
  buyTimingScore: (json['buy_timing_score'] as num?)?.toInt(),
  isOutOfStock: json['is_out_of_stock'] as bool? ?? false,
  source: json['source'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'product_name': instance.productName,
  'product_url': instance.productUrl,
  'image_url': instance.imageUrl,
  'current_price': instance.currentPrice,
  'lowest_price': instance.lowestPrice,
  'highest_price': instance.highestPrice,
  'average_price': instance.averagePrice,
  'price_trend': instance.priceTrend,
  'buy_timing_score': instance.buyTimingScore,
  'is_out_of_stock': instance.isOutOfStock,
  'source': instance.source,
  'category': instance.category,
};
