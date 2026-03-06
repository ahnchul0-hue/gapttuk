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
  });
}
