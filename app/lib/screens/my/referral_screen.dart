import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../providers/service_providers.dart';
import '../../services/reward_service.dart';

/// 리퍼럴 현황 화면 — 추천 코드 + 초대 통계 + 초대 목록.
class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  ReferralStats? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stats = await ref.read(rewardServiceProvider).getReferrals();
      if (mounted) {
        setState(() {
          _stats = stats;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('추천 현황')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError(appColors)
              : RefreshIndicator(
                  onRefresh: _loadStats,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_stats?.referralCode != null)
                        _ReferralCodeCard(
                          code: _stats!.referralCode!,
                          totalEarnedCents: _stats!.totalEarnedCents,
                        ),
                      const SizedBox(height: 16),
                      _StatsRow(
                        totalReferred: _stats?.totalReferred ?? 0,
                        totalEarnedCents: _stats?.totalEarnedCents ?? 0,
                        appColors: appColors,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '초대 목록',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (_stats == null || _stats!.referrals.isEmpty)
                        _buildEmptyList(appColors)
                      else
                        ..._stats!.referrals.map(
                          (item) => _ReferralItemTile(
                            item: item,
                            appColors: appColors,
                          ),
                        ),
                      const SizedBox(height: 24),
                      _buildStageExplanation(appColors),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError(AppColors appColors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: appColors.error),
          const SizedBox(height: 16),
          const Text('데이터를 불러올 수 없습니다.'),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadStats,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyList(AppColors appColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 48, color: appColors.neutral),
            const SizedBox(height: 8),
            Text(
              '아직 초대한 친구가 없습니다.',
              style: TextStyle(color: appColors.neutral),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageExplanation(AppColors appColors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '보상 단계 안내',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            _stageRow('0단계', '가입만 완료', appColors.neutral, appColors),
            const SizedBox(height: 8),
            _stageRow(
                '1단계',
                '첫 구매 완료 (피초대자 +1${AppConstants.rewardUnit}, '
                    '초대자 +2${AppConstants.rewardUnit})',
                appColors.info,
                appColors),
            const SizedBox(height: 8),
            _stageRow(
                '2단계',
                '두번째 구매 완료 (피초대자 +1${AppConstants.rewardUnit}, '
                    '초대자 +3${AppConstants.rewardUnit})',
                appColors.success,
                appColors),
          ],
        ),
      ),
    );
  }

  Widget _stageRow(
      String label, String desc, Color color, AppColors appColors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            desc,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// 추천 코드 카드 — 코드 + 복사/공유 버튼 + 적립 배지.
class _ReferralCodeCard extends StatelessWidget {
  final String code;
  final int totalEarnedCents;

  const _ReferralCodeCard({
    required this.code,
    required this.totalEarnedCents,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '내 추천 코드',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.neutral,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              code,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .extension<AppColors>()!
                    .success
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalEarnedCents${AppConstants.rewardUnit} 적립',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).extension<AppColors>()!.success,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: const Text('복사'),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('추천 코드가 복사되었습니다.')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('공유'),
                  onPressed: () {
                    Share.share(
                      '값뚝에서 함께 최저가를 찾아보세요! '
                      '추천 코드: $code\n'
                      'https://gapttuk.app/invite?code=$code',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 통계 행 — 초대 인원 + 획득 센트.
class _StatsRow extends StatelessWidget {
  final int totalReferred;
  final int totalEarnedCents;
  final AppColors appColors;

  const _StatsRow({
    required this.totalReferred,
    required this.totalEarnedCents,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    '$totalReferred명',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appColors.info,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '초대',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: appColors.neutral,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    '$totalEarnedCents${AppConstants.rewardUnit}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appColors.success,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '획득',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: appColors.neutral,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 리퍼럴 항목 타일.
class _ReferralItemTile extends StatelessWidget {
  final ReferralItem item;
  final AppColors appColors;

  const _ReferralItemTile({
    required this.item,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final (badgeLabel, badgeColor) = switch (item.rewardStage) {
      1 => ('1단계', appColors.info),
      2 => ('2단계', appColors.success),
      _ => ('가입', appColors.neutral),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: badgeColor.withValues(alpha: 0.15),
          child: Icon(Icons.person_outline, color: badgeColor),
        ),
        title: Text(item.referredNickname ?? '사용자'),
        subtitle: Text(
          _formatDate(item.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: appColors.neutral,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badgeLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+${item.earnedCents}${AppConstants.rewardUnit}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: appColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.year}.${dt.month.toString().padLeft(2, '0')}'
          '.${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
