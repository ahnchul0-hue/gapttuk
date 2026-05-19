import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/screens/auth/login_screen.dart';

void main() {
  Widget buildScreen() {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
  }

  group('LoginScreen', () {
    testWidgets('앱 이름 "값뚝" 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('값뚝'), findsOneWidget);
    });

    testWidgets('슬로건 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('최저가 추적의 시작'), findsOneWidget);
    });

    testWidgets('4개 소셜 로그인 버튼 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('카카오로 시작하기'), findsOneWidget);
      expect(find.text('Google로 시작하기'), findsOneWidget);
      expect(find.text('Apple로 시작하기'), findsOneWidget);
      expect(find.text('네이버로 시작하기'), findsOneWidget);
    });

    testWidgets('둘러보기 버튼 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('둘러보기'), findsOneWidget);
    });

    testWidgets('로고 아이콘 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });

    testWidgets('ElevatedButton 4개 렌더링', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(ElevatedButton), findsNWidgets(4));
    });

    testWidgets('카카오 버튼 chat_bubble 아이콘 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.chat_bubble), findsOneWidget);
    });

    testWidgets('Apple 버튼 apple 아이콘 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.apple), findsOneWidget);
    });

    testWidgets('네이버 버튼 north_east 아이콘 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.north_east), findsOneWidget);
    });

    testWidgets('초기 상태에서 로딩 표시기 없음', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    // ── Night-32 신규 ──────────────────────────────────────────────────────

    testWidgets('Google 버튼 g_mobiledata 아이콘 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
    });

    testWidgets('로고 Semantics "값뚝 로고" 레이블', (tester) async {
      await tester.pumpWidget(buildScreen());
      final logoSemantics = find
          .ancestor(
            of: find.byIcon(Icons.trending_down),
            matching: find.byType(Semantics),
          )
          .first;
      expect(
        tester.widget<Semantics>(logoSemantics).properties.label,
        '값뚝 로고',
      );
    });

    testWidgets('TextButton (둘러보기) 1개 렌더링', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('SafeArea 렌더링', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
