// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passport_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(passportEntries)
const passportEntriesProvider = PassportEntriesProvider._();

final class PassportEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PassportEntry>>,
          List<PassportEntry>,
          Stream<List<PassportEntry>>
        >
    with
        $FutureModifier<List<PassportEntry>>,
        $StreamProvider<List<PassportEntry>> {
  const PassportEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passportEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passportEntriesHash();

  @$internal
  @override
  $StreamProviderElement<List<PassportEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PassportEntry>> create(Ref ref) {
    return passportEntries(ref);
  }
}

String _$passportEntriesHash() => r'd83bdb2a5ccdb83a494394b583cb0fc192917d5b';

@ProviderFor(visitedMonumentIds)
const visitedMonumentIdsProvider = VisitedMonumentIdsProvider._();

final class VisitedMonumentIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  const VisitedMonumentIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitedMonumentIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitedMonumentIdsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return visitedMonumentIds(ref);
  }
}

String _$visitedMonumentIdsHash() =>
    r'afe70533e4de0f0b8d0dc7de24e626a7f7f0accc';

@ProviderFor(userPassport)
const userPassportProvider = UserPassportProvider._();

final class UserPassportProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserPassport>,
          UserPassport,
          FutureOr<UserPassport>
        >
    with $FutureModifier<UserPassport>, $FutureProvider<UserPassport> {
  const UserPassportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPassportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPassportHash();

  @$internal
  @override
  $FutureProviderElement<UserPassport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserPassport> create(Ref ref) {
    return userPassport(ref);
  }
}

String _$userPassportHash() => r'71f3cc998e12dd2f52ad7643f8b2243acf759cb1';

@ProviderFor(currentPosition)
const currentPositionProvider = CurrentPositionProvider._();

final class CurrentPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Position?>,
          Position?,
          FutureOr<Position?>
        >
    with $FutureModifier<Position?>, $FutureProvider<Position?> {
  const CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $FutureProviderElement<Position?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Position?> create(Ref ref) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'c49d8c25e22cbafb001f70746040f42cb1f84780';

@ProviderFor(nearbyMonument)
const nearbyMonumentProvider = NearbyMonumentProvider._();

final class NearbyMonumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<Monument?>,
          Monument?,
          FutureOr<Monument?>
        >
    with $FutureModifier<Monument?>, $FutureProvider<Monument?> {
  const NearbyMonumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyMonumentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyMonumentHash();

  @$internal
  @override
  $FutureProviderElement<Monument?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Monument?> create(Ref ref) {
    return nearbyMonument(ref);
  }
}

String _$nearbyMonumentHash() => r'8186626c42ce569c488e9daba872a368abbf906a';

@ProviderFor(nearbyMonuments10km)
const nearbyMonuments10kmProvider = NearbyMonuments10kmProvider._();

final class NearbyMonuments10kmProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Monument>>,
          List<Monument>,
          FutureOr<List<Monument>>
        >
    with $FutureModifier<List<Monument>>, $FutureProvider<List<Monument>> {
  const NearbyMonuments10kmProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyMonuments10kmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyMonuments10kmHash();

  @$internal
  @override
  $FutureProviderElement<List<Monument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Monument>> create(Ref ref) {
    return nearbyMonuments10km(ref);
  }
}

String _$nearbyMonuments10kmHash() =>
    r'16002b7cc0c4b427622266b5f75911e1550934f6';

@ProviderFor(tryAwardStamp)
const tryAwardStampProvider = TryAwardStampProvider._();

final class TryAwardStampProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  const TryAwardStampProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tryAwardStampProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tryAwardStampHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return tryAwardStamp(ref);
  }
}

String _$tryAwardStampHash() => r'b09e64bb690a7a6be2853793c9830612c9553e54';
