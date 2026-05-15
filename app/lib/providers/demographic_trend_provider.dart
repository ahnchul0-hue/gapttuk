import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/demographic_trend.dart';
import 'service_providers.dart';

part 'demographic_trend_provider.g.dart';

/// 카테고리별 인구통계 트렌드 — 연령/성별/기기 3종 반환.
/// family provider: 카테고리 코드별 자동 캐시.
@riverpod
Future<List<DemographicTrend>> demographicTrends(
  Ref ref,
  String categoryCode,
) async {
  final service = ref.watch(naverTrendServiceProvider);
  return service.getDemographicTrends(categoryCode);
}
