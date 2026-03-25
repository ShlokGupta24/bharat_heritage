// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allVisitorStats)
const allVisitorStatsProvider = AllVisitorStatsProvider._();

final class AllVisitorStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VisitorStats>>,
          List<VisitorStats>,
          FutureOr<List<VisitorStats>>
        >
    with
        $FutureModifier<List<VisitorStats>>,
        $FutureProvider<List<VisitorStats>> {
  const AllVisitorStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allVisitorStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allVisitorStatsHash();

  @$internal
  @override
  $FutureProviderElement<List<VisitorStats>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VisitorStats>> create(Ref ref) {
    return allVisitorStats(ref);
  }
}

String _$allVisitorStatsHash() => r'24b79d2cbe99a7ea74171c32849cda984c5ca9f4';

@ProviderFor(monumentVisitorStats)
const monumentVisitorStatsProvider = MonumentVisitorStatsProvider._();

final class MonumentVisitorStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<VisitorStats?>,
          VisitorStats?,
          FutureOr<VisitorStats?>
        >
    with $FutureModifier<VisitorStats?>, $FutureProvider<VisitorStats?> {
  const MonumentVisitorStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monumentVisitorStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monumentVisitorStatsHash();

  @$internal
  @override
  $FutureProviderElement<VisitorStats?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VisitorStats?> create(Ref ref) {
    return monumentVisitorStats(ref);
  }
}

String _$monumentVisitorStatsHash() =>
    r'f9e86ea2b254692eb6401d183735656d1f005ffc';

@ProviderFor(crowdCurve)
const crowdCurveProvider = CrowdCurveProvider._();

final class CrowdCurveProvider
    extends
        $FunctionalProvider<
          AsyncValue<CrowdCurveData>,
          CrowdCurveData,
          FutureOr<CrowdCurveData>
        >
    with $FutureModifier<CrowdCurveData>, $FutureProvider<CrowdCurveData> {
  const CrowdCurveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crowdCurveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crowdCurveHash();

  @$internal
  @override
  $FutureProviderElement<CrowdCurveData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CrowdCurveData> create(Ref ref) {
    return crowdCurve(ref);
  }
}

String _$crowdCurveHash() => r'dd8434d74b0c20bd425b74f93371cf8c11e45e83';
