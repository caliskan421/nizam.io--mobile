import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../domain/archive_summary.dart';
import '../domain/records.dart';
import 'archive_folders_controller.dart';
import 'archive_providers.dart';

/// Kapsam başına okunacak en çok sayfa (× 200 satır); aşılırsa özet [ArchiveSummary.partial].
const archiveSummaryMaxPages = 5;

/// Arşiv özeti: dosya listesi sayfalanarak okunur. Yöneticide uç dönem genelidir (tek kapsam);
/// diğer rollerde her klasörün departman başlığıyla ayrı okunur, aynı dosya bir kez sayılır.
/// Klasör listesi yenilenince (yükleme, silme, aşağı çekme) yeniden hesaplanır.
final archiveSummaryProvider = FutureProvider.autoDispose<ArchiveSummary>((
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
  return summarizeArchive(files, partial: partial);
});
