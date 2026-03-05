// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  shoppingMallId: (json['shopping_mall_id'] as num?)?.toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
  productName: json['product_name'] as String,
  productUrl: json['product_url'] as String?,
  imageUrl: json['image_url'] as String?,
  currentPrice: (json['current_price'] as num?)?.toInt(),
  lowestPrice: (json['lowest_price'] as num?)?.toInt(),
  highestPrice: (json['highest_price'] as num?)?.toInt(),
  averagePrice: (json['average_price'] as num?)?.toInt(),
  priceTrend: json['price_trend'] as String?,
  buyTimingScore: (json['buy_timing_score'] as num?)?.toInt(),
  daysSinceLowest: (json['days_since_lowest'] as num?)?.toInt(),
  dropFromAverage: (json['drop_from_average'] as num?)?.toInt(),
  isOutOfStock: json['is_out_of_stock'] as bool? ?? false,
  reviewCount: (json['review_count'] as num?)?.toInt(),
  priceUpdatedAt: json['price_updated_at'] == null
      ? null
      : DateTime.parse(json['price_updated_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'shopping_mall_id': instance.shoppingMallId,
  'category_id': instance.categoryId,
  'product_name': instance.productName,
  'product_url': instance.productUrl,
  'image_url': instance.imageUrl,
  'current_price': instance.currentPrice,
  'lowest_price': instance.lowestPrice,
  'highest_price': instance.highestPrice,
  'average_price': instance.averagePrice,
  'price_trend': instance.priceTrend,
  'buy_timing_score': instance.buyTimingScore,
  'days_since_lowest': instance.daysSinceLowest,
  'drop_from_average': instance.dropFromAverage,
  'is_out_of_stock': instance.isOutOfStock,
  'review_count': instance.reviewCount,
  'price_updated_at': instance.priceUpdatedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};

_AddProductResponse _$AddProductResponseFromJson(Map<String, dynamic> json) =>
    _AddProductResponse(
      id: (json['id'] as num).toInt(),
      productName: json['product_name'] as String,
      productUrl: json['product_url'] as String?,
      shoppingMallId: (json['shopping_mall_id'] as num).toInt(),
      isNew: json['is_new'] as bool? ?? false,
    );

Map<String, dynamic> _$AddProductResponseToJson(_AddProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'product_url': instance.productUrl,
      'shopping_mall_id': instance.shoppingMallId,
      'is_new': instance.isNew,
    };

_PopularSearch _$PopularSearchFromJson(Map<String, dynamic> json) =>
    _PopularSearch(
      id: (json['id'] as num).toInt(),
      keyword: json['keyword'] as String,
      searchCount: (json['search_count'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      trend: json['trend'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PopularSearchToJson(_PopularSearch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyword': instance.keyword,
      'search_count': instance.searchCount,
      'rank': instance.rank,
      'trend': instance.trend,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
