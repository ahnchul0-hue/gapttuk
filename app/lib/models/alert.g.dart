// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceAlert _$PriceAlertFromJson(Map<String, dynamic> json) => _PriceAlert(
  id: (json['id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  targetPrice: (json['target_price'] as num).toInt(),
  isActive: json['is_active'] as bool? ?? true,
  productName: json['product_name'] as String?,
  currentPrice: (json['current_price'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PriceAlertToJson(_PriceAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'target_price': instance.targetPrice,
      'is_active': instance.isActive,
      'product_name': instance.productName,
      'current_price': instance.currentPrice,
      'created_at': instance.createdAt?.toIso8601String(),
    };
