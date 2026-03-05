import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/widgets/loading_skeleton.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('LoadingSkeleton', () {
    testWidgets('기본 3개 아이템 렌더링', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingSkeleton(),
          ),
        ),
      );

      // Shimmer 위젯 존재 확인
      expect(find.byType(Shimmer), findsOneWidget);

      // 72x72 placeholder 3개
      final containers = find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 72,
      );
      expect(containers, findsNWidgets(3));
    });

    testWidgets('itemCount 파라미터 적용', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingSkeleton(itemCount: 5),
          ),
        ),
      );

      final containers = find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 72,
      );
      expect(containers, findsNWidgets(5));
    });
  });
}
