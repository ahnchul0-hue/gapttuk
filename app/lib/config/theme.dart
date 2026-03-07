import 'package:flutter/material.dart';

/// 값뚝 라이트/다크 테마 정의.
abstract final class AppTheme {
  // --- 브랜드 컬러 ---
  static const Color primary = Color(0xFF6C5CE7);
  static const Color secondary = Color(0xFF00B894);
  static const Color priceDown = Color(0xFF0984E3);
  static const Color priceUp = Color(0xFFD63031);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        extensions: const [AppColors.light],
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        extensions: const [AppColors.dark],
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );
}

/// 시맨틱 색상 — 라이트/다크 모드 자동 전환.
/// 사용법: `final appColors = Theme.of(context).extension<AppColors>()!;`
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color neutral;
  final Color neutralLight;
  final Color neutralBorder;

  static const Color kakao = Color(0xFFFEE500);
  static const Color naver = Color(0xFF03C75A);

  const AppColors({
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.neutral,
    required this.neutralLight,
    required this.neutralBorder,
  });

  static const light = AppColors(
    success: Color(0xFF00B894),
    error: Color(0xFFD63031),
    warning: Color(0xFFE17055),
    info: Color(0xFF0984E3),
    neutral: Color(0xFF757575),
    neutralLight: Color(0xFFF5F5F5),
    neutralBorder: Color(0xFFE0E0E0),
  );

  static const dark = AppColors(
    success: Color(0xFF55EFC4),
    error: Color(0xFFFF7675),
    warning: Color(0xFFFDA085),
    info: Color(0xFF74B9FF),
    neutral: Color(0xFFBDBDBD),
    neutralLight: Color(0xFF424242),
    neutralBorder: Color(0xFF616161),
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? neutral,
    Color? neutralLight,
    Color? neutralBorder,
  }) {
    return AppColors(
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      neutral: neutral ?? this.neutral,
      neutralLight: neutralLight ?? this.neutralLight,
      neutralBorder: neutralBorder ?? this.neutralBorder,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralLight: Color.lerp(neutralLight, other.neutralLight, t)!,
      neutralBorder: Color.lerp(neutralBorder, other.neutralBorder, t)!,
    );
  }
}
