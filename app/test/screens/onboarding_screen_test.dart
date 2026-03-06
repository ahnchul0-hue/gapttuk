import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/screens/onboarding/onboarding_screen.dart';

void main() {
  Widget buildScreen() {
    return const ProviderScope(
      child: MaterialApp(home: OnboardingScreen()),
    );
  }

  group('OnboardingScreen', () {
    testWidgets('환영 페이지: 앱 이름 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('값뚝에 오신 걸 환영합니다!'), findsOneWidget);
    });

    testWidgets('환영 페이지: 기능 3개 소개', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('가격 알림'), findsOneWidget);
      expect(find.text('가격 히스토리'), findsOneWidget);
      expect(find.text('센트(¢) 보상'), findsOneWidget);
    });

    testWidgets('환영 페이지: "다음" 버튼 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('다음'), findsOneWidget);
    });

    testWidgets('페이지 인디케이터 3개 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    testWidgets('"다음" 탭 → 약관 동의 페이지로 이동', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('전체 동의'), findsOneWidget);
      expect(find.text('이용약관 동의 (필수)'), findsOneWidget);
      expect(find.text('개인정보처리방침 동의 (필수)'), findsOneWidget);
      expect(find.text('마케팅 정보 수신 동의 (선택)'), findsOneWidget);
    });

    testWidgets('약관 페이지: 추천 코드 입력 필드 표시', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('추천 코드 (선택)'), findsOneWidget);
      expect(find.text('추천 코드를 입력하세요'), findsOneWidget);
    });

    testWidgets('약관 페이지: 필수 미동의 시 "다음" 비활성화', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // "다음" 버튼이 두 개 (이전 페이지 + 현재) — 현재 페이지의 것
      final nextButtons = find.widgetWithText(ElevatedButton, '다음');
      expect(nextButtons, findsOneWidget);

      final button = tester.widget<ElevatedButton>(nextButtons);
      expect(button.onPressed, isNull);
    });

    testWidgets('약관 페이지: "이전" 버튼으로 돌아가기', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('이전'));
      await tester.pumpAndSettle();

      expect(find.text('값뚝에 오신 걸 환영합니다!'), findsOneWidget);
    });
  });
}
