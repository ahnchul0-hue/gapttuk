import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/user.dart';
import 'package:gapttuk_app/providers/auth_provider.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/services/auth_service.dart';
import 'package:gapttuk_app/services/push_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockPushService extends Mock implements PushService {}

ProviderContainer buildContainer(
  MockAuthService mockAuth,
  MockPushService mockPush,
) {
  return ProviderContainer(
    overrides: [
      authServiceProvider.overrideWith((_) => mockAuth),
      pushServiceProvider.overrideWith((_) => mockPush),
    ],
  );
}

const _kUser = User(id: 1, nickname: '민지', email: 'minji@example.com');
const _kTokens = AuthTokens(
  accessToken: 'jwt_access',
  refreshToken: 'refresh_hex',
  expiresIn: 300,
);
const _kAuthResponse = AuthResponse(
  user: _kUser,
  tokens: _kTokens,
  isNewUser: false,
);

void main() {
  late MockAuthService mockAuth;
  late MockPushService mockPush;

  setUp(() {
    mockAuth = MockAuthService();
    mockPush = MockPushService();
    // pushService.registerDeviceIfNeeded() 기본 stub
    when(() => mockPush.registerDeviceIfNeeded()).thenAnswer((_) async {});
  });

  tearDown(() {
    reset(mockAuth);
    reset(mockPush);
  });

  group('AuthState', () {
    test('초기 상태 null', () {
      final container = buildContainer(mockAuth, mockPush);
      addTearDown(container.dispose);

      expect(container.read(authStateProvider), isNull);
    });

    test('login 성공 시 state = user', () async {
      when(
        () => mockAuth.socialLogin(
          provider: 'kakao',
          token: 'kakao_token',
          referralCode: null,
          termsAgreed: false,
          privacyAgreed: false,
          marketingAgreed: false,
        ),
      ).thenAnswer((_) async => _kAuthResponse);

      final container = buildContainer(mockAuth, mockPush);
      addTearDown(container.dispose);

      await container.read(authStateProvider.notifier).login(
            provider: 'kakao',
            token: 'kakao_token',
          );

      expect(container.read(authStateProvider)?.id, 1);
      expect(container.read(authStateProvider)?.nickname, '민지');
      verify(() => mockPush.registerDeviceIfNeeded()).called(1);
    });

    test('logout 후 state null', () async {
      when(() => mockAuth.logout()).thenAnswer((_) async {});

      final container = buildContainer(mockAuth, mockPush);
      addTearDown(container.dispose);

      await container.read(authStateProvider.notifier).logout();

      expect(container.read(authStateProvider), isNull);
      verify(() => mockAuth.logout()).called(1);
    });

    test('refresh 성공 시 state = user', () async {
      when(() => mockAuth.me()).thenAnswer((_) async => _kUser);

      final container = buildContainer(mockAuth, mockPush);
      addTearDown(container.dispose);

      await container.read(authStateProvider.notifier).refresh();

      expect(container.read(authStateProvider)?.id, 1);
      verify(() => mockAuth.me()).called(1);
      verify(() => mockPush.registerDeviceIfNeeded()).called(1);
    });

    test('refresh DioException 시 state null 유지', () async {
      when(() => mockAuth.me()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final container = buildContainer(mockAuth, mockPush);
      addTearDown(container.dispose);

      await container.read(authStateProvider.notifier).refresh();

      expect(container.read(authStateProvider), isNull);
    });

    test('withdraw 후 state null', () async {
      when(() => mockAuth.withdraw()).thenAnswer((_) async {});

      final container = buildContainer(mockAuth, mockPush);
      addTearDown(container.dispose);

      await container.read(authStateProvider.notifier).withdraw();

      expect(container.read(authStateProvider), isNull);
      verify(() => mockAuth.withdraw()).called(1);
    });
  });
}
