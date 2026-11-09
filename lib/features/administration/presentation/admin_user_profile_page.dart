import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/nz_icon_button.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../archive/archive.dart';
import '../../calendar/calendar.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_user_actions.dart';
import 'admin_user_memberships.dart';
import 'admin_user_related.dart';
import 'admin_user_task_summary.dart';
import 'admin_user_texts.dart';

class AdminUserProfilePage extends ConsumerStatefulWidget {
  const AdminUserProfilePage({super.key, required this.accountId, this.onBack});
  final String accountId;
  final VoidCallback? onBack;

  @override
  ConsumerState<AdminUserProfilePage> createState() =>
      _AdminUserProfilePageState();
}

class _AdminUserProfilePageState extends ConsumerState<AdminUserProfilePage> {
  static const _tabsWidth = 520.0;
  int _tab = 0;
  int _taskFilter = 0;
  final _clock = StaleClock();

  @override
  void didUpdateWidget(AdminUserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountId != widget.accountId) {
      _tab = 0;
      _taskFilter = 0;
    }
  }

  void _retry() {
    if (ref.read(taskCatalogControllerProvider).hasError) {
      ref.invalidate(taskCatalogControllerProvider);
    }
    ref.read(adminUsersProvider.notifier).invalidate();
    ref.invalidate(adminUserProfileProvider(widget.accountId));
  }

  Future<void> _refresh() async {
    final id = widget.accountId;
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    bool current() =>
        mounted &&
        id == widget.accountId &&
        scope == ref.read(scopeStateProvider) &&
        session == ref.read(sessionGenerationProvider);
    await ref.read(taskCatalogControllerProvider.notifier).refresh();
    if (!current()) return;
    await ref.read(adminUsersProvider.notifier).refresh();
    if (!current()) return;
    // The profile watches the list Future, so it resolves again from the fresh page or
    // continues the same unfiltered cursor chain for a direct-link account.
    await ref.read(adminUserProfileProvider(id).future);
    if (!current()) return;
    if (_tab == 1) {
      await ref.read(personFilesControllerProvider(id).notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = adminUserProfileProvider(widget.accountId);
    final value = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next.hasValue && !next.isLoading && !next.hasError) {
        _clock.markFresh();
      }
    });
    final catalog = ref.watch(taskCatalogControllerProvider);
    final allowed =
        catalog.value?.access?.companyAdmin == true &&
        !catalog.isReloading &&
        !catalog.hasError;
    final AsyncValue<KnownUser?> displayed = !allowed
        ? catalog.isLoading
              ? const AsyncLoading()
              : AsyncError(
                  catalog.error ?? ApiError('organization.not_authorized'),
                  catalog.stackTrace ?? StackTrace.current,
                )
        : value.hasError
        ? AsyncError(value.error!, value.stackTrace ?? StackTrace.current)
        : value;
    final user = allowed && !value.isReloading && !value.hasError
        ? value.value
        : null;
    final tasks =
        catalog.value?.tasks
            .where((t) => t.assignees.contains(widget.accountId))
            .toList() ??
        <TaskItem>[];
    final shown =
        tasks
            .where(
              (t) => switch (_taskFilter) {
                1 => !t.isDone,
                2 => !t.isDone && t.isOverdue,
                3 => t.status == TaskStatus.review,
                4 => t.isDone,
                _ => true,
              },
            )
            .toList()
          ..sort((a, b) => a.due.compareTo(b.due));
    return NzPage.feed(
      topBar: NzTopBar.detail(
        title: user?.fullName ?? l.uiUsersProfile,
        onBack: widget.onBack,
      ),
      onRefresh: _refresh,
      onRevisit: () => unawaited(_clock.refreshIfStale(value, _refresh)),
      onRetry: _retry,
      pinned: user == null
          ? null
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _tabsWidth,
                child: NzPillTabs(
                  tabs: [
                    NzPillTab(label: l.uiUsersTasks),
                    NzPillTab(label: l.uiUsersFiles),
                    NzPillTab(label: l.uiUsersCalendar),
                    NzPillTab(label: l.uiUsersHistory),
                    NzPillTab(label: l.uiUsersAccount),
                  ],
                  selected: _tab,
                  onSelected: (i) => setState(() => _tab = i),
                ),
              ),
            ),
      afterKey: ValueKey((widget.accountId, _tab)),
      after: user == null
          ? const []
          : [
              const Gap(NizamioSpacing.gapMd),
              if (_tab == 0) ...[
                AdminUserTaskSummary(
                  tasks: tasks,
                  truncated: catalog.value?.truncated == true,
                  onFilter: (filter) => setState(() => _taskFilter = filter),
                ),
                Wrap(
                  spacing: NizamioSpacing.space2,
                  children: [
                    for (final entry in [
                      l.uiUsersAll,
                      l.uiUsersOpen,
                      l.uiUsersLate,
                      l.uiUsersReview,
                      l.uiUsersDone,
                    ].asMap().entries)
                      ChoiceChip(
                        label: Text(entry.value),
                        selected: entry.key == _taskFilter,
                        onSelected: (_) =>
                            setState(() => _taskFilter = entry.key),
                      ),
                  ],
                ),
                if (catalog.value?.truncated == true) Text(l.uiUsersPartial),
                if (shown.isEmpty) Text(l.uiUsersNoTasks),
                for (final task in shown)
                  Padding(
                    key: ValueKey(task.id),
                    padding: const EdgeInsets.only(top: NizamioSpacing.gapMd),
                    child: Builder(
                      builder: (context) => TaskCardView(
                        task: task,
                        catalog: catalog.requireValue,
                        onTap: () => context.appNav.openTask(task.code),
                      ),
                    ),
                  ),
              ],
              if (_tab == 1) PersonFiles(accountId: widget.accountId),
              if (_tab == 2) PersonTaskCalendar(accountId: widget.accountId),
              if (_tab == 3)
                NzCard.outlined(child: Text(l.uiUsersHistoryUnavailable)),
              if (_tab == 4) ...[
                NzCard.outlined(child: Text(l.uiUsersAccountUnavailable)),
                const Gap(NizamioSpacing.gapMd),
                AdminUserMemberships(user: user),
                const Gap(NizamioSpacing.gapMd),
                AbsorbPointer(
                  absorbing: ref.watch(adminCommandProvider),
                  child: AdminUserActions(user: user),
                ),
              ],
            ],
      children: [
        if (user == null)
          NzAsyncView(
            value: displayed,
            skeletonOnReload: true,
            onRetry: _retry,
            data: (_) => Text(l.uiUsersNotFound),
          ),
        if (user != null) ...[
          NzCard.outlined(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NzAvatar.initials(
                      name: user.fullName,
                      tone: NzAvatar.toneOf(user.fullName),
                      extent: NzAvatarSize.xl,
                    ),
                    const Gap(NizamioSpacing.gapMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.fullName, style: context.text.titleMd),
                          const Gap(NizamioSpacing.space1),
                          Text(
                            adminMembershipSummary(
                              context,
                              user,
                              catalog.value,
                              programId: ref
                                  .watch(currentProgramControllerProvider)
                                  .value
                                  ?.id,
                            ),
                            style: context.text.caption,
                          ),
                        ],
                      ),
                    ),
                    NzIconButton(
                      icon: NzIcons.edit,
                      semanticLabel: l.uiUsersAccount,
                      onPressed: () => setState(() => _tab = 4),
                    ),
                  ],
                ),
                const Gap(NizamioSpacing.gapMd),
                AdminUserRelatedActions(accountId: widget.accountId),
              ],
            ),
          ),
          const Gap(NizamioSpacing.gapMd),
        ],
      ],
    );
  }
}
