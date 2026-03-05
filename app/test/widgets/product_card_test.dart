import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/product.dart';
import 'package:gapttuk_app/widgets/product_card.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  Widget buildCard(Product product, {VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: ProductCard(product: product, onTap: onTap),
      ),
    );
  }

  group('ProductCard', () {
    testWidgets('상품명 표시', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '에어팟 프로 2세대'),
        ));
        expect(find.text('에어팟 프로 2세대'), findsOneWidget);
      });
    });

    testWidgets('현재 가격 포맷 표시', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '상품', currentPrice: 329000),
        ));
        expect(find.text('₩329,000'), findsOneWidget);
      });
    });

    testWidgets('가격 없으면 가격 표시 안 함', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '가격 없는 상품'),
        ));
        expect(find.textContaining('₩'), findsNothing);
      });
    });

    testWidgets('하락 트렌드 아이콘 표시', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '상품', priceTrend: 'falling'),
        ));
        expect(find.byIcon(Icons.trending_down), findsOneWidget);
      });
    });

    testWidgets('상승 트렌드 아이콘 표시', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '상품', priceTrend: 'rising'),
        ));
        expect(find.byIcon(Icons.trending_up), findsOneWidget);
      });
    });

    testWidgets('보합 트렌드 아이콘 표시', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '상품', priceTrend: 'stable'),
        ));
        expect(find.byIcon(Icons.trending_flat), findsOneWidget);
      });
    });

    testWidgets('트렌드 없으면 아이콘 없음', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '상품'),
        ));
        expect(find.byIcon(Icons.trending_down), findsNothing);
        expect(find.byIcon(Icons.trending_up), findsNothing);
        expect(find.byIcon(Icons.trending_flat), findsNothing);
      });
    });

    testWidgets('onTap 콜백 호출', (tester) async {
      var tapped = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '탭 가능 상품'),
          onTap: () => tapped = true,
        ));

        await tester.tap(find.byType(InkWell));
        expect(tapped, true);
      });
    });

    testWidgets('이미지 없으면 placeholder 표시', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(buildCard(
          Product(id: 1, productName: '이미지 없음'),
        ));
        expect(find.byIcon(Icons.image), findsOneWidget);
      });
    });
  });
}
