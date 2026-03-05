// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceAlert _$PriceAlertFromJson(Map<String, dynamic> json) => _PriceAlert(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  alertType: json['alert_type'] as String,
  targetPrice: (json['target_price'] as num?)?.toInt(),
  isActive: json['is_active'] as bool? ?? true,
  lastTriggeredAt: json['last_triggered_at'] == null
      ? null
      : DateTime.parse(json['last_triggered_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PriceAlertToJson(_PriceAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'alert_type': instance.alertType,
      'target_price': instance.targetPrice,
      'is_active': instance.isActive,
      'last_triggered_at': instance.lastTriggeredAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_CategoryAlert _$CategoryAlertFromJson(Map<String, dynamic> json) =>
    _CategoryAlert(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      categoryId: (json['category_id'] as num).toInt(),
      alertCondition: json['alert_condition'] as String? ?? 'any_drop',
      thresholdPercent: (json['threshold_percent'] as num?)?.toInt(),
      maxPrice: (json['max_price'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      lastTriggeredAt: json['last_triggered_at'] == null
          ? null
          : DateTime.parse(json['last_triggered_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CategoryAlertToJson(_CategoryAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'alert_condition': instance.alertCondition,
      'threshold_percent': instance.thresholdPercent,
      'max_price': instance.maxPrice,
      'is_active': instance.isActive,
      'last_triggered_at': instance.lastTriggeredAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_KeywordAlert _$KeywordAlertFromJson(Map<String, dynamic> json) =>
    _KeywordAlert(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      keyword: json['keyword'] as String,
      categoryId: (json['category_id'] as num?)?.toInt(),
      maxPrice: (json['max_price'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      lastTriggeredAt: json['last_triggered_at'] == null
          ? null
          : DateTime.parse(json['last_triggered_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$KeywordAlertToJson(_KeywordAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'keyword': instance.keyword,
      'category_id': instance.categoryId,
      'max_price': instance.maxPrice,
      'is_active': instance.isActive,
      'last_triggered_at': instance.lastTriggeredAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_AlertListResponse _$AlertListResponseFromJson(Map<String, dynamic> json) =>
    _AlertListResponse(
      priceAlerts:
          (json['price_alerts'] as List<dynamic>?)
              ?.map((e) => PriceAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      categoryAlerts:
          (json['category_alerts'] as List<dynamic>?)
              ?.map((e) => CategoryAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      keywordAlerts:
          (json['keyword_alerts'] as List<dynamic>?)
              ?.map((e) => KeywordAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AlertListResponseToJson(_AlertListResponse instance) =>
    <String, dynamic>{
      'price_alerts': instance.priceAlerts,
      'category_alerts': instance.categoryAlerts,
      'keyword_alerts': instance.keywordAlerts,
    };
