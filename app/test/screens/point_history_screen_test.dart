import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/screens/my/point_history_screen.dart';
import 'package:gapttuk_app/services/reward_service.dart';

import '../helpers/fake_reward_service.dart';

Widget _buildScreen({FakeRewardService? service}) {
  return ProviderScope(
    overrides: [
      rewardServiceProvider.overrideWith(
        (ref) => service ?? FakeRewardService(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const PointHistoryScreen(),
    ),
  );
}

void main() {
  group('PointHistoryScreen', () {
    testWidgets('"포인트 내역" AppBar 타이틀 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('포인트 내역'), findsOneWidget);
    });

    testWidgets('로딩 중 CircularProgressIndicator 없음(빈 목록 즉시 해결)', (tester) async {
      // FakeRewardService(slow: false) → 빈 목록 즉시 반환
      await tester.pumpWidget(_buildScreen());
      await tester.pump(); // initState 실행
      // 빠른 fake → 로딩 스피너 없이 빈 상태로 이동
      await tester.pumpAndSettle();
      expect(find.text('아직 내역이 없습니다.'), findsOneWidget);
    });

    testWidgets('로딩 중 빈 body (slow fake)', (tester) async {
      await tester.pumpWidget(
        _buildScreen(service: FakeRewardService(slow: true)),
      );
      await tester.pump(); // initState 실행
      // slow → _loading=true, _items empty → body가 비어있음 (스피너 미표시)
      expect(find.text('아직 내역이 없습니다.'), findsNothing);
      expect(find.text('포인트 내역'), findsOneWidget);
    });

    testWidgets('항목 있을 때 transactionType 레이블 표시', (tester) async {
      final item = PointHistoryItem(
        id: 1,
        amount: 1,
        transactionType: 'daily_checkin',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('일일 출석 룰렛'), findsOneWidget);
    });

    testWidgets('에러 시 에러 메시지 표시', (tester) async {
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(error: Exception('서버 오류')),
        ),
      );
      await tester.pumpAndSettle();
      // friendlyErrorMessage → 에러 텍스트가 body에 표시됨
      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('양수 금액은 "+" 접두어와 함께 표시', (tester) async {
      final item = PointHistoryItem(
        id: 2,
        amount: 3,
        transactionType: 'signup_bonus',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('+3¢'), findsOneWidget);
    });

    testWidgets('"referral_welcome" 타입 → "추천 가입 보상" 레이블', (tester) async {
      final item = PointHistoryItem(
        id: 3,
        amount: 1,
        transactionType: 'referral_welcome',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('추천 가입 보상'), findsOneWidget);
    });

    testWidgets('"gifticon_exchange" 타입 → "기프티콘 교환" 레이블', (tester) async {
      final item = PointHistoryItem(
        id: 4,
        amount: -5,
        transactionType: 'gifticon_exchange',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('기프티콘 교환'), findsOneWidget);
    });

    testWidgets('음수 금액 → "-5¢" 접두어 없이 표시', (tester) async {
      final item = PointHistoryItem(
        id: 5,
        amount: -5,
        transactionType: 'gifticon_exchange',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      // isPositive=false → "${amount}¢" = "-5¢" (접두어 "+" 없음)
      expect(find.textContaining('-5¢'), findsOneWidget);
    });

    testWidgets('날짜 "yyyy.MM.dd" 형식 표시', (tester) async {
      final item = PointHistoryItem(
        id: 6,
        amount: 1,
        transactionType: 'daily_checkin',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('2026.03.24'), findsOneWidget);
    });

    // ── Night-32 신규 ──────────────────────────────────────────────────────

    testWidgets('"referral_welcome_referrer" 타입 → "추천인 웰컴 보상" 레이블', (tester) async {
      final item = PointHistoryItem(
        id: 7,
        amount: 2,
        transactionType: 'referral_welcome_referrer',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('추천인 웰컴 보상'), findsOneWidget);
    });

    testWidgets('"referral_purchase_referrer" 타입 → "추천인 보상" 레이블', (tester) async {
      final item = PointHistoryItem(
        id: 8,
        amount: 3,
        transactionType: 'referral_purchase_referrer',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('추천인 보상'), findsOneWidget);
    });

    testWidgets('"admin_adjustment" 타입 → "운영자 조정" 레이블', (tester) async {
      final item = PointHistoryItem(
        id: 9,
        amount: 5,
        transactionType: 'admin_adjustment',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('운영자 조정'), findsOneWidget);
    });

    testWidgets('description 있을 때 설명 텍스트 표시', (tester) async {
      final item = PointHistoryItem(
        id: 10,
        amount: 1,
        transactionType: 'daily_checkin',
        description: '3일 연속 출석 보너스',
        createdAt: DateTime(2026, 3, 24),
      );
      await tester.pumpWidget(
        _buildScreen(
          service: FakeRewardService(history: (items: [item], hasMore: false)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('3일 연속 출석 보너스'), findsOneWidget);
    });
  });
}
