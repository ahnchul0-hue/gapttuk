import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/alert/alert_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/my/my_page_screen.dart';
import '../screens/my/settings_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../services/token_storage.dart';

/// 인증이 필요한 경로 목록.
const _authRequiredPaths = {'/alerts', '/favorites', '/my'};

/// 앱 라우트 정의.
final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final path = state.matchedLocation;

    // 인증 필요 경로인지 확인 (정확 일치 또는 하위 경로)
    final needsAuth = _authRequiredPaths.any(
      (p) => path == p || path.startsWith('$p/'),
    );

    if (!needsAuth) return null;

    final storage = TokenStorage();
    final token = await storage.getAccessToken();
    if (token == null || token.isEmpty) {
      // from 파라미터로 로그인 후 원래 경로로 복귀 가능하게 저장
      final from = Uri.encodeComponent(path);
      return '/login?from=$from';
    }

    return null;
  },
  routes: [
    // 하단 탭 네비게이션 셸
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _ScaffoldWithNav(navigationShell: navigationShell),
      branches: [
        // 탭 1: 홈
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // 탭 2: 검색
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        // 탭 3: 즐겨찾기 (인증 필요)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        // 탭 4: 알림 (인증 필요)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/alerts',
              builder: (context, state) => const AlertScreen(),
            ),
          ],
        ),
        // 탭 5: 마이페이지 (인증 필요)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my',
              builder: (context, state) => const MyPageScreen(),
              routes: [
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // 상품 상세 (탭 외부)
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ProductDetailScreen(
        productId: int.parse(state.pathParameters['id']!),
      ),
    ),
    // 로그인
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // 온보딩
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);

/// 하단 네비게이션 바 포함 스캐폴드.
class _ScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ScaffoldWithNav({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '검색',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: '즐겨찾기',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: '알림',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
