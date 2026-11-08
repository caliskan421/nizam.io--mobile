import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/archive.dart';
import '../domain/records.dart';
import 'archive_folders_controller.dart';
import 'archive_providers.dart';

part 'archive_folder_sources.g.dart';

/// Açık klasör ve isteklerinin departman başlığı.
@immutable
final class ArchiveFolderContext {
  const ArchiveFolderContext({required this.folder, required this.scope});

  final ArchiveFolder folder;
  final ArchiveScope scope;

  /// Klasör isteklerinin departman başlığı.
  String get department => scope.departmentFor(folder);
}

/// [code] klasörü (klasör listesinden); listede yoksa null (ekran "bulunamadı" der).
@riverpod
Future<ArchiveFolderContext?> archiveFolderContext(Ref ref, String code) async {
  final scope = await ref.watch(archiveScopeProvider.future);
  final folders = await ref.watch(archiveFoldersControllerProvider.future);
  final folder = folders.where((f) => f.code == code).firstOrNull;
  return folder == null
      ? null
      : ArchiveFolderContext(folder: folder, scope: scope);
}

/// Klasörün dosyalı görevleri (`archiveTasks`). Yöneticide uç dönem genelidir: görev
/// kataloğunda departmanı bu klasör olan görevler kalır (katalogda olmayan görev düşer).
@riverpod
Future<List<ArchiveTaskSummary>> archiveFolderTasks(
  Ref ref,
  String code,
) async {
  final ctx = await ref.watch(archiveFolderContextProvider(code).future);
  if (ctx == null) return const [];
  final tasks = await ref
      .read(archiveRepositoryProvider)
      .archiveTasks(department: ctx.department);
  if (!ctx.scope.widerThan(ctx.folder)) return tasks;
  final catalog = await ref.read(taskCatalogControllerProvider.future);
  return [
    for (final t in tasks)
      if (catalog.task(t.workItemId)?.departmentId == ctx.folder.code) t,
  ];
}

/// Klasörde süzgeç olarak seçilebilen yükleyenler (`archiveUploaders`; yalnız kimlik).
@riverpod
Future<List<String>> archiveFolderUploaders(Ref ref, String code) async {
  final ctx = await ref.watch(archiveFolderContextProvider(code).future);
  if (ctx == null) return const [];
  return ref
      .read(archiveRepositoryProvider)
      .archiveUploaders(department: ctx.department);
}
