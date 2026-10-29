import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/archive.dart';
import 'archive_folders_controller.dart';

part 'archive_folder_contents.g.dart';

/// Klasör ayrıntısının türetilmiş içeriği: klasör, görev klasörleri ve dosya listesi.
@immutable
final class ArchiveFolderContents {
  const ArchiveFolderContents({
    required this.folder,
    required this.groups,
    required this.files,
  });

  final ArchiveFolder folder;
  final List<ArchiveTaskFolder> groups;
  final List<ArchiveFile> files;
}

/// Klasör içeriği bir kez türetilir (klasör ya da görev kataloğu değişene dek); ekran her
/// kurulumda, süzgeç değişiminde ya da önizlemede dosya listesini yeniden üretmez. Kaynaklardan
/// biri yüklenmemişse null (yükleme/hata durumunu ekran kaynakların kendisinden gösterir).
@riverpod
ArchiveFolderContents? archiveFolderContents(Ref ref, String code) {
  final folders = ref.watch(archiveFoldersControllerProvider).value;
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (folders == null || folders.isEmpty || catalog == null) return null;
  final folder =
      folders.where((f) => f.code == code).firstOrNull ?? folders.first;
  return ArchiveFolderContents(
    folder: folder,
    groups: taskFolders(folder, catalog),
    files: folderFiles(folder, catalog),
  );
}
