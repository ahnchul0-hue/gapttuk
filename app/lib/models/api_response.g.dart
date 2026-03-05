// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _ApiResponse<T>(ok: json['ok'] as bool, data: fromJsonT(json['data']));

Map<String, dynamic> _$ApiResponseToJson<T>(
  _ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'ok': instance.ok, 'data': toJsonT(instance.data)};

_PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginatedResponse<T>(
  ok: json['ok'] as bool,
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  cursor: json['cursor'] as String?,
  hasMore: json['has_more'] as bool? ?? false,
);

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  _PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'ok': instance.ok,
  'data': instance.data.map(toJsonT).toList(),
  'cursor': instance.cursor,
  'has_more': instance.hasMore,
};
