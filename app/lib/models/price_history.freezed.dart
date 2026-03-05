// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceHistory {

 int get id;@JsonKey(name: 'product_id') int get productId; int get price;@JsonKey(name: 'is_out_of_stock') bool get isOutOfStock;@JsonKey(name: 'recorded_at') DateTime get recordedAt;
/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryCopyWith<PriceHistory> get copyWith => _$PriceHistoryCopyWithImpl<PriceHistory>(this as PriceHistory, _$identity);

  /// Serializes this PriceHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.price, price) || other.price == price)&&(identical(other.isOutOfStock, isOutOfStock) || other.isOutOfStock == isOutOfStock)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,price,isOutOfStock,recordedAt);

@override
String toString() {
  return 'PriceHistory(id: $id, productId: $productId, price: $price, isOutOfStock: $isOutOfStock, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $PriceHistoryCopyWith<$Res>  {
  factory $PriceHistoryCopyWith(PriceHistory value, $Res Function(PriceHistory) _then) = _$PriceHistoryCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'product_id') int productId, int price,@JsonKey(name: 'is_out_of_stock') bool isOutOfStock,@JsonKey(name: 'recorded_at') DateTime recordedAt
});




}
/// @nodoc
class _$PriceHistoryCopyWithImpl<$Res>
    implements $PriceHistoryCopyWith<$Res> {
  _$PriceHistoryCopyWithImpl(this._self, this._then);

  final PriceHistory _self;
  final $Res Function(PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? price = null,Object? isOutOfStock = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isOutOfStock: null == isOutOfStock ? _self.isOutOfStock : isOutOfStock // ignore: cast_nullable_to_non_nullable
as bool,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistory].
extension PriceHistoryPatterns on PriceHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistory value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'product_id')  int productId,  int price, @JsonKey(name: 'is_out_of_stock')  bool isOutOfStock, @JsonKey(name: 'recorded_at')  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.id,_that.productId,_that.price,_that.isOutOfStock,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'product_id')  int productId,  int price, @JsonKey(name: 'is_out_of_stock')  bool isOutOfStock, @JsonKey(name: 'recorded_at')  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _PriceHistory():
return $default(_that.id,_that.productId,_that.price,_that.isOutOfStock,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'product_id')  int productId,  int price, @JsonKey(name: 'is_out_of_stock')  bool isOutOfStock, @JsonKey(name: 'recorded_at')  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.id,_that.productId,_that.price,_that.isOutOfStock,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceHistory implements PriceHistory {
  const _PriceHistory({required this.id, @JsonKey(name: 'product_id') required this.productId, required this.price, @JsonKey(name: 'is_out_of_stock') this.isOutOfStock = false, @JsonKey(name: 'recorded_at') required this.recordedAt});
  factory _PriceHistory.fromJson(Map<String, dynamic> json) => _$PriceHistoryFromJson(json);

@override final  int id;
@override@JsonKey(name: 'product_id') final  int productId;
@override final  int price;
@override@JsonKey(name: 'is_out_of_stock') final  bool isOutOfStock;
@override@JsonKey(name: 'recorded_at') final  DateTime recordedAt;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryCopyWith<_PriceHistory> get copyWith => __$PriceHistoryCopyWithImpl<_PriceHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.price, price) || other.price == price)&&(identical(other.isOutOfStock, isOutOfStock) || other.isOutOfStock == isOutOfStock)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,price,isOutOfStock,recordedAt);

