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

/// 요일별 가격 집계 — 가격 차트용.

@ProviderFor(dailyPrices)
const dailyPricesProvider = DailyPricesFamily._();

/// 요일별 가격 집계 — 가격 차트용.

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
  /// 요일별 가격 집계 — 가격 차트용.
  const DailyPricesProvider._({
    required DailyPricesFamily super.from,
    required int super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DailyPriceAggregate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailyPriceAggregate>> create(Ref ref) {
    final argument = this.argument as int;
    return dailyPrices(ref, argument);
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

String _$dailyPricesHash() => r'021c5aa5cfec0b36123a283dba3887287dbb2793';

/// 요일별 가격 집계 — 가격 차트용.

final class DailyPricesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DailyPriceAggregate>>, int> {
  const DailyPricesFamily._()
    : super(
        retry: null,
        name: r'dailyPricesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 요일별 가격 집계 — 가격 차트용.

  DailyPricesProvider call(int productId) =>
      DailyPricesProvider._(argument: productId, from: this);

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
          AsyncValue<List<PopularSearch>>,
          List<PopularSearch>,
          FutureOr<List<PopularSearch>>
        >
    with
        $FutureModifier<List<PopularSearch>>,
        $FutureProvider<List<PopularSearch>> {
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
  $FutureProviderElement<List<PopularSearch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PopularSearch>> create(Ref ref) {
    return popularSearches(ref);
  }
}

String _$popularSearchesHash() => r'267d2db7a534a410b7c211da8d27f26370c9f581';

/// AI 가격 예측 — productId별로 캐싱.

@ProviderFor(productPrediction)
const productPredictionProvider = ProductPredictionFamily._();

/// AI 가격 예측 — productId별로 캐싱.

final class ProductPredictionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// AI 가격 예측 — productId별로 캐싱.
  const ProductPredictionProvider._({
    required ProductPredictionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productPredictionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productPredictionHash();

  @override
  String toString() {
    return r'productPredictionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as int;
    return productPrediction(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductPredictionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productPredictionHash() => r'9e186a2a363ff505a134efbab994f3fc171cbb92';

/// AI 가격 예측 — productId별로 캐싱.

final class ProductPredictionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, int> {
  const ProductPredictionFamily._()
    : super(
        retry: null,
        name: r'productPredictionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// AI 가격 예측 — productId별로 캐싱.

  ProductPredictionProvider call(int productId) =>
      ProductPredictionProvider._(argument: productId, from: this);

  @override
  String toString() => r'productPredictionProvider';
}
