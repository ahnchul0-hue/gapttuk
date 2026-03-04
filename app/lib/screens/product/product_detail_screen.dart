import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../providers/product_provider.dart';
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

            // 현재 가격
            if (product.currentPrice != null) ...[
              Text(
                '₩${priceFormat.format(product.currentPrice)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
          ],
        ),
        loading: () => const LoadingSkeleton(itemCount: 6),
        error: (e, _) => Center(child: Text('오류: $e')),
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
