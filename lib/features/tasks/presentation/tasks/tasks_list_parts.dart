import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
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

/// Liste gövdesi (görünüm kutucukları, çipler, başlık + sıralama, kartlar, sayfalama) akışın
/// öğeleri olarak: sayfa bunları `NzPage.feed` tembel listesine doğrudan koyar; ekran dışı
/// kartlar kurulmaz/yerleştirilmez (tek `Column` içinde 76 kart yerine), her öğe kendi
/// boyama sınırında. Kartlar görev koduyla anahtarlıdır (sıralama/süzgeç değişince öğe
/// eşleşmesi korunur).
List<Widget> tasksListChildren(
  BuildContext context, {
  required TaskCatalog catalog,
  required TasksListState state,
  required TaskQueryResult result,
  required TasksListController ctl,
  required VoidCallback onClearAll,
  required ValueChanged<String> onOpen,
  ValueChanged<String>? onSelectDepartment,
}) {
  final l = context.l10n;
  final c = context.colors;
  final t = context.text;
  final r = result;
  final byCoord = state.sort == TaskSort.coordinatorship;
  final list = r.tasks;
  final chips = _chips(context, catalog, state, ctl);
  final tablet = NzTabletMetrics.tabletVisualAt(
    MediaQuery.sizeOf(context).width,
  );

  final rows = <Widget>[];
  Widget item(Key key, Widget child) => Padding(
    key: key,
    padding: EdgeInsets.only(top: rows.isEmpty ? 0 : NizamioSpacing.gapMd),
    child: child,
  );
  void card(TaskItem task) => rows.add(
    item(
      ValueKey('task:${task.code}'),
      TaskCardView(
        task: task,
        catalog: catalog,
        showGroup: !byCoord,
        onTap: () => onOpen(task.code),
      ),
    ),
  );
  if (byCoord) {
    for (var gi = 0; gi < r.groups.length; gi++) {
      final g = r.groups[gi];
      final open = state.isGroupOpen(g.coordinatorship, first: gi == 0);
      rows.add(
        item(
          ValueKey('group:${g.coordinatorship}'),
          _GroupHead(
            group: g,
            name:
                catalog.coordinatorship(g.coordinatorship)?.name ??
                g.coordinatorship,
            open: open,
            onTap: () => ctl.toggleGroup(g.coordinatorship),
          ),
        ),
      );
      if (open) g.tasks.forEach(card);
    }
  } else {
    list.take(state.limit).forEach(card);
  }

  // Liste tek departman bağlamındadır (istemci akışları §2): seçilebilir birden çoksa ya da
  // liste kesikse seçici gösterilir; seçim kapsamı değiştirir, katalog yeniden okunur.
  final departments = catalog.departments;
  final pickDepartment =
      onSelectDepartment != null &&
      (departments.length > 1 || catalog.departmentsTruncated);
  final selectedDepartment = catalog.departmentId;

  return [
    if (pickDepartment) ...[
      NzSelect<String>(
        label: l.uiTasksDepartment,
        items: [
          for (final d in departments)
            NzSelectItem(
              value: d.id,
              label: d.code == null || d.code!.isEmpty
                  ? d.name
                  : '${d.code} · ${d.name}',
            ),
        ],
        value: departments.any((d) => d.id == selectedDepartment)
            ? selectedDepartment
            : null,
        onChanged: (id) {
          if (id != null) onSelectDepartment(id);
        },
      ),
      if (catalog.departmentsTruncated) ...[
        const Gap(NizamioSpacing.space1),
        Text(l.uiListsTruncated, style: t.caption.copyWith(color: c.textMuted)),
      ],
      const Gap(NizamioSpacing.space3),
    ],
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
    // Tablet kaynağı: bölümler arası 20; başlık (44) sonrası `gap 20 − margin 8` = 12.
    Gap(tablet ? NizamioSpacing.space5 : NizamioSpacing.space3),
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
    Gap(tablet ? NizamioSpacing.space3 : NizamioSpacing.space1),
    ...rows,
    if (list.isEmpty && catalog.departmentRequired)
      // Departman bağlamı yok (ör. ekip satırı olmayan yönetici): liste istenmedi.
      NzEmptyState(title: l.errClientScopeMissing)
    else if (list.isEmpty)
      NzEmptyState(
        title: l.uiTasksEmpty,
        actionLabel: l.uiTasksClearFilters,
        onAction: onClearAll,
      ),
    if (!byCoord && list.length > state.limit) ...[
      const Gap(NizamioSpacing.space5),
      NzButton.secondary(
        label: l.uiTasksShowMore,
        expand: true,
        onPressed: ctl.showMore,
      ),
    ],
    if (catalog.truncated) ...[
      const Gap(NizamioSpacing.space3),
      Text(
        l.uiListsTruncated,
        textAlign: TextAlign.center,
        style: t.bodySm.copyWith(color: c.textMuted),
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
  ];
}

List<Widget> _chips(
  BuildContext context,
  TaskCatalog catalog,
  TasksListState state,
  TasksListController ctl,
) {
  final l = context.l10n;
  final f = state.filter;
  return [
    for (final p in f.people)
      _FilterChip(
        label: catalog.nameOf(p) ?? l.uiTasksUnknownPerson,
        removeLabel:
            '${catalog.nameOf(p) ?? l.uiTasksUnknownPerson} '
            '${l.uiTasksRemoveFilterTail}',
        onRemove: () => ctl.togglePerson(p),
      ),
    for (final code in f.coordinatorships)
      _FilterChip(
        label: catalog.coordinatorship(code)?.name ?? code,
        removeLabel:
            '${catalog.coordinatorship(code)?.name ?? code} '
            '${l.uiTasksRemoveFilterTail}',
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
    // Kaynak ızgarası `repeat(4, minmax(0, 1fr))` + `gap: 8px`; "Tümü" 2 sütun kaplar
    // (genişlik 2 sütun + 1 boşluk; oranla paylaştırma değil).
    const gap = NizamioSpacing.space2;
    Widget row(List<(TaskView, int)> items) => LayoutBuilder(
      builder: (context, box) {
        final col = (box.maxWidth - 3 * gap) / 4;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: gap,
            children: [
              for (final (v, span) in items)
                SizedBox(width: span * col + (span - 1) * gap, child: tile(v)),
            ],
          ),
        );
      },
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

// Tablet kaynak görünüm kutucuğu: sayı `rp-num` 22/26, etiket 11/14.
const _tileNum = 22.0;
const _tileNumLine = 26.0;
const _tileLabel = 11.0;
const _tileLabelLine = 14.0;

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
    final tablet = NzTabletMetrics.tabletVisualAt(
      MediaQuery.sizeOf(context).width,
    );
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
                Text(
                  '$count',
                  style: tablet
                      ? t.titleSm.copyWith(
                          fontSize: _tileNum,
                          height: _tileNumLine / _tileNum,
                          color: numColor,
                        )
                      : t.titleSm.copyWith(color: numColor),
                ),
                Text(
                  l.viewLabel(view),
                  maxLines: tablet ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: tablet
                      ? t.caption.copyWith(
                          fontSize: _tileLabel,
                          height: _tileLabelLine / _tileLabel,
                          color: c.textMuted,
                        )
                      : t.caption.copyWith(color: c.textMuted),
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
              icon: NzIcons.close,
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
                  child: NzIcon(
                    NzIcons.chevronDown,
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
                          child: NzIcon(
                            NzIcons.arrowUp,
                            size: NizamioSize.iconSizeSm,
                            color: c.accentText,
                          ),
                        ),
                      ),
                    )
                  : NzIcon(
                      NzIcons.check,
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
                  child: NzIcon(
                    NzIcons.chevronDown,
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
      for (final a in task.assignees)
        catalog.nameOf(a) ?? l.uiTasksUnknownPerson,
    ];
    final late = !task.isDone && task.isOverdue;
    final req = task.dateRequest;
    final subTotal = task.subtaskTotal;
    final subDone = task.subtaskDoneTotal;
    Widget counter(IconData icon, int n, String label) => Semantics(
      label: '$n $label',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.textMuted),
          const Gap(NizamioSpacing.space1),
          Text('$n', style: t.caption.copyWith(color: c.textMuted)),
        ],
      ),
    );
    return NzTaskCard(
      code: task.displayCode,
      group: showGroup
          ? catalog.coordinatorship(task.coordinatorship)?.name ??
                task.coordinatorship
          : null,
      title: task.title,
      muted: task.isDone,
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
      subtaskProgress: subTotal == 0 ? null : subDone / subTotal,
      subtaskText: subTotal == 0 ? null : l.subtaskLine(subDone, subTotal),
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
        if (task.notes > 0)
          counter(NzIcons.messages, task.notes, l.uiTasksNotesTail),
      ],
      onTap: onTap,
      semanticLabel: [
        task.displayCode,
        task.title,
        l.statusLabel(task.status),
        if (late) l.lateBadge(task.overdueDays),
      ].join(', '),
    );
  }
}

