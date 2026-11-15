import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../application/archive_folder_controller.dart';
import '../application/archive_folders_controller.dart';
import 'open_archive_file.dart';

/// Görevin arşivini açar; dosya verildiğinde aynı görevin dosyalarını önizler.
Future<void> openTaskArchive(
  BuildContext context, {
  required String departmentId,
  required String workItemId,
  required String? Function(String) taskTitle,
  String? fileId,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  try {
    final folders = await container.read(
      archiveFoldersControllerProvider.future,
    );
    if (!context.mounted) return;
    final folder =
        folders.where((f) => f.code == departmentId).firstOrNull ??
        folders.where((f) => f.isVirtual).firstOrNull;
    if (folder == null) {
      NzToast.show(context, context.l10n.uiArchiveEmptyFiles);
      return;
    }
    if (fileId != null) {
      await openArchiveFile(
        context,
        folderCode: folder.code,
        workItemId: workItemId,
        fileId: fileId,
        taskTitle: taskTitle,
        taskFilesOnly: true,
      );
      return;
    }
    final provider = archiveFolderControllerProvider(folder.code);
    // Yeni sayfa dinlemeye başlayana kadar otomatik dispose seçimi düşürmesin.
    final subscription = container.listen(provider, (_, _) {});
    try {
      final controller = container.read(provider.notifier);
      controller.clearFileFilters();
      controller.setQuery('');
      controller.openTask(workItemId);
      context.appNav.openArchiveFolder(folder.code);
      await WidgetsBinding.instance.endOfFrame;
    } finally {
      subscription.close();
    }
  } on Object catch (error, stack) {
    final api = toReportedApiError(error, stack, source: ReportSource.archive);
    if (context.mounted) NzToast.error(context, api);
  }
}
