// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'naver_trend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 네이버 쇼핑 카테고리 트렌드 — 기본 3종(생활용품/식품/가전).
/// auto-dispose: 위젯 소멸 시 자동 해제.

@ProviderFor(categoryTrends)
const categoryTrendsProvider = CategoryTrendsProvider._();

/// 네이버 쇼핑 카테고리 트렌드 — 기본 3종(생활용품/식품/가전).
/// auto-dispose: 위젯 소멸 시 자동 해제.

final class CategoryTrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryTrend>>,
          List<CategoryTrend>,
          FutureOr<List<CategoryTrend>>
        >
    with
        $FutureModifier<List<CategoryTrend>>,
        $FutureProvider<List<CategoryTrend>> {
  /// 네이버 쇼핑 카테고리 트렌드 — 기본 3종(생활용품/식품/가전).
  /// auto-dispose: 위젯 소멸 시 자동 해제.
  const CategoryTrendsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryTrendsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryTrendsHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryTrend>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryTrend>> create(Ref ref) {
    return categoryTrends(ref);
  }
}

String _$categoryTrendsHash() => r'fa4a2d73b40d5bcced143286570783a02d7f3627';
