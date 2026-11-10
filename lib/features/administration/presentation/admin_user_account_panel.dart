import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/user_account_draft_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_user_account_info.dart';
import 'admin_user_account_operations.dart';
import 'admin_user_account_role_row.dart';
import 'admin_users_filter.dart';

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

  void _role(DepartmentRole role) {
    final provider = userAccountDraftProvider(widget.user.accountId);
    final draft = ref.read(provider);
    if (draft == null) return;
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    NzBottomSheet.show<void>(
      context,
      title: role == DepartmentRole.coordinator
          ? context.l10n.uiUsersCoordinator
          : context.l10n.uiUsersMember,
      description: 'Birden çok seçebilirsin',
      actionsDivider: false,
      actions: (sheet) => [
        Consumer(
          builder: (context, ref, _) {
            final busy = ref.watch(provider.select((d) => d?.busy ?? true));
            return NzButton.secondary(
              label: context.l10n.uiTasksClear,
              onPressed: busy
                  ? null
                  : () => ref
                        .read(provider.notifier)
                        .clearDepartmentRole(
                          role,
                          widget.catalog.coordinatorships
                              .map((d) => d.code)
                              .toSet(),
                        ),
            );
          },
        ),
        NzButton.primary(
          label: 'Uygula',
          onPressed: () => Navigator.of(sheet).maybePop(),
        ),
      ],
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final current = ref.watch(provider);
          if (current == null ||
              scope != ref.watch(scopeStateProvider) ||
              session != ref.watch(sessionGenerationProvider)) {
            return const SizedBox.shrink();
          }
          return NzMenuGroup(
            rows: [
              for (final department in widget.catalog.coordinatorships)
                AdminCoordinatorshipFilterRow(
                  label: department.name,
                  code: department.shortCode,
                  count:
                      '${department.team.toSet().length} ${context.l10n.uiUsersNavCountTail}',
                  selected: current.value.teams.any(
                    (team) =>
                        team.departmentId == department.code &&
                        team.role == role,
                  ),
                  onTap: current.busy
                      ? null
                      : () => ref
                            .read(provider.notifier)
                            .setDepartmentRole(
                              department.code,
                              role,
                              selected: !current.value.teams.any(
                                (team) =>
                                    team.departmentId == department.code &&
                                    team.role == role,
                              ),
                            ),
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
    final ctl = ref.read(provider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer(
          builder: (context, ref, _) {
            final draft = ref.watch(
              provider.select(
                (d) => d == null
                    ? null
                    : (d.value.fullName, d.value.email, d.busy, d.valid),
              ),
            );
            if (draft == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminUserAccountInfo(
                  accountId: widget.user.accountId,
                  fullName: draft.$1,
                  email: draft.$2,
                  enabled: !draft.$3,
                  onFullNameChanged: ctl.setFullName,
                  onEmailChanged: ctl.setEmail,
                  onPasswordChanged: ctl.setPassword,
                ),
                if (!draft.$4)
                  Padding(
                    padding: const EdgeInsets.only(top: NizamioSpacing.space1),
                    child: Text(
                      l.uiUsersDraftInvalid,
                      style: context.text.caption.copyWith(color: c.danger),
                    ),
                  ),
              ],
            );
          },
        ),
        const Gap(_sectionGap),
        _heading(context, l.uiUsersDraftRoles),
        const Gap(NizamioSpacing.space2),
        Consumer(
          builder: (context, ref, _) {
            final draft = ref.watch(
              provider.select(
                (d) => d == null
                    ? null
                    : (
                        d.value.companyAdmin,
                        d.value.teams.any(
                          (t) => t.role == DepartmentRole.coordinator,
                        ),
                        d.value.teams.any(
                          (t) => t.role == DepartmentRole.member,
                        ),
                        d.busy,
                      ),
              ),
            );
            if (draft == null) return const SizedBox.shrink();
            final coordinator = draft.$2;
            final member = draft.$3;
            return LayoutBuilder(
              builder: (context, constraints) {
                final choices = Row(
                  children: [
                    Expanded(
                      child: AdminUserAccountRoleChoice(
                        label: l.uiUsersAdmin,
                        dot: c.roleAdmin,
                        selected: draft.$1,
                        hint: draft.$1 == null
                            ? l.uiUsersDraftAdminUnknown
                            : l.uiUsersDraftRoleScope,
                        onTap: draft.$4 || draft.$1 == null
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
                        onTap: draft.$4
                            ? null
                            : () => _role(DepartmentRole.coordinator),
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    Expanded(
                      child: AdminUserAccountRoleChoice(
                        label: l.uiUsersMember,
                        dot: c.roleMember,
                        selected: member,
                        hint: l.uiUsersDraftRoleScope,
                        onTap: draft.$4
                            ? null
                            : () => _role(DepartmentRole.member),
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
            );
          },
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
