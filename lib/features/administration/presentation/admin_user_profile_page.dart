import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/nz_icon_button.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../archive/archive.dart';
import '../../messages/messages.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../application/admin_user_task_panel_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_user_account_panel.dart';
import 'admin_user_collapsed_title.dart';
import 'admin_user_hero.dart';
import 'admin_user_identity.dart';
import 'admin_user_profile_menu.dart';
import 'admin_user_related.dart';
import 'admin_user_tasks_panel.dart';

class AdminUserProfilePage extends ConsumerStatefulWidget {
  const AdminUserProfilePage({super.key, required this.accountId, this.onBack});
  final String accountId;
  final VoidCallback? onBack;
  @override
  ConsumerState<AdminUserProfilePage> createState() =>
      _AdminUserProfilePageState();
}

class _AdminUserProfilePageState extends ConsumerState<AdminUserProfilePage> {
  static const _sectionGap = 18.0;
  static const _largeTextThreshold = 1.3;
  final _headingKey = GlobalKey(debugLabel: 'user-profile-heading');
  final _barKey = GlobalKey(debugLabel: 'user-profile-bar-title-box');
  final _collapse = ValueNotifier<double>(0);
  final _clock = StaleClock();
  bool _geometryScheduled = false;
  int _tab = 0;
  double _scrollPixels = 0;
  double? _headingTopAtZero;
  double? _headingHeight;

