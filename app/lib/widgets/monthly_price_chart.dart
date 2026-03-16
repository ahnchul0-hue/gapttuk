import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/theme.dart';
import '../models/monthly_price.dart';

class MonthlyPriceChart extends StatelessWidget {
  final List<MonthlyPrice> prices;

  const MonthlyPriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.length < 2) return const SizedBox.shrink();

    final priceFormat = NumberFormat('#,###', 'ko_KR');
    final monthFormat = DateFormat('yy.MM');

    final spots = prices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.avgPrice.toDouble());
    }).toList();

    final minY = prices.map((p) => p.avgPrice).reduce((a, b) => a < b ? a : b).toDouble() * 0.9;
    final maxY = prices.map((p) => p.avgPrice).reduce((a, b) => a > b ? a : b).toDouble() * 1.1;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, _) => Text(
                  priceFormat.format(value.round()),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (prices.length / 4).ceilToDouble().clamp(1, double.infinity),
                getTitlesWidget: (value, _) {
                  final idx = value.round();
                  if (idx < 0 || idx >= prices.length) return const SizedBox.shrink();
                  return Text(
                    monthFormat.format(prices[idx].yearMonth),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final idx = s.x.round();
                if (idx < 0 || idx >= prices.length) return null;
                final p = prices[idx];
                return LineTooltipItem(
                  '${monthFormat.format(p.yearMonth)}\n₩${priceFormat.format(p.avgPrice)}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.2,
              color: AppTheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primary.withAlpha(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
