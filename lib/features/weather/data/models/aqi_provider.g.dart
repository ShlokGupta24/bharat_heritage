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

String _$monumentAqiHash() => r'b66d1f03a3269e9776280b539aeb14d52557d0ac';

@ProviderFor(aqiForCoordinates)
const aqiForCoordinatesProvider = AqiForCoordinatesFamily._();

final class AqiForCoordinatesProvider
    extends
        $FunctionalProvider<AsyncValue<AqiData?>, AqiData?, FutureOr<AqiData?>>
    with $FutureModifier<AqiData?>, $FutureProvider<AqiData?> {
  const AqiForCoordinatesProvider._({
    required AqiForCoordinatesFamily super.from,
    required (double, double) super.argument,
  }) : super(
         retry: null,
         name: r'aqiForCoordinatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aqiForCoordinatesHash();

  @override
  String toString() {
    return r'aqiForCoordinatesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AqiData?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AqiData?> create(Ref ref) {
    final argument = this.argument as (double, double);
    return aqiForCoordinates(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is AqiForCoordinatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aqiForCoordinatesHash() => r'59601fe20f2377032227697187d97fb01f8c3a06';

final class AqiForCoordinatesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AqiData?>, (double, double)> {
  const AqiForCoordinatesFamily._()
    : super(
        retry: null,
        name: r'aqiForCoordinatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AqiForCoordinatesProvider call(double lat, double lon) =>
      AqiForCoordinatesProvider._(argument: (lat, lon), from: this);

  @override
  String toString() => r'aqiForCoordinatesProvider';
}
