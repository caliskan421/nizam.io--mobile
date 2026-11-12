import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/lists/nz_list_tile.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_forms.dart';

/// Hesap durumu ve silme işlemleri.
class AdminUserAccountOperations extends ConsumerWidget {
  const AdminUserAccountOperations({super.key, required this.user});
  final KnownUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final catalog = ref.watch(taskCatalogControllerProvider);
    final access = catalog.value?.access;
    final admin =
        !catalog.hasError && !catalog.isLoading && access?.companyAdmin == true;
    final self = access?.accountId == user.accountId;
    final busy = ref.watch(adminCommandProvider);
    bool sameOwner(int session, String? program, String? department) {
      if (!context.mounted) return false;
      final scope = ref.read(scopeControllerProvider).current;
      return ref.read(sessionControllerProvider).generation == session &&
          scope.programId == program &&
          scope.departmentId == department;
    }

    Future<void> changeStatus() async {
      if (!admin ||
          self ||
          busy ||
          user.accountStatus == AccountStatus.unknown) {
        return;
      }
      final session = ref.read(sessionControllerProvider).generation;
      final scope = ref.read(scopeControllerProvider).current;
      final disable = user.accountStatus == AccountStatus.active;
      final title = disable ? l.uiUsersDisableAccount : l.uiUsersEnableAccount;
      final description = disable
          ? l.uiUsersDisableConfirm
          : l.uiUsersEnableConfirm;
      if (!await adminConfirm(context, title, description) ||
          !sameOwner(session, scope.programId, scope.departmentId)) {
        return;
      }
      try {
        await ref.read(adminCommandProvider.notifier).run((
          organization,
          _,
        ) async {
          if (disable) {
            await organization.disableAccount(user.accountId);
          } else {
            await organization.enableAccount(user.accountId);
          }
        });
        if (context.mounted) NzToast.success(context, title);
      } on Object catch (error, st) {
        // Rapor, bağlam korumasından ÖNCE.
        final api = toReportedApiError(
          error,
          st,
          source: ReportSource.administration,
        );
        if (context.mounted) NzToast.error(context, api);
      }
    }

    Future<void> remove() async {
      if (!admin || self || busy) return;
      final session = ref.read(sessionControllerProvider).generation;
      final scope = ref.read(scopeControllerProvider).current;
      if (!await adminConfirm(
            context,
            l.uiUsersOpsDelete,
            l.uiUsersOpsDeleteConfirm,
          ) ||
          !sameOwner(session, scope.programId, scope.departmentId)) {
        return;
      }
      try {
        await ref.read(adminCommandProvider.notifier).run((
          organization,
          _,
        ) async {
          await organization.deleteUser(user.accountId);
        });
        if (!context.mounted) return;
        NzToast.success(context, l.uiUsersOpsDeleted);
        context.appNav.openUsers();
      } on Object catch (error, st) {
        // Rapor, bağlam korumasından ÖNCE.
        final api = toReportedApiError(
          error,
          st,
          source: ReportSource.administration,
        );
        if (context.mounted) NzToast.error(context, api);
      }
    }

    Widget icon(IconData data, {bool danger = false}) => NzIcon(
      data,
      size: NizamioSize.iconSizeSm,
      color: danger ? c.danger : c.textMuted,
    );
    Widget divider() =>
        Divider(height: 1, thickness: 1, indent: 16, color: c.border);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(NizamioRadius.group),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NizamioRadius.group),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              if (!self && user.accountStatus != AccountStatus.unknown)
                NzListTile(
                  title: user.accountStatus == AccountStatus.active
                      ? l.uiUsersDisableAccount
                      : l.uiUsersEnableAccount,
                  subtitle: l.uiUsersAccountHistoryPreserved,
                  leading: icon(NzIcons.lock),
                  onTap: admin && !busy ? changeStatus : null,
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    user.accountStatus == AccountStatus.unknown
                        ? l.uiUsersAccountStatusUnknown
                        : l.uiUsersOwnAccount,
                  ),
                ),
              divider(),
              AbsorbPointer(
                absorbing: !admin || self || busy,
                child: Semantics(
                  enabled: admin && !self && !busy,
                  child: NzListTile.danger(
                    title: l.uiUsersOpsDelete,
                    subtitle: self
                        ? l.uiUsersOpsSelfDelete
                        : !admin
                        ? l.uiUsersOpsAdminRequired
                        : null,
                    leading: icon(NzIcons.delete, danger: true),
                    onTap: remove,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
