import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../config/theme.dart';
import '../providers/product_provider.dart';

/// 30일 가격 추이 라인 차트.
class PriceChart extends ConsumerWidget {
  final int productId;

  const PriceChart({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricesAsync = ref.watch(dailyPricesProvider(productId));

    return pricesAsync.when(
      data: (prices) {
        if (prices.isEmpty) {
          return const Center(child: Text('가격 데이터가 없습니다'));
        }

        final spots = prices.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.avgPrice.toDouble());
        }).toList();

        final priceFormat = NumberFormat('#,###', 'ko_KR');

        return LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  getTitlesWidget: (value, meta) => Text(
                    '₩${priceFormat.format(value.toInt())}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (prices.length / 5).ceilToDouble().clamp(1, 30),
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= prices.length) {
                      return const SizedBox.shrink();
                    }
                    final date = prices[idx].date;
                    // date 형식: "2026-03-01" → "3/1"
                    final parts = date.split('-');
                    if (parts.length >= 3) {
                      return Text(
                        '${int.parse(parts[1])}/${int.parse(parts[2])}',
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return Text(date, style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppTheme.primary,
                barWidth: 2.5,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => spots.map((spot) {
                  return LineTooltipItem(
                    '₩${priceFormat.format(spot.y.toInt())}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('차트 로드 실패: $e')),
    );
  }
}
