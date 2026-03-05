import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

/// 가격 알림 — target_price, below_average, near_lowest, all_time_low
@freezed
abstract class PriceAlert with _$PriceAlert {
  const factory PriceAlert({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'alert_type') required String alertType,
    @JsonKey(name: 'target_price') int? targetPrice,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PriceAlert;

  factory PriceAlert.fromJson(Map<String, dynamic> json) =>
      _$PriceAlertFromJson(json);
}

/// 카테고리 알림
@freezed
abstract class CategoryAlert with _$CategoryAlert {
  const factory CategoryAlert({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'alert_condition') @Default('any_drop') String alertCondition,
    @JsonKey(name: 'threshold_percent') int? thresholdPercent,
    @JsonKey(name: 'max_price') int? maxPrice,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryAlert;

  factory CategoryAlert.fromJson(Map<String, dynamic> json) =>
      _$CategoryAlertFromJson(json);
}

/// 키워드 알림
@freezed
abstract class KeywordAlert with _$KeywordAlert {
  const factory KeywordAlert({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String keyword,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'max_price') int? maxPrice,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _KeywordAlert;

  factory KeywordAlert.fromJson(Map<String, dynamic> json) =>
      _$KeywordAlertFromJson(json);
}

/// GET /alerts 응답 — { price_alerts, category_alerts, keyword_alerts }
@freezed
abstract class AlertListResponse with _$AlertListResponse {
  const factory AlertListResponse({
    @JsonKey(name: 'price_alerts') @Default([]) List<PriceAlert> priceAlerts,
    @JsonKey(name: 'category_alerts') @Default([]) List<CategoryAlert> categoryAlerts,
    @JsonKey(name: 'keyword_alerts') @Default([]) List<KeywordAlert> keywordAlerts,
  }) = _AlertListResponse;

  factory AlertListResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertListResponseFromJson(json);
}
