import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/nz_switch.dart';
import '../../../core/ui/widgets/lists/nz_list_tile.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_forms.dart';

/// Hesap sekmesinin son işlem grubu. Pinli API aktiflik değiştirmeyi sunmaz;
/// yalnız mevcut oturumun hesabının açık olduğu bilinir. Silme gerçek ucu kullanır.
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
    final activeSession = !catalog.hasError && !catalog.isLoading && self;
    final statusDescription = activeSession
        ? l.uiUserAccountFieldsSignedInStatusHint
        : l.uiUsersOpsStatusUnavailable;
    final busy = ref.watch(adminCommandProvider);
    Future<void> remove() async {
      if (!admin || self || busy) return;
      if (!await adminConfirm(
            context,
            l.uiUsersOpsDelete,
            l.uiUsersOpsDeleteConfirm,
          ) ||
          !context.mounted) {
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
      } on Object catch (error) {
        if (context.mounted) NzToast.error(context, toApiError(error));
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
              Semantics(
                enabled: false,
                label:
                    '${l.uiUsersOpsActive}${activeSession ? '' : ' · —'}. $statusDescription',
                child: ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        icon(NzIcons.lock), const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l.uiUsersOpsActive}${activeSession ? '' : ' · —'}',
                                style: context.text.bodyMd,
                              ),
                              const Gap(2),
                              Text(
                                statusDescription,
                                style: context.text.caption.copyWith(
                                  color: c.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),
                        // Diğer hesaplarda false bir aktiflik olgusu değildir;
                        // bilinmeyen durum başlık ve alt metinde açıklanır.
                        NzToggle(value: activeSession, onChanged: null),
                      ],
                    ),
                  ),
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
