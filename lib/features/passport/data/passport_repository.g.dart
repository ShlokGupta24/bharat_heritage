// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passport_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(passportRepository)
const passportRepositoryProvider = PassportRepositoryProvider._();

final class PassportRepositoryProvider
    extends
        $FunctionalProvider<
          PassportRepository,
          PassportRepository,
          PassportRepository
        >
    with $Provider<PassportRepository> {
  const PassportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passportRepositoryHash();

  @$internal
  @override
  $ProviderElement<PassportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PassportRepository create(Ref ref) {
    return passportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PassportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PassportRepository>(value),
    );
  }
}

String _$passportRepositoryHash() =>
    r'e420f00bbb7a369f78eef2c5879e6af067cef3af';
