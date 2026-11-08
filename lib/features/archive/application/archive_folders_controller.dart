import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive.dart';
import 'archive_providers.dart';

part 'archive_folders_controller.g.dart';

/// Arşiv klasörleri (`archiveFolders`; yönetici tüm koordinatörlükler, koordinatör kendi
/// klasörü, üye tek sanal klasör). Kapsam değişince yeniden okunur; aksi hâlde yalnız dokunuşla.
@Riverpod(keepAlive: true)
class ArchiveFoldersController extends _$ArchiveFoldersController {
  @override
  Future<List<ArchiveFolder>> build() async {
    final scope = await ref.watch(archiveScopeProvider.future);
    return ref
        .read(archiveRepositoryProvider)
        .loadFolders(department: scope.department);
  }
}
