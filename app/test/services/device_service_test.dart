import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/device_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late DeviceService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = DeviceService(api: mockApi);
  });

  group('getDevices', () {
    test('기기 목록 조회', () async {
      when(() => mockDio.get('/api/v1/devices/')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': [
              {
                'id': 1,
                'device_token': 'fcm_token_1',
                'platform': 'android',
                'device_name': 'Galaxy S24',
                'push_enabled': true,
              },
              {
                'id': 2,
                'device_token': 'apns_token_1',
                'platform': 'ios',
                'device_name': 'iPhone 16',
                'push_enabled': false,
              },
            ]
          },
        ),
      );

      final devices = await service.getDevices();

      expect(devices.length, 2);
      expect(devices.first['platform'], 'android');
      expect(devices.last['platform'], 'ios');
    });

    test('기기 없음', () async {
      when(() => mockDio.get('/api/v1/devices/')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'data': []},
        ),
      );

      final devices = await service.getDevices();

      expect(devices, isEmpty);
    });
  });

  group('registerDevice', () {
    test('FCM 기기 등록', () async {
      when(() => mockDio.post(
            '/api/v1/devices/',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 1,
              'device_token': 'fcm_token_abc',
              'platform': 'android',
              'device_name': 'Pixel 9',
              'push_enabled': true,
            }
          },
        ),
      );

      final device = await service.registerDevice(
        deviceToken: 'fcm_token_abc',
        platform: 'android',
        deviceName: 'Pixel 9',
      );

      expect(device['id'], 1);
      expect(device['platform'], 'android');
      expect(device['device_name'], 'Pixel 9');
    });

    test('deviceName 없이 등록', () async {
      when(() => mockDio.post(
            '/api/v1/devices/',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 2,
              'device_token': 'apns_token_xyz',
              'platform': 'ios',
              'push_enabled': true,
            }
          },
        ),
      );

      final device = await service.registerDevice(
        deviceToken: 'apns_token_xyz',
        platform: 'ios',
      );

      expect(device['id'], 2);
      expect(device['platform'], 'ios');
    });
  });

  group('unregisterDevice', () {
    test('기기 삭제 (204)', () async {
      when(() => mockDio.delete('/api/v1/devices/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );

      await service.unregisterDevice(1);

      verify(() => mockDio.delete('/api/v1/devices/1')).called(1);
    });
  });

  group('togglePush', () {
    test('푸시 활성화', () async {
      when(() => mockDio.patch(
            '/api/v1/devices/1/push',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 1,
              'push_enabled': true,
            }
          },
        ),
      );

      final device = await service.togglePush(id: 1, pushEnabled: true);

      expect(device['push_enabled'], true);
    });

    test('푸시 비활성화', () async {
      when(() => mockDio.patch(
            '/api/v1/devices/1/push',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 1,
              'push_enabled': false,
            }
          },
        ),
      );

      final device = await service.togglePush(id: 1, pushEnabled: false);

      expect(device['push_enabled'], false);
    });
  });
}
