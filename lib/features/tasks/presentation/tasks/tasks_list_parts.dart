import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';
import '../task_widgets.dart';

/// Görünüm noktası rengi (prototip `VD`).
Color viewDot(TaskView v, NizamioColors c) => switch (v) {
  TaskView.all => c.textMuted,
  TaskView.late => c.danger,
  TaskView.inProgress => c.inProgress,
  TaskView.review || TaskView.dateRequest => c.warning,
  TaskView.notStarted => c.textFaint,
  TaskView.done => c.accentText,
};

/// Liste gövdesi: görünüm kutucukları, çipler, başlık + sıralama, kartlar, sayfalama.
class TasksListBody extends ConsumerWidget {
  const TasksListBody({
    super.key,
    required this.catalog,
    required this.state,
    required this.provider,
    required this.onClearAll,
    required this.onOpen,
  });

  final TaskCatalog catalog;
  final TasksListState state;
  final TasksListControllerProvider provider;
  final VoidCallback onClearAll;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final ctl = ref.read(provider.notifier);
    final r = queryTasks(
      catalog,
      view: state.view,
      sort: state.sort,
      descending: state.descending,
      filter: state.filter,
    );
    final byCoord = state.sort == TaskSort.coordinatorship;
    final list = r.tasks;
    final shown = byCoord ? list : list.take(state.limit).toList();
    final chips = _chips(context, ctl);

    TaskCardView card(TaskItem task) => TaskCardView(
      task: task,
      catalog: catalog,
      showGroup: !byCoord,
      onTap: () => onOpen(task.code),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TaskViewGrid(
          counts: r.counts,
          selected: state.view,
          onSelected: ctl.selectView,
        ),
        if (chips.isNotEmpty) ...[
          const Gap(NizamioSpacing.space3),
          Wrap(
            spacing: NizamioSpacing.space2,
            runSpacing: NizamioSpacing.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...chips,
              TaskLink(label: l.uiTasksClear, onTap: onClearAll),
            ],
          ),
        ],
        const Gap(NizamioSpacing.space3),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  '${l.viewListTitle(state.view)} · ${list.length}',
                  style: t.kicker.copyWith(color: c.text),
                ),
              ),
            ),
            TaskSortMenu(
              sort: state.sort,
              descending: state.descending,
              onSelected: ctl.selectSort,
            ),
          ],
        ),
        const Gap(NizamioSpacing.space1),
        Semantics(
          container: true,
          label: l.uiTasksTaskList,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: NizamioSpacing.gapMd,
            children: [
              if (byCoord)
                for (var gi = 0; gi < r.groups.length; gi++) ...[
                  _GroupHead(
                    group: r.groups[gi],
                    name:
                        catalog
                            .coordinatorship(r.groups[gi].coordinatorship)
                            ?.name ??
                        r.groups[gi].coordinatorship,
                    open: state.isGroupOpen(
                      r.groups[gi].coordinatorship,
                      first: gi == 0,
                    ),
                    onTap: () => ctl.toggleGroup(
                      r.groups[gi].coordinatorship,
                      first: gi == 0,
                    ),
                  ),
                  if (state.isGroupOpen(
                    r.groups[gi].coordinatorship,
                    first: gi == 0,
                  ))
                    for (final task in r.groups[gi].tasks) card(task),
                ]
              else
                for (final task in shown) card(task),
              if (list.isEmpty)
                NzEmptyState(
                  title: l.uiTasksEmpty,
                  actionLabel: l.uiTasksClearFilters,
                  onAction: onClearAll,
                ),
            ],
          ),
        ),
        if (!byCoord && list.length > state.limit) ...[
          const Gap(NizamioSpacing.space5),
          NzButton.secondary(
            label: l.uiTasksShowMore,
            expand: true,
            onPressed: ctl.showMore,
          ),
        ],
        const Gap(NizamioSpacing.space3),
        Text(
          byCoord
              ? l.groupedCountLine(list.length, r.groups.length)
              : l.countLine(
                  state.limit < list.length ? state.limit : list.length,
                  list.length,
                ),
          textAlign: TextAlign.center,
          style: t.caption.copyWith(color: c.textMuted),
        ),
      ],
    );
  }

  List<Widget> _chips(BuildContext context, TasksListController ctl) {
    final l = context.l10n;
    final f = state.filter;
    return [
      for (final p in f.people)
        _FilterChip(
          label: catalog.person(p)?.name ?? p,
          removeLabel:
              '${catalog.person(p)?.name ?? p} ${l.uiTasksRemoveFilterTail}',
          onRemove: () => ctl.togglePerson(p),
        ),
      for (final code in f.coordinatorships)
        _FilterChip(
          label: catalog.coordinatorship(code)?.name ?? code,
          removeLabel: '$code ${l.uiTasksRemoveFilterTail}',
          onRemove: () => ctl.toggleCoordinatorship(code),
        ),
      for (final p in f.priorities)
        _FilterChip(
          label: '${l.uiTasksPriority}: ${l.priorityLabel(p)}',
          removeLabel: l.uiTasksPriorityFilterRemove,
          onRemove: () => ctl.togglePriority(p),
        ),
    ];
  }
}

