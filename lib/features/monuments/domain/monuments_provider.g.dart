// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monuments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monuments)
const monumentsProvider = MonumentsProvider._();

final class MonumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Monument>>,
          List<Monument>,
          FutureOr<List<Monument>>
        >
    with $FutureModifier<List<Monument>>, $FutureProvider<List<Monument>> {
  const MonumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monumentsHash();

  @$internal
  @override
  $FutureProviderElement<List<Monument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Monument>> create(Ref ref) {
    return monuments(ref);
  }
}

String _$monumentsHash() => r'f7819715ef48fc9fe21a81b82a26ce319f9650da';

@ProviderFor(monumentOfTheDay)
const monumentOfTheDayProvider = MonumentOfTheDayProvider._();

final class MonumentOfTheDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<Monument?>,
          Monument?,
          FutureOr<Monument?>
        >
    with $FutureModifier<Monument?>, $FutureProvider<Monument?> {
  const MonumentOfTheDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monumentOfTheDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monumentOfTheDayHash();

  @$internal
  @override
  $FutureProviderElement<Monument?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Monument?> create(Ref ref) {
    return monumentOfTheDay(ref);
  }
}

String _$monumentOfTheDayHash() => r'1da58b9f1e658b5e5d00e772a79a3a86bf4af187';

@ProviderFor(SearchQuery)
const searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  const SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'c20c8b67cdf9a8c8820d422de83c580e88655dcd';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredMonuments)
const filteredMonumentsProvider = FilteredMonumentsProvider._();

final class FilteredMonumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Monument>>,
          List<Monument>,
          FutureOr<List<Monument>>
        >
    with $FutureModifier<List<Monument>>, $FutureProvider<List<Monument>> {
  const FilteredMonumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMonumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMonumentsHash();

  @$internal
  @override
  $FutureProviderElement<List<Monument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Monument>> create(Ref ref) {
    return filteredMonuments(ref);
  }
}

String _$filteredMonumentsHash() => r'691de3ed61fb95053b6cb41eccf1be0d3b17de06';

@ProviderFor(otherExpeditions)
const otherExpeditionsProvider = OtherExpeditionsProvider._();

final class OtherExpeditionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Monument>>,
          List<Monument>,
          FutureOr<List<Monument>>
        >
    with $FutureModifier<List<Monument>>, $FutureProvider<List<Monument>> {
  const OtherExpeditionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otherExpeditionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otherExpeditionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Monument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Monument>> create(Ref ref) {
    return otherExpeditions(ref);
  }
}

String _$otherExpeditionsHash() => r'adb32e7ddcde4baa705caae2f55b0bedb4b8a8d0';
