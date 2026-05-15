// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demographic_trend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DemographicPeriodData _$DemographicPeriodDataFromJson(
  Map<String, dynamic> json,
) => _DemographicPeriodData(
  period: json['period'] as String,
  ratio: (json['ratio'] as num).toDouble(),
  group: json['group'] as String,
);

Map<String, dynamic> _$DemographicPeriodDataToJson(
  _DemographicPeriodData instance,
) => <String, dynamic>{
  'period': instance.period,
  'ratio': instance.ratio,
  'group': instance.group,
};

_DemographicTrend _$DemographicTrendFromJson(Map<String, dynamic> json) =>
    _DemographicTrend(
      categoryCode: json['category_code'] as String,
      dimension: json['dimension'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => DemographicPeriodData.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupRecentAvg: (json['group_recent_avg'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topGroup: json['top_group'] as String,
    );

Map<String, dynamic> _$DemographicTrendToJson(_DemographicTrend instance) =>
    <String, dynamic>{
      'category_code': instance.categoryCode,
      'dimension': instance.dimension,
      'data': instance.data,
      'group_recent_avg': instance.groupRecentAvg,
      'top_group': instance.topGroup,
    };
