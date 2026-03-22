// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wikipedia_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wikipediaImageRepository)
const wikipediaImageRepositoryProvider = WikipediaImageRepositoryProvider._();

final class WikipediaImageRepositoryProvider
    extends
        $FunctionalProvider<
          WikipediaImageRepository,
          WikipediaImageRepository,
          WikipediaImageRepository
        >
    with $Provider<WikipediaImageRepository> {
  const WikipediaImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wikipediaImageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wikipediaImageRepositoryHash();

  @$internal
  @override
  $ProviderElement<WikipediaImageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WikipediaImageRepository create(Ref ref) {
    return wikipediaImageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WikipediaImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WikipediaImageRepository>(value),
    );
  }
}

String _$wikipediaImageRepositoryHash() =>
    r'7224476ead4fccc8dbd7c087dd15dec19cdb5b7a';

/// Family provider — pass the monument name, get back a nullable image URL.
/// Results are cached per name for the lifetime of the provider.

@ProviderFor(wikipediaImage)
const wikipediaImageProvider = WikipediaImageFamily._();

/// Family provider — pass the monument name, get back a nullable image URL.
/// Results are cached per name for the lifetime of the provider.

final class WikipediaImageProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Family provider — pass the monument name, get back a nullable image URL.
  /// Results are cached per name for the lifetime of the provider.
  const WikipediaImageProvider._({
    required WikipediaImageFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'wikipediaImageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wikipediaImageHash();

  @override
  String toString() {
    return r'wikipediaImageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return wikipediaImage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WikipediaImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wikipediaImageHash() => r'9f6f5d165d3ae237e4b8ab78d011489dc954595c';

/// Family provider — pass the monument name, get back a nullable image URL.
/// Results are cached per name for the lifetime of the provider.

final class WikipediaImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  const WikipediaImageFamily._()
    : super(
        retry: null,
        name: r'wikipediaImageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Family provider — pass the monument name, get back a nullable image URL.
  /// Results are cached per name for the lifetime of the provider.

  WikipediaImageProvider call(String monumentName) =>
      WikipediaImageProvider._(argument: monumentName, from: this);

  @override
  String toString() => r'wikipediaImageProvider';
}
