import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    } on DioException catch (e, st) {
      // 네트워크 오류 또는 401 — 미인증으로 처리
      debugPrint('AuthState.refresh: network/auth error — $e\n$st');
      state = null;
    } catch (e, st) {
      // 예상치 못한 오류 (스키마 변경, 타입 오류 등) — 로깅 후 미인증 처리
      debugPrint('AuthState.refresh: unexpected error — $e\n$st');
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
