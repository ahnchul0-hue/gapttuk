import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/services/api_client.dart';
import 'package:gapttuk_app/services/auth_service.dart';
import 'package:gapttuk_app/services/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApi;
  late MockTokenStorage mockStorage;
  late AuthService service;

  setUp(() {
    mockDio = MockDio();
    mockApi = MockApiClient();
    mockStorage = MockTokenStorage();
    when(() => mockApi.dio).thenReturn(mockDio);
    service = AuthService(api: mockApi, tokenStorage: mockStorage);
  });

  group('socialLogin', () {
    test('카카오 로그인 — access_token 키 사용', () async {
      when(() => mockDio.post(
            '/api/v1/auth/kakao',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'user': {
                'id': 1,
                'email': 'test@kakao.com',
                'nickname': '테스터',
              },
              'tokens': {
                'access_token': 'jwt_access',
                'refresh_token': 'refresh_hex',
                'expires_in': 300,
              },
              'is_new_user': true,
            }
          },
        ),
      );
      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      final result = await service.socialLogin(
        provider: 'kakao',
        token: 'kakao_access_token',
      );

      expect(result.user.email, 'test@kakao.com');
      expect(result.isNewUser, true);
      expect(result.tokens.accessToken, 'jwt_access');
      verify(() => mockStorage.saveTokens(
            accessToken: 'jwt_access',
            refreshToken: 'refresh_hex',
          )).called(1);
    });

    test('구글 로그인 — id_token 키 사용', () async {
      when(() => mockDio.post(
            '/api/v1/auth/google',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'user': {
                'id': 2,
                'email': 'test@gmail.com',
                'nickname': '구글유저',
              },
              'tokens': {
                'access_token': 'jwt_google',
                'refresh_token': 'refresh_google',
                'expires_in': 300,
              },
              'is_new_user': false,
            }
          },
        ),
      );
      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      final result = await service.socialLogin(
        provider: 'google',
        token: 'google_id_token',
      );

      expect(result.user.email, 'test@gmail.com');
      expect(result.isNewUser, false);
      // 구글은 id_token 키로 전달됨을 verify
      verify(() => mockDio.post(
            '/api/v1/auth/google',
            data: {
              'id_token': 'google_id_token',
              'terms_agreed': false,
              'privacy_agreed': false,
              'marketing_agreed': false,
            },
          )).called(1);
    });
  });

  group('me', () {
    test('현재 사용자 정보 조회', () async {
      when(() => mockDio.get('/api/v1/auth/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            'data': {
              'id': 1,
              'email': 'user@example.com',
              'nickname': '민지',
              'referral_code': 'GAP-AB12',
            }
          },
        ),
      );

      final user = await service.me();

      expect(user.id, 1);
      expect(user.nickname, '민지');
      expect(user.referralCode, 'GAP-AB12');
    });
  });

  group('updateConsent', () {
    test('약관 동의 업데이트', () async {
      when(() => mockDio.patch(
            '/api/v1/auth/consent',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {'ok': true},
        ),
      );

      await service.updateConsent(
        termsAgreed: true,
        privacyAgreed: true,
        marketingAgreed: false,
        referralCode: 'GAP-XY99',
      );

      verify(() => mockDio.patch(
            '/api/v1/auth/consent',
            data: {
              'terms_agreed': true,
              'privacy_agreed': true,
              'marketing_agreed': false,
              'referral_code': 'GAP-XY99',
            },
          )).called(1);
    });

    test('추천코드 없이 업데이트', () async {
      when(() => mockDio.patch(
            '/api/v1/auth/consent',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {'ok': true},
        ),
      );

      await service.updateConsent(
        termsAgreed: true,
        privacyAgreed: true,
        marketingAgreed: true,
      );

      verify(() => mockDio.patch(
            '/api/v1/auth/consent',
            data: {
              'terms_agreed': true,
              'privacy_agreed': true,
              'marketing_agreed': true,
            },
          )).called(1);
    });
  });

  group('logout', () {
    test('로그아웃 — 토큰 삭제', () async {
      when(() => mockDio.post('/api/v1/auth/logout')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {'ok': true},
        ),
      );
      when(() => mockStorage.clearTokens()).thenAnswer((_) async {});

      await service.logout();

      verify(() => mockDio.post('/api/v1/auth/logout')).called(1);
      verify(() => mockStorage.clearTokens()).called(1);
    });

    test('로그아웃 API 실패해도 토큰 삭제', () async {
      when(() => mockDio.post('/api/v1/auth/logout')).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      when(() => mockStorage.clearTokens()).thenAnswer((_) async {});

      // finally 블록에서 clearTokens 호출되므로 예외는 전파됨
      await expectLater(
        () => service.logout(),
        throwsA(isA<DioException>()),
      );

      verify(() => mockStorage.clearTokens()).called(1);
    });
  });

  group('withdraw', () {
    test('회원 탈퇴 — 토큰 삭제', () async {
      when(() => mockDio.delete('/api/v1/auth/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 204,
        ),
      );
      when(() => mockStorage.clearTokens()).thenAnswer((_) async {});

      await service.withdraw();

      verify(() => mockDio.delete('/api/v1/auth/me')).called(1);
      verify(() => mockStorage.clearTokens()).called(1);
    });

    test('탈퇴 API 실패해도 토큰 삭제', () async {
      when(() => mockDio.delete('/api/v1/auth/me')).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      when(() => mockStorage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        () => service.withdraw(),
        throwsA(isA<DioException>()),
      );

      verify(() => mockStorage.clearTokens()).called(1);
    });
  });
}