/// Alt menüde "Görevler"e yeniden dokununca açılan kısayol menüsü (prototip `buildNav`
/// `cur === 'tasks'`): görünümler + sayıları, sıralama, görev eylemleri. [onNewTask] null →
/// "Yeni görev" satırı yok (seçili kapsamda görev açma yetkisi yok).
Future<void> showTasksShortcuts(
  BuildContext context, {
  required TasksListControllerProvider provider,
  required VoidCallback? onNewTask,
  required VoidCallback onTimeline,
  required VoidCallback onSearch,
  required VoidCallback onFilters,
}) {
  final l = context.l10n;
  final c = context.colors;
  final container = ProviderScope.containerOf(context, listen: false);
  final state = container.read(provider);
  final ctl = container.read(provider.notifier);
  final r = container.read(tasksListResultOf(provider));
  if (r == null) return Future.value();
  return NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiTasksShortcuts,
    entries: [
      NzFlyoutSection(l.uiTasksFlyView),
      for (final v in TaskView.values)
        NzFlyoutItem(
          label: l.viewLabel(v),
          dot: viewDot(v, c),
          count: '${r.counts[v] ?? 0}',
          selected: v == state.view,
          onSelected: () => ctl.selectView(v),
        ),
      NzFlyoutSection(l.uiTasksFlySort),
      for (final s in TaskSort.values)
        NzFlyoutItem(
          label: l.sortShort(s),
          icon: NzIcons.swapVertical,
          selected: s == state.sort,
          onSelected: () => ctl.selectSort(s),
        ),
      NzFlyoutSection(l.uiTasksFlyTasks),
      if (onNewTask != null)
        NzFlyoutItem(
          label: l.uiTasksNewTask,
          icon: NzIcons.add,
          accent: true,
          onSelected: onNewTask,
        ),
      NzFlyoutItem(
        label: l.uiTasksModeTimeline,
        caption: l.uiTasksFlyTimelineCaption,
        icon: NzIcons.timeline,
        onSelected: onTimeline,
      ),
      NzFlyoutItem(
        label: l.uiTasksFlySearch,
        icon: NzIcons.search,
        onSelected: onSearch,
      ),
      NzFlyoutItem(
        label: l.uiTasksFlyFilter,
        icon: NzIcons.filter,
        onSelected: onFilters,
      ),
    ],
  );
}

