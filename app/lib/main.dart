import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'config/constants.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: AppConstants.kakaoNativeAppKey);
  runApp(const ProviderScope(child: GapttukApp()));
}

class GapttukApp extends ConsumerStatefulWidget {
  const GapttukApp({super.key});

  @override
  ConsumerState<GapttukApp> createState() => _GapttukAppState();
}

class _GapttukAppState extends ConsumerState<GapttukApp> {
  @override
  void initState() {
    super.initState();
    // 앱 시작 시 저장된 토큰으로 사용자 정보 복원 시도.
    Future.microtask(() => ref.read(authStateProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '값뚝',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
