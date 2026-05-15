// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demographic_trend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DemographicPeriodData {

 String get period; double get ratio; String get group;
/// Create a copy of DemographicPeriodData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemographicPeriodDataCopyWith<DemographicPeriodData> get copyWith => _$DemographicPeriodDataCopyWithImpl<DemographicPeriodData>(this as DemographicPeriodData, _$identity);

  /// Serializes this DemographicPeriodData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemographicPeriodData&&(identical(other.period, period) || other.period == period)&&(identical(other.ratio, ratio) || other.ratio == ratio)&&(identical(other.group, group) || other.group == group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,ratio,group);

@override
String toString() {
  return 'DemographicPeriodData(period: $period, ratio: $ratio, group: $group)';
}


}

/// @nodoc
abstract mixin class $DemographicPeriodDataCopyWith<$Res>  {
  factory $DemographicPeriodDataCopyWith(DemographicPeriodData value, $Res Function(DemographicPeriodData) _then) = _$DemographicPeriodDataCopyWithImpl;
@useResult
$Res call({
 String period, double ratio, String group
});




}
/// @nodoc
class _$DemographicPeriodDataCopyWithImpl<$Res>
    implements $DemographicPeriodDataCopyWith<$Res> {
  _$DemographicPeriodDataCopyWithImpl(this._self, this._then);

  final DemographicPeriodData _self;
  final $Res Function(DemographicPeriodData) _then;

/// Create a copy of DemographicPeriodData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? ratio = null,Object? group = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DemographicPeriodData].
extension DemographicPeriodDataPatterns on DemographicPeriodData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemographicPeriodData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemographicPeriodData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemographicPeriodData value)  $default,){
final _that = this;
switch (_that) {
case _DemographicPeriodData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemographicPeriodData value)?  $default,){
final _that = this;
switch (_that) {
case _DemographicPeriodData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double ratio,  String group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemographicPeriodData() when $default != null:
return $default(_that.period,_that.ratio,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double ratio,  String group)  $default,) {final _that = this;
switch (_that) {
case _DemographicPeriodData():
return $default(_that.period,_that.ratio,_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double ratio,  String group)?  $default,) {final _that = this;
switch (_that) {
case _DemographicPeriodData() when $default != null:
return $default(_that.period,_that.ratio,_that.group);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DemographicPeriodData implements DemographicPeriodData {
  const _DemographicPeriodData({required this.period, required this.ratio, required this.group});
  factory _DemographicPeriodData.fromJson(Map<String, dynamic> json) => _$DemographicPeriodDataFromJson(json);

@override final  String period;
@override final  double ratio;
@override final  String group;

/// Create a copy of DemographicPeriodData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemographicPeriodDataCopyWith<_DemographicPeriodData> get copyWith => __$DemographicPeriodDataCopyWithImpl<_DemographicPeriodData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DemographicPeriodDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemographicPeriodData&&(identical(other.period, period) || other.period == period)&&(identical(other.ratio, ratio) || other.ratio == ratio)&&(identical(other.group, group) || other.group == group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,ratio,group);

@override
String toString() {
  return 'DemographicPeriodData(period: $period, ratio: $ratio, group: $group)';
}


}

/// @nodoc
abstract mixin class _$DemographicPeriodDataCopyWith<$Res> implements $DemographicPeriodDataCopyWith<$Res> {
  factory _$DemographicPeriodDataCopyWith(_DemographicPeriodData value, $Res Function(_DemographicPeriodData) _then) = __$DemographicPeriodDataCopyWithImpl;
@override @useResult
$Res call({
 String period, double ratio, String group
});




}
/// @nodoc
class __$DemographicPeriodDataCopyWithImpl<$Res>
    implements _$DemographicPeriodDataCopyWith<$Res> {
  __$DemographicPeriodDataCopyWithImpl(this._self, this._then);

  final _DemographicPeriodData _self;
  final $Res Function(_DemographicPeriodData) _then;

/// Create a copy of DemographicPeriodData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? ratio = null,Object? group = null,}) {
  return _then(_DemographicPeriodData(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DemographicTrend {

@JsonKey(name: 'category_code') String get categoryCode;/// 차원: 'age' | 'gender' | 'device'
 String get dimension; List<DemographicPeriodData> get data;/// 그룹별 최근 3개월 평균 ratio
@JsonKey(name: 'group_recent_avg') Map<String, double> get groupRecentAvg;/// 가장 높은 관심도를 가진 그룹
@JsonKey(name: 'top_group') String get topGroup;
/// Create a copy of DemographicTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemographicTrendCopyWith<DemographicTrend> get copyWith => _$DemographicTrendCopyWithImpl<DemographicTrend>(this as DemographicTrend, _$identity);

  /// Serializes this DemographicTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemographicTrend&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.dimension, dimension) || other.dimension == dimension)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.groupRecentAvg, groupRecentAvg)&&(identical(other.topGroup, topGroup) || other.topGroup == topGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryCode,dimension,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(groupRecentAvg),topGroup);

@override
String toString() {
  return 'DemographicTrend(categoryCode: $categoryCode, dimension: $dimension, data: $data, groupRecentAvg: $groupRecentAvg, topGroup: $topGroup)';
}


}

/// @nodoc
abstract mixin class $DemographicTrendCopyWith<$Res>  {
  factory $DemographicTrendCopyWith(DemographicTrend value, $Res Function(DemographicTrend) _then) = _$DemographicTrendCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_code') String categoryCode, String dimension, List<DemographicPeriodData> data,@JsonKey(name: 'group_recent_avg') Map<String, double> groupRecentAvg,@JsonKey(name: 'top_group') String topGroup
});




}
/// @nodoc
class _$DemographicTrendCopyWithImpl<$Res>
    implements $DemographicTrendCopyWith<$Res> {
  _$DemographicTrendCopyWithImpl(this._self, this._then);

  final DemographicTrend _self;
  final $Res Function(DemographicTrend) _then;

/// Create a copy of DemographicTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryCode = null,Object? dimension = null,Object? data = null,Object? groupRecentAvg = null,Object? topGroup = null,}) {
  return _then(_self.copyWith(
categoryCode: null == categoryCode ? _self.categoryCode : categoryCode // ignore: cast_nullable_to_non_nullable
as String,dimension: null == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<DemographicPeriodData>,groupRecentAvg: null == groupRecentAvg ? _self.groupRecentAvg : groupRecentAvg // ignore: cast_nullable_to_non_nullable
as Map<String, double>,topGroup: null == topGroup ? _self.topGroup : topGroup // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DemographicTrend].
extension DemographicTrendPatterns on DemographicTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemographicTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemographicTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemographicTrend value)  $default,){
final _that = this;
switch (_that) {
case _DemographicTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemographicTrend value)?  $default,){
final _that = this;
switch (_that) {
case _DemographicTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_code')  String categoryCode,  String dimension,  List<DemographicPeriodData> data, @JsonKey(name: 'group_recent_avg')  Map<String, double> groupRecentAvg, @JsonKey(name: 'top_group')  String topGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemographicTrend() when $default != null:
return $default(_that.categoryCode,_that.dimension,_that.data,_that.groupRecentAvg,_that.topGroup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_code')  String categoryCode,  String dimension,  List<DemographicPeriodData> data, @JsonKey(name: 'group_recent_avg')  Map<String, double> groupRecentAvg, @JsonKey(name: 'top_group')  String topGroup)  $default,) {final _that = this;
switch (_that) {
case _DemographicTrend():
return $default(_that.categoryCode,_that.dimension,_that.data,_that.groupRecentAvg,_that.topGroup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_code')  String categoryCode,  String dimension,  List<DemographicPeriodData> data, @JsonKey(name: 'group_recent_avg')  Map<String, double> groupRecentAvg, @JsonKey(name: 'top_group')  String topGroup)?  $default,) {final _that = this;
switch (_that) {
case _DemographicTrend() when $default != null:
return $default(_that.categoryCode,_that.dimension,_that.data,_that.groupRecentAvg,_that.topGroup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DemographicTrend implements DemographicTrend {
  const _DemographicTrend({@JsonKey(name: 'category_code') required this.categoryCode, required this.dimension, required final  List<DemographicPeriodData> data, @JsonKey(name: 'group_recent_avg') required final  Map<String, double> groupRecentAvg, @JsonKey(name: 'top_group') required this.topGroup}): _data = data,_groupRecentAvg = groupRecentAvg;
  factory _DemographicTrend.fromJson(Map<String, dynamic> json) => _$DemographicTrendFromJson(json);

@override@JsonKey(name: 'category_code') final  String categoryCode;
/// 차원: 'age' | 'gender' | 'device'
@override final  String dimension;
 final  List<DemographicPeriodData> _data;
@override List<DemographicPeriodData> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

/// 그룹별 최근 3개월 평균 ratio
 final  Map<String, double> _groupRecentAvg;
/// 그룹별 최근 3개월 평균 ratio
@override@JsonKey(name: 'group_recent_avg') Map<String, double> get groupRecentAvg {
  if (_groupRecentAvg is EqualUnmodifiableMapView) return _groupRecentAvg;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupRecentAvg);
}

/// 가장 높은 관심도를 가진 그룹
@override@JsonKey(name: 'top_group') final  String topGroup;

/// Create a copy of DemographicTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemographicTrendCopyWith<_DemographicTrend> get copyWith => __$DemographicTrendCopyWithImpl<_DemographicTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DemographicTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemographicTrend&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.dimension, dimension) || other.dimension == dimension)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._groupRecentAvg, _groupRecentAvg)&&(identical(other.topGroup, topGroup) || other.topGroup == topGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryCode,dimension,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_groupRecentAvg),topGroup);

@override
String toString() {
  return 'DemographicTrend(categoryCode: $categoryCode, dimension: $dimension, data: $data, groupRecentAvg: $groupRecentAvg, topGroup: $topGroup)';
}


}

/// @nodoc
abstract mixin class _$DemographicTrendCopyWith<$Res> implements $DemographicTrendCopyWith<$Res> {
  factory _$DemographicTrendCopyWith(_DemographicTrend value, $Res Function(_DemographicTrend) _then) = __$DemographicTrendCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_code') String categoryCode, String dimension, List<DemographicPeriodData> data,@JsonKey(name: 'group_recent_avg') Map<String, double> groupRecentAvg,@JsonKey(name: 'top_group') String topGroup
});




}
/// @nodoc
class __$DemographicTrendCopyWithImpl<$Res>
    implements _$DemographicTrendCopyWith<$Res> {
  __$DemographicTrendCopyWithImpl(this._self, this._then);

  final _DemographicTrend _self;
  final $Res Function(_DemographicTrend) _then;

/// Create a copy of DemographicTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryCode = null,Object? dimension = null,Object? data = null,Object? groupRecentAvg = null,Object? topGroup = null,}) {
  return _then(_DemographicTrend(
categoryCode: null == categoryCode ? _self.categoryCode : categoryCode // ignore: cast_nullable_to_non_nullable
as String,dimension: null == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<DemographicPeriodData>,groupRecentAvg: null == groupRecentAvg ? _self._groupRecentAvg : groupRecentAvg // ignore: cast_nullable_to_non_nullable
as Map<String, double>,topGroup: null == topGroup ? _self.topGroup : topGroup // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
