import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// 알림 내역
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'notification_type') required String notificationType,
    @JsonKey(name: 'reference_id') int? referenceId,
    @JsonKey(name: 'reference_type') String? referenceType,
    required String title,
    String? body,
    @JsonKey(name: 'deep_link') String? deepLink,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
