import 'package:freezed_annotation/freezed_annotation.dart';

part 'demographic_trend.freezed.dart';
part 'demographic_trend.g.dart';

/// 인구통계 데이터 포인트 — period/ratio/group 3개 필드.
/// group: 연령("20"~"60") | 성별("m"/"f") | 기기("mo"/"pc")
@freezed
abstract class DemographicPeriodData with _$DemographicPeriodData {
  const factory DemographicPeriodData({
    required String period,
    required double ratio,
    required String group,
  }) = _DemographicPeriodData;

  factory DemographicPeriodData.fromJson(Map<String, dynamic> json) =>
      _$DemographicPeriodDataFromJson(json);
}

/// 인구통계 트렌드 분석 결과 — Rust DemographicTrendScore 1:1 대응.
@freezed
abstract class DemographicTrend with _$DemographicTrend {
  const factory DemographicTrend({
    @JsonKey(name: 'category_code') required String categoryCode,
    /// 차원: 'age' | 'gender' | 'device'
    required String dimension,
    required List<DemographicPeriodData> data,
    /// 그룹별 최근 3개월 평균 ratio
    @JsonKey(name: 'group_recent_avg') required Map<String, double> groupRecentAvg,
    /// 가장 높은 관심도를 가진 그룹
    @JsonKey(name: 'top_group') required String topGroup,
  }) = _DemographicTrend;

  factory DemographicTrend.fromJson(Map<String, dynamic> json) =>
      _$DemographicTrendFromJson(json);
}
