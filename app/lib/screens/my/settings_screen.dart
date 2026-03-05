import 'package:flutter/material.dart';

/// 설정 화면 (placeholder).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(child: Text('준비 중')),
    );
  }
}
