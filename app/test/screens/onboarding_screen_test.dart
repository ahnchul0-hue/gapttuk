import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/screens/onboarding/onboarding_screen.dart';

void main() {
  Widget buildScreen() {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: const OnboardingScreen()),
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

    testWidgets('약관 페이지: 타이틀 텍스트 표시', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.textContaining('서비스 이용을 위해'), findsOneWidget);
    });

    testWidgets('약관 페이지: 추천 코드 보너스 안내 텍스트 표시', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.textContaining('1¢ 웰컴 보너스'), findsOneWidget);
    });

    testWidgets('약관 페이지: 전체 동의 탭 → "다음" 버튼 활성화', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 전체 동의 체크박스 탭
      await tester.tap(find.text('전체 동의'));
      await tester.pumpAndSettle();

      // 이제 _canProceedFromPage2 = true → '다음' 버튼 활성화
      final nextButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '다음'),
      );
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('환영 페이지: 가격 알림 기능 설명 표시', (tester) async {
      await tester.pumpWidget(buildScreen());
      expect(find.text('원하는 가격이 되면 즉시 알려드립니다.'), findsOneWidget);
    });

    // ── Night-34 신규 ──────────────────────────────────────────────────────

    testWidgets('환영 페이지: "가격 히스토리" 기능 설명 표시', (tester) async {
      // _FeatureItem(title: '가격 히스토리', description: '상품의 가격 변화를 한눈에 확인하세요.')
      await tester.pumpWidget(buildScreen());
      expect(find.text('상품의 가격 변화를 한눈에 확인하세요.'), findsOneWidget);
    });

    testWidgets('환영 페이지: "센트(¢) 보상" 기능 설명 표시', (tester) async {
      // _FeatureItem(title: '센트(¢) 보상', description: '가격 제보와 활동으로 센트를 적립하세요.')
      await tester.pumpWidget(buildScreen());
      expect(find.text('가격 제보와 활동으로 센트를 적립하세요.'), findsOneWidget);
    });

    testWidgets('약관 페이지: 이용약관만 탭 → "다음" 버튼 여전히 비활성 (개인정보 미동의)', (tester) async {
      // termsAgreed=true, privacyAgreed=false → _canProceedFromPage2=false → onPressed=null
      await tester.pumpWidget(buildScreen());
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 이용약관 CheckboxListTile 탭
      await tester.tap(find.text('이용약관 동의 (필수)'));
      await tester.pumpAndSettle();

      // privacyAgreed=false이므로 버튼 여전히 비활성
      final nextButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '다음'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('완료 페이지: "준비 완료!" 텍스트 + "시작하기" 버튼 표시', (tester) async {
      // 전체 동의 후 다음 탭 → Page 3 (_CompletePage)
      await tester.pumpWidget(buildScreen());

      // Page 1 → Page 2
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 전체 동의 체크
      await tester.tap(find.text('전체 동의'));
      await tester.pumpAndSettle();

      // Page 2 → Page 3 (다음 탭, _canProceedFromPage2=true)
      await tester.tap(find.widgetWithText(ElevatedButton, '다음'));
      await tester.pumpAndSettle();

      expect(find.text('준비 완료!'), findsOneWidget);
      expect(find.text('시작하기'), findsOneWidget);
    });
  });
}
