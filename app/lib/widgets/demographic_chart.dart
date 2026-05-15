import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/demographic_trend.dart';

/// 인구통계 트렌드 차트 위젯.
///
/// [trends] 목록에서 dimension에 따라 연령/성별/기기 차트를 선택 렌더링.
/// - 'age': 연령대별 최근 평균 수직 막대 차트
/// - 'gender': 남/녀 수평 비율 막대
/// - 'device': 모바일/PC 수평 비율 막대
class DemographicChartWidget extends StatelessWidget {
  final List<DemographicTrend> trends;

  const DemographicChartWidget({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) {
      return const Center(child: Text('인구통계 데이터 없음'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: trends.map((t) => _buildSection(context, t)).toList(),
    );
  }

  Widget _buildSection(BuildContext context, DemographicTrend trend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _sectionTitle(trend.dimension),
            style: AppTextStyles.sectionHeader,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildChart(context, trend),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, DemographicTrend trend) {
    return switch (trend.dimension) {
      'age' => _AgeChart(trend: trend),
      'gender' => _GenderBar(trend: trend),
      'device' => _DeviceBar(trend: trend),
      _ => const SizedBox.shrink(),
    };
  }

  static String _sectionTitle(String dimension) => switch (dimension) {
        'age' => '연령대별 관심도',
        'gender' => '성별 관심도',
        'device' => '기기별 관심도',
        _ => dimension,
      };
}

// ── 연령대별 막대 차트 ──────────────────────────────────────────

class _AgeChart extends StatelessWidget {
  final DemographicTrend trend;

  const _AgeChart({required this.trend});

  static const _ageLabels = {
    '10': '10대',
    '20': '20대',
    '30': '30대',
    '40': '40대',
    '50': '50대',
    '60': '60대+',
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final avgs = trend.groupRecentAvg;
    final sortedGroups = avgs.keys.toList()
      ..sort((a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));

    if (sortedGroups.isEmpty) return const SizedBox.shrink();

    final maxVal = avgs.values.fold(0.0, (m, v) => v > m ? v : m);

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.2,
          barGroups: sortedGroups.asMap().entries.map((e) {
            final isTop = e.value == trend.topGroup;
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: avgs[e.value] ?? 0,
                  color: isTop
                      ? (colors?.success ?? const Color(0xFF00B96B))
                      : (colors?.neutralBorder ?? const Color(0xFFBDBDBD)),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final group = sortedGroups[value.toInt()];
                  return Text(
                    _ageLabels[group] ?? group,
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

// ── 성별 수평 비율 막대 ──────────────────────────────────────

class _GenderBar extends StatelessWidget {
  final DemographicTrend trend;

  const _GenderBar({required this.trend});

  @override
  Widget build(BuildContext context) {
    final mVal = trend.groupRecentAvg['m'] ?? 0;
    final fVal = trend.groupRecentAvg['f'] ?? 0;
    final total = mVal + fVal;
    if (total == 0) return const SizedBox.shrink();

    final mRatio = mVal / total;
    final fRatio = fVal / total;

    return Column(
      children: [
        _buildRatioRow(
          context,
          label: '남성',
          ratio: mRatio,
          color: const Color(0xFF2196F3),
          isTop: trend.topGroup == 'm',
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildRatioRow(
          context,
          label: '여성',
          ratio: fRatio,
          color: const Color(0xFFE91E63),
          isTop: trend.topGroup == 'f',
        ),
      ],
    );
  }

  Widget _buildRatioRow(
    BuildContext context, {
    required String label,
    required double ratio,
    required Color color,
    required bool isTop,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isTop ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 16,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('${(ratio * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ── 기기별 수평 비율 막대 ────────────────────────────────────

class _DeviceBar extends StatelessWidget {
  final DemographicTrend trend;

  const _DeviceBar({required this.trend});

  @override
  Widget build(BuildContext context) {
    final moVal = trend.groupRecentAvg['mo'] ?? 0;
    final pcVal = trend.groupRecentAvg['pc'] ?? 0;
    final total = moVal + pcVal;
    if (total == 0) return const SizedBox.shrink();

    final moRatio = moVal / total;
    final pcRatio = pcVal / total;

    return Column(
      children: [
        _buildRatioRow(
          context,
          label: '모바일',
          ratio: moRatio,
          color: const Color(0xFF4CAF50),
          isTop: trend.topGroup == 'mo',
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildRatioRow(
          context,
          label: 'PC',
          ratio: pcRatio,
          color: const Color(0xFF9C27B0),
          isTop: trend.topGroup == 'pc',
        ),
      ],
    );
  }

  Widget _buildRatioRow(
    BuildContext context, {
    required String label,
    required double ratio,
    required Color color,
    required bool isTop,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isTop ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 16,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('${(ratio * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
