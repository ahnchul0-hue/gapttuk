import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';

/// 소셜 로그인 화면.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onPressed: () => _login(context, ref, 'kakao'),
              ),
              const SizedBox(height: 12),

              // 구글 로그인
              _SocialLoginButton(
                label: 'Google로 시작하기',
                color: Colors.white,
                textColor: Colors.black87,
                icon: Icons.g_mobiledata,
                onPressed: () => _login(context, ref, 'google'),
              ),
              const SizedBox(height: 12),

              // 애플 로그인
              _SocialLoginButton(
                label: 'Apple로 시작하기',
                color: Colors.black,
                textColor: Colors.white,
                icon: Icons.apple,
                onPressed: () => _login(context, ref, 'apple'),
              ),
              const SizedBox(height: 12),

              // 네이버 로그인
              _SocialLoginButton(
                label: '네이버로 시작하기',
                color: const Color(0xFF03C75A),
                textColor: Colors.white,
                icon: Icons.north_east,
                onPressed: () => _login(context, ref, 'naver'),
              ),

              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('둘러보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, WidgetRef ref, String provider) {
    // TODO: 각 소셜 SDK에서 access_token 획득 후 호출
    // ref.read(authStateProvider.notifier).login(
    //   provider: provider,
    //   accessToken: socialAccessToken,
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider 로그인 — SDK 연동 필요')),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
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
