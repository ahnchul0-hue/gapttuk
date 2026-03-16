import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/monthly_price.dart';
import '../models/price_history.dart';
import '../models/product.dart';
import 'service_providers.dart';

part 'product_provider.g.dart';

/// 상품 상세 — productId별로 캐싱.
@riverpod
Future<Product> productDetail(Ref ref, int productId) async {
  final service = ref.watch(productServiceProvider);
  return service.getProduct(productId);
}

/// 요일별 가격 집계 — 가격 차트용.
@riverpod
Future<List<DailyPriceAggregate>> dailyPrices(
  Ref ref,
  int productId,
) async {
  final service = ref.watch(productServiceProvider);
  return service.getDailyPrices(productId);
}

/// 인기 검색어.
@riverpod
Future<List<PopularSearch>> popularSearches(Ref ref) async {
  final service = ref.watch(productServiceProvider);
  return service.getPopularSearches();
}

/// 월별 평균 가격 — 장기 추이 차트용.
@riverpod
Future<List<MonthlyPrice>> monthlyPrices(
  Ref ref,
  int productId,
) async {
  final service = ref.watch(productServiceProvider);
  return service.getMonthlyPrices(productId);
}

/// AI 가격 예측 — productId별로 캐싱.
@riverpod
Future<Map<String, dynamic>> productPrediction(
  Ref ref,
  int productId,
) async {
  final service = ref.watch(predictionServiceProvider);
  return service.getPrediction(productId);
}
