import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/alert.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';

/// 알림 센터 화면 — 가격 알림 / 카테고리 알림 / 키워드 알림 3탭.
class AlertScreen extends ConsumerStatefulWidget {
  const AlertScreen({super.key});

  @override
  ConsumerState<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends ConsumerState<AlertScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AlertListResponse? _alertData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAlerts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final service = ref.read(alertServiceProvider);
      final data = await service.getAlerts();
      if (mounted) {
        setState(() {
          _alertData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  // ─── 알림 타입 라벨 ────────────────────────────────────────────────────────

  String _alertTypeLabel(String type) {
    switch (type) {
      case 'target_price':
        return '목표 가격';
      case 'below_average':
        return '평균 이하';
      case 'near_lowest':
        return '최저가 근접';
      case 'all_time_low':
        return '최저가 갱신';
      default:
        return type;
    }
  }

  // ─── 가격 알림 토글 ────────────────────────────────────────────────────────

  Future<void> _togglePriceAlert(PriceAlert alert) async {
    try {
      final service = ref.read(alertServiceProvider);
      final updated = await service.togglePriceAlert(alert.id);
      if (mounted) {
        setState(() {
          final list = List<PriceAlert>.from(_alertData!.priceAlerts);
          final idx = list.indexWhere((a) => a.id == alert.id);
          if (idx != -1) list[idx] = updated;
          _alertData = _alertData!.copyWith(priceAlerts: list);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 카테고리 알림 토글 ────────────────────────────────────────────────────

  Future<void> _toggleCategoryAlert(CategoryAlert alert) async {
    try {
      final service = ref.read(alertServiceProvider);
      final updated = await service.toggleCategoryAlert(alert.id);
      if (mounted) {
        setState(() {
          final list = List<CategoryAlert>.from(_alertData!.categoryAlerts);
          final idx = list.indexWhere((a) => a.id == alert.id);
          if (idx != -1) list[idx] = updated;
          _alertData = _alertData!.copyWith(categoryAlerts: list);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 키워드 알림 토글 ─────────────────────────────────────────────────────

  Future<void> _toggleKeywordAlert(KeywordAlert alert) async {
    try {
      final service = ref.read(alertServiceProvider);
      final updated = await service.toggleKeywordAlert(alert.id);
      if (mounted) {
        setState(() {
          final list = List<KeywordAlert>.from(_alertData!.keywordAlerts);
          final idx = list.indexWhere((a) => a.id == alert.id);
          if (idx != -1) list[idx] = updated;
          _alertData = _alertData!.copyWith(keywordAlerts: list);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 가격 알림 삭제 ────────────────────────────────────────────────────────

  Future<void> _deletePriceAlert(PriceAlert alert) async {
    try {
      final service = ref.read(alertServiceProvider);
      await service.deletePriceAlert(alert.id);
      if (mounted) {
        setState(() {
          _alertData = _alertData!.copyWith(
            priceAlerts: _alertData!.priceAlerts
                .where((a) => a.id != alert.id)
                .toList(),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 카테고리 알림 삭제 ────────────────────────────────────────────────────

  Future<void> _deleteCategoryAlert(CategoryAlert alert) async {
    try {
      final service = ref.read(alertServiceProvider);
      await service.deleteCategoryAlert(alert.id);
      if (mounted) {
        setState(() {
          _alertData = _alertData!.copyWith(
            categoryAlerts: _alertData!.categoryAlerts
                .where((a) => a.id != alert.id)
                .toList(),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 키워드 알림 삭제 ─────────────────────────────────────────────────────

  Future<void> _deleteKeywordAlert(KeywordAlert alert) async {
    try {
      final service = ref.read(alertServiceProvider);
      await service.deleteKeywordAlert(alert.id);
      if (mounted) {
        setState(() {
          _alertData = _alertData!.copyWith(
            keywordAlerts: _alertData!.keywordAlerts
                .where((a) => a.id != alert.id)
                .toList(),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 키워드 알림 추가 다이얼로그 ──────────────────────────────────────────

  Future<void> _showAddKeywordDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('키워드 알림 추가'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '알림 받을 키워드 입력',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('추가'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result == null || result.isEmpty) return;
    try {
      final service = ref.read(alertServiceProvider);
      final created = await service.createKeywordAlert(keyword: result);
      if (mounted) {
        setState(() {
          final list = List<KeywordAlert>.from(_alertData?.keywordAlerts ?? []);
          list.add(created);
          _alertData = (_alertData ?? const AlertListResponse())
              .copyWith(keywordAlerts: list);
        });
        // 키워드 탭으로 이동
        _tabController.animateTo(2);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  // ─── 빈 상태 위젯 ─────────────────────────────────────────────────────────

  Widget _buildEmpty(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── 가격 알림 탭 ─────────────────────────────────────────────────────────

  Widget _buildPriceAlertTab(List<PriceAlert> alerts) {
    if (alerts.isEmpty) {
      return _buildEmpty(
        '가격 알림이 없습니다\n상품 상세에서 알림을 설정하세요',
        Icons.price_change_outlined,
      );
    }
    return RefreshIndicator(
      onRefresh: _loadAlerts,
      child: ListView.separated(
        itemCount: alerts.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final alert = alerts[i];
          return Dismissible(
            key: ValueKey('price_${alert.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (_) => _deletePriceAlert(alert),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.price_change, color: Colors.blue),
              ),
              title: Text(
                '상품 #${alert.productId}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_alertTypeLabel(alert.alertType)),
                  if (alert.targetPrice != null)
                    Text(
                      '목표가: ${formatPrice(alert.targetPrice!)}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              trailing: Switch(
                value: alert.isActive,
                onChanged: (_) => _togglePriceAlert(alert),
              ),
              isThreeLine: alert.targetPrice != null,
            ),
          );
        },
      ),
    );
  }

  // ─── 카테고리 알림 탭 ─────────────────────────────────────────────────────

  Widget _buildCategoryAlertTab(List<CategoryAlert> alerts) {
    if (alerts.isEmpty) {
      return _buildEmpty(
        '카테고리 알림이 없습니다\n관심 카테고리 알림을 추가하세요',
        Icons.category_outlined,
      );
    }
    return RefreshIndicator(
      onRefresh: _loadAlerts,
      child: ListView.separated(
        itemCount: alerts.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final alert = alerts[i];
          return Dismissible(
            key: ValueKey('category_${alert.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (_) => _deleteCategoryAlert(alert),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple.shade50,
                child:
                    const Icon(Icons.category, color: Colors.purple),
              ),
              title: Text(
                '카테고리 #${alert.categoryId}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_categoryConditionLabel(alert.alertCondition)),
                  if (alert.thresholdPercent != null)
                    Text(
                      '${alert.thresholdPercent}% 이상 할인',
                      style: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 12,
                      ),
                    ),
                  if (alert.maxPrice != null)
                    Text(
                      '최대 ${formatPrice(alert.maxPrice!)}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                ],
              ),
              trailing: Switch(
                value: alert.isActive,
                onChanged: (_) => _toggleCategoryAlert(alert),
              ),
              isThreeLine: alert.thresholdPercent != null ||
                  alert.maxPrice != null,
            ),
          );
        },
      ),
    );
  }

  // ─── 키워드 알림 탭 ───────────────────────────────────────────────────────

  Widget _buildKeywordAlertTab(List<KeywordAlert> alerts) {
    if (alerts.isEmpty) {
      return _buildEmpty(
        '키워드 알림이 없습니다\n우측 상단 + 버튼으로 추가하세요',
        Icons.search_outlined,
      );
    }
    return RefreshIndicator(
      onRefresh: _loadAlerts,
      child: ListView.separated(
        itemCount: alerts.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final alert = alerts[i];
          return Dismissible(
            key: ValueKey('keyword_${alert.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (_) => _deleteKeywordAlert(alert),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade50,
                child:
                    const Icon(Icons.key, color: Colors.orange),
              ),
              title: Text(
                alert.keyword,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (alert.categoryId != null)
                    Text('카테고리 #${alert.categoryId}'),
                  if (alert.maxPrice != null)
                    Text(
                      '최대 ${formatPrice(alert.maxPrice!)}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                ],
              ),
              trailing: Switch(
                value: alert.isActive,
                onChanged: (_) => _toggleKeywordAlert(alert),
              ),
              isThreeLine:
                  alert.categoryId != null || alert.maxPrice != null,
            ),
          );
        },
      ),
    );
  }

  // ─── 헬퍼 ─────────────────────────────────────────────────────────────────

  String _categoryConditionLabel(String condition) {
    switch (condition) {
      case 'any_drop':
        return '어떤 하락이든';
      case 'threshold':
        return '특정 비율 할인';
      case 'below_max':
        return '최대가 이하';
      default:
        return condition;
    }
  }

  // ─── 빌드 ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '키워드 알림 추가',
            onPressed: _showAddKeywordDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: '가격 알림',
              icon: _alertData != null &&
                      _alertData!.priceAlerts.isNotEmpty
                  ? Badge(
                      label:
                          Text('${_alertData!.priceAlerts.length}'),
                      child: const Icon(Icons.price_change_outlined),
                    )
                  : const Icon(Icons.price_change_outlined),
            ),
            Tab(
              text: '카테고리',
              icon: _alertData != null &&
                      _alertData!.categoryAlerts.isNotEmpty
                  ? Badge(
                      label:
                          Text('${_alertData!.categoryAlerts.length}'),
                      child: const Icon(Icons.category_outlined),
                    )
                  : const Icon(Icons.category_outlined),
            ),
            Tab(
              text: '키워드',
              icon: _alertData != null &&
                      _alertData!.keywordAlerts.isNotEmpty
                  ? Badge(
                      label:
                          Text('${_alertData!.keywordAlerts.length}'),
                      child: const Icon(Icons.search_outlined),
                    )
                  : const Icon(Icons.search_outlined),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              '알림 목록을 불러오지 못했습니다',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadAlerts,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final data = _alertData;
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildPriceAlertTab(data.priceAlerts),
        _buildCategoryAlertTab(data.categoryAlerts),
        _buildKeywordAlertTab(data.keywordAlerts),
      ],
    );
  }
}