/// 4×2 görünüm kutucukları; "Tümü" iki sütun.
class TaskViewGrid extends StatelessWidget {
  const TaskViewGrid({
    super.key,
    required this.counts,
    required this.selected,
    required this.onSelected,
  });

  final Map<TaskView, int> counts;
  final TaskView selected;
  final ValueChanged<TaskView> onSelected;

  @override
  Widget build(BuildContext context) {
    Widget tile(TaskView v) => _ViewTile(
      view: v,
      count: counts[v] ?? 0,
      selected: v == selected,
      onTap: () => onSelected(v),
    );
    Widget row(List<(TaskView, int)> items) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NizamioSpacing.space2,
        children: [
          for (final (v, flex) in items) Expanded(flex: flex, child: tile(v)),
        ],
      ),
    );
    return Semantics(
      container: true,
      label: context.l10n.uiTasksViews,
      child: Column(
        spacing: NizamioSpacing.space2,
        children: [
          row([
            (TaskView.all, 2),
            (TaskView.late, 1),
            (TaskView.inProgress, 1),
          ]),
          row([
            (TaskView.review, 1),
            (TaskView.dateRequest, 1),
            (TaskView.notStarted, 1),
            (TaskView.done, 1),
          ]),
        ],
      ),
    );
  }
}

