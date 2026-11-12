import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../application/archive_folder_sources.dart';
import '../application/archive_providers.dart';
import '../domain/records.dart';
import 'archive/archive_preview_sheet.dart';

/// Arşiv listesini değiştirmeden, görev dosyasını kimliğiyle bulup doğrudan önizler.
Future<void> openArchiveFile(
  BuildContext context, {
  required String folderCode,
  required String workItemId,
  required String fileId,
  required String? Function(String) taskTitle,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final subscription = container.listen(
    archiveFolderContextProvider(folderCode),
    (_, _) {},
  );
  try {
    final folder = await container.read(
      archiveFolderContextProvider(folderCode).future,
    );
    if (!context.mounted) return;
    if (folder == null) {
      NzToast.show(context, context.l10n.uiArchiveEmptyFiles);
      return;
    }
    final repository = container.read(archiveRepositoryProvider);
    final seen = <String>{};
    String? cursor;
    do {
      final page = await repository.archiveAttachments(
        department: folder.department,
        filter: ArchiveAttachmentFilter(workItemId: workItemId),
        page: PageRequest(limit: 50, cursor: cursor),
      );
      if (!context.mounted) return;
      final file = page.items.where((f) => f.id == fileId).firstOrNull;
      if (file != null) {
        await showArchivePreview(
          context,
          code: folderCode,
          taskTitle: taskTitle,
          fileId: file.id,
          initialFile: file,
        );
        return;
      }
      cursor = page.nextCursor;
      if (cursor != null && !seen.add(cursor)) break;
    } while (cursor != null);
    if (context.mounted) {
      NzToast.show(context, context.l10n.uiArchiveEmptyFiles);
    }
  } on Object catch (error, st) {
    // Rapor, bağlam korumasından ÖNCE.
    final api = toReportedApiError(error, st, source: ReportSource.archive);
    if (context.mounted) NzToast.error(context, api);
  } finally {
    subscription.close();
  }
}
