// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 int get id;@JsonKey(name: 'shopping_mall_id') int? get shoppingMallId;@JsonKey(name: 'category_id') int? get categoryId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'product_url') String? get productUrl;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'current_price') int? get currentPrice;@JsonKey(name: 'lowest_price') int? get lowestPrice;@JsonKey(name: 'highest_price') int? get highestPrice;@JsonKey(name: 'average_price') int? get averagePrice;@JsonKey(name: 'price_trend') String? get priceTrend;@JsonKey(name: 'buy_timing_score') int? get buyTimingScore;@JsonKey(name: 'days_since_lowest') int? get daysSinceLowest;@JsonKey(name: 'drop_from_average') int? get dropFromAverage;@JsonKey(name: 'is_out_of_stock') bool get isOutOfStock;@JsonKey(name: 'review_count') int? get reviewCount;@JsonKey(name: 'price_updated_at') DateTime? get priceUpdatedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.shoppingMallId, shoppingMallId) || other.shoppingMallId == shoppingMallId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productUrl, productUrl) || other.productUrl == productUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.lowestPrice, lowestPrice) || other.lowestPrice == lowestPrice)&&(identical(other.highestPrice, highestPrice) || other.highestPrice == highestPrice)&&(identical(other.averagePrice, averagePrice) || other.averagePrice == averagePrice)&&(identical(other.priceTrend, priceTrend) || other.priceTrend == priceTrend)&&(identical(other.buyTimingScore, buyTimingScore) || other.buyTimingScore == buyTimingScore)&&(identical(other.daysSinceLowest, daysSinceLowest) || other.daysSinceLowest == daysSinceLowest)&&(identical(other.dropFromAverage, dropFromAverage) || other.dropFromAverage == dropFromAverage)&&(identical(other.isOutOfStock, isOutOfStock) || other.isOutOfStock == isOutOfStock)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.priceUpdatedAt, priceUpdatedAt) || other.priceUpdatedAt == priceUpdatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shoppingMallId,categoryId,productName,productUrl,imageUrl,currentPrice,lowestPrice,highestPrice,averagePrice,priceTrend,buyTimingScore,daysSinceLowest,dropFromAverage,isOutOfStock,reviewCount,priceUpdatedAt,createdAt);

@override
String toString() {
  return 'Product(id: $id, shoppingMallId: $shoppingMallId, categoryId: $categoryId, productName: $productName, productUrl: $productUrl, imageUrl: $imageUrl, currentPrice: $currentPrice, lowestPrice: $lowestPrice, highestPrice: $highestPrice, averagePrice: $averagePrice, priceTrend: $priceTrend, buyTimingScore: $buyTimingScore, daysSinceLowest: $daysSinceLowest, dropFromAverage: $dropFromAverage, isOutOfStock: $isOutOfStock, reviewCount: $reviewCount, priceUpdatedAt: $priceUpdatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'shopping_mall_id') int? shoppingMallId,@JsonKey(name: 'category_id') int? categoryId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_url') String? productUrl,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'current_price') int? currentPrice,@JsonKey(name: 'lowest_price') int? lowestPrice,@JsonKey(name: 'highest_price') int? highestPrice,@JsonKey(name: 'average_price') int? averagePrice,@JsonKey(name: 'price_trend') String? priceTrend,@JsonKey(name: 'buy_timing_score') int? buyTimingScore,@JsonKey(name: 'days_since_lowest') int? daysSinceLowest,@JsonKey(name: 'drop_from_average') int? dropFromAverage,@JsonKey(name: 'is_out_of_stock') bool isOutOfStock,@JsonKey(name: 'review_count') int? reviewCount,@JsonKey(name: 'price_updated_at') DateTime? priceUpdatedAt,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shoppingMallId = freezed,Object? categoryId = freezed,Object? productName = null,Object? productUrl = freezed,Object? imageUrl = freezed,Object? currentPrice = freezed,Object? lowestPrice = freezed,Object? highestPrice = freezed,Object? averagePrice = freezed,Object? priceTrend = freezed,Object? buyTimingScore = freezed,Object? daysSinceLowest = freezed,Object? dropFromAverage = freezed,Object? isOutOfStock = null,Object? reviewCount = freezed,Object? priceUpdatedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shoppingMallId: freezed == shoppingMallId ? _self.shoppingMallId : shoppingMallId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productUrl: freezed == productUrl ? _self.productUrl : productUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,currentPrice: freezed == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as int?,lowestPrice: freezed == lowestPrice ? _self.lowestPrice : lowestPrice // ignore: cast_nullable_to_non_nullable
