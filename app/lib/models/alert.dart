import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

@freezed
abstract class PriceAlert with _$PriceAlert {
  const factory PriceAlert({
    required int id,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'target_price') required int targetPrice,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'current_price') int? currentPrice,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _PriceAlert;

  factory PriceAlert.fromJson(Map<String, dynamic> json) =>
      _$PriceAlertFromJson(json);
}
