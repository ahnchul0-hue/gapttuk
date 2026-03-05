import 'dart:io';
import 'package:flutter/foundation.dart';
import 'device_service.dart';

/// 푸시 알림 서비스 — FCM 토큰 관리 및 디바이스 등록.
///
/// Firebase 설정 완료 후 [_getFirebaseToken]을 실제 구현으로 교체.
class PushService {
  final DeviceService _deviceService;

  PushService({required DeviceService deviceService})
      : _deviceService = deviceService;

  /// 디바이스 등록 시도. Firebase 미설정 시 무시.
  Future<void> registerDeviceIfNeeded() async {
    try {
      final token = await _getDeviceToken();
      if (token == null) return;

      final platform = _getPlatform();
      if (platform == null) return;

      await _deviceService.registerDevice(
        deviceToken: token,
        platform: platform,
      );
    } catch (e) {
      // Firebase 미설정 또는 네트워크 오류 — 무시
      debugPrint('PushService: 디바이스 등록 실패 — $e');
    }
  }

  /// 푸시 토글.
  Future<void> togglePush({required int deviceId, required bool enabled}) async {
    await _deviceService.togglePush(id: deviceId, pushEnabled: enabled);
  }

  /// FCM 토큰 획득. Firebase 설정 전에는 null 반환.
  ///
  /// TODO: firebase_messaging 패키지 추가 후 아래로 교체:
  /// ```dart
  /// final messaging = FirebaseMessaging.instance;
  /// await messaging.requestPermission();
  /// return await messaging.getToken();
  /// ```
  Future<String?> _getDeviceToken() async {
    // Firebase 미설정 상태 — 토큰 없음
    return null;
  }

  String? _getPlatform() {
    if (kIsWeb) return null;
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return null;
  }
}
