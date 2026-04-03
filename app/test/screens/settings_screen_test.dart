import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/screens/my/settings_screen.dart';

void main() {
  Widget buildScreen() {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: const SettingsScreen()),
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

    testWidgets('푸시 알림 스위치 비활성 + 안내 문구', (tester) async {
      await tester.pumpWidget(buildScreen());
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
      expect(switchWidget.onChanged, isNull);
      expect(find.text('준비 중'), findsOneWidget);
    });

    // ── Night-30 신규 ──────────────────────────────────────────────────────

    testWidgets('로그아웃 탭 → 확인 다이얼로그 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();
      expect(find.text('정말 로그아웃 하시겠습니까?'), findsOneWidget);
    });

    testWidgets('로그아웃 다이얼로그 취소 탭 → 다이얼로그 닫힘', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('회원 탈퇴 탭 → 확인 다이얼로그 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('회원 탈퇴'));
      await tester.pumpAndSettle();
      expect(find.textContaining('정말 탈퇴하시겠습니까?'), findsOneWidget);
    });

    testWidgets('계정 섹션 아이콘 표시 — logout + person_remove_outlined', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byIcon(Icons.person_remove_outlined), findsOneWidget);
    });

    // ── Night-33 신규 ──────────────────────────────────────────────────────

    testWidgets('회원 탈퇴 다이얼로그 "탈퇴" 버튼 표시', (tester) async {
      // _showDeleteAccountDialog → AlertDialog actions에 '탈퇴' TextButton
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('회원 탈퇴'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextButton, '탈퇴'), findsOneWidget);
    });

    testWidgets('회원 탈퇴 다이얼로그 취소 탭 → 닫힘', (tester) async {
      // '취소' → Navigator.pop(false) → confirmed != true → withdraw() 미호출
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('회원 탈퇴'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('로그아웃 다이얼로그 "로그아웃" 확인 버튼 표시', (tester) async {
      // _logout → AlertDialog actions에 '로그아웃' TextButton (확인용)
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('로그아웃').first);
      await tester.pumpAndSettle();
      // 다이얼로그 action 버튼 '로그아웃' 확인
      expect(find.widgetWithText(TextButton, '로그아웃'), findsOneWidget);
    });

    testWidgets('회원 탈퇴 다이얼로그 경고 문구 "데이터가 삭제됩니다" 포함', (tester) async {
      // AlertDialog content: '정말 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제됩니다.'
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('회원 탈퇴'));
      await tester.pumpAndSettle();
      expect(find.textContaining('데이터가 삭제됩니다'), findsOneWidget);
    });
  });
}
