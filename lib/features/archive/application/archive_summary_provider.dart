import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../tasks/tasks.dart' show taskCatalogControllerProvider;
import '../domain/archive_summary.dart';
import '../domain/records.dart';
import 'archive_controller.dart';
import 'archive_folders_controller.dart';
import 'archive_providers.dart';

/// Kapsam başına okunacak en çok sayfa (× 200 satır); aşılırsa özet [ArchiveSummary.partial].
const archiveSummaryMaxPages = 5;

/// Arşivin okunmuş dosya listesi ([partial]: sayfa sınırına takıldı).
typedef ArchiveFileSet = ({List<RecordFile> files, bool partial});

/// Arşiv özeti: dosya listesi sayfalanarak okunur. Yöneticide uç dönem genelidir (tek kapsam);
/// diğer rollerde her klasörün departman başlığıyla ayrı okunur, aynı dosya bir kez sayılır.
/// Klasör listesi yenilenince (yükleme, silme, aşağı çekme) yeniden hesaplanır.
final archiveFileSetProvider = FutureProvider.autoDispose<ArchiveFileSet>((
  ref,
) async {
  final scope = await ref.watch(archiveScopeProvider.future);
  final folders = await ref.watch(archiveFoldersControllerProvider.future);
  final repo = ref.read(archiveRepositoryProvider);
  final departments = scope.admin
      ? {scope.department}
      : {for (final f in folders) scope.departmentFor(f)};
  final files = <RecordFile>[];
  var partial = false;
  for (final department in departments) {
    String? cursor;
    var pages = 0;
    do {
      final page = await repo.archiveAttachments(
        department: department,
        page: PageRequest(limit: 200, cursor: cursor),
      );
      files.addAll(page.items);
      cursor = page.nextCursor;
      pages++;
    } while (cursor != null && pages < archiveSummaryMaxPages);
    if (cursor != null) partial = true;
  }
  return (files: files, partial: partial);
});

/// Arşiv özeti ([archiveFileSetProvider]'dan).
final archiveSummaryProvider = FutureProvider.autoDispose<ArchiveSummary>((
  ref,
) async {
  final set = await ref.watch(archiveFileSetProvider.future);
  return summarizeArchive(set.files, partial: set.partial);
});

/// Yönetici arşiv ana sayfasının istatistiği: seçili etiket süzgeciyle
/// ([ArchiveViewState.tags]); görevin koordinatörlüğü görev kataloğundan.
final archiveStatsProvider = FutureProvider.autoDispose<ArchiveStats>((
  ref,
) async {
  final tags = ref.watch(archiveControllerProvider.select((s) => s.tags));
  final set = await ref.watch(archiveFileSetProvider.future);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  return archiveStats(
    set.files,
    folderOf: (id) => catalog.task(id)?.departmentId,
    tags: tags,
    partial: set.partial,
  );
});

/// Etiket süzgecinde seçili etiketli dosyası olan görevler (üye görev klasörleri); süzgeç
/// boşsa null (hepsi).
final archiveTaggedTasksProvider = FutureProvider.autoDispose<Set<String>?>((
  ref,
) async {
  final tags = ref.watch(archiveControllerProvider.select((s) => s.tags));
  if (tags.isEmpty) return null;
  final set = await ref.watch(archiveFileSetProvider.future);
  return {
    for (final f in set.files)
      if (tags.contains(f.tag)) f.workItemId,
  };
});
