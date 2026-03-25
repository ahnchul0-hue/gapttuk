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
  });
}
