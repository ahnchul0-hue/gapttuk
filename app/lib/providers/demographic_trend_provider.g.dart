// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demographic_trend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 카테고리별 인구통계 트렌드 — 연령/성별/기기 3종 반환.
/// family provider: 카테고리 코드별 자동 캐시.

@ProviderFor(demographicTrends)
const demographicTrendsProvider = DemographicTrendsFamily._();

/// 카테고리별 인구통계 트렌드 — 연령/성별/기기 3종 반환.
/// family provider: 카테고리 코드별 자동 캐시.

final class DemographicTrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DemographicTrend>>,
          List<DemographicTrend>,
          FutureOr<List<DemographicTrend>>
        >
    with
        $FutureModifier<List<DemographicTrend>>,
        $FutureProvider<List<DemographicTrend>> {
  /// 카테고리별 인구통계 트렌드 — 연령/성별/기기 3종 반환.
  /// family provider: 카테고리 코드별 자동 캐시.
  const DemographicTrendsProvider._({
    required DemographicTrendsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'demographicTrendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$demographicTrendsHash();

  @override
  String toString() {
    return r'demographicTrendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DemographicTrend>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DemographicTrend>> create(Ref ref) {
    final argument = this.argument as String;
    return demographicTrends(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DemographicTrendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$demographicTrendsHash() => r'33151e2aff34f14c4e6b4c4d613bca5e37ce367b';

/// 카테고리별 인구통계 트렌드 — 연령/성별/기기 3종 반환.
/// family provider: 카테고리 코드별 자동 캐시.

final class DemographicTrendsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DemographicTrend>>, String> {
  const DemographicTrendsFamily._()
    : super(
        retry: null,
        name: r'demographicTrendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 카테고리별 인구통계 트렌드 — 연령/성별/기기 3종 반환.
  /// family provider: 카테고리 코드별 자동 캐시.

  DemographicTrendsProvider call(String categoryCode) =>
      DemographicTrendsProvider._(argument: categoryCode, from: this);

  @override
  String toString() => r'demographicTrendsProvider';
}
