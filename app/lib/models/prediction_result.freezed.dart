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

/// @nodoc


class _PredictionResult  implements PredictionResult {
  const _PredictionResult({@JsonKey(name: 'predicted_action') required this.predictedAction, @JsonKey(fromJson: _confidenceFromJson) required this.confidence});

@override @JsonKey(name: 'predicted_action') final  PredictionAction predictedAction;
@override @JsonKey(fromJson: _confidenceFromJson) final  double confidence;

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
@pragma('vm:prefer-inline') @override $Res call({Object? predictedAction = null,Object? confidence = null,}) {
  return _then(_PredictionResult(
predictedAction: null == predictedAction ? _self.predictedAction : predictedAction // ignore: cast_nullable_to_non_nullable
as PredictionAction,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}
