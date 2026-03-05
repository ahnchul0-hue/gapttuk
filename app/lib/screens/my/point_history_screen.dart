import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../providers/service_providers.dart';
import '../../services/reward_service.dart';
import '../../utils/error_utils.dart';

/// 포인트(¢) 적립/사용 내역 화면.
class PointHistoryScreen extends ConsumerStatefulWidget {
  const PointHistoryScreen({super.key});

  @override
  ConsumerState<PointHistoryScreen> createState() => _PointHistoryScreenState();
}

class _PointHistoryScreenState extends ConsumerState<PointHistoryScreen> {
  final List<PointHistoryItem> _items = [];
  bool _loading = false;
  bool _hasMore = true;
  int? _cursor;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    try {
      final result = await ref.read(rewardServiceProvider).getHistory(
            cursor: _cursor,
          );
      if (!mounted) return;
      setState(() {
        _items.addAll(result.items);
        _hasMore = result.hasMore;
        if (result.items.isNotEmpty) {
          _cursor = result.items.last.id;
        }
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _transactionLabel(String type) {
    return switch (type) {
      'daily_checkin' => '일일 출석 룰렛',
      'referral_welcome' => '추천 가입 보상',
      'referral_purchase_referred' => '추천 구매 보상',
      'referral_purchase_referrer' => '추천인 보상',
      'signup_bonus' => '가입 보너스',
      'gifticon_exchange' => '기프티콘 교환',
      'admin_adjustment' => '운영자 조정',
      _ => type,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('포인트 내역')),
      body: _error != null && _items.isEmpty
          ? Center(child: Text(_error!))
          : _items.isEmpty && !_loading
              ? const Center(child: Text('아직 내역이 없습니다.'))
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter < 200) {
                      _loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    itemCount: _items.length + (_hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == _items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      final item = _items[index];
                      final isPositive = item.amount > 0;
                      return ListTile(
                        leading: Icon(
                          isPositive
                              ? Icons.add_circle_outline
                              : Icons.remove_circle_outline,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                        title: Text(_transactionLabel(item.transactionType)),
                        subtitle: item.description != null
                            ? Text(item.description!)
                            : null,
                        trailing: Text(
                          '${isPositive ? '+' : ''}${item.amount}${AppConstants.rewardUnit}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isPositive ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