@override
String toString() {
  return 'PriceHistory(id: $id, productId: $productId, price: $price, isOutOfStock: $isOutOfStock, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryCopyWith<$Res> implements $PriceHistoryCopyWith<$Res> {
  factory _$PriceHistoryCopyWith(_PriceHistory value, $Res Function(_PriceHistory) _then) = __$PriceHistoryCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'product_id') int productId, int price,@JsonKey(name: 'is_out_of_stock') bool isOutOfStock,@JsonKey(name: 'recorded_at') DateTime recordedAt
});




}
/// @nodoc
class __$PriceHistoryCopyWithImpl<$Res>
    implements _$PriceHistoryCopyWith<$Res> {
  __$PriceHistoryCopyWithImpl(this._self, this._then);

  final _PriceHistory _self;
  final $Res Function(_PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? price = null,Object? isOutOfStock = null,Object? recordedAt = null,}) {
  return _then(_PriceHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isOutOfStock: null == isOutOfStock ? _self.isOutOfStock : isOutOfStock // ignore: cast_nullable_to_non_nullable
as bool,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DailyPriceAggregate {

@JsonKey(name: 'day_of_week') int get dayOfWeek;@JsonKey(name: 'avg_price') int? get avgPrice;@JsonKey(name: 'min_price') int? get minPrice;@JsonKey(name: 'max_price') int? get maxPrice;@JsonKey(name: 'sample_count') int get sampleCount;
/// Create a copy of DailyPriceAggregate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyPriceAggregateCopyWith<DailyPriceAggregate> get copyWith => _$DailyPriceAggregateCopyWithImpl<DailyPriceAggregate>(this as DailyPriceAggregate, _$identity);

  /// Serializes this DailyPriceAggregate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyPriceAggregate&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.avgPrice, avgPrice) || other.avgPrice == avgPrice)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,avgPrice,minPrice,maxPrice,sampleCount);

@override
String toString() {
  return 'DailyPriceAggregate(dayOfWeek: $dayOfWeek, avgPrice: $avgPrice, minPrice: $minPrice, maxPrice: $maxPrice, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class $DailyPriceAggregateCopyWith<$Res>  {
  factory $DailyPriceAggregateCopyWith(DailyPriceAggregate value, $Res Function(DailyPriceAggregate) _then) = _$DailyPriceAggregateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'avg_price') int? avgPrice,@JsonKey(name: 'min_price') int? minPrice,@JsonKey(name: 'max_price') int? maxPrice,@JsonKey(name: 'sample_count') int sampleCount
});




}
/// @nodoc
class _$DailyPriceAggregateCopyWithImpl<$Res>
    implements $DailyPriceAggregateCopyWith<$Res> {
  _$DailyPriceAggregateCopyWithImpl(this._self, this._then);

  final DailyPriceAggregate _self;
  final $Res Function(DailyPriceAggregate) _then;

/// Create a copy of DailyPriceAggregate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayOfWeek = null,Object? avgPrice = freezed,Object? minPrice = freezed,Object? maxPrice = freezed,Object? sampleCount = null,}) {
  return _then(_self.copyWith(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,avgPrice: freezed == avgPrice ? _self.avgPrice : avgPrice // ignore: cast_nullable_to_non_nullable
as int?,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as int?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyPriceAggregate].
extension DailyPriceAggregatePatterns on DailyPriceAggregate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyPriceAggregate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyPriceAggregate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyPriceAggregate value)  $default,){
final _that = this;
switch (_that) {
case _DailyPriceAggregate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyPriceAggregate value)?  $default,){
final _that = this;
switch (_that) {
case _DailyPriceAggregate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'avg_price')  int? avgPrice, @JsonKey(name: 'min_price')  int? minPrice, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'sample_count')  int sampleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyPriceAggregate() when $default != null:
return $default(_that.dayOfWeek,_that.avgPrice,_that.minPrice,_that.maxPrice,_that.sampleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'avg_price')  int? avgPrice, @JsonKey(name: 'min_price')  int? minPrice, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'sample_count')  int sampleCount)  $default,) {final _that = this;
switch (_that) {
case _DailyPriceAggregate():
return $default(_that.dayOfWeek,_that.avgPrice,_that.minPrice,_that.maxPrice,_that.sampleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'avg_price')  int? avgPrice, @JsonKey(name: 'min_price')  int? minPrice, @JsonKey(name: 'max_price')  int? maxPrice, @JsonKey(name: 'sample_count')  int sampleCount)?  $default,) {final _that = this;
switch (_that) {
case _DailyPriceAggregate() when $default != null:
return $default(_that.dayOfWeek,_that.avgPrice,_that.minPrice,_that.maxPrice,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyPriceAggregate implements DailyPriceAggregate {
  const _DailyPriceAggregate({@JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'avg_price') this.avgPrice, @JsonKey(name: 'min_price') this.minPrice, @JsonKey(name: 'max_price') this.maxPrice, @JsonKey(name: 'sample_count') this.sampleCount = 0});
  factory _DailyPriceAggregate.fromJson(Map<String, dynamic> json) => _$DailyPriceAggregateFromJson(json);

@override@JsonKey(name: 'day_of_week') final  int dayOfWeek;
@override@JsonKey(name: 'avg_price') final  int? avgPrice;
@override@JsonKey(name: 'min_price') final  int? minPrice;
@override@JsonKey(name: 'max_price') final  int? maxPrice;
@override@JsonKey(name: 'sample_count') final  int sampleCount;

/// Create a copy of DailyPriceAggregate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyPriceAggregateCopyWith<_DailyPriceAggregate> get copyWith => __$DailyPriceAggregateCopyWithImpl<_DailyPriceAggregate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyPriceAggregateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyPriceAggregate&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.avgPrice, avgPrice) || other.avgPrice == avgPrice)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,avgPrice,minPrice,maxPrice,sampleCount);

@override
String toString() {
  return 'DailyPriceAggregate(dayOfWeek: $dayOfWeek, avgPrice: $avgPrice, minPrice: $minPrice, maxPrice: $maxPrice, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$DailyPriceAggregateCopyWith<$Res> implements $DailyPriceAggregateCopyWith<$Res> {
  factory _$DailyPriceAggregateCopyWith(_DailyPriceAggregate value, $Res Function(_DailyPriceAggregate) _then) = __$DailyPriceAggregateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'avg_price') int? avgPrice,@JsonKey(name: 'min_price') int? minPrice,@JsonKey(name: 'max_price') int? maxPrice,@JsonKey(name: 'sample_count') int sampleCount
});




}
/// @nodoc
class __$DailyPriceAggregateCopyWithImpl<$Res>
    implements _$DailyPriceAggregateCopyWith<$Res> {
  __$DailyPriceAggregateCopyWithImpl(this._self, this._then);

  final _DailyPriceAggregate _self;
  final $Res Function(_DailyPriceAggregate) _then;

/// Create a copy of DailyPriceAggregate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayOfWeek = null,Object? avgPrice = freezed,Object? minPrice = freezed,Object? maxPrice = freezed,Object? sampleCount = null,}) {
  return _then(_DailyPriceAggregate(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,avgPrice: freezed == avgPrice ? _self.avgPrice : avgPrice // ignore: cast_nullable_to_non_nullable
as int?,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as int?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int?,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
