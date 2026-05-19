import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/naver_trend.dart';
import 'service_providers.dart';

part 'naver_trend_provider.g.dart';

/// 네이버 쇼핑 카테고리 트렌드 — 기본 3종(생활용품/식품/가전).
/// auto-dispose: 위젯 소멸 시 자동 해제.
@riverpod
Future<List<CategoryTrend>> categoryTrends(Ref ref) async {
  final service = ref.watch(naverTrendServiceProvider);
  return service.getCategoryTrends();
}
