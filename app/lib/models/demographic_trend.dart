import 'package:freezed_annotation/freezed_annotation.dart';

part 'demographic_trend.freezed.dart';
part 'demographic_trend.g.dart';

/// 인구통계 차원 — Rust DemographicDimension enum과 1:1 대응.
enum DemographicDimension {
  @JsonValue('age')
  age,
  @JsonValue('gender')
  gender,
  @JsonValue('device')
  device,
}

/// DemographicDimension → API 요청에 사용하는 snake_case 문자열 변환.
extension DemographicDimensionX on DemographicDimension {
  String get value => switch (this) {
        DemographicDimension.age => 'age',
        DemographicDimension.gender => 'gender',
        DemographicDimension.device => 'device',
      };
}

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
    required DemographicDimension dimension,
    required List<DemographicPeriodData> data,
    /// 그룹별 최근 3개월 평균 ratio
    @JsonKey(name: 'group_recent_avg') required Map<String, double> groupRecentAvg,
    /// 가장 높은 관심도를 가진 그룹
    @JsonKey(name: 'top_group') required String topGroup,
  }) = _DemographicTrend;

  factory DemographicTrend.fromJson(Map<String, dynamic> json) =>
      _$DemographicTrendFromJson(json);
}
