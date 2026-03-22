// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aqi_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aqiRepository)
const aqiRepositoryProvider = AqiRepositoryProvider._();

final class AqiRepositoryProvider
    extends $FunctionalProvider<AqiRepository, AqiRepository, AqiRepository>
    with $Provider<AqiRepository> {
  const AqiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aqiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aqiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AqiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AqiRepository create(Ref ref) {
    return aqiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AqiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AqiRepository>(value),
    );
  }
}

String _$aqiRepositoryHash() => r'92729fe39a1d442fae4647bd945b5a6e090c47fe';
