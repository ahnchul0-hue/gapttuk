import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/screens/search/search_screen.dart';

Widget buildScreen() {
  return ProviderScope(
    child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
  );
}

void main() {
  group('SearchScreen', () {
    testWidgets('검색 AppBar 렌더링', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('검색 입력 필드 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('초기 "검색어를 입력하세요" 텍스트 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();
      expect(find.text('검색어를 입력하세요'), findsOneWidget);
    });

    testWidgets('검색어 입력 가능', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.enterText(find.byType(TextField), '아이폰');
      expect(find.text('아이폰'), findsOneWidget);
    });

    testWidgets('힌트 텍스트 "상품명 또는 URL 검색" 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration?.hintText, '상품명 또는 URL 검색');
    });

    testWidgets('검색 아이콘 버튼 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('초기 로딩 인디케이터 없음', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('초기 상태에서 ListView 없음 — 검색 전 빈 상태', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();
      expect(find.byType(ListView), findsNothing);
    });

    // ── Night-30 신규 ──────────────────────────────────────────────────────

    testWidgets('초기 텍스트 Semantics 위젯으로 감싸짐 — label 검증', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();
      // 최근접 Semantics 조상 (.first = 가장 가까운 Semantics)
      final semanticsNode = tester.widget<Semantics>(
        find.ancestor(
          of: find.text('검색어를 입력하세요'),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(semanticsNode.properties.label, '검색어를 입력하세요');
    });

    testWidgets('TextField textInputAction.search 설정', (tester) async {
      await tester.pumpWidget(buildScreen());
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.textInputAction, TextInputAction.search);
    });

    testWidgets('검색 아이콘 버튼 tooltip "검색" 설정', (tester) async {
      await tester.pumpWidget(buildScreen());
      final iconBtn = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconBtn.tooltip, '검색');
    });

    testWidgets('빈 검색어로 검색 버튼 탭 → 로딩 인디케이터 없음', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
