import 'package:freezed_annotation/freezed_annotation.dart';

part 'naver_trend.freezed.dart';
part 'naver_trend.g.dart';

/// 기간별 검색 트렌드 점수 (0.0 ~ 100.0, 기간 내 최고값 = 100).
@freezed
abstract class TrendPeriodData with _$TrendPeriodData {
  const factory TrendPeriodData({
    /// "2025-11-01" 형식 날짜 문자열
    required String period,
    /// 0.0 ~ 100.0 (기간 최고값 기준 정규화)
    required double ratio,
  }) = _TrendPeriodData;

  factory TrendPeriodData.fromJson(Map<String, dynamic> json) =>
      _$TrendPeriodDataFromJson(json);
}

/// 카테고리 트렌드 분석 결과.
/// Rust CategoryTrendScore와 1:1 대응.
@freezed
abstract class CategoryTrend with _$CategoryTrend {
  const factory CategoryTrend({
    @JsonKey(name: 'category_name') required String categoryName,
    required List<TrendPeriodData> periods,
    /// 최근 3개월 평균 ratio
    @JsonKey(name: 'recent_avg') required double recentAvg,
    /// 직전월 대비 변화율 (%)
    @JsonKey(name: 'mom_change') required double momChange,
  }) = _CategoryTrend;

  factory CategoryTrend.fromJson(Map<String, dynamic> json) =>
      _$CategoryTrendFromJson(json);
}
