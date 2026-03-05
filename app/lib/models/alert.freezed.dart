// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceAlert {

 int get id;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'product_id') int get productId;@JsonKey(name: 'alert_type') String get alertType;@JsonKey(name: 'target_price') int? get targetPrice;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_triggered_at') DateTime? get lastTriggeredAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceAlertCopyWith<PriceAlert> get copyWith => _$PriceAlertCopyWithImpl<PriceAlert>(this as PriceAlert, _$identity);

  /// Serializes this PriceAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.targetPrice, targetPrice) || other.targetPrice == targetPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastTriggeredAt, lastTriggeredAt) || other.lastTriggeredAt == lastTriggeredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,productId,alertType,targetPrice,isActive,lastTriggeredAt,createdAt,updatedAt);

@override
String toString() {
  return 'PriceAlert(id: $id, userId: $userId, productId: $productId, alertType: $alertType, targetPrice: $targetPrice, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PriceAlertCopyWith<$Res>  {
  factory $PriceAlertCopyWith(PriceAlert value, $Res Function(PriceAlert) _then) = _$PriceAlertCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'alert_type') String alertType,@JsonKey(name: 'target_price') int? targetPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$PriceAlertCopyWithImpl<$Res>
    implements $PriceAlertCopyWith<$Res> {
  _$PriceAlertCopyWithImpl(this._self, this._then);

  final PriceAlert _self;
  final $Res Function(PriceAlert) _then;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? productId = null,Object? alertType = null,Object? targetPrice = freezed,Object? isActive = null,Object? lastTriggeredAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as String,targetPrice: freezed == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastTriggeredAt: freezed == lastTriggeredAt ? _self.lastTriggeredAt : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceAlert].
