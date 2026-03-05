import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../utils/error_utils.dart';

/// 설정 화면.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL을 열 수 없습니다.')),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
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

  Future<void> _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text(
          '정말 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authStateProvider.notifier).withdraw();
        if (context.mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(friendlyErrorMessage(e))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          // ─── 섹션 1: 알림 설정 ────────────────────────────────────────────
          _SectionHeader(title: '알림 설정'),
          _PushNotificationTile(),
          const Divider(height: 1),

          // ─── 섹션 2: 앱 정보 ──────────────────────────────────────────────
          _SectionHeader(title: '앱 정보'),
          ListTile(
            title: const Text('버전'),
            trailing: Text(
              AppConstants.appVersion,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('이용약관'),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _launchUrl(context, AppConstants.termsUrl),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('개인정보처리방침'),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _launchUrl(context, AppConstants.privacyUrl),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('오픈소스 라이선스'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: '값뚝',
              applicationVersion: AppConstants.appVersion,
            ),
          ),
          const Divider(height: 1),

          // ─── 섹션 3: 계정 ─────────────────────────────────────────────────
          _SectionHeader(title: '계정'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _logout(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_remove_outlined,
                color: Colors.red),
            title: const Text(
              '회원 탈퇴',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _showDeleteAccountDialog(context, ref),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// 섹션 헤더 위젯.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

/// 푸시 알림 스위치 타일 (로컬 상태 관리).
class _PushNotificationTile extends StatefulWidget {
  const _PushNotificationTile();

  @override
  State<_PushNotificationTile> createState() => _PushNotificationTileState();
}

class _PushNotificationTileState extends State<_PushNotificationTile> {
  bool _pushEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: const Text('푸시 알림'),
      trailing: Switch(
        value: _pushEnabled,
        onChanged: (value) {
          setState(() {
            _pushEnabled = value;
          });
        },
      ),
    );
  }
}
