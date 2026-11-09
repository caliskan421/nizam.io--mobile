import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_icon_button.dart';
import '../../../core/ui/widgets/lists/nz_list_tile.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/user_account_draft_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_user_account_info.dart';
import 'admin_user_account_operations.dart';
import 'admin_user_account_role_row.dart';

class AdminUserAccountPanel extends ConsumerStatefulWidget {
  const AdminUserAccountPanel({
    super.key,
    required this.user,
    required this.catalog,
    required this.companyAdmin,
    this.email,
  });
  final KnownUser user;
  final TaskCatalog catalog;
  final bool? companyAdmin;
  final String? email;
  @override
  ConsumerState<AdminUserAccountPanel> createState() => _AccountPanelState();
}

class _AccountPanelState extends ConsumerState<AdminUserAccountPanel> {
  static const _sectionGap = 18.0;
  bool _seedScheduled = false;
  void _initialize() {
    if (_seedScheduled) return;
    _seedScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _seedScheduled = false;
      if (!mounted) return;
      ref
          .read(userAccountDraftProvider(widget.user.accountId).notifier)
          .initialize(
            widget.user,
            email: widget.email,
            companyAdmin: widget.companyAdmin,
          );
    });
  }

  void _departments() {
    final id = widget.user.accountId;
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiUsersDraftAddDepartment,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final draft = ref.watch(userAccountDraftProvider(id));
          if (draft == null ||
              scope != ref.watch(scopeStateProvider) ||
              session != ref.watch(sessionGenerationProvider))
            return const SizedBox.shrink();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final d in widget.catalog.coordinatorships)
                CheckboxListTile(
                  value: draft.value.teams.any((t) => t.departmentId == d.code),
                  title: Text(d.name),
                  subtitle: Text(d.label),
                  onChanged: draft.busy
                      ? null
                      : (_) => ref
                            .read(userAccountDraftProvider(id).notifier)
                            .toggleDepartment(d.code),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initialize();
    final l = context.l10n;
    final c = context.colors;
    final provider = userAccountDraftProvider(widget.user.accountId);
    final draft = ref.watch(provider);
    final ctl = ref.read(provider.notifier);
    if (draft == null) return const SizedBox.shrink();
    final selected = [
      for (final team in draft.value.teams)
        if (widget.catalog.coordinatorship(team.departmentId)
            case final department?)
          (team: team, department: department),
    ];
    final coordinator = draft.value.teams.isEmpty
        ? draft.roleForNew == DepartmentRole.coordinator
        : draft.value.teams.any((t) => t.role == DepartmentRole.coordinator);
    final member = draft.value.teams.isEmpty
        ? draft.roleForNew == DepartmentRole.member
        : draft.value.teams.any((t) => t.role == DepartmentRole.member);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminUserAccountInfo(
          accountId: widget.user.accountId,
          fullName: draft.value.fullName,
          email: draft.value.email,
          enabled: !draft.busy,
          onFullNameChanged: ctl.setFullName,
          onEmailChanged: ctl.setEmail,
          onPasswordChanged: ctl.setPassword,
        ),
        if (!draft.valid)
          Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space1),
            child: Text(
              l.uiUsersDraftInvalid,
              style: context.text.caption.copyWith(color: c.danger),
            ),
          ),
        const Gap(_sectionGap),
        _heading(context, l.uiUsersDraftRoles),
        const Gap(NizamioSpacing.space2),
        LayoutBuilder(
          builder: (context, constraints) {
            final choices = Row(
              children: [
                Expanded(
                  child: AdminUserAccountRoleChoice(
                    label: l.uiUsersAdmin,
                    dot: c.roleAdmin,
                    selected: draft.value.companyAdmin,
                    hint: draft.value.companyAdmin == null
                        ? l.uiUsersDraftAdminUnknown
                        : l.uiUsersDraftRoleScope,
                    onTap: draft.busy || draft.value.companyAdmin == null
                        ? null
                        : ctl.toggleAdmin,
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: AdminUserAccountRoleChoice(
                    label: l.uiUsersCoordinator,
                    dot: c.avatar1,
                    selected: coordinator,
                    hint: l.uiUsersDraftRoleScope,
                    onTap: draft.busy
                        ? null
                        : () => ctl.selectRole(
                            DepartmentRole.coordinator,
                            departmentIds: widget.catalog.coordinatorships
                                .map((d) => d.code)
                                .toSet(),
                          ),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: AdminUserAccountRoleChoice(
                    label: l.uiUsersMember,
                    dot: c.roleMember,
                    selected: member,
                    hint: l.uiUsersDraftRoleScope,
                    onTap: draft.busy
                        ? null
                        : () => ctl.selectRole(
                            DepartmentRole.member,
                            departmentIds: widget.catalog.coordinatorships
                                .map((d) => d.code)
                                .toSet(),
                          ),
                  ),
                ),
              ],
            );
            final scale = MediaQuery.textScalerOf(context).scale(1);
            if (scale <= 1.3) return choices;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: constraints.maxWidth * scale,
                child: choices,
              ),
            );
          },
        ),
        const Gap(_sectionGap),
        _heading(context, l.uiUsersAccountDepartmentHeading),
        const Gap(NizamioSpacing.space2),
        Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: c.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final entry in selected) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.rowPad,
                    vertical: NizamioSpacing.gapMd,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: NizamioSpacing.space10,
                        height: NizamioSpacing.space10,
                        padding: const EdgeInsets.all(NizamioSpacing.space1),
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(
                            NizamioSpacing.space3,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            entry.department.label,
                            style: context.text.monoSm.copyWith(
                              color: c.accentText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Gap(NizamioSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.department.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodyMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(NizamioSpacing.space1 / 2),
                            Text(
                              '${switch (entry.team.role) {
                                DepartmentRole.coordinator => l.uiUsersCoordinator,
                                DepartmentRole.member => l.uiUsersMember,
                                DepartmentRole.unknown => l.uiUsersMembershipUnknown,
                              }} · ${entry.department.team.toSet().length} ${l.uiUsersNavCountTail}',
                              style: context.text.caption.copyWith(
                                fontSize: 12.5,
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      NzIconButton(
                        icon: NzIcons.close,
                        semanticLabel:
                            '${l.uiUsersRemoveMembership}: ${entry.department.name}',
                        onPressed: draft.busy
                            ? null
                            : () => ctl.toggleDepartment(entry.department.code),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: NizamioSize.borderWidth,
                  thickness: NizamioSize.borderWidth,
                  color: c.border,
                ),
              ],
              NzListTile(
                title: l.uiUsersDraftAddDepartment,
                leading: NzIcon(
                  NzIcons.add,
                  color: c.accentText,
                  size: NizamioSize.iconSizeSm,
                ),
                size: NzSize.sm,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${draft.value.teams.length} ${l.uiUsersDraftSelected}',
                      style: context.text.bodyMd.copyWith(color: c.textFaint),
                    ),
                    const Gap(NizamioSpacing.space2),
                    NzIcon(
                      NzIcons.chevronRight,
                      size: NizamioSize.iconSizeSm,
                      color: c.textFaint,
                    ),
                  ],
                ),
                onTap: draft.busy ? null : _departments,
              ),
            ],
          ),
        ),
        const Gap(_sectionGap),
        AdminUserAccountOperations(user: widget.user),
      ],
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(left: NizamioSpacing.space1),
    child: Text(
      text,
      style: context.text.kicker.copyWith(color: context.colors.textFaint),
    ),
  );
}
