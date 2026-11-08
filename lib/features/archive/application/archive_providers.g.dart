// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: records arşiv uçlarının kaynağı (`archive_module.dart`'ta sunucu deposu bağlanır).

@ProviderFor(archiveRepository)
final archiveRepositoryProvider = ArchiveRepositoryProvider._();

/// PORT: records arşiv uçlarının kaynağı (`archive_module.dart`'ta sunucu deposu bağlanır).

final class ArchiveRepositoryProvider
    extends
        $FunctionalProvider<
          ArchiveRepository,
          ArchiveRepository,
          ArchiveRepository
        >
    with $Provider<ArchiveRepository> {
  /// PORT: records arşiv uçlarının kaynağı (`archive_module.dart`'ta sunucu deposu bağlanır).
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

/// Arşiv isteklerinin kapsamı: rol görev kataloğunun erişim bilgisinden (`/v1/me` +
/// `/v1/me/departments`) okunur. Departman: programdaki ilk koordinatörlük, yoksa ilk ekip
/// satırı; ekip satırı olmayan yöneticide programın ilk departmanı. Hiçbiri yoksa
/// `client.scope_missing` (istek gönderilmez). Katalog yalnız bu iki değer değişince yeniden
/// hesaplatır (görev yazmaları arşivi yeniden okutmaz).

@ProviderFor(archiveScope)
final archiveScopeProvider = ArchiveScopeProvider._();

/// Arşiv isteklerinin kapsamı: rol görev kataloğunun erişim bilgisinden (`/v1/me` +
/// `/v1/me/departments`) okunur. Departman: programdaki ilk koordinatörlük, yoksa ilk ekip
/// satırı; ekip satırı olmayan yöneticide programın ilk departmanı. Hiçbiri yoksa
/// `client.scope_missing` (istek gönderilmez). Katalog yalnız bu iki değer değişince yeniden
/// hesaplatır (görev yazmaları arşivi yeniden okutmaz).

final class ArchiveScopeProvider
    extends
        $FunctionalProvider<
          AsyncValue<ArchiveScope>,
          ArchiveScope,
          FutureOr<ArchiveScope>
        >
    with $FutureModifier<ArchiveScope>, $FutureProvider<ArchiveScope> {
  /// Arşiv isteklerinin kapsamı: rol görev kataloğunun erişim bilgisinden (`/v1/me` +
  /// `/v1/me/departments`) okunur. Departman: programdaki ilk koordinatörlük, yoksa ilk ekip
  /// satırı; ekip satırı olmayan yöneticide programın ilk departmanı. Hiçbiri yoksa
  /// `client.scope_missing` (istek gönderilmez). Katalog yalnız bu iki değer değişince yeniden
  /// hesaplatır (görev yazmaları arşivi yeniden okutmaz).
  ArchiveScopeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveScopeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveScopeHash();

  @$internal
  @override
  $FutureProviderElement<ArchiveScope> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ArchiveScope> create(Ref ref) {
    return archiveScope(ref);
  }
}

String _$archiveScopeHash() => r'dc13f3ad83c9e139e36f1457d5016e80514025d8';
