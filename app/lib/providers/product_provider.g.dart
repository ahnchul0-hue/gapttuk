// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 상품 상세 — productId별로 캐싱.

@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily._();

/// 상품 상세 — productId별로 캐싱.

final class ProductDetailProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  /// 상품 상세 — productId별로 캐싱.
  const ProductDetailProvider._({
    required ProductDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as int;
    return productDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailHash() => r'709e2739f71d3ae7295648f8be49852fdf12bafa';

/// 상품 상세 — productId별로 캐싱.

final class ProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, int> {
  const ProductDetailFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 상품 상세 — productId별로 캐싱.

  ProductDetailProvider call(int productId) =>
      ProductDetailProvider._(argument: productId, from: this);

  @override
  String toString() => r'productDetailProvider';
}

/// 일별 가격 집계 — 가격 차트용.

@ProviderFor(dailyPrices)
const dailyPricesProvider = DailyPricesFamily._();

/// 일별 가격 집계 — 가격 차트용.

final class DailyPricesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailyPriceAggregate>>,
          List<DailyPriceAggregate>,
          FutureOr<List<DailyPriceAggregate>>
        >
    with
        $FutureModifier<List<DailyPriceAggregate>>,
        $FutureProvider<List<DailyPriceAggregate>> {
  /// 일별 가격 집계 — 가격 차트용.
  const DailyPricesProvider._({
    required DailyPricesFamily super.from,
    required (int, {int days}) super.argument,
  }) : super(
         retry: null,
         name: r'dailyPricesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyPricesHash();

  @override
  String toString() {
    return r'dailyPricesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<DailyPriceAggregate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailyPriceAggregate>> create(Ref ref) {
    final argument = this.argument as (int, {int days});
    return dailyPrices(ref, argument.$1, days: argument.days);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyPricesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyPricesHash() => r'3dff02a036969407c26fe94e362679da7f746241';

/// 일별 가격 집계 — 가격 차트용.

final class DailyPricesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<DailyPriceAggregate>>,
          (int, {int days})
        > {
  const DailyPricesFamily._()
    : super(
        retry: null,
        name: r'dailyPricesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 일별 가격 집계 — 가격 차트용.

  DailyPricesProvider call(int productId, {int days = 30}) =>
      DailyPricesProvider._(argument: (productId, days: days), from: this);

  @override
  String toString() => r'dailyPricesProvider';
}

/// 인기 검색어.

@ProviderFor(popularSearches)
const popularSearchesProvider = PopularSearchesProvider._();

/// 인기 검색어.

final class PopularSearchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  /// 인기 검색어.
  const PopularSearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularSearchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularSearchesHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return popularSearches(ref);
  }
}

String _$popularSearchesHash() => r'e61445a51e57dcee51a1952550bae9f9ba068adb';