class _ViewTile extends StatelessWidget {
  const _ViewTile({
    required this.view,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final TaskView view;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final numColor = switch (view) {
      TaskView.late => c.danger,
      TaskView.dateRequest => c.warning,
      _ => c.text,
    };
    return Semantics(
      button: true,
      selected: selected,
      label: '${l.viewLabel(view)}, $count',
      excludeSemantics: true,
      child: NzPressable.card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: AnimatedContainer(
            duration: NzMotion.of(context, NizamioMotion.durPress),
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.all(NizamioSpacing.gapMd),
            decoration: BoxDecoration(
              color: selected ? c.surfaceOverlay : c.surface,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              border: Border.all(
                color: selected ? c.accentText : c.border,
                width: NizamioSize.borderWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: NizamioSpacing.space1,
              children: [
                NzDot(color: viewDot(view, c)),
                Text('$count', style: t.titleSm.copyWith(color: numColor)),
                Text(
                  l.viewLabel(view),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.removeLabel,
    required this.onRemove,
  });

  final String label;
  final String removeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceOverlay,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        border: Border.all(
          color: c.borderStrong,
          width: NizamioSize.borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: NizamioSpacing.space3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.caption,
              ),
            ),
            NzIconButton(
              icon: Icons.close_rounded,
              semanticLabel: removeLabel,
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

/// Liste başlığındaki sıralama menüsü (prototip `.rp-pop`): seçili tarihli ölçüte yeniden
/// dokunmak yönü çevirir (menü açık kalır); başka ölçüt seçmek menüyü kapatır.
class TaskSortMenu extends StatelessWidget {
  const TaskSortMenu({
    super.key,
    required this.sort,
    required this.descending,
    required this.onSelected,
  });

  final TaskSort sort;
  final bool descending;
  final ValueChanged<TaskSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(c.surfaceOverlay),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NizamioRadius.group),
            side: BorderSide(color: c.borderStrong),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.all(NizamioSpacing.space1 + 2),
        ),
      ),
      alignmentOffset: const Offset(-120, 0),
      menuChildren: [for (final s in TaskSort.values) _sortItem(context, s, c)],
      builder: (context, controller, _) => Semantics(
        button: true,
        expanded: controller.isOpen,
        label: '${l.uiTasksSortMenu}: ${l.sortLabel(sort)}',
        excludeSemantics: true,
        child: InkWell(
          onTap: () =>
              controller.isOpen ? controller.close() : controller.open(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: NizamioSize.tap),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.sortLabel(sort),
                  style: t.labelMd.copyWith(
                    color: c.textMuted,
                    decoration: TextDecoration.underline,
                    decorationColor: c.textMuted,
                  ),
                ),
                const Gap(NizamioSpacing.space1),
                AnimatedRotation(
                  turns: controller.isOpen ? 0.5 : 0,
                  duration: NzMotion.of(context, NizamioMotion.durPress),
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sortItem(BuildContext context, TaskSort s, NizamioColors c) {
    final ll = context.l10n;
    final tt = context.text;
    final sel = s == sort;
    final aria = sel && s.dated
        ? '${ll.sortShort(s)} · ${ll.sortDirection(s, descending: descending)} · ${ll.uiTasksDirTap}'
        : ll.sortShort(s);
    return Semantics(
      label: aria,
      selected: sel,
      child: MenuItemButton(
        closeOnActivate: !(sel && s.dated),
        onPressed: () => onSelected(s),
        style: const ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(220, NizamioSize.tap)),
        ),
        trailingIcon: sel
            ? s.dated
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.background,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          NizamioSpacing.space1 + 2,
                        ),
                        child: AnimatedRotation(
                          turns: descending ? 0.5 : 0,
                          duration: NzMotion.of(
                            context,
                            NizamioMotion.durPress,
                          ),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: NizamioSize.iconSizeSm,
                            color: c.accentText,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.check_rounded,
                      size: NizamioSize.iconSizeSm,
                      color: c.accentText,
                    )
            : null,
        child: Text(ll.sortShort(s), style: tt.bodyMd),
      ),
    );
  }
}

class _GroupHead extends StatelessWidget {
  const _GroupHead({
    required this.group,
    required this.name,
    required this.open,
    required this.onTap,
  });

  final TaskGroup group;
  final String name;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      expanded: open,
      label: '$name, ${group.coordinatorship}, ${group.tasks.length}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: c.border,
                width: NizamioSize.borderWidth,
              ),
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NizamioSize.controlMd + 4,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: t.list.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Text(
                  group.coordinatorship,
                  style: t.kicker.copyWith(color: c.textFaint),
                ),
                const Spacer(),
                Text(
                  '${group.tasks.length}',
                  style: t.monoSm.copyWith(color: c.textMuted),
                ),
                const Gap(NizamioSpacing.space2),
                AnimatedRotation(
                  turns: open ? 0 : -0.25,
                  duration: NzMotion.of(context, NizamioMotion.durPress),
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Görev kartı (prototip `.t-card`): [NzTaskCard] + talep rozeti, dosya/not sayaçları.
class TaskCardView extends StatelessWidget {
  const TaskCardView({
    super.key,
    required this.task,
    required this.catalog,
    required this.onTap,
    this.showGroup = true,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final VoidCallback onTap;
  final bool showGroup;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final names = [
      for (final a in task.assignees) catalog.person(a)?.name ?? a,
    ];
    final late = !task.isDone && task.isOverdue;
    final req = task.dateRequest;
    final subs = task.subtasks;
    Widget counter(IconData icon, int n, String label) => Semantics(
      label: '$n $label',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: NizamioSize.iconSizeSm, color: c.textMuted),
          const Gap(NizamioSpacing.space1),
          Text('$n', style: t.caption.copyWith(color: c.textMuted)),
        ],
      ),
    );
    return NzTaskCard(
      code: task.code,
      group: showGroup
          ? catalog.coordinatorship(task.coordinatorship)?.name ??
                task.coordinatorship
          : null,
      title: task.title,
      statusLabel: l.statusLabel(task.status),
      statusTone: statusTone(task.status),
      start: NzTaskCardDate(
        caption: l.uiTasksCardStart,
        value: TaskDates.full(task.start),
      ),
      end: NzTaskCardDate(
        caption: l.uiTasksCardDue,
        value: TaskDates.full(task.due),
        overdue: late,
      ),
      priorityCaption: l.uiTasksCardPriority,
      priority: l.priorityLabel(task.priority),
      priorityLevel: priorityLevel(task.priority),
      subtaskProgress: subs.isEmpty ? null : task.subtasksDone / subs.length,
      subtaskText: subs.isEmpty
          ? null
          : l.subtaskLine(task.subtasksDone, subs.length),
      assignees: names.take(3).toList(),
      assigneeText: names.isEmpty
          ? null
          : names.length > 1
          ? '${names.first} +${names.length - 1}'
          : names.first,
      badge: late ? l.lateBadge(task.overdueDays) : null,
      trailing: [
        if (req != null && req.isPending)
          NzStatusLabel.badge(
            label: '${l.uiTasksRequestBadge} · ${TaskDates.short(req.due)}',
            tone: NzTone.waiting,
          ),
        if (task.files > 0)
          counter(Icons.description_outlined, task.files, l.uiTasksFilesTail),
        if (task.notes > 0)
          counter(
            Icons.chat_bubble_outline_rounded,
            task.notes,
            l.uiTasksNotesTail,
          ),
      ],
      onTap: onTap,
      semanticLabel: [
        task.code,
        task.title,
        l.statusLabel(task.status),
        if (late) l.lateBadge(task.overdueDays),
      ].join(', '),
    );
  }
}

/// Alt menüde "Görevler"e yeniden dokununca açılan kısayol menüsü (prototip `buildNav`
/// `cur === 'tasks'`): görünümler + sayıları, sıralama, görev eylemleri.
Future<void> showTasksShortcuts(
  BuildContext context, {
  required TaskCatalog catalog,
  required TasksListControllerProvider provider,
  required VoidCallback onNewTask,
  required VoidCallback onTimeline,
  required VoidCallback onSearch,
  required VoidCallback onFilters,
}) {
  final l = context.l10n;
  final c = context.colors;
  final container = ProviderScope.containerOf(context, listen: false);
  final state = container.read(provider);
  final ctl = container.read(provider.notifier);
  final r = queryTasks(
    catalog,
    view: state.view,
    sort: state.sort,
    descending: state.descending,
    filter: state.filter,
  );
  return NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiTasksShortcuts,
    entries: [
      NzFlyoutSection(l.uiTasksFlyView),
      for (final v in TaskView.values)
        NzFlyoutItem(
          label: l.viewLabel(v),
          dot: viewDot(v, c),
          trailing: '${r.counts[v] ?? 0}',
          selected: v == state.view,
          onSelected: () => ctl.selectView(v),
        ),
      NzFlyoutSection(l.uiTasksFlySort),
      for (final s in TaskSort.values)
        NzFlyoutItem(
          label: l.sortShort(s),
          icon: Icons.swap_vert_rounded,
          selected: s == state.sort,
          onSelected: () => ctl.selectSort(s),
        ),
      NzFlyoutSection(l.uiTasksFlyTasks),
      NzFlyoutItem(
        label: l.uiTasksNewTask,
        icon: Icons.add_rounded,
        accent: true,
        onSelected: onNewTask,
      ),
      NzFlyoutItem(
        label: l.uiTasksModeTimeline,
        caption: l.uiTasksFlyTimelineCaption,
        icon: Icons.view_timeline_outlined,
        onSelected: onTimeline,
      ),
      NzFlyoutItem(
        label: l.uiTasksFlySearch,
        icon: Icons.search_rounded,
        onSelected: onSearch,
      ),
      NzFlyoutItem(
        label: l.uiTasksFlyFilter,
        icon: Icons.filter_list_rounded,
        onSelected: onFilters,
      ),
    ],
  );
}