  @override
  void dispose() {
    _collapse.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AdminUserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountId != widget.accountId) {
      _tab = 0;
      _collapse.value = 0;
      _headingTopAtZero = null;
      _headingHeight = null;
      _scrollPixels = 0;
    }
    _scheduleGeometry();
  }

  void _scheduleGeometry() {
    if (_geometryScheduled || !mounted) return;
    _geometryScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geometryScheduled = false;
      if (!mounted) return;
      final heading = _headingKey.currentContext?.findRenderObject();
      final bar = _barKey.currentContext?.findRenderObject();
      var progress = _collapse.value;
      if (bar is RenderBox && bar.attached && bar.hasSize) {
        final barBottom = bar.localToGlobal(Offset(0, bar.size.height)).dy;
        if (heading is RenderBox && heading.attached && heading.hasSize) {
          _headingTopAtZero =
              heading.localToGlobal(Offset.zero).dy + _scrollPixels;
          _headingHeight = heading.size.height
              .clamp(1.0, double.infinity)
              .toDouble();
        }
        // A lazy sliver may detach the hero far above the viewport. Its last actual
        // geometry plus primary scroll pixels keeps the identity visible until return.
        if (_headingTopAtZero != null && _headingHeight != null) {
          final heroTop = _headingTopAtZero! - _scrollPixels;
          progress = (((barBottom - heroTop) / _headingHeight! - 0.75) / 0.55)
              .clamp(0.0, 1.0)
              .toDouble();
        }
      }
      if ((progress - _collapse.value).abs() > 0.001) {
        _collapse.value = progress;
      }
    });
  }

  void _selectTab(int tab) {
    if (_tab == tab) return;
    setState(() => _tab = tab);
    _scheduleGeometry();
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
    await ref.read(adminUserProfileProvider(id).future);
    if (!current()) return;
    if (_tab == 1) {
      await ref.read(personFilesControllerProvider(id).notifier).refresh();
    }
    _scheduleGeometry();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = adminUserProfileProvider(widget.accountId);
    ref.watch(adminUserTaskPanelProvider(widget.accountId));
    final value = ref.watch(profile);
    ref.listen(profile, (_, next) {
      if (next.hasValue && !next.isLoading && !next.hasError) {
        _clock.markFresh();
      }
      _scheduleGeometry();
    });
    final catalogState = ref.watch(taskCatalogControllerProvider);
    final catalog = catalogState.value;
    final scope = ref.watch(scopeStateProvider);
    final allowed =
        catalog?.access?.companyAdmin == true &&
        !catalogState.isReloading &&
        !catalogState.hasError;
    final AsyncValue<KnownUser?> displayed = !allowed
        ? catalogState.isLoading
              ? const AsyncLoading()
              : AsyncError(
                  catalogState.error ?? ApiError('organization.not_authorized'),
                  catalogState.stackTrace ?? StackTrace.current,
                )
        : value.hasError
        ? AsyncError(value.error!, value.stackTrace ?? StackTrace.current)
        : value;
    final user = allowed && !value.isReloading && !value.hasError
        ? value.value
        : null;
    if (user == null) {
      _headingTopAtZero = null;
      _headingHeight = null;
      if (_collapse.value != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _collapse.value = 0;
        });
      }
    }
    final adminIndex = user == null
        ? null
        : ref.watch(companyAdminIndexProvider);
    final isAdmin =
        adminIndex != null &&
        !adminIndex.isLoading &&
        !adminIndex.hasError &&
        adminIndex.value?.accountIds.contains(widget.accountId) == true;
    final identity = user == null
        ? null
        : AdminUserIdentity(user, companyAdmin: isAdmin);
    final tasks =
        catalog?.tasks
            .where((t) => t.assignees.contains(widget.accountId))
            .toList() ??
        const <TaskItem>[];
    final taskCount = '${tasks.length}${catalog?.truncated == true ? '+' : ''}';
    // The tab count and the files panel share one first-page read for this person.
    final filesProvider = personFilesControllerProvider(widget.accountId);
    String filesCount = '—';
    if (user != null) {
      ref.watch(filesProvider);
      final files = ref.read(filesProvider.notifier).visible;
      if (files.hasValue && !files.hasError) {
        final slice = files.requireValue.files;
        filesCount =
            '${slice.items.length}${slice.hasMore || slice.truncated ? '+' : ''}';
      }
    }
    _scheduleGeometry();

    final page = NzPage.feed(
      topBar: NzTopBar.detail(
        onBack: widget.onBack,
        titleContent: user == null
            ? SizedBox.expand(key: _barKey)
            : AdminUserCollapsedTitle(
                name: user.fullName,
                fill: identity!.fill(context),
                ink: identity.ink(context),
                progress: _collapse,
                geometryKey: _barKey,
              ),
        actions: [
          NzIconButton(
            icon: NzIcons.edit,
            semanticLabel: l.uiUsersEditAccount,
            onPressed: user == null ? null : () => _selectTab(3),
          ),
          NzIconButton(
            icon: NzIcons.moreHorizontal,
            semanticLabel: l.uiUsersMoreActions,
            onPressed: user == null
                ? null
                : () => showAdminUserProfileMenu(
                    context,
                    ref,
                    user: user,
                    catalog: catalog!,
                    onAccount: () => _selectTab(3),
                  ),
          ),
        ],
      ),
      onRefresh: _refresh,
      onRevisit: () => unawaited(_clock.refreshIfStale(value, _refresh)),
      onRetry: _retry,
      afterKey: ValueKey((widget.accountId, _tab)),
      after: user == null
          ? const []
          : [
              const Gap(_sectionGap - NizamioSpacing.space1),
              if (_tab == 0)
                ...adminUserTaskPanelChildren(
                  context,
                  ref,
                  accountId: widget.accountId,
                  catalog: catalog!,
                ),
              if (_tab == 1) PersonFiles(accountId: widget.accountId),
              if (_tab == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: NizamioSpacing.space4,
                  ),
                  child: Text(
                    l.uiUsersHistoryUnavailable,
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
              if (_tab == 3)
                AdminUserAccountPanel(
                  key: ValueKey(user.accountId),
                  user: user,
                  catalog: catalog!,
                  email: user.accountId == catalog.me
                      ? catalog.accountEmail
                      : null,
                  companyAdmin: isAdmin
                      ? true
                      : adminIndex != null &&
                            !adminIndex.isLoading &&
                            !adminIndex.hasError &&
                            adminIndex.value?.complete == true
                      ? false
                      : null,
                ),
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
          AdminUserHero(
            identity: identity!,
            catalog: catalog!,
            programId: scope.programId,
            nameKey: _headingKey,
            email: user.accountId == catalog.me ? catalog.accountEmail : null,
          ),
          const Gap(_sectionGap - NizamioSpacing.space1),
          AdminUserRelatedActions(accountId: widget.accountId),
          const Gap(_sectionGap - NizamioSpacing.space1),
          LayoutBuilder(
            builder: (context, constraints) {
              final tabs = NzPillTabs(
                compact: true,
                semanticLabel: l.uiUsersProfile,
                tabs: [
                  NzPillTab(label: l.uiUsersTasks, countText: taskCount),
                  NzPillTab(label: l.uiUsersFiles, countText: filesCount),
                  NzPillTab(label: l.uiUsersHistory, countText: '—'),
                  NzPillTab(label: l.uiUsersAccount),
                ],
                selected: _tab,
                onSelected: _selectTab,
              );
              final scale = MediaQuery.textScalerOf(context).scale(1);
              if (scale <= _largeTextThreshold) return tabs;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth * scale,
                  child: tabs,
                ),
              );
            },
          ),
        ],
      ],
    );
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification.depth == 0) {
          _scrollPixels = notification.metrics.pixels;
          _scheduleGeometry();
        }
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical &&
              notification.depth == 0) {
            _scrollPixels = notification.metrics.pixels;
            _scheduleGeometry();
          }
          return false;
        },
        child: page,
      ),
    );
  }
}
