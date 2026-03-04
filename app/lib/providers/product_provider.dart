import 'package:riverpod_annotation/riverpod_annotation.dart';

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

/// 일별 가격 집계 — 가격 차트용.
@riverpod
Future<List<DailyPriceAggregate>> dailyPrices(
  Ref ref,
  int productId, {
  int days = 30,
}) async {
  final service = ref.watch(productServiceProvider);
  return service.getDailyPrices(productId, days: days);
}

/// 인기 검색어.
@riverpod
Future<List<Map<String, dynamic>>> popularSearches(
  Ref ref,
) async {
  final service = ref.watch(productServiceProvider);
  return service.getPopularSearches();
}
