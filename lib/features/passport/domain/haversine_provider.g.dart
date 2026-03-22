// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'haversine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isNearMonument)
const isNearMonumentProvider = IsNearMonumentFamily._();

final class IsNearMonumentProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsNearMonumentProvider._({
    required IsNearMonumentFamily super.from,
    required (double, double, double, double) super.argument,
  }) : super(
         retry: null,
         name: r'isNearMonumentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isNearMonumentHash();

  @override
  String toString() {
    return r'isNearMonumentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as (double, double, double, double);
    return isNearMonument(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsNearMonumentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isNearMonumentHash() => r'64305e21ce35c3e08bfa80523470f3dcf21d9cde';

final class IsNearMonumentFamily extends $Family
    with $FunctionalFamilyOverride<bool, (double, double, double, double)> {
  const IsNearMonumentFamily._()
    : super(
        retry: null,
        name: r'isNearMonumentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsNearMonumentProvider call(
    double userLat,
    double userLng,
    double monumentLat,
    double monumentLng,
  ) => IsNearMonumentProvider._(
    argument: (userLat, userLng, monumentLat, monumentLng),
    from: this,
  );

  @override
  String toString() => r'isNearMonumentProvider';
}
