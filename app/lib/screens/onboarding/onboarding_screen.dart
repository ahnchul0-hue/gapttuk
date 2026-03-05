import 'package:flutter/material.dart';

/// 온보딩 화면 (placeholder).
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시작하기')),
      body: const Center(child: Text('준비 중')),
    );
  }
}
