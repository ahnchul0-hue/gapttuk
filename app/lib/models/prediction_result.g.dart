// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PredictionResult _$PredictionResultFromJson(Map<String, dynamic> json) =>
    _PredictionResult(
      predictedAction: $enumDecode(
        _$PredictionActionEnumMap,
        json['predicted_action'],
      ),
      confidence: _confidenceFromJson(json['confidence']),
    );

Map<String, dynamic> _$PredictionResultToJson(_PredictionResult instance) =>
    <String, dynamic>{
      'predicted_action': _$PredictionActionEnumMap[instance.predictedAction]!,
      'confidence': instance.confidence,
    };

const _$PredictionActionEnumMap = {
  PredictionAction.buyNow: 'buy_now',
  PredictionAction.wait: 'wait',
  PredictionAction.neutral: 'neutral',
};
