import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/export/csv_writer.dart';
import '../../../core/providers.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';
import 'admin_user_texts.dart';

/// Exports exactly the loaded, filtered rows. No inferred totals or hidden account data.
Future<void> exportAdminUsers(
  BuildContext context,
  WidgetRef ref,
  List<KnownUser> users,
  TaskCatalog? catalog,
  String? programId,
) async {
  final l = context.l10n;
  final session = ref.read(sessionGenerationProvider);
  final scope = ref.read(scopeStateProvider);
  final lines = [
    [l.uiUsersExportName, l.uiUsersMemberships],
    for (final user in users)
      [
        user.fullName,
        adminMembershipSummary(context, user, catalog, programId: programId),
      ],
  ];
  try {
    final saved = await ref
        .read(downloadSinkProvider)
        .save('kullanicilar.csv', Stream.value(csvBytes(lines)));
    if (context.mounted &&
        session == ref.read(sessionGenerationProvider) &&
        scope == ref.read(scopeStateProvider)) {
      NzToast.show(context, '${l.uiUsersExportSaved} $saved');
    }
  } on Object catch (e) {
    if (context.mounted) NzToast.error(context, toApiError(e));
  }
}
