import 'api_client.dart';

class DeviceService {
  final ApiClient _api;

  DeviceService({required ApiClient api}) : _api = api;

  /// 기기 목록 조회.
  Future<List<Map<String, dynamic>>> getDevices() async {
    final response = await _api.dio.get('/api/v1/devices/');
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  /// 기기 등록 (FCM 토큰).
  Future<Map<String, dynamic>> registerDevice({
    required String deviceToken,
    required String platform, // 'android' | 'ios'
    String? deviceName,
  }) async {
    final response = await _api.dio.post(
      '/api/v1/devices/',
      data: {
        'device_token': deviceToken,
        'platform': platform,
        'device_name': ?deviceName,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  /// 기기 삭제 (204).
  Future<void> unregisterDevice(int id) async {
    await _api.dio.delete('/api/v1/devices/$id');
  }

  /// 푸시 토글.
  Future<Map<String, dynamic>> togglePush({
    required int id,
    required bool pushEnabled,
  }) async {
    final response = await _api.dio.patch(
      '/api/v1/devices/$id/push',
      data: {'push_enabled': pushEnabled},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
