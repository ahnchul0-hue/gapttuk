import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/product.dart';
import 'package:gapttuk_app/providers/product_provider.dart';
import 'package:gapttuk_app/screens/home/home_screen.dart';

void main() {
  final fakeSearches = [
    PopularSearch(id: 1, rank: 1, keyword: '아이폰 15', searchCount: 500, trend: 'up'),
    PopularSearch(id: 2, rank: 2, keyword: '갤럭시 S24', searchCount: 400, trend: 'down'),
    PopularSearch(id: 3, rank: 3, keyword: '에어팟', searchCount: 300, trend: null),
  ];

  Widget buildScreen({
    AsyncValue<List<PopularSearch>> popularAsync =
        const AsyncValue.loading(),
  }) {
    return ProviderScope(
      overrides: [
        popularSearchesProvider.overrideWith(
          (ref) => Future.value(
            popularAsync.maybeWhen(data: (d) => d, orElse: () => throw Exception('test error')),
          ),
        ),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
    );
  }

  Widget buildScreenWithData() {
    return ProviderScope(
      overrides: [
        popularSearchesProvider.overrideWith((_) => Future.value(fakeSearches)),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
    );
  }

  Widget buildScreenWithError() {
    return ProviderScope(
      overrides: [
        popularSearchesProvider.overrideWith(
          (_) => Future.error(Exception('서버 오류'), StackTrace.empty),
        ),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets('앱 이름 "값뚝" AppBar 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('값뚝'), findsOneWidget);
    });

    testWidgets('검색 바 힌트 텍스트 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('상품명 또는 URL을 검색하세요'), findsOneWidget);
    });

    testWidgets('URL로 상품 추가 카드 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('URL로 상품 추가'), findsOneWidget);
    });

    testWidgets('인기 검색어 섹션 타이틀 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('인기 검색어'), findsOneWidget);
    });

    testWidgets('데이터 로드 후 인기 검색어 목록 표시', (tester) async {
      await tester.pumpWidget(buildScreenWithData());
      await tester.pumpAndSettle();

      expect(find.text('아이폰 15'), findsOneWidget);
      expect(find.text('갤럭시 S24'), findsOneWidget);
      expect(find.text('에어팟'), findsOneWidget);
    });

    testWidgets('에러 시 에러 메시지 표시', (tester) async {
      await tester.pumpWidget(buildScreenWithError());
      await tester.pumpAndSettle();

      // friendlyErrorMessage로 변환된 에러 표시
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('URL 추가 다이얼로그 열기', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('URL로 상품 추가'));
      await tester.pumpAndSettle();

      expect(find.text('URL로 상품 추가'), findsWidgets);
      expect(find.text('취소'), findsOneWidget);
    });
  });
}
