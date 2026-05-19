// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'naver_trend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendPeriodData _$TrendPeriodDataFromJson(Map<String, dynamic> json) =>
    _TrendPeriodData(
      period: json['period'] as String,
      ratio: (json['ratio'] as num).toDouble(),
    );

Map<String, dynamic> _$TrendPeriodDataToJson(_TrendPeriodData instance) =>
    <String, dynamic>{'period': instance.period, 'ratio': instance.ratio};

_CategoryTrend _$CategoryTrendFromJson(Map<String, dynamic> json) =>
    _CategoryTrend(
      categoryName: json['category_name'] as String,
      periods: (json['periods'] as List<dynamic>)
          .map((e) => TrendPeriodData.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentAvg: (json['recent_avg'] as num).toDouble(),
      momChange: (json['mom_change'] as num).toDouble(),
    );

Map<String, dynamic> _$CategoryTrendToJson(_CategoryTrend instance) =>
    <String, dynamic>{
      'category_name': instance.categoryName,
      'periods': instance.periods,
      'recent_avg': instance.recentAvg,
      'mom_change': instance.momChange,
    };
