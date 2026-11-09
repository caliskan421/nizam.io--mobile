import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/nz_form_rows.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../../core/ui/widgets/surfaces/nz_reveal.dart';
import '../../coordinatorships/coordinatorships.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import '../domain/organization_admin_repository.dart';
import 'admin_forms.dart';
import 'admin_user_account_operations.dart';
import 'admin_user_account_role_row.dart';

typedef _AccountOwner = ({int session, Object scope});

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
  static const _sectionGap = 14.0;
  final _email = TextEditingController();
  late String _baseline;
  bool _addOpen = false;
  bool _busy = false;
  bool get _dirty => _email.text.trim() != _baseline;
  bool get _validEmail =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email.text.trim());
  _AccountOwner get _owner => (
    session: ref.read(sessionGenerationProvider),
    scope: ref.read(scopeStateProvider),
  );
  bool _current(_AccountOwner owner) => mounted && owner == _owner;

  @override
  void initState() {
    super.initState();
    _baseline = widget.email ?? '';
    _email.text = _baseline;
  }

  @override
  void didUpdateWidget(AdminUserAccountPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.accountId != widget.user.accountId ||
        !_dirty && oldWidget.email != widget.email) {
      _baseline = widget.email ?? '';
      _email.text = _baseline;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<bool> _run(
    Future<void> Function(OrganizationAdminRepository, bool) call, {
    _AccountOwner? owner,
  }) async {
    final captured = owner ?? _owner;
    if (!_current(captured) || _busy || ref.read(adminCommandProvider))
      return false;
    setState(() => _busy = true);
    Future<void> attempt(bool confirmed) => ref
        .read(adminCommandProvider.notifier)
        .run((organization, _) => call(organization, confirmed));
    try {
      try {
        await attempt(false);
      } on ApiError catch (e) {
        if (e.code != 'organization.confirmation_required' ||
            !_current(captured))
          rethrow;
        if (!await adminConfirm(
              context,
              context.l10n.uiUsersMemberships,
              context.l10n.uiUsersMembershipConfirm,
            ) ||
            !_current(captured))
          return false;
        await attempt(true);
      }
      if (_current(captured))
        NzToast.success(context, context.l10n.uiUsersSaved);
      return true;
    } on Object catch (e) {
      if (_current(captured)) NzToast.error(context, toApiError(e));
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveEmail() async {
    if (!_dirty || !_validEmail) return;
    final email = _email.text.trim();
    final ok = await _run((organization, _) async {
      await organization.updateUser(widget.user.accountId, email: email);
    });
    if (ok && mounted)
      setState(() {
        _baseline = email;
        _email.text = email;
      });
  }

  Future<void> _adminRole() async {
    final current = widget.companyAdmin;
    if (current == null) return;
    final owner = _owner;
    final l = context.l10n;
    if (!await adminConfirm(
          context,
          l.uiUsersAdmin,
          current ? l.uiUsersAccountRevokeAdmin : l.uiUsersAccountGrantAdmin,
        ) ||
        !_current(owner))
      return;
    await _run((organization, _) async {
      await organization.updateUser(
        widget.user.accountId,
        companyAdmin: !current,
      );
    }, owner: owner);
  }

  Future<void> _setMembership(
    CoordinatorshipRef department,
    DepartmentRole role,
    _AccountOwner owner,
  ) async {
    if (!_current(owner)) return;
    final program = ref.read(scopeStateProvider).programId;
    final exists = widget.user.teams.any(
      (m) => m.programId == program && m.departmentId == department.code,
    );
    final repo = ref.read(departmentRepositoryProvider);
    await _run((_, confirmed) async {
      if (exists) {
        await repo.changeMembershipRole(
          department.code,
          widget.user.accountId,
          role: role,
          confirm: confirmed,
        );
      } else {
        await repo.assignMembership(
          department.code,
          accountId: widget.user.accountId,
          role: role,
        );
      }
    }, owner: owner);
  }

  Future<void> _removeMembership(
    CoordinatorshipRef department,
    _AccountOwner owner,
  ) async {
    if (!_current(owner)) return;
    final l = context.l10n;
    if (!await adminConfirm(
          context,
          l.uiUsersRemoveMembership,
          l.uiUsersRemoveMembershipConfirm,
        ) ||
        !_current(owner))
      return;
    final repo = ref.read(departmentRepositoryProvider);
    await _run((_, confirmed) async {
      await repo.removeMember(
        department.code,
        widget.user.accountId,
        confirm: confirmed,
      );
    }, owner: owner);
  }

  void _roleChoices(DepartmentRole role) {
    final owner = _owner;
    final program = ref.read(scopeStateProvider).programId;
    final l = context.l10n;
    NzBottomSheet.show<void>(
      context,
      title: role == DepartmentRole.coordinator
          ? l.uiUsersCoordinator
          : l.uiUsersMember,
      description: l.uiUsersAccountRoleScope,
      builder: (sheet) => Consumer(
        builder: (context, ref, _) {
          if (owner.session != ref.watch(sessionGenerationProvider) ||
              owner.scope != ref.watch(scopeStateProvider))
            return const SizedBox.shrink();
          return NzMenuGroup(
            rows: [
              for (final d in widget.catalog.coordinatorships)
                AdminUserAccountRoleRow(
                  label: d.name,
                  description: d.label,
                  dot: role == DepartmentRole.coordinator
                      ? context.colors.avatar1
                      : context.colors.roleMember,
                  selected: widget.user.teams.any(
                    (m) =>
                        m.programId == program &&
                        m.departmentId == d.code &&
                        m.role == role,
                  ),
                  onTap: () {
                    Navigator.of(sheet).pop();
                    if (widget.user.teams.any(
                      (m) =>
                          m.programId == program &&
                          m.departmentId == d.code &&
                          m.role == role,
                    )) {
                      _removeMembership(d, owner);
                    } else {
                      _setMembership(d, role, owner);
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _membershipChoices(CoordinatorshipRef department) {
    final owner = _owner;
    final l = context.l10n;
    NzBottomSheet.show<void>(
      context,
      title: department.name,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final role in [
            DepartmentRole.coordinator,
            DepartmentRole.member,
          ])
            ListTile(
              title: Text(
                role == DepartmentRole.coordinator
                    ? l.uiUsersSetCoordinator
                    : l.uiUsersSetMember,
              ),
              onTap: () {
                Navigator.of(sheet).pop();
                _setMembership(department, role, owner);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final program = ref.watch(scopeStateProvider).programId;
    final memberships = widget.user.teams
        .where((m) => m.programId == program)
        .toList();
    final assigned = widget.catalog.coordinatorships
        .where((d) => memberships.any((m) => m.departmentId == d.code))
        .toList();
    final available = widget.catalog.coordinatorships
        .where((d) => !memberships.any((m) => m.departmentId == d.code))
        .toList();
    final busy = _busy || ref.watch(adminCommandProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AbsorbPointer(
          absorbing: busy,
          child: NzFormRows(
            rows: [
              NzFormRow.input(
                label: l.uiUsersAccountEmail,
                icon: NzIcons.mail,
                controller: _email,
                hint: l.uiUsersAccountEmailHint,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        if (_dirty && !_validEmail)
          Padding(
            padding: const EdgeInsets.only(
              left: NizamioSpacing.space1,
              top: NizamioSpacing.space1,
            ),
            child: Text(
              l.uiUsersAccountEmailInvalid,
              style: context.text.caption.copyWith(color: c.danger),
            ),
          ),
        const Gap(_sectionGap),
        Padding(
          padding: const EdgeInsets.only(left: NizamioSpacing.space1),
          child: Text(
            l.uiUsersAccountRoleHeading,
            style: context.text.kicker.copyWith(color: c.textMuted),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        NzMenuGroup(
          rows: [
            AdminUserAccountRoleRow(
              label: l.uiUsersAdmin,
              description: l.uiUsersAccountAdminDescription,
              dot: c.roleAdmin,
              selected: widget.companyAdmin,
              onTap: busy || widget.companyAdmin == null ? null : _adminRole,
            ),
            AdminUserAccountRoleRow(
              label: l.uiUsersCoordinator,
              description: l.uiUsersAccountCoordinatorDescription,
              dot: c.avatar1,
              selected: memberships.any(
                (m) => m.role == DepartmentRole.coordinator,
              ),
              onTap: busy
                  ? null
                  : () => _roleChoices(DepartmentRole.coordinator),
            ),
            AdminUserAccountRoleRow(
              label: l.uiUsersMember,
              description: l.uiUsersAccountMemberDescription,
              dot: c.roleMember,
              selected: memberships.any((m) => m.role == DepartmentRole.member),
              onTap: busy ? null : () => _roleChoices(DepartmentRole.member),
            ),
          ],
        ),
        const Gap(_sectionGap),
        Padding(
          padding: const EdgeInsets.only(left: NizamioSpacing.space1),
          child: Text(
            l.uiUsersAccountDepartmentHeading,
            style: context.text.kicker.copyWith(color: c.textMuted),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        Wrap(
          spacing: NizamioSpacing.space1 + NizamioSpacing.space1 / 2,
          runSpacing: NizamioSpacing.space1 + NizamioSpacing.space1 / 2,
          children: [
            for (final d in assigned)
              InputChip(
                label: Text(d.name),
                labelStyle: context.text.caption.copyWith(fontSize: 12.5),
                backgroundColor: c.surfaceRaised,
                side: BorderSide.none,
                deleteIcon: const NzIcon(NzIcons.close, size: 14),
                onPressed: busy ? null : () => _membershipChoices(d),
                onDeleted: busy ? null : () => _removeMembership(d, _owner),
              ),
            if (assigned.isEmpty)
              Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space2),
                child: Text(
                  l.uiUsersUnassigned,
                  style: context.text.caption.copyWith(color: c.textMuted),
                ),
              ),
            ActionChip(
              avatar: const NzIcon(NzIcons.add, size: NizamioSize.iconSizeSm),
              label: Text(l.uiUsersAccountAdd),
              labelStyle: context.text.caption.copyWith(fontSize: 12.5),
              backgroundColor: c.surface,
              side: BorderSide(color: c.borderControl),
              onPressed: busy || available.isEmpty
                  ? null
                  : () => setState(() => _addOpen = !_addOpen),
            ),
          ],
        ),
        NzReveal(
          open: _addOpen && available.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space2),
            child: NzMenuGroup(
              rows: [
                for (final d in available)
                  ListTile(
                    title: Text(d.name, style: context.text.bodyMd),
                    subtitle: Text(
                      l.uiUsersAccountAddAsMember,
                      style: context.text.caption,
                    ),
                    trailing: const NzIcon(
                      NzIcons.add,
                      size: NizamioSize.iconSizeSm,
                    ),
                    onTap: busy
                        ? null
                        : () {
                            setState(() => _addOpen = false);
                            _setMembership(d, DepartmentRole.member, _owner);
                          },
                  ),
              ],
            ),
          ),
        ),
        const Gap(_sectionGap),
        AdminUserAccountOperations(user: widget.user),
        if (_dirty) ...[
          const Gap(_sectionGap),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space3,
              vertical: NizamioSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioSpacing.space3),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.uiUsersAccountUnsaved,
                    style: context.text.caption.copyWith(color: c.textMuted),
                  ),
                ),
                NzButton.ghost(
                  label: l.uiUsersAccountCancel,
                  size: NzSize.sm,
                  onPressed: busy
                      ? null
                      : () => setState(() => _email.text = _baseline),
                ),
                const Gap(NizamioSpacing.space1),
                NzButton.primary(
                  label: l.uiUsersAccountSave,
                  size: NzSize.sm,
                  loading: _busy,
                  onPressed: busy || !_validEmail ? null : _saveEmail,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
