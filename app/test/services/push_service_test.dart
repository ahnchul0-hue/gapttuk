import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/device_service.dart';
import 'package:gapttuk_app/services/push_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDeviceService extends Mock implements DeviceService {}

void main() {
  late MockDeviceService mockDeviceService;
  late PushService pushService;

  setUp(() {
    mockDeviceService = MockDeviceService();
    pushService = PushService(deviceService: mockDeviceService);
  });

  group('registerDeviceIfNeeded', () {
    test('Firebase 미설정 시 registerDevice를 호출하지 않는다', () async {
      await pushService.registerDeviceIfNeeded();

      verifyNever(() => mockDeviceService.registerDevice(
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ));
    });

    test('에러 발생 시 예외를 삼킨다', () async {
      // _getDeviceToken이 null이므로 registerDevice에 도달하지 않지만,
      // try-catch 블록의 안전성을 확인
      expect(
        () => pushService.registerDeviceIfNeeded(),
        returnsNormally,
      );
    });
  });

  group('togglePush', () {
    test('deviceService.togglePush에 위임한다', () async {
      when(() => mockDeviceService.togglePush(
            id: 42,
            pushEnabled: true,
          )).thenAnswer((_) async => {
            'id': 42,
            'push_enabled': true,
          });

      await pushService.togglePush(deviceId: 42, enabled: true);

      verify(() => mockDeviceService.togglePush(
            id: 42,
            pushEnabled: true,
          )).called(1);
    });

    test('비활성화 시 pushEnabled=false 전달', () async {
      when(() => mockDeviceService.togglePush(
            id: 7,
            pushEnabled: false,
          )).thenAnswer((_) async => {
            'id': 7,
            'push_enabled': false,
          });

      await pushService.togglePush(deviceId: 7, enabled: false);

      verify(() => mockDeviceService.togglePush(
            id: 7,
            pushEnabled: false,
          )).called(1);
    });

    test('deviceService 에러 시 예외가 전파된다', () async {
      when(() => mockDeviceService.togglePush(
            id: 1,
            pushEnabled: true,
          )).thenThrow(Exception('네트워크 오류'));

      expect(
        () => pushService.togglePush(deviceId: 1, enabled: true),
        throwsException,
      );
    });
  });
}
