// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aqi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monumentAqi)
const monumentAqiProvider = MonumentAqiProvider._();

final class MonumentAqiProvider
    extends
        $FunctionalProvider<AsyncValue<AqiData?>, AqiData?, FutureOr<AqiData?>>
    with $FutureModifier<AqiData?>, $FutureProvider<AqiData?> {
  const MonumentAqiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monumentAqiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monumentAqiHash();

  @$internal
  @override
  $FutureProviderElement<AqiData?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AqiData?> create(Ref ref) {
    return monumentAqi(ref);
  }
}

String _$monumentAqiHash() => r'fc921b4f548c3e6c6643bb5510267d8497e3a059';
