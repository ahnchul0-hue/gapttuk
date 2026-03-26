import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/config/theme.dart';
import 'package:gapttuk_app/models/user.dart';
import 'package:gapttuk_app/providers/auth_provider.dart';
import 'package:gapttuk_app/providers/service_providers.dart';
import 'package:gapttuk_app/screens/my/my_page_screen.dart';

import '../helpers/fake_reward_service.dart';

/// AuthState fake — build()로 초기 User? 주입.
class _FakeAuthState extends AuthState {
  final User? _user;
  _FakeAuthState(this._user);

  @override
  User? build() => _user;
}

const _fakeUser = User(
  id: 1,
  nickname: '테스트유저',
  email: 'test@example.com',
  referralCode: 'GAP-ABCD12',
);

Widget _buildScreen({User? user, bool slowReward = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith(() => _FakeAuthState(user)),
      rewardServiceProvider.overrideWith(
        (ref) => FakeRewardService(slow: slowReward),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const MyPageScreen(),
    ),
  );
}

void main() {
  group('MyPageScreen', () {
    testWidgets('"마이페이지" AppBar 타이틀 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('마이페이지'), findsOneWidget);
    });

    testWidgets('미인증 — "로그인이 필요합니다" 메시지 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('로그인이 필요합니다.'), findsOneWidget);
    });

    testWidgets('미인증 — "로그인" 버튼 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('로그인'), findsOneWidget);
    });

    testWidgets('로그인 — 닉네임 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pump(); // initState → _loadPoints 시작
      expect(find.text('테스트유저'), findsOneWidget);
    });

    testWidgets('로그인 — 추천 코드 있을 때 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pump();
      expect(find.text('GAP-ABCD12'), findsOneWidget);
    });

    testWidgets('로그인 — 로그아웃 메뉴 항목 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pump();
      expect(find.text('로그아웃'), findsOneWidget);
    });

    // ── Night-27 신규 ──────────────────────────────────────────────────────

    testWidgets('로그인 — "알림 설정" 메뉴 항목 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pump();
      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('로그인 — "설정" 메뉴 항목 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pump();
      expect(find.text('설정'), findsOneWidget);
    });

    testWidgets('로그인 — 이메일 표시', (tester) async {
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('로그인 — 포인트 로드 후 잔액 "5¢" 표시', (tester) async {
      // FakeRewardService 기본값: balance = 5
      await tester.pumpWidget(_buildScreen(user: _fakeUser));
      await tester.pumpAndSettle();
      expect(find.textContaining('5¢'), findsOneWidget);
    });
  });
}
