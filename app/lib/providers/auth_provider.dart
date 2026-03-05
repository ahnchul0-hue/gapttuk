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
  Future<AuthResponse> login({
    required String provider,
    required String token,
    String? referralCode,
    bool termsAgreed = false,
    bool privacyAgreed = false,
    bool marketingAgreed = false,
  }) async {
    final authService = ref.read(authServiceProvider);
    final response = await authService.socialLogin(
      provider: provider,
      token: token,
      referralCode: referralCode,
      termsAgreed: termsAgreed,
      privacyAgreed: privacyAgreed,
      marketingAgreed: marketingAgreed,
    );
    state = response.user;
    // 로그인 성공 후 FCM 토큰 등록 시도
    ref.read(pushServiceProvider).registerDeviceIfNeeded();
    return response;
  }

  /// 현재 사용자 정보 새로고침.
  Future<void> refresh() async {
    final authService = ref.read(authServiceProvider);
    try {
      state = await authService.me();
      // 세션 복원 후 FCM 토큰 등록 시도
      ref.read(pushServiceProvider).registerDeviceIfNeeded();
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

  /// 회원 탈퇴.
  Future<void> withdraw() async {
    final authService = ref.read(authServiceProvider);
    await authService.withdraw();
    state = null;
  }
}
