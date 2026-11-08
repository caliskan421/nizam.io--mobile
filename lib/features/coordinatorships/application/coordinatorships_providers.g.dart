// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorships_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: koordinatörlük departman kaydının (tür, açıklama) kaynağı
/// (`coordinatorships_module.dart`'ta bağlanır; sunucu).

@ProviderFor(coordinatorshipProfileRepository)
final coordinatorshipProfileRepositoryProvider =
    CoordinatorshipProfileRepositoryProvider._();

/// PORT: koordinatörlük departman kaydının (tür, açıklama) kaynağı
/// (`coordinatorships_module.dart`'ta bağlanır; sunucu).

final class CoordinatorshipProfileRepositoryProvider
    extends
        $FunctionalProvider<
          CoordinatorshipProfileRepository,
          CoordinatorshipProfileRepository,
          CoordinatorshipProfileRepository
        >
    with $Provider<CoordinatorshipProfileRepository> {
  /// PORT: koordinatörlük departman kaydının (tür, açıklama) kaynağı
  /// (`coordinatorships_module.dart`'ta bağlanır; sunucu).
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

/// PORT: koordinatörlük toplantı ve arşiv kaynağı (`coordinatorships_module.dart`'ta bağlanır).

@ProviderFor(coordinatorshipActivityRepository)
final coordinatorshipActivityRepositoryProvider =
    CoordinatorshipActivityRepositoryProvider._();

/// PORT: koordinatörlük toplantı ve arşiv kaynağı (`coordinatorships_module.dart`'ta bağlanır).

final class CoordinatorshipActivityRepositoryProvider
    extends
        $FunctionalProvider<
          CoordinatorshipActivityRepository,
          CoordinatorshipActivityRepository,
          CoordinatorshipActivityRepository
        >
    with $Provider<CoordinatorshipActivityRepository> {
  /// PORT: koordinatörlük toplantı ve arşiv kaynağı (`coordinatorships_module.dart`'ta bağlanır).
  CoordinatorshipActivityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipActivityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$coordinatorshipActivityRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoordinatorshipActivityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoordinatorshipActivityRepository create(Ref ref) {
    return coordinatorshipActivityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipActivityRepository>(
        value,
      ),
    );
  }
}

String _$coordinatorshipActivityRepositoryHash() =>
    r'49062873e70f15fb3b785db75fecddf83a765492';
