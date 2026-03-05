import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/service_providers.dart';
import '../../widgets/price_chart.dart';
import '../../widgets/loading_skeleton.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final priceFormat = NumberFormat('#,###', 'ko_KR');

    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAlertSetup(context, ref),
        icon: const Icon(Icons.notifications_active),
        label: const Text('가격 알림'),
      ),
      body: productAsync.when(
        data: (product) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 상품 이미지
            if (product.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // 상품명
            Text(product.productName,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),

            // 품절 배지 + 현재 가격
            if (product.isOutOfStock)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_shopping_cart,
                        color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '품절',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            // 현재 가격
            if (product.currentPrice != null) ...[
              Text(
                '₩${priceFormat.format(product.currentPrice)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: product.isOutOfStock ? Colors.grey : null,
                    ),
              ),
              const SizedBox(height: 4),
            ],

            // 가격 트렌드 + 매수 타이밍
            Row(
              children: [
                if (product.priceTrend != null)
                  _TrendChip(trend: product.priceTrend!),
                const SizedBox(width: 8),
                if (product.buyTimingScore != null)
                  _TimingBadge(score: product.buyTimingScore!),
              ],
            ),
            const SizedBox(height: 16),

            // 가격 통계
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      label: '최저가',
                      value: product.lowestPrice != null
                          ? '₩${priceFormat.format(product.lowestPrice)}'
                          : '-',
                      color: AppTheme.priceDown,
                    ),
                    _StatColumn(
                      label: '평균가',
                      value: product.averagePrice != null
                          ? '₩${priceFormat.format(product.averagePrice)}'
                          : '-',
                    ),
                    _StatColumn(
                      label: '최고가',
                      value: product.highestPrice != null
                          ? '₩${priceFormat.format(product.highestPrice)}'
                          : '-',
                      color: AppTheme.priceUp,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 가격 차트
            Text('30일 가격 추이',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: PriceChart(productId: productId),
            ),
            // FAB와 겹치지 않도록 여백 추가
            const SizedBox(height: 80),
          ],
        ),
        loading: () => const LoadingSkeleton(itemCount: 6),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
    );
  }

  void _showAlertSetup(BuildContext context, WidgetRef ref) {
    String selectedType = 'target_price';
    final priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('가격 알림 설정',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...[
                'target_price',
                'below_average',
                'near_lowest',
                'all_time_low',
              ].map((type) {
                final label = switch (type) {
                  'target_price' => '목표 가격 도달',
                  'below_average' => '평균 이하로 하락',
                  'near_lowest' => '역대 최저가 근접',
                  'all_time_low' => '역대 최저가 갱신',
                  _ => type,
                };
                return RadioListTile<String>(
                  title: Text(label),
                  value: type,
                  groupValue: selectedType,
                  onChanged: (v) => setState(() => selectedType = v!),
                );
              }),
              if (selectedType == 'target_price') ...[
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '목표 가격 (₩)',
                    prefixText: '₩',
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final alertService = ref.read(alertServiceProvider);
                    try {
                      await alertService.createPriceAlert(
                        productId: productId,
                        alertType: selectedType,
                        targetPrice: selectedType == 'target_price'
                            ? int.tryParse(
                                priceController.text.replaceAll(',', ''))
                            : null,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('가격 알림이 설정되었습니다')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('알림 설정 실패: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('알림 설정'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  final String trend;
  const _TrendChip({required this.trend});

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (trend) {
      'rising' => (Icons.trending_up, AppTheme.priceUp, '상승'),
      'falling' => (Icons.trending_down, AppTheme.priceDown, '하락'),
      _ => (Icons.trending_flat, Colors.grey, '안정'),
    };
    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _TimingBadge extends StatelessWidget {
  final int score;
  const _TimingBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 70
        ? AppTheme.secondary
        : score >= 40
            ? Colors.orange
            : AppTheme.priceUp;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '매수 타이밍 $score점',
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatColumn({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