as int?,highestPrice: freezed == highestPrice ? _self.highestPrice : highestPrice // ignore: cast_nullable_to_non_nullable
as int?,averagePrice: freezed == averagePrice ? _self.averagePrice : averagePrice // ignore: cast_nullable_to_non_nullable
as int?,priceTrend: freezed == priceTrend ? _self.priceTrend : priceTrend // ignore: cast_nullable_to_non_nullable
as String?,buyTimingScore: freezed == buyTimingScore ? _self.buyTimingScore : buyTimingScore // ignore: cast_nullable_to_non_nullable
as int?,daysSinceLowest: freezed == daysSinceLowest ? _self.daysSinceLowest : daysSinceLowest // ignore: cast_nullable_to_non_nullable
as int?,dropFromAverage: freezed == dropFromAverage ? _self.dropFromAverage : dropFromAverage // ignore: cast_nullable_to_non_nullable
as int?,isOutOfStock: null == isOutOfStock ? _self.isOutOfStock : isOutOfStock // ignore: cast_nullable_to_non_nullable
as bool,reviewCount: freezed == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int?,priceUpdatedAt: freezed == priceUpdatedAt ? _self.priceUpdatedAt : priceUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'shopping_mall_id')  int? shoppingMallId, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_url')  String? productUrl, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'current_price')  int? currentPrice, @JsonKey(name: 'lowest_price')  int? lowestPrice, @JsonKey(name: 'highest_price')  int? highestPrice, @JsonKey(name: 'average_price')  int? averagePrice, @JsonKey(name: 'price_trend')  String? priceTrend, @JsonKey(name: 'buy_timing_score')  int? buyTimingScore, @JsonKey(name: 'days_since_lowest')  int? daysSinceLowest, @JsonKey(name: 'drop_from_average')  int? dropFromAverage, @JsonKey(name: 'is_out_of_stock')  bool isOutOfStock, @JsonKey(name: 'review_count')  int? reviewCount, @JsonKey(name: 'price_updated_at')  DateTime? priceUpdatedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.shoppingMallId,_that.categoryId,_that.productName,_that.productUrl,_that.imageUrl,_that.currentPrice,_that.lowestPrice,_that.highestPrice,_that.averagePrice,_that.priceTrend,_that.buyTimingScore,_that.daysSinceLowest,_that.dropFromAverage,_that.isOutOfStock,_that.reviewCount,_that.priceUpdatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'shopping_mall_id')  int? shoppingMallId, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_url')  String? productUrl, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'current_price')  int? currentPrice, @JsonKey(name: 'lowest_price')  int? lowestPrice, @JsonKey(name: 'highest_price')  int? highestPrice, @JsonKey(name: 'average_price')  int? averagePrice, @JsonKey(name: 'price_trend')  String? priceTrend, @JsonKey(name: 'buy_timing_score')  int? buyTimingScore, @JsonKey(name: 'days_since_lowest')  int? daysSinceLowest, @JsonKey(name: 'drop_from_average')  int? dropFromAverage, @JsonKey(name: 'is_out_of_stock')  bool isOutOfStock, @JsonKey(name: 'review_count')  int? reviewCount, @JsonKey(name: 'price_updated_at')  DateTime? priceUpdatedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.shoppingMallId,_that.categoryId,_that.productName,_that.productUrl,_that.imageUrl,_that.currentPrice,_that.lowestPrice,_that.highestPrice,_that.averagePrice,_that.priceTrend,_that.buyTimingScore,_that.daysSinceLowest,_that.dropFromAverage,_that.isOutOfStock,_that.reviewCount,_that.priceUpdatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'shopping_mall_id')  int? shoppingMallId, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_url')  String? productUrl, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'current_price')  int? currentPrice, @JsonKey(name: 'lowest_price')  int? lowestPrice, @JsonKey(name: 'highest_price')  int? highestPrice, @JsonKey(name: 'average_price')  int? averagePrice, @JsonKey(name: 'price_trend')  String? priceTrend, @JsonKey(name: 'buy_timing_score')  int? buyTimingScore, @JsonKey(name: 'days_since_lowest')  int? daysSinceLowest, @JsonKey(name: 'drop_from_average')  int? dropFromAverage, @JsonKey(name: 'is_out_of_stock')  bool isOutOfStock, @JsonKey(name: 'review_count')  int? reviewCount, @JsonKey(name: 'price_updated_at')  DateTime? priceUpdatedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.shoppingMallId,_that.categoryId,_that.productName,_that.productUrl,_that.imageUrl,_that.currentPrice,_that.lowestPrice,_that.highestPrice,_that.averagePrice,_that.priceTrend,_that.buyTimingScore,_that.daysSinceLowest,_that.dropFromAverage,_that.isOutOfStock,_that.reviewCount,_that.priceUpdatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, @JsonKey(name: 'shopping_mall_id') this.shoppingMallId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'product_url') this.productUrl, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'current_price') this.currentPrice, @JsonKey(name: 'lowest_price') this.lowestPrice, @JsonKey(name: 'highest_price') this.highestPrice, @JsonKey(name: 'average_price') this.averagePrice, @JsonKey(name: 'price_trend') this.priceTrend, @JsonKey(name: 'buy_timing_score') this.buyTimingScore, @JsonKey(name: 'days_since_lowest') this.daysSinceLowest, @JsonKey(name: 'drop_from_average') this.dropFromAverage, @JsonKey(name: 'is_out_of_stock') this.isOutOfStock = false, @JsonKey(name: 'review_count') this.reviewCount, @JsonKey(name: 'price_updated_at') this.priceUpdatedAt, @JsonKey(name: 'created_at') this.createdAt});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  int id;
@override@JsonKey(name: 'shopping_mall_id') final  int? shoppingMallId;
@override@JsonKey(name: 'category_id') final  int? categoryId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'product_url') final  String? productUrl;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'current_price') final  int? currentPrice;
@override@JsonKey(name: 'lowest_price') final  int? lowestPrice;
@override@JsonKey(name: 'highest_price') final  int? highestPrice;
@override@JsonKey(name: 'average_price') final  int? averagePrice;
@override@JsonKey(name: 'price_trend') final  String? priceTrend;
@override@JsonKey(name: 'buy_timing_score') final  int? buyTimingScore;
@override@JsonKey(name: 'days_since_lowest') final  int? daysSinceLowest;
@override@JsonKey(name: 'drop_from_average') final  int? dropFromAverage;
@override@JsonKey(name: 'is_out_of_stock') final  bool isOutOfStock;
@override@JsonKey(name: 'review_count') final  int? reviewCount;
@override@JsonKey(name: 'price_updated_at') final  DateTime? priceUpdatedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.shoppingMallId, shoppingMallId) || other.shoppingMallId == shoppingMallId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productUrl, productUrl) || other.productUrl == productUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.lowestPrice, lowestPrice) || other.lowestPrice == lowestPrice)&&(identical(other.highestPrice, highestPrice) || other.highestPrice == highestPrice)&&(identical(other.averagePrice, averagePrice) || other.averagePrice == averagePrice)&&(identical(other.priceTrend, priceTrend) || other.priceTrend == priceTrend)&&(identical(other.buyTimingScore, buyTimingScore) || other.buyTimingScore == buyTimingScore)&&(identical(other.daysSinceLowest, daysSinceLowest) || other.daysSinceLowest == daysSinceLowest)&&(identical(other.dropFromAverage, dropFromAverage) || other.dropFromAverage == dropFromAverage)&&(identical(other.isOutOfStock, isOutOfStock) || other.isOutOfStock == isOutOfStock)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.priceUpdatedAt, priceUpdatedAt) || other.priceUpdatedAt == priceUpdatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shoppingMallId,categoryId,productName,productUrl,imageUrl,currentPrice,lowestPrice,highestPrice,averagePrice,priceTrend,buyTimingScore,daysSinceLowest,dropFromAverage,isOutOfStock,reviewCount,priceUpdatedAt,createdAt);

