// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prediction_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PredictionResult {

@JsonKey(name: 'predicted_action') PredictionAction get predictedAction;@JsonKey(fromJson: _confidenceFromJson) double get confidence;
/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictionResultCopyWith<PredictionResult> get copyWith => _$PredictionResultCopyWithImpl<PredictionResult>(this as PredictionResult, _$identity);

  /// Serializes this PredictionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictionResult&&(identical(other.predictedAction, predictedAction) || other.predictedAction == predictedAction)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,predictedAction,confidence);

@override
String toString() {
  return 'PredictionResult(predictedAction: $predictedAction, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $PredictionResultCopyWith<$Res>  {
  factory $PredictionResultCopyWith(PredictionResult value, $Res Function(PredictionResult) _then) = _$PredictionResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'predicted_action') PredictionAction predictedAction,@JsonKey(fromJson: _confidenceFromJson) double confidence
});




}
/// @nodoc
class _$PredictionResultCopyWithImpl<$Res>
    implements $PredictionResultCopyWith<$Res> {
  _$PredictionResultCopyWithImpl(this._self, this._then);

  final PredictionResult _self;
  final $Res Function(PredictionResult) _then;

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? predictedAction = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
predictedAction: null == predictedAction ? _self.predictedAction : predictedAction // ignore: cast_nullable_to_non_nullable
as PredictionAction,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictionResult].
extension PredictionResultPatterns on PredictionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictionResult value)  $default,){
final _that = this;
switch (_that) {
case _PredictionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictionResult value)?  $default,){
final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'predicted_action')  PredictionAction predictedAction, @JsonKey(fromJson: _confidenceFromJson)  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
return $default(_that.predictedAction,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'predicted_action')  PredictionAction predictedAction, @JsonKey(fromJson: _confidenceFromJson)  double confidence)  $default,) {final _that = this;
switch (_that) {
case _PredictionResult():
return $default(_that.predictedAction,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'predicted_action')  PredictionAction predictedAction, @JsonKey(fromJson: _confidenceFromJson)  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
return $default(_that.predictedAction,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PredictionResult implements PredictionResult {
  const _PredictionResult({@JsonKey(name: 'predicted_action') required this.predictedAction, @JsonKey(fromJson: _confidenceFromJson) required this.confidence});
  factory _PredictionResult.fromJson(Map<String, dynamic> json) => _$PredictionResultFromJson(json);

@override@JsonKey(name: 'predicted_action') final  PredictionAction predictedAction;
@override@JsonKey(fromJson: _confidenceFromJson) final  double confidence;

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictionResultCopyWith<_PredictionResult> get copyWith => __$PredictionResultCopyWithImpl<_PredictionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PredictionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictionResult&&(identical(other.predictedAction, predictedAction) || other.predictedAction == predictedAction)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,predictedAction,confidence);

@override
String toString() {
  return 'PredictionResult(predictedAction: $predictedAction, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$PredictionResultCopyWith<$Res> implements $PredictionResultCopyWith<$Res> {
  factory _$PredictionResultCopyWith(_PredictionResult value, $Res Function(_PredictionResult) _then) = __$PredictionResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'predicted_action') PredictionAction predictedAction,@JsonKey(fromJson: _confidenceFromJson) double confidence
});




}
/// @nodoc
class __$PredictionResultCopyWithImpl<$Res>
    implements _$PredictionResultCopyWith<$Res> {
  __$PredictionResultCopyWithImpl(this._self, this._then);

  final _PredictionResult _self;
  final $Res Function(_PredictionResult) _then;

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? predictedAction = null,Object? confidence = null,}) {
  return _then(_PredictionResult(
predictedAction: null == predictedAction ? _self.predictedAction : predictedAction // ignore: cast_nullable_to_non_nullable
as PredictionAction,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
