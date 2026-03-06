import '../config/api_endpoints.dart';
import 'api_client.dart';

class DeviceService {
  final ApiClient _api;

  DeviceService({required ApiClient api}) : _api = api;

  /// 기기 목록 조회.
  Future<List<Map<String, dynamic>>> getDevices() async {
    final response = await _api.dio.get(ApiEndpoints.devices);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  /// 기기 등록 (FCM 토큰).
  Future<Map<String, dynamic>> registerDevice({
    required String deviceToken,
    required String platform, // 'android' | 'ios'
  }) async {
    final response = await _api.dio.post(
      ApiEndpoints.devices,
      data: {
        'device_token': deviceToken,
        'platform': platform,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  /// 기기 삭제 (204).
  Future<void> unregisterDevice(int id) async {
    await _api.dio.delete(ApiEndpoints.deviceDelete(id));
  }

  /// 푸시 토글.
  Future<Map<String, dynamic>> togglePush({
    required int id,
    required bool pushEnabled,
  }) async {
    final response = await _api.dio.patch(
      ApiEndpoints.devicePushToggle(id),
      data: {'push_enabled': pushEnabled},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
