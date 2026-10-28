// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arşiv klasörleri (koordinatörlük başına bir klasör). Yeniden yükleme yalnız dokunuşla.

@ProviderFor(ArchiveFoldersController)
final archiveFoldersControllerProvider = ArchiveFoldersControllerProvider._();

/// Arşiv klasörleri (koordinatörlük başına bir klasör). Yeniden yükleme yalnız dokunuşla.
final class ArchiveFoldersControllerProvider
    extends
        $AsyncNotifierProvider<ArchiveFoldersController, List<ArchiveFolder>> {
  /// Arşiv klasörleri (koordinatörlük başına bir klasör). Yeniden yükleme yalnız dokunuşla.
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
    r'a38947a53170e5f1fba22c31179c985e383245e3';

/// Arşiv klasörleri (koordinatörlük başına bir klasör). Yeniden yükleme yalnız dokunuşla.

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
