// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorships_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: koordinatörlük ek bilgilerinin kaynağı (`coordinatorships_module.dart`'ta bağlanır;
/// bugün geliştirme örneği).

@ProviderFor(coordinatorshipProfileRepository)
final coordinatorshipProfileRepositoryProvider =
    CoordinatorshipProfileRepositoryProvider._();

/// PORT: koordinatörlük ek bilgilerinin kaynağı (`coordinatorships_module.dart`'ta bağlanır;
/// bugün geliştirme örneği).

final class CoordinatorshipProfileRepositoryProvider
    extends
        $FunctionalProvider<
          CoordinatorshipProfileRepository,
          CoordinatorshipProfileRepository,
          CoordinatorshipProfileRepository
        >
    with $Provider<CoordinatorshipProfileRepository> {
  /// PORT: koordinatörlük ek bilgilerinin kaynağı (`coordinatorships_module.dart`'ta bağlanır;
  /// bugün geliştirme örneği).
  CoordinatorshipProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipProfileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoordinatorshipProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoordinatorshipProfileRepository create(Ref ref) {
    return coordinatorshipProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipProfileRepository>(
        value,
      ),
    );
  }
}

String _$coordinatorshipProfileRepositoryHash() =>
    r'4b81468fdc9a915d7c020ad5f84f5f9d08efad4f';
