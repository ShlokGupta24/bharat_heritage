// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_stats_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(visitorStatsRepository)
const visitorStatsRepositoryProvider = VisitorStatsRepositoryProvider._();

final class VisitorStatsRepositoryProvider
    extends
        $FunctionalProvider<
          VisitorStatsRepository,
          VisitorStatsRepository,
          VisitorStatsRepository
        >
    with $Provider<VisitorStatsRepository> {
  const VisitorStatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitorStatsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitorStatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<VisitorStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VisitorStatsRepository create(Ref ref) {
    return visitorStatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VisitorStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VisitorStatsRepository>(value),
    );
  }
}

String _$visitorStatsRepositoryHash() =>
    r'1eb536a67e9b9cd597d09b8585c9577d00d82711';
