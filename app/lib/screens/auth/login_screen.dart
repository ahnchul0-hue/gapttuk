import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/error_utils.dart';

/// 소셜 로그인 화면.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _login(String provider) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      String token;

      switch (provider) {
        case 'kakao':
          token = await _getKakaoToken();
        case 'google':
          token = await _getGoogleToken();
        case 'apple':
          token = await _getAppleToken();
        case 'naver':
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('네이버 로그인 준비 중입니다.')),
            );
          }
          if (mounted) setState(() => _isLoading = false);
          return;
        default:
          throw Exception('지원하지 않는 프로바이더: $provider');
      }

      // 서버 로그인 (termsAgreed: false — 신규 사용자는 온보딩에서 처리)
      final response = await ref.read(authStateProvider.notifier).login(
            provider: provider,
            token: token,
            termsAgreed: false,
            privacyAgreed: false,
            marketingAgreed: false,
          );

      if (!mounted) return;

      if (response.isNewUser) {
        // 신규 사용자 → 온보딩으로 이동
        context.go('/onboarding');
      } else {
        // 기존 사용자 → from 파라미터 경로 또는 홈으로
        final from = GoRouterState.of(context).uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) {
          context.go(Uri.decodeComponent(from));
        } else {
          context.go('/');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// 카카오 소셜 토큰 획득.
  Future<String> _getKakaoToken() async {
    OAuthToken oAuthToken;
    if (await isKakaoTalkInstalled()) {
      try {
        oAuthToken = await UserApi.instance.loginWithKakaoTalk();
      } catch (_) {
        // 카카오톡 미설치 또는 취소 시 계정으로 폴백
        oAuthToken = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      oAuthToken = await UserApi.instance.loginWithKakaoAccount();
    }
    return oAuthToken.accessToken;
  }

  /// 구글 소셜 토큰 획득 (id_token).
  Future<String> _getGoogleToken() async {
    final googleSignIn = GoogleSignIn();
    final account = await googleSignIn.signIn();
    if (account == null) throw Exception('구글 로그인이 취소되었습니다.');
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) throw Exception('구글 ID 토큰을 가져올 수 없습니다.');
    return idToken;
  }

  /// 애플 소셜 토큰 획득 (identity_token).
  Future<String> _getAppleToken() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final identityToken = credential.identityToken;
    if (identityToken == null) throw Exception('Apple ID 토큰을 가져올 수 없습니다.');
    return identityToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고
              Icon(
                Icons.trending_down,
                size: 80,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '값뚝',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '최저가 추적의 시작',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 48),

              // 카카오 로그인
              _SocialLoginButton(
                label: '카카오로 시작하기',
                color: const Color(0xFFFEE500),
                textColor: Colors.black87,
                icon: Icons.chat_bubble,
                isLoading: _isLoading,
                onPressed: () => _login('kakao'),
              ),
              const SizedBox(height: 12),

              // 구글 로그인
              _SocialLoginButton(
                label: 'Google로 시작하기',
                color: Colors.white,
                textColor: Colors.black87,
                icon: Icons.g_mobiledata,
                isLoading: _isLoading,
                onPressed: () => _login('google'),
              ),
              const SizedBox(height: 12),

              // 애플 로그인
              _SocialLoginButton(
                label: 'Apple로 시작하기',
                color: Colors.black,
                textColor: Colors.white,
                icon: Icons.apple,
                isLoading: _isLoading,
                onPressed: () => _login('apple'),
              ),
              const SizedBox(height: 12),

              // 네이버 로그인
              _SocialLoginButton(
                label: '네이버로 시작하기',
                color: const Color(0xFF03C75A),
                textColor: Colors.white,
                icon: Icons.north_east,
                isLoading: _isLoading,
                onPressed: () => _login('naver'),
              ),

              const SizedBox(height: 24),
              TextButton(
                onPressed: _isLoading ? null : () => context.go('/'),
                child: const Text('둘러보기'),
              ),

              if (_isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const _SocialLoginButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: color == Colors.white
                ? const BorderSide(color: Colors.grey)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
