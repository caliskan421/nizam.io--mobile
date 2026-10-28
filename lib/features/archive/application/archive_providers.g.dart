// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: arşiv klasörlerinin kaynağı (`archive_module.dart`'ta bağlanır; bugün geliştirme
/// örneği).

@ProviderFor(archiveRepository)
final archiveRepositoryProvider = ArchiveRepositoryProvider._();

/// PORT: arşiv klasörlerinin kaynağı (`archive_module.dart`'ta bağlanır; bugün geliştirme
/// örneği).

final class ArchiveRepositoryProvider
    extends
        $FunctionalProvider<
          ArchiveRepository,
          ArchiveRepository,
          ArchiveRepository
        >
    with $Provider<ArchiveRepository> {
  /// PORT: arşiv klasörlerinin kaynağı (`archive_module.dart`'ta bağlanır; bugün geliştirme
  /// örneği).
  ArchiveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveRepositoryHash();

  @$internal
  @override
  $ProviderElement<ArchiveRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ArchiveRepository create(Ref ref) {
    return archiveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArchiveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArchiveRepository>(value),
    );
  }
}

String _$archiveRepositoryHash() => r'5b952ae7568e20c4e616e6ec337c9ec5b15b0b77';
