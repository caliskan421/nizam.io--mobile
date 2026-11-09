import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/nz_icon_button.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_page_header.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_management_tools.dart';
import 'admin_user_actions.dart';
import 'admin_user_memberships.dart';
import 'admin_user_profile_page.dart';
import 'admin_user_texts.dart';
import 'admin_users_export.dart';
import 'admin_users_filter.dart';

/// The shell owns list → account navigation. Standalone uses the same public detail.
class AdministrationPage extends ConsumerStatefulWidget {
  const AdministrationPage({super.key, this.onUserSelected});
  final ValueChanged<String>? onUserSelected;

  @override
  ConsumerState<AdministrationPage> createState() => _AdministrationPageState();
}

class _AdministrationPageState extends ConsumerState<AdministrationPage> {
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
    ref.invalidate(adminUsersProvider);
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    ref.watch(adminUsersProvider);
    final ctl = ref.read(adminUsersProvider.notifier);
    final value = ctl.visible;
    final query = ref.watch(adminUserQueryProvider);
    final catalogState = ref.watch(taskCatalogControllerProvider);
    final catalog = catalogState.value;
    final allowed =
        catalog?.access?.companyAdmin == true &&
        !catalogState.isReloading &&
        !catalogState.hasError;
    final busy = ref.watch(adminCommandProvider);
    final programId = ref.watch(currentProgramControllerProvider).value?.id;
    final departments = ref.watch(adminUserDepartmentsProvider);
    final ownerScope = ref.watch(scopeStateProvider);
    final ownerSession = ref.watch(sessionGenerationProvider);
    final shown =
        value.value?.items
            .where(
              (u) =>
                  departments.isEmpty ||
                  u.teams.any(
                    (m) =>
                        m.programId == programId &&
                        departments.contains(m.departmentId),
                  ),
            )
            .toList() ??
        <KnownUser>[];
    final roles = <DepartmentRole?>[
      null,
      DepartmentRole.coordinator,
      DepartmentRole.member,
    ];
    void update(AdminUserQuery q) =>
        ref.read(adminUserQueryProvider.notifier).set(q);
    return NzPage.feed(
      topBar: const RootTopBar(),
      onRefresh: ctl.refresh,
      onRevisit: () => unawaited(ctl.refreshIfStale()),
      onRetry: _retry,
      children: [
        NzPageHeader(
          title: l.uiUsersTitle,
          actions: [
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
            NzIconButton.circle(
              icon: NzIcons.filter,
              semanticLabel: l.uiUsersFilters,
              onPressed: () => showAdminUsersFilter(context),
            ),
            NzIconButton.circleAccent(
              icon: NzIcons.add,
              semanticLabel: l.uiUsersAdd,
              onPressed: allowed && !busy
                  ? () => showAdminCreateUser(context, ref)
                  : null,
            ),
          ],
        ),
        const Gap(NizamioSpacing.gapMd),
        NzSearchField(
          controller: _search,
          label: l.uiUsersSearch,
          onChanged: (text) {
            _searchDelay?.cancel();
            _searchDelay = Timer(const Duration(milliseconds: 300), () {
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
        const Gap(NizamioSpacing.gapMd),
        NzPillTabs(
          tabs: [
            NzPillTab(label: l.uiUsersAll),
            NzPillTab(label: l.uiUsersCoordinators),
            NzPillTab(label: l.uiUsersMembers),
          ],
          selected: roles.indexOf(query.role),
          onSelected: (i) => update((
            search: query.search,
            role: roles[i],
            sort: query.sort,
            direction: query.direction,
          )),
        ),
        if (!value.hasValue)
          NzAsyncView(
            value: value,
            onRetry: _retry,
            data: (_) => const SizedBox.shrink(),
          ),
        if (value.value case final page?) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.gapMd),
            child: Text(
              '${page.items.length} ${l.uiUsersLoadedCountTail}${page.nextCursor == null ? '' : ' · ${l.uiUsersMoreAvailable}'}',
              style: context.text.caption,
            ),
          ),
          if (departments.isNotEmpty) ...[
            Wrap(
              children: [
                for (final d
                    in catalog?.coordinatorships ??
                        const <CoordinatorshipRef>[])
                  if (departments.contains(d.code))
                    InputChip(
                      label: Text(d.name),
                      onDeleted: () => ref
                          .read(adminUserDepartmentsProvider.notifier)
                          .toggle(d.code),
                    ),
              ],
            ),
            Text(l.uiUsersLoadedFilterNote, style: context.text.caption),
          ],
          if (shown.isEmpty) Text(l.uiUsersEmpty),
          for (final user in shown)
            Padding(
              key: ValueKey(user.accountId),
              padding: const EdgeInsets.only(bottom: NizamioSpacing.gapMd),
              child: Builder(
                builder: (context) => NzCard.outlined(
                  onTap: () => _open(user.accountId),
                  child: Row(
                    children: [
                      NzAvatar.initials(
                        name: user.fullName,
                        tone: NzAvatar.toneOf(user.fullName),
                        extent: NzAvatarSize.lg,
                      ),
                      const Gap(NizamioSpacing.gapMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullName, style: context.text.labelLg),
                            const Gap(NizamioSpacing.space1),
                            Text(
                              adminMembershipSummary(
                                context,
                                user,
                                catalog,
                                programId: programId,
                              ),
                              style: context.text.caption,
                            ),
                          ],
                        ),
                      ),
                      const Gap(NizamioSpacing.space2),
                      NzIconButton(
                        icon: NzIcons.more,
                        semanticLabel: l.uiUsersQuickActions,
                        onPressed: busy
                            ? null
                            : () => NzBottomSheet.show<void>(
                                context,
                                title: user.fullName,
                                builder: (sheet) => Consumer(
                                  builder: (context, ref, _) =>
                                      ownerScope !=
                                              ref.watch(scopeStateProvider) ||
                                          ownerSession !=
                                              ref.watch(
                                                sessionGenerationProvider,
                                              ) ||
                                          ref
                                                  .watch(
                                                    taskCatalogControllerProvider,
                                                  )
                                                  .value
                                                  ?.access
                                                  ?.companyAdmin !=
                                              true
                                      ? const SizedBox.shrink()
                                      : AbsorbPointer(
                                          absorbing: ref.watch(
                                            adminCommandProvider,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(sheet).pop();
                                                  _open(user.accountId);
                                                },
                                                child: Text(
                                                  l.uiUsersOpenProfile,
                                                ),
                                              ),
                                              AdminUserActions(user: user),
                                              AdminUserMemberships(user: user),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (page.truncated) Text(l.uiUsersPartial),
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
