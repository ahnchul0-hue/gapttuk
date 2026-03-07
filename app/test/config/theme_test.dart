import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';

void main() {
  group('AppColors', () {
    test('light and dark have different values', () {
      expect(AppColors.light.success, isNot(equals(AppColors.dark.success)));
      expect(AppColors.light.error, isNot(equals(AppColors.dark.error)));
      expect(AppColors.light.neutral, isNot(equals(AppColors.dark.neutral)));
    });

    test('copyWith preserves unchanged values', () {
      const original = AppColors.light;
      final modified = original.copyWith(error: Colors.pink);
      expect(modified.error, Colors.pink);
      expect(modified.success, original.success);
      expect(modified.info, original.info);
    });

    test('lerp interpolates between light and dark', () {
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);
      expect(mid.success, isNot(equals(AppColors.light.success)));
      expect(mid.success, isNot(equals(AppColors.dark.success)));
    });

    test('lerp at 0 returns start', () {
      final result = AppColors.light.lerp(AppColors.dark, 0.0);
      expect(result.success, AppColors.light.success);
    });

    test('lerp at 1 returns end', () {
      final result = AppColors.light.lerp(AppColors.dark, 1.0);
      expect(result.success, AppColors.dark.success);
    });

    test('brand colors are constant across themes', () {
      expect(AppColors.kakao, const Color(0xFFFEE500));
      expect(AppColors.naver, const Color(0xFF03C75A));
    });
  });

  group('AppTheme', () {
    test('light theme has AppColors extension', () {
      final ext = AppTheme.light.extension<AppColors>();
      expect(ext, isNotNull);
      expect(ext!.success, AppColors.light.success);
    });

    test('dark theme has AppColors extension', () {
      final ext = AppTheme.dark.extension<AppColors>();
      expect(ext, isNotNull);
      expect(ext!.success, AppColors.dark.success);
    });
  });
}
