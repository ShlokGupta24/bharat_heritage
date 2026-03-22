// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monument_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monumentsRepository)
const monumentsRepositoryProvider = MonumentsRepositoryProvider._();

final class MonumentsRepositoryProvider
    extends
        $FunctionalProvider<
          MonumentsRepository,
          MonumentsRepository,
          MonumentsRepository
        >
    with $Provider<MonumentsRepository> {
  const MonumentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monumentsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monumentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<MonumentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MonumentsRepository create(Ref ref) {
    return monumentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonumentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonumentsRepository>(value),
    );
  }
}

String _$monumentsRepositoryHash() =>
    r'7c900b698a39120b3d69c35b06b6a12e3a27c19a';
