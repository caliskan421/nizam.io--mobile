import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/task_catalog_controller.dart';
import '../application/task_detail_controller.dart';
import '../domain/task_catalog.dart';
import 'detail/detail_actions.dart';
import 'detail/detail_tabs.dart';
import 'task_texts.dart';

/// Görev ayrıntısı (prototip `detail`): üst çubukta kod + düzenle/diğer işlemler;
/// koordinatörlük, başlık, durum ve öncelik seçicileri, tarih talebi/hatırlat daireleri ve
/// "Kanıt yükle"; bekleyen tarih değişikliği talebi kartı (Reddet/Onayla); Özet / Alt görev /
/// Dosya / Not sekmeleri. Silinen görevde "silinen kayıtlara taşındı" + Geri al. Alt menüde
/// "Görevler"e yeniden dokunmak bu görevin kısayol menüsünü açar.
class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final nav = context.appNav;
    final provider = taskDetailControllerProvider(code);
    final actions = TaskDetailActions(context, ref, code);
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != 1 || !visible) return;
      final task = ref.read(taskCatalogControllerProvider).value?.task(code);
      NzFlyoutMenu.show(
        context,
        semanticLabel: '$code · ${l.uiTasksFlyThisTask}',
        entries: [
          NzFlyoutSection('$code · ${l.uiTasksFlyThisTask}'),
          if (task != null) ...[
            NzFlyoutItem(
              label: l.uiTasksFlyStatus,
              caption: l.statusLabel(task.status),
              icon: Icons.check_circle_outline_rounded,
              onSelected: actions.openStatus,
            ),
            NzFlyoutItem(
              label: l.uiTasksRemind,
              icon: Icons.notifications_none_rounded,
              onSelected: actions.remind,
            ),
            NzFlyoutItem(
              label: l.uiTasksEditTask,
              icon: Icons.edit_outlined,
              onSelected: actions.openEdit,
            ),
            NzFlyoutSection(l.uiTasksFlyGo),
            NzFlyoutItem(
              label: l.uiTasksFlyTimeline,
              icon: Icons.view_timeline_outlined,
              onSelected: () =>
                  nav.openTimeline(coordinatorship: task.coordinatorship),
            ),
          ],
          NzFlyoutItem(
            label: l.uiTasksTaskList,
            icon: Icons.view_list_rounded,
            onSelected: nav.openTasks,
          ),
        ],
      );
    });
    final catalog = ref.watch(taskCatalogControllerProvider);
    final state = ref.watch(provider);
    final task = catalog.value?.task(code);
    return NzPage.feed(
      onRetry: () => ref.invalidate(taskCatalogControllerProvider),
      topBar: NzTopBar.detail(
        code: code,
        actions: task == null
            ? const []
            : [
                NzIconButton(
                  icon: Icons.edit_outlined,
                  semanticLabel: l.uiTasksEditTask,
                  onPressed: actions.openEdit,
                ),
                NzIconButton(
                  icon: Icons.more_vert_rounded,
                  semanticLabel: l.uiTasksMoreActions,
                  onPressed: actions.openMenu,
                ),
              ],
      ),
      children: [
        NzAsyncView<TaskCatalog>(
          value: catalog,
          onRetry: () => ref.invalidate(taskCatalogControllerProvider),
          data: (c) {
            final t = c.task(code);
            if (t == null) {
              if (state.deleted != null) {
                return NzEmptyState(
                  icon: Icons.delete_outline_rounded,
                  title: '$code ${l.uiTasksDeletedTail}',
                  message: l.uiTasksDeletedFilesKept,
                  actionLabel: l.uiTasksUndo,
                  onAction: actions.undoDelete,
                );
              }
              return NzEmptyState(title: l.uiTasksNotFound);
            }
            return _Body(task: t, catalog: c, state: state, actions: actions);
          },
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.task,
    required this.catalog,
    required this.state,
    required this.actions,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final TaskDetailState state;
  final TaskDetailActions actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final ctl = ref.read(taskDetailControllerProvider(task.code).notifier);
    final req = task.dateRequest;
    final tabs = TaskDetailTab.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(
          catalog.coordinatorship(task.coordinatorship)?.name ??
              task.coordinatorship,
        ),
        const Gap(NizamioSpacing.space1),
        Semantics(header: true, child: Text(task.title, style: t.titleMd)),
        const Gap(NizamioSpacing.space4),
        Row(
          spacing: NizamioSpacing.space2,
          children: [
            Expanded(
              child: _Picker(
                label: l.statusLabel(task.status),
                semanticLabel:
                    '${l.uiTasksFlyStatus}: ${l.statusLabel(task.status)}',
                leading: NzDot(color: statusTone(task.status).color(c)),
                onTap: actions.openStatus,
              ),
            ),
            Expanded(
              child: _Picker(
                label: l.priorityLabel(task.priority),
                semanticLabel:
                    '${l.uiTasksPriority}: ${l.priorityLabel(task.priority)}',
                leading: NzPriorityBars(level: priorityLevel(task.priority)),
                onTap: actions.openPriority,
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        Row(
          children: [
            NzIconButton.circle(
              icon: Icons.event_outlined,
              semanticLabel: l.uiTasksRequestDate,
              onPressed: actions.openDateRequest,
            ),
            const Gap(NizamioSpacing.space2),
            NzIconButton.circle(
              icon: Icons.notifications_none_rounded,
              semanticLabel: l.uiTasksRemind,
              onPressed: actions.remind,
            ),
            const Gap(NizamioSpacing.space2),
            Expanded(
              child: NzButton.primary(
                label: l.uiTasksUpload,
                icon: Icons.upload_file_rounded,
                expand: true,
                onPressed: actions.openUpload,
              ),
            ),
          ],
        ),
        if (req != null && req.isPending) ...[
          const Gap(NizamioSpacing.space5),
          _RequestCard(
            request: req,
            by: catalog.person(req.by)?.name ?? req.by,
            onReject: actions.rejectRequest,
            onApprove: actions.approveRequest,
          ),
        ],
        const Gap(NizamioSpacing.space5),
        NzPillTabs(
          semanticLabel: l.uiTasksDetailTabs,
          selected: state.tab.index,
          onSelected: (i) => ctl.selectTab(tabs[i]),
          tabs: [
            NzPillTab(label: l.uiTasksTabSummary),
            NzPillTab(label: l.uiTasksTabSubtasks, count: task.subtasks.length),
            NzPillTab(label: l.uiTasksTabFiles, count: task.fileEntries.length),
            NzPillTab(label: l.uiTasksTabNotes, count: task.noteEntries.length),
          ],
        ),
        const Gap(NizamioSpacing.space5),
        switch (state.tab) {
          TaskDetailTab.summary => DetailSummary(task: task, catalog: catalog),
          TaskDetailTab.subtasks => DetailSubtasks(
            task: task,
            catalog: catalog,
            state: state,
            actions: actions,
          ),
          TaskDetailTab.files => DetailFiles(task: task, catalog: catalog),
          TaskDetailTab.notes => DetailNotes(
            task: task,
            catalog: catalog,
            draft: state.noteDraft,
            actions: actions,
          ),
        },
      ],
    );
  }
}

/// Durum/öncelik açılır seçici düğmesi (prototip 44 yükseklik hap).
class _Picker extends StatelessWidget {
  const _Picker({
    required this.label,
    required this.semanticLabel,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final String semanticLabel;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.controlMd),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
              border: Border.all(
                color: c.borderControl,
                width: NizamioSize.borderWidth,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.rowPad,
                vertical: NizamioSpacing.space2,
              ),
              child: Row(
                children: [
                  leading,
                  const Gap(NizamioSpacing.space2),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMd.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bekleyen tarih değişikliği talebi kartı (prototip `.rp-reqcard`).
class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.by,
    required this.onReject,
    required this.onApprove,
  });

  final DateChangeRequest request;
  final String by;
  final VoidCallback onReject;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final r = request;
    final plus = DateTime.utc(r.due.year, r.due.month, r.due.day)
        .difference(DateTime.utc(r.oldDue.year, r.oldDue.month, r.oldDue.day))
        .inDays;
    return Semantics(
      container: true,
      label: l.uiTasksRequestTitle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(NizamioRadius.card),
          border: Border.all(
            color: c.warning.withValues(alpha: 0.4),
            width: NizamioSize.borderWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(NizamioSpacing.rowPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: NizamioSpacing.space3,
            children: [
              Row(
                children: [
                  NzIconTile(
                    icon: Icons.event_repeat_rounded,
                    color: c.warning,
                  ),
                  const Gap(NizamioSpacing.gapMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.uiTasksRequestTitle,
                          style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$by · ${TaskDates.short(r.at)} ${TaskDates.time(r.at)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: NizamioSpacing.space2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    TaskDates.full(r.oldDue),
                    style: t.mono.copyWith(
                      color: c.textMuted,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: c.textMuted,
                    ),
                  ),
                  ExcludeSemantics(
                    child: Text(
                      '→',
                      style: t.mono.copyWith(color: c.textMuted),
                    ),
                  ),
                  Text(
                    TaskDates.full(r.due),
                    style: t.mono.copyWith(
                      color: c.accentText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    l.plusDays(plus),
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ),
              Text(
                '“${r.reason.isEmpty ? l.uiTasksNoReason : r.reason}”',
                style: t.caption.copyWith(color: c.textMuted),
              ),
              Row(
                spacing: NizamioSpacing.space2,
                children: [
                  Expanded(
                    child: NzButton.secondary(
                      label: l.uiTasksReject,
                      expand: true,
                      onPressed: onReject,
                    ),
                  ),
                  Expanded(
                    child: NzButton.primary(
                      label: l.uiTasksApprove,
                      expand: true,
                      onPressed: onApprove,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
