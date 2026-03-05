import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../config/theme.dart';
import '../providers/product_provider.dart';
import '../utils/error_utils.dart';

/// 요일별 가격 바 차트 — day_of_week 0(일)~6(토).
class PriceChart extends ConsumerWidget {
  final int productId;

  const PriceChart({super.key, required this.productId});

  static const _dayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricesAsync = ref.watch(dailyPricesProvider(productId));

    return pricesAsync.when(
      data: (prices) {
        if (prices.isEmpty) {
          return const Center(child: Text('가격 데이터가 없습니다'));
        }

        // dayOfWeek 기준 정렬 (0=일 ~ 6=토)
        final sorted = List.of(prices)
          ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

        final spots = sorted.asMap().entries
            .where((e) => e.value.avgPrice != null)
            .map((e) {
          return FlSpot(
              e.key.toDouble(), e.value.avgPrice!.toDouble());
        }).toList();

        if (spots.isEmpty) {
          return const Center(child: Text('평균 가격 데이터가 없습니다'));
        }

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
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= sorted.length) {
                      return const SizedBox.shrink();
                    }
                    final dow = sorted[idx].dayOfWeek;
                    return Text(
                      _dayLabels[dow.clamp(0, 6)],
                      style: const TextStyle(fontSize: 10),
                    );
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
      error: (e, st) => Center(child: Text(friendlyErrorMessage(e))),
    );
  }
}
