import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';
import '../../services/reward_service.dart';

/// 마이페이지 화면.
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);

    // router guard가 처리하지만 방어적으로 null 체크.
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('마이페이지')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('로그인이 필요합니다.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      );
    }

    final nickname = user.nickname ?? '익명 사용자';

    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: ListView(
        children: [
          // 프로필 섹션
          _ProfileHeader(
            profileImageUrl: user.profileImageUrl,
            nickname: nickname,
            email: user.email,
          ),
          const Divider(),
          // 센트 잔액 + 일일 체크인 섹션
          const _CentsBalanceTile(),
          const Divider(),
          // 추천 코드 섹션
          if (user.referralCode != null)
            _ReferralCodeTile(referralCode: user.referralCode!),
          const Divider(),
          // 메뉴 섹션
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('알림 설정'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/alerts'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('설정'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/my/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            onTap: () => _showLogoutDialog(context, ref),
          ),
          const SizedBox(height: 32),
          // 앱 버전
          const _AppVersionFooter(),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}

/// 프로필 헤더 — 아바타 + 닉네임 + 이메일.
class _ProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final String nickname;
  final String? email;

  const _ProfileHeader({
    required this.profileImageUrl,
    required this.nickname,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickname,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (email != null) ...[
                const SizedBox(height: 4),
                Text(
                  email!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 36,
        backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
        backgroundColor: Colors.grey[200],
      );
    }
    return CircleAvatar(
      radius: 36,
      backgroundColor:
          Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

/// 추천 코드 타일 — 코드 표시 + 클립보드 복사 버튼.
class _ReferralCodeTile extends StatelessWidget {
  final String referralCode;

  const _ReferralCodeTile({required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.card_giftcard_outlined),
      title: const Text('내 추천 코드'),
      subtitle: Text(
        referralCode,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.copy_outlined),
        tooltip: '복사',
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: referralCode));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('추천 코드가 복사되었습니다.')),
            );
          }
        },
      ),
    );
  }
}

/// 앱 버전 표시 위젯 (하단).
class _AppVersionFooter extends StatelessWidget {
  const _AppVersionFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: Text(
          'v${AppConstants.appVersion}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
        ),
      ),
    );
  }
}

/// 센트 잔액 + 일일 출석 룰렛 타일.
class _CentsBalanceTile extends ConsumerStatefulWidget {
  const _CentsBalanceTile();

  @override
  ConsumerState<_CentsBalanceTile> createState() => _CentsBalanceTileState();
}

class _CentsBalanceTileState extends ConsumerState<_CentsBalanceTile> {
  PointsInfo? _points;
  bool _loading = false;
  bool _checkinDone = false;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      final info = await ref.read(rewardServiceProvider).getPoints();
      if (mounted) setState(() => _points = info);
    } catch (_) {
      // 잔액 조회 실패 시 무시 (비핵심 UI)
    }
  }

  Future<void> _doCheckin() async {
    if (_loading || _checkinDone) return;
    setState(() => _loading = true);
    try {
      final result = await ref.read(rewardServiceProvider).checkin();
      if (!mounted) return;
      if (result.alreadyCheckedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('오늘은 이미 출석했습니다.')),
        );
      } else if (result.rewardAmount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result.rewardAmount}${AppConstants.rewardUnit} 획득! 내일 또 도전하세요.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('아쉽게도 오늘은 0¢. 내일 또 도전하세요!')),
        );
      }
      setState(() {
        _checkinDone = true;
        // checkin 응답에서 직접 잔액 갱신 (추가 API 호출 불필요)
        if (_points != null) {
          _points = PointsInfo(
            balance: result.newBalance,
            totalEarned: _points!.totalEarned + result.rewardAmount,
            totalSpent: _points!.totalSpent,
          );
        }
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('출석 체크 중 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = _points?.balance ?? 0;

    return ListTile(
      onTap: () => context.push('/my/points'),
      leading: const Icon(Icons.monetization_on_outlined, color: Colors.amber),
      title: Text(
        '센트(¢) 잔액',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '$balance${AppConstants.rewardUnit}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber[700],
            ),
      ),
      trailing: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : TextButton(
              onPressed: _checkinDone ? null : _doCheckin,
              child: Text(_checkinDone ? '출석 완료' : '오늘 출석'),
            ),
    );
  }
}
