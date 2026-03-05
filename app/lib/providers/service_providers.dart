import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/alert_service.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/device_service.dart';
import '../services/notification_service.dart';
import '../services/prediction_service.dart';
import '../services/product_service.dart';
import '../services/token_storage.dart';

part 'service_providers.g.dart';

/// 토큰 저장소 (싱글톤).
@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => TokenStorage();

/// API 클라이언트 (싱글톤).
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(tokenStorage: tokenStorage);
}

/// 인증 서비스.
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthService(api: api, tokenStorage: tokenStorage);
}

/// 상품 서비스.
@Riverpod(keepAlive: true)
ProductService productService(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return ProductService(api: api);
}

/// 알림(Alert) 서비스.
@Riverpod(keepAlive: true)
AlertService alertService(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return AlertService(api: api);
}

/// 알림(Notification) 서비스.
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return NotificationService(api: api);
}

/// 디바이스 서비스.
@Riverpod(keepAlive: true)
DeviceService deviceService(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return DeviceService(api: api);
}

/// AI 예측 서비스.
@Riverpod(keepAlive: true)
PredictionService predictionService(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return PredictionService(api: api);
}