@override
String toString() {
  return 'Product(id: $id, shoppingMallId: $shoppingMallId, categoryId: $categoryId, productName: $productName, productUrl: $productUrl, imageUrl: $imageUrl, currentPrice: $currentPrice, lowestPrice: $lowestPrice, highestPrice: $highestPrice, averagePrice: $averagePrice, priceTrend: $priceTrend, buyTimingScore: $buyTimingScore, daysSinceLowest: $daysSinceLowest, dropFromAverage: $dropFromAverage, isOutOfStock: $isOutOfStock, reviewCount: $reviewCount, priceUpdatedAt: $priceUpdatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'shopping_mall_id') int? shoppingMallId,@JsonKey(name: 'category_id') int? categoryId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_url') String? productUrl,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'current_price') int? currentPrice,@JsonKey(name: 'lowest_price') int? lowestPrice,@JsonKey(name: 'highest_price') int? highestPrice,@JsonKey(name: 'average_price') int? averagePrice,@JsonKey(name: 'price_trend') String? priceTrend,@JsonKey(name: 'buy_timing_score') int? buyTimingScore,@JsonKey(name: 'days_since_lowest') int? daysSinceLowest,@JsonKey(name: 'drop_from_average') int? dropFromAverage,@JsonKey(name: 'is_out_of_stock') bool isOutOfStock,@JsonKey(name: 'review_count') int? reviewCount,@JsonKey(name: 'price_updated_at') DateTime? priceUpdatedAt,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shoppingMallId = freezed,Object? categoryId = freezed,Object? productName = null,Object? productUrl = freezed,Object? imageUrl = freezed,Object? currentPrice = freezed,Object? lowestPrice = freezed,Object? highestPrice = freezed,Object? averagePrice = freezed,Object? priceTrend = freezed,Object? buyTimingScore = freezed,Object? daysSinceLowest = freezed,Object? dropFromAverage = freezed,Object? isOutOfStock = null,Object? reviewCount = freezed,Object? priceUpdatedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shoppingMallId: freezed == shoppingMallId ? _self.shoppingMallId : shoppingMallId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productUrl: freezed == productUrl ? _self.productUrl : productUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,currentPrice: freezed == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as int?,lowestPrice: freezed == lowestPrice ? _self.lowestPrice : lowestPrice // ignore: cast_nullable_to_non_nullable
