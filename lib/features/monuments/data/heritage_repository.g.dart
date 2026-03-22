// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heritage_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(heritageRepository)
const heritageRepositoryProvider = HeritageRepositoryProvider._();

final class HeritageRepositoryProvider
    extends
        $FunctionalProvider<
          HeritageRepository,
          HeritageRepository,
          HeritageRepository
        >
    with $Provider<HeritageRepository> {
  const HeritageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'heritageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$heritageRepositoryHash();

  @$internal
  @override
  $ProviderElement<HeritageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HeritageRepository create(Ref ref) {
    return heritageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeritageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeritageRepository>(value),
    );
  }
}

String _$heritageRepositoryHash() =>
    r'00cd4b4345f95dda8e50a445de7c9a372724502b';
