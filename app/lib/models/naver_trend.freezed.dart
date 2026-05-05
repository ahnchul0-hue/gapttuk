// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'naver_trend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendPeriodData {

/// "2025-11-01" 형식 날짜 문자열
 String get period;/// 0.0 ~ 100.0 (기간 최고값 기준 정규화)
 double get ratio;
/// Create a copy of TrendPeriodData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendPeriodDataCopyWith<TrendPeriodData> get copyWith => _$TrendPeriodDataCopyWithImpl<TrendPeriodData>(this as TrendPeriodData, _$identity);

  /// Serializes this TrendPeriodData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendPeriodData&&(identical(other.period, period) || other.period == period)&&(identical(other.ratio, ratio) || other.ratio == ratio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,ratio);

@override
String toString() {
  return 'TrendPeriodData(period: $period, ratio: $ratio)';
}


}

/// @nodoc
abstract mixin class $TrendPeriodDataCopyWith<$Res>  {
  factory $TrendPeriodDataCopyWith(TrendPeriodData value, $Res Function(TrendPeriodData) _then) = _$TrendPeriodDataCopyWithImpl;
@useResult
$Res call({
 String period, double ratio
});




}
/// @nodoc
class _$TrendPeriodDataCopyWithImpl<$Res>
    implements $TrendPeriodDataCopyWith<$Res> {
  _$TrendPeriodDataCopyWithImpl(this._self, this._then);

  final TrendPeriodData _self;
  final $Res Function(TrendPeriodData) _then;

/// Create a copy of TrendPeriodData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? ratio = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendPeriodData].
extension TrendPeriodDataPatterns on TrendPeriodData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendPeriodData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendPeriodData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendPeriodData value)  $default,){
final _that = this;
switch (_that) {
case _TrendPeriodData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendPeriodData value)?  $default,){
final _that = this;
switch (_that) {
case _TrendPeriodData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double ratio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendPeriodData() when $default != null:
return $default(_that.period,_that.ratio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double ratio)  $default,) {final _that = this;
switch (_that) {
case _TrendPeriodData():
return $default(_that.period,_that.ratio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double ratio)?  $default,) {final _that = this;
switch (_that) {
case _TrendPeriodData() when $default != null:
return $default(_that.period,_that.ratio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendPeriodData implements TrendPeriodData {
  const _TrendPeriodData({required this.period, required this.ratio});
  factory _TrendPeriodData.fromJson(Map<String, dynamic> json) => _$TrendPeriodDataFromJson(json);

/// "2025-11-01" 형식 날짜 문자열
@override final  String period;
/// 0.0 ~ 100.0 (기간 최고값 기준 정규화)
@override final  double ratio;

/// Create a copy of TrendPeriodData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendPeriodDataCopyWith<_TrendPeriodData> get copyWith => __$TrendPeriodDataCopyWithImpl<_TrendPeriodData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendPeriodDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendPeriodData&&(identical(other.period, period) || other.period == period)&&(identical(other.ratio, ratio) || other.ratio == ratio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,ratio);

@override
String toString() {
  return 'TrendPeriodData(period: $period, ratio: $ratio)';
}


}

/// @nodoc
abstract mixin class _$TrendPeriodDataCopyWith<$Res> implements $TrendPeriodDataCopyWith<$Res> {
  factory _$TrendPeriodDataCopyWith(_TrendPeriodData value, $Res Function(_TrendPeriodData) _then) = __$TrendPeriodDataCopyWithImpl;
@override @useResult
$Res call({
 String period, double ratio
});




}
/// @nodoc
class __$TrendPeriodDataCopyWithImpl<$Res>
    implements _$TrendPeriodDataCopyWith<$Res> {
  __$TrendPeriodDataCopyWithImpl(this._self, this._then);

  final _TrendPeriodData _self;
  final $Res Function(_TrendPeriodData) _then;

/// Create a copy of TrendPeriodData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? ratio = null,}) {
  return _then(_TrendPeriodData(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CategoryTrend {

@JsonKey(name: 'category_name') String get categoryName; List<TrendPeriodData> get periods;/// 최근 3개월 평균 ratio
@JsonKey(name: 'recent_avg') double get recentAvg;/// 직전월 대비 변화율 (%)
@JsonKey(name: 'mom_change') double get momChange;
/// Create a copy of CategoryTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryTrendCopyWith<CategoryTrend> get copyWith => _$CategoryTrendCopyWithImpl<CategoryTrend>(this as CategoryTrend, _$identity);

  /// Serializes this CategoryTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryTrend&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other.periods, periods)&&(identical(other.recentAvg, recentAvg) || other.recentAvg == recentAvg)&&(identical(other.momChange, momChange) || other.momChange == momChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,const DeepCollectionEquality().hash(periods),recentAvg,momChange);

@override
String toString() {
  return 'CategoryTrend(categoryName: $categoryName, periods: $periods, recentAvg: $recentAvg, momChange: $momChange)';
}


}

/// @nodoc
abstract mixin class $CategoryTrendCopyWith<$Res>  {
  factory $CategoryTrendCopyWith(CategoryTrend value, $Res Function(CategoryTrend) _then) = _$CategoryTrendCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_name') String categoryName, List<TrendPeriodData> periods,@JsonKey(name: 'recent_avg') double recentAvg,@JsonKey(name: 'mom_change') double momChange
});




}
/// @nodoc
class _$CategoryTrendCopyWithImpl<$Res>
    implements $CategoryTrendCopyWith<$Res> {
  _$CategoryTrendCopyWithImpl(this._self, this._then);

  final CategoryTrend _self;
  final $Res Function(CategoryTrend) _then;

/// Create a copy of CategoryTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryName = null,Object? periods = null,Object? recentAvg = null,Object? momChange = null,}) {
  return _then(_self.copyWith(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as List<TrendPeriodData>,recentAvg: null == recentAvg ? _self.recentAvg : recentAvg // ignore: cast_nullable_to_non_nullable
as double,momChange: null == momChange ? _self.momChange : momChange // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryTrend].
extension CategoryTrendPatterns on CategoryTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryTrend value)  $default,){
final _that = this;
switch (_that) {
case _CategoryTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryTrend value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_name')  String categoryName,  List<TrendPeriodData> periods, @JsonKey(name: 'recent_avg')  double recentAvg, @JsonKey(name: 'mom_change')  double momChange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryTrend() when $default != null:
return $default(_that.categoryName,_that.periods,_that.recentAvg,_that.momChange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_name')  String categoryName,  List<TrendPeriodData> periods, @JsonKey(name: 'recent_avg')  double recentAvg, @JsonKey(name: 'mom_change')  double momChange)  $default,) {final _that = this;
switch (_that) {
case _CategoryTrend():
return $default(_that.categoryName,_that.periods,_that.recentAvg,_that.momChange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_name')  String categoryName,  List<TrendPeriodData> periods, @JsonKey(name: 'recent_avg')  double recentAvg, @JsonKey(name: 'mom_change')  double momChange)?  $default,) {final _that = this;
switch (_that) {
case _CategoryTrend() when $default != null:
return $default(_that.categoryName,_that.periods,_that.recentAvg,_that.momChange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryTrend implements CategoryTrend {
  const _CategoryTrend({@JsonKey(name: 'category_name') required this.categoryName, required final  List<TrendPeriodData> periods, @JsonKey(name: 'recent_avg') required this.recentAvg, @JsonKey(name: 'mom_change') required this.momChange}): _periods = periods;
  factory _CategoryTrend.fromJson(Map<String, dynamic> json) => _$CategoryTrendFromJson(json);

@override@JsonKey(name: 'category_name') final  String categoryName;
 final  List<TrendPeriodData> _periods;
@override List<TrendPeriodData> get periods {
  if (_periods is EqualUnmodifiableListView) return _periods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_periods);
}

/// 최근 3개월 평균 ratio
@override@JsonKey(name: 'recent_avg') final  double recentAvg;
/// 직전월 대비 변화율 (%)
@override@JsonKey(name: 'mom_change') final  double momChange;

/// Create a copy of CategoryTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryTrendCopyWith<_CategoryTrend> get copyWith => __$CategoryTrendCopyWithImpl<_CategoryTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryTrend&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other._periods, _periods)&&(identical(other.recentAvg, recentAvg) || other.recentAvg == recentAvg)&&(identical(other.momChange, momChange) || other.momChange == momChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,const DeepCollectionEquality().hash(_periods),recentAvg,momChange);

@override
String toString() {
  return 'CategoryTrend(categoryName: $categoryName, periods: $periods, recentAvg: $recentAvg, momChange: $momChange)';
}


}

/// @nodoc
abstract mixin class _$CategoryTrendCopyWith<$Res> implements $CategoryTrendCopyWith<$Res> {
  factory _$CategoryTrendCopyWith(_CategoryTrend value, $Res Function(_CategoryTrend) _then) = __$CategoryTrendCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_name') String categoryName, List<TrendPeriodData> periods,@JsonKey(name: 'recent_avg') double recentAvg,@JsonKey(name: 'mom_change') double momChange
});




}
/// @nodoc
class __$CategoryTrendCopyWithImpl<$Res>
    implements _$CategoryTrendCopyWith<$Res> {
  __$CategoryTrendCopyWithImpl(this._self, this._then);

  final _CategoryTrend _self;
  final $Res Function(_CategoryTrend) _then;

/// Create a copy of CategoryTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? periods = null,Object? recentAvg = null,Object? momChange = null,}) {
  return _then(_CategoryTrend(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,periods: null == periods ? _self._periods : periods // ignore: cast_nullable_to_non_nullable
as List<TrendPeriodData>,recentAvg: null == recentAvg ? _self.recentAvg : recentAvg // ignore: cast_nullable_to_non_nullable
as double,momChange: null == momChange ? _self.momChange : momChange // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