as int?,highestPrice: freezed == highestPrice ? _self.highestPrice : highestPrice // ignore: cast_nullable_to_non_nullable
as int?,averagePrice: freezed == averagePrice ? _self.averagePrice : averagePrice // ignore: cast_nullable_to_non_nullable
as int?,priceTrend: freezed == priceTrend ? _self.priceTrend : priceTrend // ignore: cast_nullable_to_non_nullable
as String?,buyTimingScore: freezed == buyTimingScore ? _self.buyTimingScore : buyTimingScore // ignore: cast_nullable_to_non_nullable
as int?,daysSinceLowest: freezed == daysSinceLowest ? _self.daysSinceLowest : daysSinceLowest // ignore: cast_nullable_to_non_nullable
as int?,dropFromAverage: freezed == dropFromAverage ? _self.dropFromAverage : dropFromAverage // ignore: cast_nullable_to_non_nullable
as int?,isOutOfStock: null == isOutOfStock ? _self.isOutOfStock : isOutOfStock // ignore: cast_nullable_to_non_nullable
as bool,reviewCount: freezed == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int?,priceUpdatedAt: freezed == priceUpdatedAt ? _self.priceUpdatedAt : priceUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AddProductResponse {

 int get id;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'product_url') String? get productUrl;@JsonKey(name: 'shopping_mall_id') int get shoppingMallId;@JsonKey(name: 'is_new') bool get isNew;
/// Create a copy of AddProductResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductResponseCopyWith<AddProductResponse> get copyWith => _$AddProductResponseCopyWithImpl<AddProductResponse>(this as AddProductResponse, _$identity);

  /// Serializes this AddProductResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productUrl, productUrl) || other.productUrl == productUrl)&&(identical(other.shoppingMallId, shoppingMallId) || other.shoppingMallId == shoppingMallId)&&(identical(other.isNew, isNew) || other.isNew == isNew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,productUrl,shoppingMallId,isNew);

@override
String toString() {
  return 'AddProductResponse(id: $id, productName: $productName, productUrl: $productUrl, shoppingMallId: $shoppingMallId, isNew: $isNew)';
}


}

