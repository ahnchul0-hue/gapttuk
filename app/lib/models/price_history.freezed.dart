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

 String get date;@JsonKey(name: 'min_price') int get minPrice;@JsonKey(name: 'max_price') int get maxPrice;@JsonKey(name: 'avg_price') int get avgPrice;
/// Create a copy of DailyPriceAggregate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyPriceAggregateCopyWith<DailyPriceAggregate> get copyWith => _$DailyPriceAggregateCopyWithImpl<DailyPriceAggregate>(this as DailyPriceAggregate, _$identity);

  /// Serializes this DailyPriceAggregate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyPriceAggregate&&(identical(other.date, date) || other.date == date)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.avgPrice, avgPrice) || other.avgPrice == avgPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,minPrice,maxPrice,avgPrice);

@override
String toString() {
  return 'DailyPriceAggregate(date: $date, minPrice: $minPrice, maxPrice: $maxPrice, avgPrice: $avgPrice)';
}


}

/// @nodoc
abstract mixin class $DailyPriceAggregateCopyWith<$Res>  {
  factory $DailyPriceAggregateCopyWith(DailyPriceAggregate value, $Res Function(DailyPriceAggregate) _then) = _$DailyPriceAggregateCopyWithImpl;
@useResult
$Res call({
 String date,@JsonKey(name: 'min_price') int minPrice,@JsonKey(name: 'max_price') int maxPrice,@JsonKey(name: 'avg_price') int avgPrice
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
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? minPrice = null,Object? maxPrice = null,Object? avgPrice = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as int,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int,avgPrice: null == avgPrice ? _self.avgPrice : avgPrice // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'min_price')  int minPrice, @JsonKey(name: 'max_price')  int maxPrice, @JsonKey(name: 'avg_price')  int avgPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyPriceAggregate() when $default != null:
return $default(_that.date,_that.minPrice,_that.maxPrice,_that.avgPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'min_price')  int minPrice, @JsonKey(name: 'max_price')  int maxPrice, @JsonKey(name: 'avg_price')  int avgPrice)  $default,) {final _that = this;
switch (_that) {
case _DailyPriceAggregate():
return $default(_that.date,_that.minPrice,_that.maxPrice,_that.avgPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date, @JsonKey(name: 'min_price')  int minPrice, @JsonKey(name: 'max_price')  int maxPrice, @JsonKey(name: 'avg_price')  int avgPrice)?  $default,) {final _that = this;
switch (_that) {
case _DailyPriceAggregate() when $default != null:
return $default(_that.date,_that.minPrice,_that.maxPrice,_that.avgPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyPriceAggregate implements DailyPriceAggregate {
  const _DailyPriceAggregate({required this.date, @JsonKey(name: 'min_price') required this.minPrice, @JsonKey(name: 'max_price') required this.maxPrice, @JsonKey(name: 'avg_price') required this.avgPrice});
  factory _DailyPriceAggregate.fromJson(Map<String, dynamic> json) => _$DailyPriceAggregateFromJson(json);

@override final  String date;
@override@JsonKey(name: 'min_price') final  int minPrice;
@override@JsonKey(name: 'max_price') final  int maxPrice;
@override@JsonKey(name: 'avg_price') final  int avgPrice;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyPriceAggregate&&(identical(other.date, date) || other.date == date)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.avgPrice, avgPrice) || other.avgPrice == avgPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,minPrice,maxPrice,avgPrice);

@override
String toString() {
  return 'DailyPriceAggregate(date: $date, minPrice: $minPrice, maxPrice: $maxPrice, avgPrice: $avgPrice)';
}


}

/// @nodoc
abstract mixin class _$DailyPriceAggregateCopyWith<$Res> implements $DailyPriceAggregateCopyWith<$Res> {
  factory _$DailyPriceAggregateCopyWith(_DailyPriceAggregate value, $Res Function(_DailyPriceAggregate) _then) = __$DailyPriceAggregateCopyWithImpl;
@override @useResult
$Res call({
 String date,@JsonKey(name: 'min_price') int minPrice,@JsonKey(name: 'max_price') int maxPrice,@JsonKey(name: 'avg_price') int avgPrice
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
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? minPrice = null,Object? maxPrice = null,Object? avgPrice = null,}) {
  return _then(_DailyPriceAggregate(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as int,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int,avgPrice: null == avgPrice ? _self.avgPrice : avgPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
