import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/screens/my/settings_screen.dart';

void main() {
  Widget buildScreen() {
    return const ProviderScope(
      child: MaterialApp(home: SettingsScreen()),
    );
  }

  group('SettingsScreen', () {
    testWidgets('AppBar에 "설정" 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('설정'), findsOneWidget);
    });

    testWidgets('알림 설정 섹션 헤더 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('푸시 알림 스위치 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('푸시 알림'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('앱 정보 섹션 항목들 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('앱 정보'), findsOneWidget);
      expect(find.text('버전'), findsOneWidget);
      expect(find.text('이용약관'), findsOneWidget);
      expect(find.text('개인정보처리방침'), findsOneWidget);
      expect(find.text('오픈소스 라이선스'), findsOneWidget);
    });

    testWidgets('계정 섹션: 로그아웃/탈퇴 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('계정'), findsOneWidget);
      expect(find.text('로그아웃'), findsOneWidget);
      expect(find.text('회원 탈퇴'), findsOneWidget);
    });

    testWidgets('버전 번호 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('0.1.0'), findsOneWidget);
    });

    testWidgets('푸시 알림 스위치 토글 동작', (tester) async {
      await tester.pumpWidget(buildScreen());
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pump();

      final updated = tester.widget<Switch>(find.byType(Switch));
      expect(updated.value, isFalse);
    });
  });
}
