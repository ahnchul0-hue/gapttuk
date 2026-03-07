// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      notificationType: json['notification_type'] as String,
      referenceId: (json['reference_id'] as num?)?.toInt(),
      referenceType: json['reference_type'] as String?,
      title: json['title'] as String,
      body: json['body'] as String?,
      deepLink: json['deep_link'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'notification_type': instance.notificationType,
      'reference_id': instance.referenceId,
      'reference_type': instance.referenceType,
      'title': instance.title,
      'body': instance.body,
      'deep_link': instance.deepLink,
      'is_read': instance.isRead,
      'sent_at': instance.sentAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
    };
