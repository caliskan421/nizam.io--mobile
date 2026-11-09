import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/nz_icon_button.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/admin_user_directory.dart';
import '../domain/organization_admin.dart';
import 'admin_management_tools.dart';
import 'admin_user_actions.dart';
import 'admin_user_identity.dart';
import 'admin_user_list_row.dart';
import 'admin_user_memberships.dart';
import 'admin_user_profile_page.dart';
import 'admin_users_export.dart';
import 'admin_users_filter.dart';

class AdministrationPage extends ConsumerStatefulWidget {
  const AdministrationPage({super.key, this.onUserSelected});
  final ValueChanged<String>? onUserSelected;

  @override
  ConsumerState<AdministrationPage> createState() => _AdministrationPageState();
}

class _AdministrationPageState extends ConsumerState<AdministrationPage> {
  static const _searchDelayDuration = Duration(milliseconds: 300);
  static const _betweenControls = 14.0;
  Timer? _searchDelay;
  final _search = TextEditingController();

  @override
  void dispose() {
    _searchDelay?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _retry() {
    if (ref.read(taskCatalogControllerProvider).hasError) {
      ref.invalidate(taskCatalogControllerProvider);
    }
    ref.read(adminUsersProvider.notifier).invalidate();
  }

  void _open(String id) {
    if (widget.onUserSelected case final open?) {
      open(id);
    } else {
      Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (_) => AdminUserProfilePage(accountId: id)),
      );
    }
  }

  void _quick(KnownUser user) {
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    NzBottomSheet.show<void>(
      context,
      title: user.fullName,
      builder: (sheet) => Consumer(
        builder: (context, ref, _) {
          if (scope != ref.watch(scopeStateProvider) ||
              session != ref.watch(sessionGenerationProvider) ||
              ref
                      .watch(taskCatalogControllerProvider)
                      .value
                      ?.access
                      ?.companyAdmin !=
                  true) {
            return const SizedBox.shrink();
          }
          return AbsorbPointer(
            absorbing: ref.watch(adminCommandProvider),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(sheet).pop();
                    _open(user.accountId);
                  },
                  child: Text(context.l10n.uiUsersOpenProfile),
                ),
                AdminUserActions(user: user),
                AdminUserMemberships(user: user),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    ref.watch(adminUsersProvider);
    final ctl = ref.read(adminUsersProvider.notifier);
    final rawValue = ctl.visible;
    final value = rawValue.hasError && !rawValue.isLoading
        ? AsyncError<PageSlice<KnownUser>>(
            rawValue.error!,
            rawValue.stackTrace ?? StackTrace.current,
          )
        : rawValue;
    final query = ref.watch(adminUserQueryProvider);
    final summary = ref.watch(adminUsersSummaryProvider);
    final page = value.value;
    final shown = value.hasError
        ? const <KnownUser>[]
        : summary?.shown ?? const <KnownUser>[];
    final catalogState = ref.watch(taskCatalogControllerProvider);
    final catalog = catalogState.value;
    final allowed =
        catalog?.access?.companyAdmin == true &&
        !catalogState.isReloading &&
        !catalogState.hasError;
    final busy = ref.watch(adminCommandProvider);
    final programId = ref.watch(scopeStateProvider).programId;
    final departments = ref.watch(adminUserDepartmentsProvider);
    final roles = AdminUserRoleFilter.values;
    final roleLabels = [
      l.uiUsersAll,
      l.uiUsersAdmin,
      l.uiUsersCoordinator,
      l.uiUsersMember,
    ];
    ref.listen(sessionGenerationProvider, (_, _) {
      _searchDelay?.cancel();
      _search.clear();
    });
    void update(AdminUserQuery q) =>
        ref.read(adminUserQueryProvider.notifier).set(q);

    return NzPage.feed(
      topBar: const RootTopBar(referenceHeader: true),
      onRefresh: ctl.refresh,
      onRevisit: () => unawaited(ctl.refreshIfStale()),
      onRetry: _retry,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(l.uiUsersTitle, style: context.text.titleLg),
                  ),
                  const Gap(NizamioSpacing.space1 / 2),
                  Text(
                    '${summary?.total.label ?? '—'} ${l.uiUsersCountTail}',
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(NizamioSpacing.space1),
            NzIconButton.circle(
              icon: NzIcons.download,
              semanticLabel: l.uiUsersExportLoaded,
              onPressed: allowed && shown.isNotEmpty
                  ? () => exportAdminUsers(
                      context,
                      ref,
                      shown,
                      catalog,
                      programId,
                    )
                  : null,
            ),
            const Gap(NizamioSpacing.space1),
            NzIconButton.circleAccent(
              icon: NzIcons.add,
              semanticLabel: l.uiUsersAdd,
              onPressed: allowed && !busy
                  ? () => showAdminCreateUser(context, ref)
                  : null,
            ),
          ],
        ),
        const Gap(NizamioSpacing.gapLg),
        Row(
          children: [
            Expanded(
              child: NzSearchField(
                controller: _search,
                label: l.uiUsersSearch,
                hint: l.uiUsersSearchHint,
                onChanged: (text) {
                  _searchDelay?.cancel();
                  _searchDelay = Timer(_searchDelayDuration, () {
                    if (!mounted) return;
                    final now = ref.read(adminUserQueryProvider);
                    update((
                      search: text.trim(),
                      role: now.role,
                      sort: now.sort,
                      direction: now.direction,
                    ));
                  });
                },
              ),
            ),
            const Gap(NizamioSpacing.space2),
            NzIconButton.circle(
              icon: NzIcons.filter,
              semanticLabel: l.uiUsersFilters,
              dot: departments.isEmpty ? null : context.colors.accentText,
              onPressed: () => showAdminUsersFilter(context),
            ),
          ],
        ),
        if (departments.isNotEmpty) ...[
          const Gap(NizamioSpacing.space2),
          Wrap(
            spacing: NizamioSpacing.space1,
            children: [
              for (final d
                  in catalog?.coordinatorships ?? const <CoordinatorshipRef>[])
                if (departments.contains(d.code))
                  InputChip(
                    label: Text(d.name),
                    onDeleted: () => ref
                        .read(adminUserDepartmentsProvider.notifier)
                        .toggle(d.code),
                  ),
            ],
          ),
        ],
        const Gap(_betweenControls),
        LayoutBuilder(
          builder: (context, constraints) {
            final tabs = NzPillTabs(
              compact: true,
              tabs: [
                for (final entry in roles.asMap().entries)
                  NzPillTab(
                    label: roleLabels[entry.key],
                    countText: summary?.countFor(entry.value)?.label ?? '—',
                    enabled:
                        entry.value != AdminUserRoleFilter.admin ||
                        summary?.admins != null,
                  ),
              ],
              selected: roles.indexOf(query.role),
              onSelected: (i) => update((
                search: query.search,
                role: roles[i],
                sort: query.sort,
                direction: query.direction,
              )),
            );
            final scale = MediaQuery.textScalerOf(context).scale(1);
            if (scale <= 1.3) return tabs;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: constraints.maxWidth * scale, child: tabs),
            );
          },
        ),
        const Gap(_betweenControls),
        if (!value.hasValue || value.hasError)
          NzAsyncView(
            value: value,
            onRetry: _retry,
            data: (_) => const SizedBox.shrink(),
          ),
        if (!value.hasError && page != null) ...[
          // The list error branch above never reuses rows from a previous result.
          Padding(
            padding: const EdgeInsets.only(left: NizamioSpacing.space1),
            child: Text(
              '${summary?.matched?.label ?? '—'} ${l.uiUsersNavCountTail}',
              style: context.text.kicker.copyWith(
                color: context.colors.textFaint,
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: NizamioSpacing.gapLg,
              ),
              child: Text(
                page.nextCursor == null
                    ? l.uiUsersEmpty
                    : l.uiUsersNoLoadedMatch,
                style: context.text.caption,
              ),
            ),
          for (final entry in shown.asMap().entries)
            Builder(
              key: ValueKey(entry.value.accountId),
              builder: (context) {
                final user = entry.value;
                final admin =
                    summary?.adminAccountIds?.contains(user.accountId) == true;
                final identity = AdminUserIdentity(user, companyAdmin: admin);
                final roleNames = identity.roles(context);
                final departmentNames = identity.departmentNames(
                  catalog,
                  programId,
                );
                return AdminUserListRow(
                  name: user.fullName,
                  roles: roleNames.isEmpty
                      ? l.uiUsersUnassigned
                      : roleNames.join(', '),
                  departments: departmentNames.join(', '),
                  avatarColor: identity.fill(context),
                  avatarForeground: identity.ink(context),
                  first: entry.key == 0,
                  last: entry.key == shown.length - 1,
                  onOpen: () => _open(user.accountId),
                  onQuick: () {
                    if (!busy) _quick(user);
                  },
                );
              },
            ),
          if (page.nextCursor != null)
            TextButton(
              onPressed: () async {
                try {
                  await ctl.loadMore();
                } on Object catch (e) {
                  if (context.mounted) NzToast.error(context, toApiError(e));
                }
              },
              child: Text(l.uiUsersMore),
            ),
          if (summary?.total.exact == false || page.truncated)
            Text(l.uiUsersDirectoryPartial, style: context.text.caption),
        ],
        const Gap(NizamioSpacing.space4),
        if (allowed)
          ExpansionTile(
            title: Text(l.uiUsersManagement),
            children: [
              AbsorbPointer(
                absorbing: busy,
                child: const AdminManagementTools(),
              ),
            ],
          ),
      ],
    );
  }
}
