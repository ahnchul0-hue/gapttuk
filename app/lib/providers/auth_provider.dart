import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import 'service_providers.dart';

part 'auth_provider.g.dart';

/// 인증 상태 — null이면 미인증.
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  User? build() => null;

  /// 소셜 로그인 실행.
  Future<void> login({
    required String provider,
    required String accessToken,
  }) async {
    final authService = ref.read(authServiceProvider);
    final response = await authService.socialLogin(
      provider: provider,
      accessToken: accessToken,
    );
    state = response.user;
  }

  /// 현재 사용자 정보 새로고침.
  Future<void> refresh() async {
    final authService = ref.read(authServiceProvider);
    try {
      state = await authService.me();
    } catch (_) {
      state = null;
    }
  }

  /// 로그아웃.
  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = null;
  }
}
