import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../messages/messages.dart';
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';
import 'admin_user_report.dart';

Future<void> showAdminUserProfileMenu(
  BuildContext hostContext,
  WidgetRef ref, {
  required KnownUser user,
  required TaskCatalog catalog,
  required VoidCallback onAccount,
}) {
  final scope = ref.read(scopeStateProvider);
  final session = ref.read(sessionGenerationProvider);
  return NzBottomSheet.show<void>(
    hostContext,
    title: user.fullName,
    builder: (sheet) => Consumer(
      builder: (context, sheetRef, _) {
        if (scope != sheetRef.watch(scopeStateProvider) ||
            session != sheetRef.watch(sessionGenerationProvider) ||
            sheetRef
                    .watch(taskCatalogControllerProvider)
                    .value
                    ?.access
                    ?.companyAdmin !=
                true) {
          return const SizedBox.shrink();
        }
        return NzMenuGroup(
          rows: [
            NzListTile(
              title: context.l10n.uiUsersPersonalReport,
              subtitle: context.l10n.uiUsersPersonalReportNote,
              leading: const NzIcon(NzIcons.download),
              onTap: () {
                Navigator.of(sheet).pop();
                exportAdminUserReport(hostContext, ref, user, catalog);
              },
            ),
            NzListTile(
              title: context.l10n.uiUsersAccountAndRoles,
              leading: const NzIcon(NzIcons.edit),
              onTap: () {
                Navigator.of(sheet).pop();
                onAccount();
              },
            ),
            NzListTile(
              title: context.l10n.uiUsersSendMessage,
              leading: const NzIcon(NzIcons.mail),
              onTap: catalog.access?.accountId == user.accountId
                  ? null
                  : () {
                      Navigator.of(sheet).pop();
                      openPersonChat(hostContext, user.accountId);
                    },
            ),
          ],
        );
      },
    ),
  );
}