/// Görev listesinin ilk yükleme iskeleti (liste gövdesinin yerinde; başlık, anahtar ve arama
/// veriden bağımsız olduğundan gerçek hâlleriyle kalır): görünüm kutucukları ("Tümü" 2 sütun
/// + 2, ardından 4), liste başlığı + sıralama, görev kartları. Tek [NzShimmer] kapsamında
/// parlar; ölçüler yaklaşıktır.
class TasksListSkeleton extends StatelessWidget {
  const TasksListSkeleton({super.key, this.cards = 4});

  /// Kart yeri sayısı.
  final int cards;

  static const _tileHeight = 64.0;
  static const _cardHeight = 112.0;
  static const _titleWidth = 0.45;
  static const _sortWidth = 80.0;

  @override
  Widget build(BuildContext context) {
    const gap = NizamioSpacing.space2;
    Widget tile({int flex = 1}) => Expanded(
      flex: flex,
      child: const NzSkeleton.block(height: _tileHeight),
    );
    Widget bar(double f) => FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: f,
      child: const NzSkeleton.block(
        height: NizamioSpacing.space3,
        radius: NizamioRadius.pill,
      ),
    );
    return NzShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // "Tümü" 2 sütun + 1 boşluk kaplar: flex 2 + 1 + 1 yaklaşık eşler.
          Row(spacing: gap, children: [tile(flex: 2), tile(), tile()]),
          const Gap(gap),
          Row(spacing: gap, children: [tile(), tile(), tile(), tile()]),
          const Gap(NizamioSpacing.space5),
          Row(
            children: [
              Expanded(child: bar(_titleWidth)),
              const Gap(NizamioSpacing.space3),
              const SizedBox(
                width: _sortWidth,
                child: NzSkeleton.block(
                  height: NizamioSpacing.space3,
                  radius: NizamioRadius.pill,
                ),
              ),
            ],
          ),
          for (var i = 0; i < cards; i++) ...[
            const Gap(NizamioSpacing.gapMd),
            const NzSkeleton.block(
              height: _cardHeight,
              radius: NizamioRadius.card,
            ),
          ],
        ],
      ),
    );
  }
}
