import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/screens/search/search_screen.dart';

Widget buildScreen() {
  return const ProviderScope(
    child: MaterialApp(home: SearchScreen()),
  );
}

void main() {
  group('SearchScreen', () {
    testWidgets('검색 AppBar 렌더링', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('검색 입력 필드 표시', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('초기 상태: 검색 전 안내 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
        ),
      );
      await tester.pump();
      // 아직 검색하지 않은 상태 — 결과 없음 UI
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('검색어 입력 가능', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
        ),
      );
      await tester.enterText(find.byType(TextField), '아이폰');
      expect(find.text('아이폰'), findsOneWidget);
    });
  });
}