/// @nodoc
abstract mixin class $AddProductResponseCopyWith<$Res>  {
  factory $AddProductResponseCopyWith(AddProductResponse value, $Res Function(AddProductResponse) _then) = _$AddProductResponseCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_url') String? productUrl,@JsonKey(name: 'shopping_mall_id') int shoppingMallId,@JsonKey(name: 'is_new') bool isNew
});




}
/// @nodoc
class _$AddProductResponseCopyWithImpl<$Res>
    implements $AddProductResponseCopyWith<$Res> {
  _$AddProductResponseCopyWithImpl(this._self, this._then);

  final AddProductResponse _self;
  final $Res Function(AddProductResponse) _then;

/// Create a copy of AddProductResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? productUrl = freezed,Object? shoppingMallId = null,Object? isNew = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productUrl: freezed == productUrl ? _self.productUrl : productUrl // ignore: cast_nullable_to_non_nullable
as String?,shoppingMallId: null == shoppingMallId ? _self.shoppingMallId : shoppingMallId // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AddProductResponse].
extension AddProductResponsePatterns on AddProductResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddProductResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddProductResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddProductResponse value)  $default,){
final _that = this;
switch (_that) {
case _AddProductResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddProductResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AddProductResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_url')  String? productUrl, @JsonKey(name: 'shopping_mall_id')  int shoppingMallId, @JsonKey(name: 'is_new')  bool isNew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddProductResponse() when $default != null:
return $default(_that.id,_that.productName,_that.productUrl,_that.shoppingMallId,_that.isNew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_url')  String? productUrl, @JsonKey(name: 'shopping_mall_id')  int shoppingMallId, @JsonKey(name: 'is_new')  bool isNew)  $default,) {final _that = this;
switch (_that) {
case _AddProductResponse():
return $default(_that.id,_that.productName,_that.productUrl,_that.shoppingMallId,_that.isNew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_url')  String? productUrl, @JsonKey(name: 'shopping_mall_id')  int shoppingMallId, @JsonKey(name: 'is_new')  bool isNew)?  $default,) {final _that = this;
switch (_that) {
case _AddProductResponse() when $default != null:
return $default(_that.id,_that.productName,_that.productUrl,_that.shoppingMallId,_that.isNew);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddProductResponse implements AddProductResponse {
  const _AddProductResponse({required this.id, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'product_url') this.productUrl, @JsonKey(name: 'shopping_mall_id') required this.shoppingMallId, @JsonKey(name: 'is_new') this.isNew = false});
  factory _AddProductResponse.fromJson(Map<String, dynamic> json) => _$AddProductResponseFromJson(json);

@override final  int id;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'product_url') final  String? productUrl;
@override@JsonKey(name: 'shopping_mall_id') final  int shoppingMallId;
@override@JsonKey(name: 'is_new') final  bool isNew;

/// Create a copy of AddProductResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddProductResponseCopyWith<_AddProductResponse> get copyWith => __$AddProductResponseCopyWithImpl<_AddProductResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddProductResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddProductResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productUrl, productUrl) || other.productUrl == productUrl)&&(identical(other.shoppingMallId, shoppingMallId) || other.shoppingMallId == shoppingMallId)&&(identical(other.isNew, isNew) || other.isNew == isNew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,productUrl,shoppingMallId,isNew);

@override
String toString() {
  return 'AddProductResponse(id: $id, productName: $productName, productUrl: $productUrl, shoppingMallId: $shoppingMallId, isNew: $isNew)';
}


}

/// @nodoc
abstract mixin class _$AddProductResponseCopyWith<$Res> implements $AddProductResponseCopyWith<$Res> {
  factory _$AddProductResponseCopyWith(_AddProductResponse value, $Res Function(_AddProductResponse) _then) = __$AddProductResponseCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_url') String? productUrl,@JsonKey(name: 'shopping_mall_id') int shoppingMallId,@JsonKey(name: 'is_new') bool isNew
});




}
/// @nodoc
class __$AddProductResponseCopyWithImpl<$Res>
    implements _$AddProductResponseCopyWith<$Res> {
  __$AddProductResponseCopyWithImpl(this._self, this._then);

  final _AddProductResponse _self;
  final $Res Function(_AddProductResponse) _then;

/// Create a copy of AddProductResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? productUrl = freezed,Object? shoppingMallId = null,Object? isNew = null,}) {
  return _then(_AddProductResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productUrl: freezed == productUrl ? _self.productUrl : productUrl // ignore: cast_nullable_to_non_nullable
as String?,shoppingMallId: null == shoppingMallId ? _self.shoppingMallId : shoppingMallId // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PopularSearch {

 int get id; String get keyword;@JsonKey(name: 'search_count') int get searchCount; int get rank; String? get trend;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of PopularSearch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopularSearchCopyWith<PopularSearch> get copyWith => _$PopularSearchCopyWithImpl<PopularSearch>(this as PopularSearch, _$identity);

  /// Serializes this PopularSearch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopularSearch&&(identical(other.id, id) || other.id == id)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.searchCount, searchCount) || other.searchCount == searchCount)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,keyword,searchCount,rank,trend,updatedAt);

@override
String toString() {
  return 'PopularSearch(id: $id, keyword: $keyword, searchCount: $searchCount, rank: $rank, trend: $trend, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PopularSearchCopyWith<$Res>  {
  factory $PopularSearchCopyWith(PopularSearch value, $Res Function(PopularSearch) _then) = _$PopularSearchCopyWithImpl;
@useResult
$Res call({
 int id, String keyword,@JsonKey(name: 'search_count') int searchCount, int rank, String? trend,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$PopularSearchCopyWithImpl<$Res>
    implements $PopularSearchCopyWith<$Res> {
  _$PopularSearchCopyWithImpl(this._self, this._then);

  final PopularSearch _self;
  final $Res Function(PopularSearch) _then;

/// Create a copy of PopularSearch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? keyword = null,Object? searchCount = null,Object? rank = null,Object? trend = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,searchCount: null == searchCount ? _self.searchCount : searchCount // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PopularSearch].
extension PopularSearchPatterns on PopularSearch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopularSearch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopularSearch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopularSearch value)  $default,){
final _that = this;
switch (_that) {
case _PopularSearch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopularSearch value)?  $default,){
final _that = this;
switch (_that) {
case _PopularSearch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String keyword, @JsonKey(name: 'search_count')  int searchCount,  int rank,  String? trend, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PopularSearch() when $default != null:
return $default(_that.id,_that.keyword,_that.searchCount,_that.rank,_that.trend,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String keyword, @JsonKey(name: 'search_count')  int searchCount,  int rank,  String? trend, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PopularSearch():
return $default(_that.id,_that.keyword,_that.searchCount,_that.rank,_that.trend,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String keyword, @JsonKey(name: 'search_count')  int searchCount,  int rank,  String? trend, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PopularSearch() when $default != null:
return $default(_that.id,_that.keyword,_that.searchCount,_that.rank,_that.trend,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PopularSearch implements PopularSearch {
  const _PopularSearch({required this.id, required this.keyword, @JsonKey(name: 'search_count') required this.searchCount, required this.rank, this.trend, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _PopularSearch.fromJson(Map<String, dynamic> json) => _$PopularSearchFromJson(json);

@override final  int id;
@override final  String keyword;
@override@JsonKey(name: 'search_count') final  int searchCount;
@override final  int rank;
@override final  String? trend;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of PopularSearch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopularSearchCopyWith<_PopularSearch> get copyWith => __$PopularSearchCopyWithImpl<_PopularSearch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PopularSearchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopularSearch&&(identical(other.id, id) || other.id == id)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.searchCount, searchCount) || other.searchCount == searchCount)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,keyword,searchCount,rank,trend,updatedAt);

@override
String toString() {
  return 'PopularSearch(id: $id, keyword: $keyword, searchCount: $searchCount, rank: $rank, trend: $trend, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PopularSearchCopyWith<$Res> implements $PopularSearchCopyWith<$Res> {
  factory _$PopularSearchCopyWith(_PopularSearch value, $Res Function(_PopularSearch) _then) = __$PopularSearchCopyWithImpl;
@override @useResult
$Res call({
 int id, String keyword,@JsonKey(name: 'search_count') int searchCount, int rank, String? trend,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$PopularSearchCopyWithImpl<$Res>
    implements _$PopularSearchCopyWith<$Res> {
  __$PopularSearchCopyWithImpl(this._self, this._then);

  final _PopularSearch _self;
  final $Res Function(_PopularSearch) _then;

/// Create a copy of PopularSearch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? keyword = null,Object? searchCount = null,Object? rank = null,Object? trend = freezed,Object? updatedAt = freezed,}) {
  return _then(_PopularSearch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,searchCount: null == searchCount ? _self.searchCount : searchCount // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
