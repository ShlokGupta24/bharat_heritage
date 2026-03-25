// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monument_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monumentsRepositoryProvider)
const monumentsRepositoryProviderProvider =
    MonumentsRepositoryProviderProvider._();

final class MonumentsRepositoryProviderProvider
    extends
        $FunctionalProvider<
          MonumentsRepository,
          MonumentsRepository,
          MonumentsRepository
        >
    with $Provider<MonumentsRepository> {
  const MonumentsRepositoryProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monumentsRepositoryProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monumentsRepositoryProviderHash();

  @$internal
  @override
  $ProviderElement<MonumentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MonumentsRepository create(Ref ref) {
    return monumentsRepositoryProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonumentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonumentsRepository>(value),
    );
  }
}

String _$monumentsRepositoryProviderHash() =>
    r'e140f55b0489a2212583bac3b7e583d14657aca9';