extension PriceAlertPatterns on PriceAlert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceAlert value)  $default,){
final _that = this;
switch (_that) {
case _PriceAlert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceAlert value)?  $default,){
final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'alert_type')  String alertType, @JsonKey(name: 'target_price')  int? targetPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that.id,_that.userId,_that.productId,_that.alertType,_that.targetPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'alert_type')  String alertType, @JsonKey(name: 'target_price')  int? targetPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PriceAlert():
return $default(_that.id,_that.userId,_that.productId,_that.alertType,_that.targetPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'alert_type')  String alertType, @JsonKey(name: 'target_price')  int? targetPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that.id,_that.userId,_that.productId,_that.alertType,_that.targetPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceAlert implements PriceAlert {
  const _PriceAlert({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'alert_type') required this.alertType, @JsonKey(name: 'target_price') this.targetPrice, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_triggered_at') this.lastTriggeredAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _PriceAlert.fromJson(Map<String, dynamic> json) => _$PriceAlertFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'product_id') final  int productId;
@override@JsonKey(name: 'alert_type') final  String alertType;
@override@JsonKey(name: 'target_price') final  int? targetPrice;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_triggered_at') final  DateTime? lastTriggeredAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceAlertCopyWith<_PriceAlert> get copyWith => __$PriceAlertCopyWithImpl<_PriceAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.targetPrice, targetPrice) || other.targetPrice == targetPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastTriggeredAt, lastTriggeredAt) || other.lastTriggeredAt == lastTriggeredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,productId,alertType,targetPrice,isActive,lastTriggeredAt,createdAt,updatedAt);

@override
String toString() {
  return 'PriceAlert(id: $id, userId: $userId, productId: $productId, alertType: $alertType, targetPrice: $targetPrice, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PriceAlertCopyWith<$Res> implements $PriceAlertCopyWith<$Res> {
  factory _$PriceAlertCopyWith(_PriceAlert value, $Res Function(_PriceAlert) _then) = __$PriceAlertCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'alert_type') String alertType,@JsonKey(name: 'target_price') int? targetPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$PriceAlertCopyWithImpl<$Res>
    implements _$PriceAlertCopyWith<$Res> {
  __$PriceAlertCopyWithImpl(this._self, this._then);

  final _PriceAlert _self;
  final $Res Function(_PriceAlert) _then;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? productId = null,Object? alertType = null,Object? targetPrice = freezed,Object? isActive = null,Object? lastTriggeredAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PriceAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as String,targetPrice: freezed == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastTriggeredAt: freezed == lastTriggeredAt ? _self.lastTriggeredAt : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CategoryAlert {

 int get id;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'alert_condition') String get alertCondition;@JsonKey(name: 'threshold_percent') int? get thresholdPercent;@JsonKey(name: 'max_price') int? get maxPrice;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_triggered_at') DateTime? get lastTriggeredAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of CategoryAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryAlertCopyWith<CategoryAlert> get copyWith => _$CategoryAlertCopyWithImpl<CategoryAlert>(this as CategoryAlert, _$identity);

  /// Serializes this CategoryAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.alertCondition, alertCondition) || other.alertCondition == alertCondition)&&(identical(other.thresholdPercent, thresholdPercent) || other.thresholdPercent == thresholdPercent)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastTriggeredAt, lastTriggeredAt) || other.lastTriggeredAt == lastTriggeredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,alertCondition,thresholdPercent,maxPrice,isActive,lastTriggeredAt,createdAt,updatedAt);

@override
String toString() {
  return 'CategoryAlert(id: $id, userId: $userId, categoryId: $categoryId, alertCondition: $alertCondition, thresholdPercent: $thresholdPercent, maxPrice: $maxPrice, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CategoryAlertCopyWith<$Res>  {
  factory $CategoryAlertCopyWith(CategoryAlert value, $Res Function(CategoryAlert) _then) = _$CategoryAlertCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'alert_condition') String alertCondition,@JsonKey(name: 'threshold_percent') int? thresholdPercent,@JsonKey(name: 'max_price') int? maxPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$CategoryAlertCopyWithImpl<$Res>
    implements $CategoryAlertCopyWith<$Res> {
  _$CategoryAlertCopyWithImpl(this._self, this._then);

  final CategoryAlert _self;
  final $Res Function(CategoryAlert) _then;

/// Create a copy of CategoryAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? categoryId = null,Object? alertCondition = null,Object? thresholdPercent = freezed,Object? maxPrice = freezed,Object? isActive = null,Object? lastTriggeredAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,alertCondition: null == alertCondition ? _self.alertCondition : alertCondition // ignore: cast_nullable_to_non_nullable
as String,thresholdPercent: freezed == thresholdPercent ? _self.thresholdPercent : thresholdPercent // ignore: cast_nullable_to_non_nullable
as int?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastTriggeredAt: freezed == lastTriggeredAt ? _self.lastTriggeredAt : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryAlert].
extension CategoryAlertPatterns on CategoryAlert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryAlert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryAlert value)  $default,){
final _that = this;
switch (_that) {
case _CategoryAlert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryAlert value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryAlert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'alert_condition')  String alertCondition, @JsonKey(name: 'threshold_percent')  int? thresholdPercent, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryAlert() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.alertCondition,_that.thresholdPercent,_that.maxPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'alert_condition')  String alertCondition, @JsonKey(name: 'threshold_percent')  int? thresholdPercent, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryAlert():
return $default(_that.id,_that.userId,_that.categoryId,_that.alertCondition,_that.thresholdPercent,_that.maxPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'alert_condition')  String alertCondition, @JsonKey(name: 'threshold_percent')  int? thresholdPercent, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryAlert() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.alertCondition,_that.thresholdPercent,_that.maxPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryAlert implements CategoryAlert {
  const _CategoryAlert({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'alert_condition') this.alertCondition = 'any_drop', @JsonKey(name: 'threshold_percent') this.thresholdPercent, @JsonKey(name: 'max_price') this.maxPrice, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_triggered_at') this.lastTriggeredAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _CategoryAlert.fromJson(Map<String, dynamic> json) => _$CategoryAlertFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'alert_condition') final  String alertCondition;
@override@JsonKey(name: 'threshold_percent') final  int? thresholdPercent;
@override@JsonKey(name: 'max_price') final  int? maxPrice;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_triggered_at') final  DateTime? lastTriggeredAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of CategoryAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryAlertCopyWith<_CategoryAlert> get copyWith => __$CategoryAlertCopyWithImpl<_CategoryAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.alertCondition, alertCondition) || other.alertCondition == alertCondition)&&(identical(other.thresholdPercent, thresholdPercent) || other.thresholdPercent == thresholdPercent)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastTriggeredAt, lastTriggeredAt) || other.lastTriggeredAt == lastTriggeredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,alertCondition,thresholdPercent,maxPrice,isActive,lastTriggeredAt,createdAt,updatedAt);

@override
String toString() {
  return 'CategoryAlert(id: $id, userId: $userId, categoryId: $categoryId, alertCondition: $alertCondition, thresholdPercent: $thresholdPercent, maxPrice: $maxPrice, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryAlertCopyWith<$Res> implements $CategoryAlertCopyWith<$Res> {
  factory _$CategoryAlertCopyWith(_CategoryAlert value, $Res Function(_CategoryAlert) _then) = __$CategoryAlertCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'alert_condition') String alertCondition,@JsonKey(name: 'threshold_percent') int? thresholdPercent,@JsonKey(name: 'max_price') int? maxPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$CategoryAlertCopyWithImpl<$Res>
    implements _$CategoryAlertCopyWith<$Res> {
  __$CategoryAlertCopyWithImpl(this._self, this._then);

  final _CategoryAlert _self;
  final $Res Function(_CategoryAlert) _then;

/// Create a copy of CategoryAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? categoryId = null,Object? alertCondition = null,Object? thresholdPercent = freezed,Object? maxPrice = freezed,Object? isActive = null,Object? lastTriggeredAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CategoryAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,alertCondition: null == alertCondition ? _self.alertCondition : alertCondition // ignore: cast_nullable_to_non_nullable
as String,thresholdPercent: freezed == thresholdPercent ? _self.thresholdPercent : thresholdPercent // ignore: cast_nullable_to_non_nullable
as int?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastTriggeredAt: freezed == lastTriggeredAt ? _self.lastTriggeredAt : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$KeywordAlert {

 int get id;@JsonKey(name: 'user_id') int get userId; String get keyword;@JsonKey(name: 'category_id') int? get categoryId;@JsonKey(name: 'max_price') int? get maxPrice;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_triggered_at') DateTime? get lastTriggeredAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of KeywordAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeywordAlertCopyWith<KeywordAlert> get copyWith => _$KeywordAlertCopyWithImpl<KeywordAlert>(this as KeywordAlert, _$identity);

  /// Serializes this KeywordAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeywordAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastTriggeredAt, lastTriggeredAt) || other.lastTriggeredAt == lastTriggeredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,keyword,categoryId,maxPrice,isActive,lastTriggeredAt,createdAt,updatedAt);

@override
String toString() {
  return 'KeywordAlert(id: $id, userId: $userId, keyword: $keyword, categoryId: $categoryId, maxPrice: $maxPrice, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KeywordAlertCopyWith<$Res>  {
  factory $KeywordAlertCopyWith(KeywordAlert value, $Res Function(KeywordAlert) _then) = _$KeywordAlertCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, String keyword,@JsonKey(name: 'category_id') int? categoryId,@JsonKey(name: 'max_price') int? maxPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$KeywordAlertCopyWithImpl<$Res>
    implements $KeywordAlertCopyWith<$Res> {
  _$KeywordAlertCopyWithImpl(this._self, this._then);

  final KeywordAlert _self;
  final $Res Function(KeywordAlert) _then;

/// Create a copy of KeywordAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? keyword = null,Object? categoryId = freezed,Object? maxPrice = freezed,Object? isActive = null,Object? lastTriggeredAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastTriggeredAt: freezed == lastTriggeredAt ? _self.lastTriggeredAt : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [KeywordAlert].
extension KeywordAlertPatterns on KeywordAlert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeywordAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeywordAlert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeywordAlert value)  $default,){
final _that = this;
switch (_that) {
case _KeywordAlert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeywordAlert value)?  $default,){
final _that = this;
switch (_that) {
case _KeywordAlert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  String keyword, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeywordAlert() when $default != null:
return $default(_that.id,_that.userId,_that.keyword,_that.categoryId,_that.maxPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  String keyword, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _KeywordAlert():
return $default(_that.id,_that.userId,_that.keyword,_that.categoryId,_that.maxPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId,  String keyword, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_triggered_at')  DateTime? lastTriggeredAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _KeywordAlert() when $default != null:
return $default(_that.id,_that.userId,_that.keyword,_that.categoryId,_that.maxPrice,_that.isActive,_that.lastTriggeredAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeywordAlert implements KeywordAlert {
  const _KeywordAlert({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.keyword, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'max_price') this.maxPrice, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_triggered_at') this.lastTriggeredAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _KeywordAlert.fromJson(Map<String, dynamic> json) => _$KeywordAlertFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override final  String keyword;
@override@JsonKey(name: 'category_id') final  int? categoryId;
@override@JsonKey(name: 'max_price') final  int? maxPrice;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_triggered_at') final  DateTime? lastTriggeredAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of KeywordAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeywordAlertCopyWith<_KeywordAlert> get copyWith => __$KeywordAlertCopyWithImpl<_KeywordAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeywordAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeywordAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastTriggeredAt, lastTriggeredAt) || other.lastTriggeredAt == lastTriggeredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,keyword,categoryId,maxPrice,isActive,lastTriggeredAt,createdAt,updatedAt);

@override
String toString() {
  return 'KeywordAlert(id: $id, userId: $userId, keyword: $keyword, categoryId: $categoryId, maxPrice: $maxPrice, isActive: $isActive, lastTriggeredAt: $lastTriggeredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KeywordAlertCopyWith<$Res> implements $KeywordAlertCopyWith<$Res> {
  factory _$KeywordAlertCopyWith(_KeywordAlert value, $Res Function(_KeywordAlert) _then) = __$KeywordAlertCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, String keyword,@JsonKey(name: 'category_id') int? categoryId,@JsonKey(name: 'max_price') int? maxPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_triggered_at') DateTime? lastTriggeredAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$KeywordAlertCopyWithImpl<$Res>
    implements _$KeywordAlertCopyWith<$Res> {
  __$KeywordAlertCopyWithImpl(this._self, this._then);

  final _KeywordAlert _self;
  final $Res Function(_KeywordAlert) _then;

/// Create a copy of KeywordAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? keyword = null,Object? categoryId = freezed,Object? maxPrice = freezed,Object? isActive = null,Object? lastTriggeredAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_KeywordAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastTriggeredAt: freezed == lastTriggeredAt ? _self.lastTriggeredAt : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AlertListResponse {

@JsonKey(name: 'price_alerts') List<PriceAlert> get priceAlerts;@JsonKey(name: 'category_alerts') List<CategoryAlert> get categoryAlerts;@JsonKey(name: 'keyword_alerts') List<KeywordAlert> get keywordAlerts;
/// Create a copy of AlertListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertListResponseCopyWith<AlertListResponse> get copyWith => _$AlertListResponseCopyWithImpl<AlertListResponse>(this as AlertListResponse, _$identity);

  /// Serializes this AlertListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertListResponse&&const DeepCollectionEquality().equals(other.priceAlerts, priceAlerts)&&const DeepCollectionEquality().equals(other.categoryAlerts, categoryAlerts)&&const DeepCollectionEquality().equals(other.keywordAlerts, keywordAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(priceAlerts),const DeepCollectionEquality().hash(categoryAlerts),const DeepCollectionEquality().hash(keywordAlerts));

@override
String toString() {
  return 'AlertListResponse(priceAlerts: $priceAlerts, categoryAlerts: $categoryAlerts, keywordAlerts: $keywordAlerts)';
}


}

/// @nodoc
abstract mixin class $AlertListResponseCopyWith<$Res>  {
  factory $AlertListResponseCopyWith(AlertListResponse value, $Res Function(AlertListResponse) _then) = _$AlertListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'price_alerts') List<PriceAlert> priceAlerts,@JsonKey(name: 'category_alerts') List<CategoryAlert> categoryAlerts,@JsonKey(name: 'keyword_alerts') List<KeywordAlert> keywordAlerts
});




}
/// @nodoc
class _$AlertListResponseCopyWithImpl<$Res>
    implements $AlertListResponseCopyWith<$Res> {
  _$AlertListResponseCopyWithImpl(this._self, this._then);

  final AlertListResponse _self;
  final $Res Function(AlertListResponse) _then;

/// Create a copy of AlertListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? priceAlerts = null,Object? categoryAlerts = null,Object? keywordAlerts = null,}) {
  return _then(_self.copyWith(
priceAlerts: null == priceAlerts ? _self.priceAlerts : priceAlerts // ignore: cast_nullable_to_non_nullable
as List<PriceAlert>,categoryAlerts: null == categoryAlerts ? _self.categoryAlerts : categoryAlerts // ignore: cast_nullable_to_non_nullable
as List<CategoryAlert>,keywordAlerts: null == keywordAlerts ? _self.keywordAlerts : keywordAlerts // ignore: cast_nullable_to_non_nullable
as List<KeywordAlert>,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertListResponse].
extension AlertListResponsePatterns on AlertListResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertListResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlertListResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlertListResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'price_alerts')  List<PriceAlert> priceAlerts, @JsonKey(name: 'category_alerts')  List<CategoryAlert> categoryAlerts, @JsonKey(name: 'keyword_alerts')  List<KeywordAlert> keywordAlerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertListResponse() when $default != null:
return $default(_that.priceAlerts,_that.categoryAlerts,_that.keywordAlerts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'price_alerts')  List<PriceAlert> priceAlerts, @JsonKey(name: 'category_alerts')  List<CategoryAlert> categoryAlerts, @JsonKey(name: 'keyword_alerts')  List<KeywordAlert> keywordAlerts)  $default,) {final _that = this;
switch (_that) {
case _AlertListResponse():
return $default(_that.priceAlerts,_that.categoryAlerts,_that.keywordAlerts);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'price_alerts')  List<PriceAlert> priceAlerts, @JsonKey(name: 'category_alerts')  List<CategoryAlert> categoryAlerts, @JsonKey(name: 'keyword_alerts')  List<KeywordAlert> keywordAlerts)?  $default,) {final _that = this;
switch (_that) {
case _AlertListResponse() when $default != null:
return $default(_that.priceAlerts,_that.categoryAlerts,_that.keywordAlerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertListResponse implements AlertListResponse {
  const _AlertListResponse({@JsonKey(name: 'price_alerts') final  List<PriceAlert> priceAlerts = const [], @JsonKey(name: 'category_alerts') final  List<CategoryAlert> categoryAlerts = const [], @JsonKey(name: 'keyword_alerts') final  List<KeywordAlert> keywordAlerts = const []}): _priceAlerts = priceAlerts,_categoryAlerts = categoryAlerts,_keywordAlerts = keywordAlerts;
  factory _AlertListResponse.fromJson(Map<String, dynamic> json) => _$AlertListResponseFromJson(json);

 final  List<PriceAlert> _priceAlerts;
@override@JsonKey(name: 'price_alerts') List<PriceAlert> get priceAlerts {
  if (_priceAlerts is EqualUnmodifiableListView) return _priceAlerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_priceAlerts);
}

 final  List<CategoryAlert> _categoryAlerts;
@override@JsonKey(name: 'category_alerts') List<CategoryAlert> get categoryAlerts {
  if (_categoryAlerts is EqualUnmodifiableListView) return _categoryAlerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryAlerts);
}

 final  List<KeywordAlert> _keywordAlerts;
@override@JsonKey(name: 'keyword_alerts') List<KeywordAlert> get keywordAlerts {
  if (_keywordAlerts is EqualUnmodifiableListView) return _keywordAlerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywordAlerts);
}


/// Create a copy of AlertListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertListResponseCopyWith<_AlertListResponse> get copyWith => __$AlertListResponseCopyWithImpl<_AlertListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertListResponse&&const DeepCollectionEquality().equals(other._priceAlerts, _priceAlerts)&&const DeepCollectionEquality().equals(other._categoryAlerts, _categoryAlerts)&&const DeepCollectionEquality().equals(other._keywordAlerts, _keywordAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_priceAlerts),const DeepCollectionEquality().hash(_categoryAlerts),const DeepCollectionEquality().hash(_keywordAlerts));

@override
String toString() {
  return 'AlertListResponse(priceAlerts: $priceAlerts, categoryAlerts: $categoryAlerts, keywordAlerts: $keywordAlerts)';
}


}

/// @nodoc
abstract mixin class _$AlertListResponseCopyWith<$Res> implements $AlertListResponseCopyWith<$Res> {
  factory _$AlertListResponseCopyWith(_AlertListResponse value, $Res Function(_AlertListResponse) _then) = __$AlertListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'price_alerts') List<PriceAlert> priceAlerts,@JsonKey(name: 'category_alerts') List<CategoryAlert> categoryAlerts,@JsonKey(name: 'keyword_alerts') List<KeywordAlert> keywordAlerts
});




}
/// @nodoc
class __$AlertListResponseCopyWithImpl<$Res>
    implements _$AlertListResponseCopyWith<$Res> {
  __$AlertListResponseCopyWithImpl(this._self, this._then);

  final _AlertListResponse _self;
  final $Res Function(_AlertListResponse) _then;

/// Create a copy of AlertListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? priceAlerts = null,Object? categoryAlerts = null,Object? keywordAlerts = null,}) {
  return _then(_AlertListResponse(
priceAlerts: null == priceAlerts ? _self._priceAlerts : priceAlerts // ignore: cast_nullable_to_non_nullable
as List<PriceAlert>,categoryAlerts: null == categoryAlerts ? _self._categoryAlerts : categoryAlerts // ignore: cast_nullable_to_non_nullable
as List<CategoryAlert>,keywordAlerts: null == keywordAlerts ? _self._keywordAlerts : keywordAlerts // ignore: cast_nullable_to_non_nullable
as List<KeywordAlert>,
  ));
}


}

// dart format on
