// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arşiv klasörleri (`archiveFolders`; yönetici tüm koordinatörlükler, koordinatör kendi
/// klasörü, üye tek sanal klasör). Kapsam değişince yeniden okunur; aksi hâlde yalnız dokunuşla.

@ProviderFor(ArchiveFoldersController)
final archiveFoldersControllerProvider = ArchiveFoldersControllerProvider._();

/// Arşiv klasörleri (`archiveFolders`; yönetici tüm koordinatörlükler, koordinatör kendi
/// klasörü, üye tek sanal klasör). Kapsam değişince yeniden okunur; aksi hâlde yalnız dokunuşla.
final class ArchiveFoldersControllerProvider
    extends
        $AsyncNotifierProvider<ArchiveFoldersController, List<ArchiveFolder>> {
  /// Arşiv klasörleri (`archiveFolders`; yönetici tüm koordinatörlükler, koordinatör kendi
  /// klasörü, üye tek sanal klasör). Kapsam değişince yeniden okunur; aksi hâlde yalnız dokunuşla.
  ArchiveFoldersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveFoldersControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveFoldersControllerHash();

  @$internal
  @override
  ArchiveFoldersController create() => ArchiveFoldersController();
}

String _$archiveFoldersControllerHash() =>
    r'62304453fbf5d9c6b160824997f83c1689830e73';

/// Arşiv klasörleri (`archiveFolders`; yönetici tüm koordinatörlükler, koordinatör kendi
/// klasörü, üye tek sanal klasör). Kapsam değişince yeniden okunur; aksi hâlde yalnız dokunuşla.

abstract class _$ArchiveFoldersController
    extends $AsyncNotifier<List<ArchiveFolder>> {
  FutureOr<List<ArchiveFolder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ArchiveFolder>>, List<ArchiveFolder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ArchiveFolder>>, List<ArchiveFolder>>,
              AsyncValue<List<ArchiveFolder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
