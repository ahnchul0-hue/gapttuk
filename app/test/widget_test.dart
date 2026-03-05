import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gapttuk_app/main.dart';
import 'package:gapttuk_app/models/product.dart';
import 'package:gapttuk_app/providers/product_provider.dart';

void main() {
  testWidgets('App renders without crash', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // 네트워크 호출 방지 — 빈 리스트 반환
          popularSearchesProvider.overrideWith(
            (ref) async => <PopularSearch>[],
          ),
        ],
        child: const GapttukApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('값뚝'), findsOneWidget);
  });
}
