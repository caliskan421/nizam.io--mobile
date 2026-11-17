import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../domain/archive.dart';
import 'archive_providers.dart';

part 'archive_folders_controller.g.dart';

/// Arşiv klasörleri (`archiveFolders`; yönetici tüm koordinatörlükler, koordinatör kendi
/// klasörü, üye tek sanal klasör). Kapsam değişince yeniden okunur; aksi hâlde yalnız dokunuşla.
@Riverpod(keepAlive: true)
class ArchiveFoldersController extends _$ArchiveFoldersController {
  @override
  Future<List<ArchiveFolder>> build() async {
    final filterFuture = ref.watch(archiveViewFilterProvider.future);
    final scope = await ref.watch(archiveScopeProvider.future);
    final repo = ref.read(archiveRepositoryProvider);
    final folders = await repo.loadFolders(department: scope.department);
    final filter = await filterFuture;
    if (filter == null) return folders;
    final tasks = await repo.archiveTasks(department: scope.department);
    final files = tasks
        .where((t) => filter.taskIds.contains(t.workItemId))
        .fold<int>(0, (sum, t) => sum + t.fileCount);
    if (filter.member) {
      final l = lookupAppLocalizations(ref.watch(localeProvider));
      return [
        ArchiveFolder(
          code: 'my-tasks',
          name: l.uiHomeModuleMyTasks,
          files: files,
          isVirtual: true,
        ),
      ];
    }
    return [
      for (final folder in folders)
        if (folder.code == scope.department)
          ArchiveFolder(code: folder.code, name: folder.name, files: files),
    ];
  }
}
