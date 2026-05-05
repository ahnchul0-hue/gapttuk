import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/naver_trend.dart';

/// 네이버 쇼핑 카테고리 트렌드 라인 차트.
///
/// [trends] 목록의 각 카테고리를 서로 다른 색상 라인으로 표시.
/// x축: 월(기간), y축: ratio (0~100 정규화 검색량).
class TrendChartWidget extends StatelessWidget {
  final List<CategoryTrend> trends;

  const TrendChartWidget({super.key, required this.trends});

  static const List<Color> _lineColors = [
    Color(0xFF2196F3), // 파란색 — 디지털/가전
    Color(0xFF4CAF50), // 초록색 — 생활용품
    Color(0xFFFF9800), // 주황색 — 식품
    Color(0xFF9C27B0), // 보라색 — 추가 카테고리
    Color(0xFFF44336), // 빨간색
  ];

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) {
      return const Center(child: Text('트렌드 데이터 없음'));
    }

    final colors = Theme.of(context).extension<AppColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegend(),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: _buildLineBars(),
              titlesData: _buildTitlesData(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors?.neutralBorder ?? const Color(0xFFE0E0E0),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: _maxX.toDouble(),
              minY: 0,
              maxY: 110,
            ),
          ),
        ),
      ],
    );
  }

  int get _maxX {
    if (trends.isEmpty) return 5;
    return (trends.first.periods.length - 1).clamp(0, 100);
  }

  List<LineChartBarData> _buildLineBars() {
    return trends.asMap().entries.map((entry) {
      final index = entry.key;
      final trend = entry.value;
      final color = _lineColors[index % _lineColors.length];

      final spots = trend.periods.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.ratio);
      }).toList();

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 2.5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) =>
              FlDotCirclePainter(
            radius: 3,
            color: color,
            strokeWidth: 0,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          color: color.withValues(alpha: 0.08),
        ),
      );
    }).toList();
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: 50,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 10, color: Color(0xFF757575)),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (trends.isEmpty || index >= trends.first.periods.length) {
              return const SizedBox.shrink();
            }
            final period = trends.first.periods[index].period;
            // "2025-11-01" → "11월"
            final parts = period.split('-');
            if (parts.length < 2) return const SizedBox.shrink();
            return Text(
              '${parts[1]}월',
              style: const TextStyle(fontSize: 10, color: Color(0xFF757575)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: trends.asMap().entries.map((entry) {
        final color = _lineColors[entry.key % _lineColors.length];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              entry.value.categoryName,
              style: const TextStyle(fontSize: 11, color: Color(0xFF616161)),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// 트렌드 카드 — 카테고리명, 전월 대비 변화율 표시.
class TrendSummaryCard extends StatelessWidget {
  final CategoryTrend trend;
  final Color color;

  const TrendSummaryCard({
    super.key,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = trend.momChange >= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  trend.categoryName,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: isUp ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                ),
                const SizedBox(width: 4),
                Text(
                  '${isUp ? '+' : ''}${trend.momChange.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isUp ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '전월 대비',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF757575)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
