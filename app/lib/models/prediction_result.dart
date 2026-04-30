import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction_result.freezed.dart';
part 'prediction_result.g.dart';

/// AI 예측 행동 유형 — 서버 PredictedAction enum과 1:1 대응.
enum PredictionAction {
  @JsonValue('buy_now')
  buyNow,
  @JsonValue('wait')
  wait,
  @JsonValue('neutral')
  neutral,
}

/// AI 가격 예측 결과.
@freezed
abstract class PredictionResult with _$PredictionResult {
  const factory PredictionResult({
    @JsonKey(name: 'predicted_action') required PredictionAction predictedAction,
    @JsonKey(fromJson: _confidenceFromJson) required double confidence,
  }) = _PredictionResult;

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      _$PredictionResultFromJson(json);
}

/// confidence는 Rust Decimal이 String 또는 num으로 직렬화될 수 있어 방어적 파싱.
double _confidenceFromJson(dynamic value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0.0,
      _ => 0.0,
    };
