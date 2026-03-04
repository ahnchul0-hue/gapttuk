import '../models/user.dart';
import 'api_client.dart';
import 'token_storage.dart';

/// 인증 API 호출.
class AuthService {
  final ApiClient _api;
  final TokenStorage _tokenStorage;

  AuthService({required ApiClient api, required TokenStorage tokenStorage})
      : _api = api,
        _tokenStorage = tokenStorage;

  /// 소셜 로그인 (kakao/google/apple/naver).
  Future<AuthResponse> socialLogin({
    required String provider,
    required String accessToken,
  }) async {
    final response = await _api.dio.post(
      '/api/v1/auth/$provider',
      data: {'access_token': accessToken},
    );
    final authResponse =
        AuthResponse.fromJson(response.data['data'] as Map<String, dynamic>);
    await _tokenStorage.saveTokens(
      accessToken: authResponse.tokens.accessToken,
      refreshToken: authResponse.tokens.refreshToken,
    );
    return authResponse;
  }

  /// 현재 사용자 정보 조회.
  Future<User> me() async {
    final response = await _api.dio.get('/api/v1/auth/me');
    return User.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// 로그아웃.
  Future<void> logout() async {
    try {
      await _api.dio.post('/api/v1/auth/logout');
    } finally {
      await _tokenStorage.clearTokens();
    }
  }
}
