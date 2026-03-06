import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/constants.dart';
import 'package:gapttuk_app/services/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockSecure;
  late TokenStorage storage;

  setUp(() {
    mockSecure = MockFlutterSecureStorage();
    storage = TokenStorage(storage: mockSecure);
  });

  group('getAccessToken', () {
    test('저장된 토큰이 있으면 반환', () async {
      when(() => mockSecure.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'jwt_abc');

      final token = await storage.getAccessToken();
      expect(token, 'jwt_abc');
    });

    test('토큰이 없으면 null 반환', () async {
      when(() => mockSecure.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => null);

      final token = await storage.getAccessToken();
      expect(token, isNull);
    });
  });

  group('getRefreshToken', () {
    test('저장된 리프레시 토큰 반환', () async {
      when(() => mockSecure.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => 'refresh_xyz');

      final token = await storage.getRefreshToken();
      expect(token, 'refresh_xyz');
    });
  });

  group('saveTokens', () {
    test('access_token과 refresh_token을 동시 저장', () async {
      when(() => mockSecure.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await storage.saveTokens(
        accessToken: 'new_access',
        refreshToken: 'new_refresh',
      );

      verify(() => mockSecure.write(
            key: AppConstants.accessTokenKey,
            value: 'new_access',
          )).called(1);
      verify(() => mockSecure.write(
            key: AppConstants.refreshTokenKey,
            value: 'new_refresh',
          )).called(1);
    });
  });

  group('clearTokens', () {
    test('두 키 모두 삭제', () async {
      when(() => mockSecure.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await storage.clearTokens();

      verify(() => mockSecure.delete(key: AppConstants.accessTokenKey))
          .called(1);
      verify(() => mockSecure.delete(key: AppConstants.refreshTokenKey))
          .called(1);
    });
  });

  group('엣지 케이스', () {
    test('saveTokens 후 getAccessToken 호출 시 저장된 값 반환', () async {
      when(() => mockSecure.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
      when(() => mockSecure.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'saved_token');

      await storage.saveTokens(
        accessToken: 'saved_token',
        refreshToken: 'saved_refresh',
      );

      final token = await storage.getAccessToken();
      expect(token, 'saved_token');
    });

    test('빈 문자열 토큰도 저장 가능', () async {
      when(() => mockSecure.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await storage.saveTokens(
        accessToken: '',
        refreshToken: '',
      );

      verify(() => mockSecure.write(
            key: AppConstants.accessTokenKey,
            value: '',
          )).called(1);
    });
  });
}
