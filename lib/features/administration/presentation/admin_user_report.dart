import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/export/csv_writer.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';

/// A real CSV of the currently readable program tasks, with its scope stated in
/// the file. It never invents user history, files, account state, or company totals.
Future<void> exportAdminUserReport(
  BuildContext context,
  WidgetRef ref,
  KnownUser user,
  TaskCatalog catalog,
) async {
  final l = context.l10n;
  final scope = ref.read(scopeStateProvider);
  final session = ref.read(sessionGenerationProvider);
  final tasks = catalog.tasks.where(
    (t) => t.assignees.contains(user.accountId),
  );
  String status(TaskStatus value) => switch (value) {
    TaskStatus.todo => l.uiUsersNotStarted,
    TaskStatus.inProgress => l.uiUsersInProgress,
    TaskStatus.review => l.uiUsersReview,
    TaskStatus.returned => l.uiUsersReturned,
    TaskStatus.done => l.uiUsersDone,
    TaskStatus.unknown => l.uiUsersUnknownStatus,
  };
  final rows = [
    [l.uiUsersReportScope, l.uiUsersScopeNote],
    if (catalog.truncated) [l.uiUsersReportScope, l.uiUsersPartial],
    [
      l.uiUsersExportName,
      l.uiUsersReportTask,
      l.uiUsersReportStatus,
      l.uiUsersReportDue,
    ],
    for (final task in tasks)
      [
        user.fullName,
        task.title,
        status(task.status),
        DateFormat('dd.MM.yyyy').format(task.due),
      ],
  ];
  try {
    final path = await ref
        .read(downloadSinkProvider)
        .save('kisi-gorev-raporu.csv', Stream.value(csvBytes(rows)));
    if (context.mounted &&
        scope == ref.read(scopeStateProvider) &&
        session == ref.read(sessionGenerationProvider)) {
      NzToast.success(context, '${l.uiUsersExportSaved} $path');
    }
  } on Object catch (e, st) {
    // Rapor, bağlam/kapsam korumasından ÖNCE.
    final api = toReportedApiError(e, st, source: ReportSource.administration);
    if (context.mounted &&
        scope == ref.read(scopeStateProvider) &&
        session == ref.read(sessionGenerationProvider)) {
      NzToast.error(context, api);
    }
  }
}
