import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/motion/page_content_entrance.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_alert_icon.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'task_card_grid.dart';
import 'task_view_grid.dart';

/// Liste gövdesi (görünüm kutucukları, çipler, başlık + sıralama, kartlar, sayfalama) akışın
/// öğeleri olarak: sayfa bunları `NzPage.feed` tembel listesine doğrudan koyar; ekran dışı
/// kartlar kurulmaz/yerleştirilmez (tek `Column` içinde 76 kart yerine), her öğe kendi
/// boyama sınırında. Kartlar görev koduyla anahtarlıdır (sıralama/süzgeç değişince öğe
/// eşleşmesi korunur). [columns] > 1 (tablette tam genişlik liste) kartlar satırlara dizilir
/// ([TaskCardRow]); her satır ayrı öğedir.
List<Widget> tasksListChildren(
  BuildContext context, {
  required TaskCatalog catalog,
  required TasksListState state,
  required TaskQueryResult result,
  required TasksListController ctl,
  required VoidCallback onClearAll,
  required ValueChanged<String> onOpen,
  int columns = 1,
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
    padding: EdgeInsets.only(top: rows.isEmpty ? 0 : TaskCardGrid.gap),
    child: child,
  );
  // Satırı dolmayı bekleyen kartlar (çok sütunda); grup başlığından önce ve sonda boşaltılır.
  final pending = <Widget>[];
  void flush() {
    if (pending.isEmpty) return;
    rows.add(
      item(
        ValueKey('row:${pending.first.key}'),
        TaskCardRow(cards: [...pending], columns: columns),
      ),
    );
    pending.clear();
  }

  // Grup açılınca kartlar ana sayfadaki koordinatörlük kartlarıyla aynı girişle, kademeli
  // gelir ([NzEntrance]; yeni eklenen kart oynar, açık kalan grup yeniden oynamaz).
  void card(TaskItem task, {int? stagger}) {
    final view = TaskCardView(
      task: task,
      catalog: catalog,
      showGroup: !byCoord,
      onTap: () => onOpen(task.code),
      fill: columns > 1,
    );
    final key = ValueKey('task:${task.code}');
    final child = stagger == null
        ? view
        : NzEntrance(replay: task.code, index: stagger, child: view);
    if (columns == 1) {
      rows.add(item(key, child));
      return;
    }
    pending.add(KeyedSubtree(key: key, child: child));
    if (pending.length == columns) flush();
  }

  if (byCoord) {
    for (var gi = 0; gi < r.groups.length; gi++) {
      final g = r.groups[gi];
      final open = state.isGroupOpen(g.coordinatorship, first: gi == 0);
      flush();
      rows.add(
        item(
          ValueKey('group:${g.coordinatorship}'),
          _GroupHead(
            group: g,
            name:
                catalog.coordinatorship(g.coordinatorship)?.name ??
                g.coordinatorship,
            code: _groupCode(catalog, g.coordinatorship),
            open: open,
            onTap: () => ctl.toggleGroup(g.coordinatorship),
          ),
        ),
      );
      if (open) {
        for (final (i, t) in g.tasks.indexed) {
          card(t, stagger: i);
        }
      }
    }
  } else {
    list.take(state.limit).forEach(card);
  }
  flush();

  final sort = NzSplitButton(
    label: l.sortLabel(state.sort),
    semanticLabel: '${l.uiHomeSortChange}: ${l.sortLabel(state.sort)}',
    onPressed: ctl.cycleSort,
    icon: NzIcons.chevronDown,
    iconTurns: state.descending ? 0 : 0.5,
    iconSemanticLabel:
        '${l.uiHomeSortFlip}: ${state.descending ? l.uiHomeSortDescending : l.uiHomeSortAscending}',
    onIconPressed: ctl.flipDirection,
  );

  return [
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
    // Ana sayfadaki koordinatörlük sıralamasıyla aynı bileşen: etiket ölçütü değiştirir, ok
    // yönü çevirir (koordinatörlük ölçütü yönsüzdür). Tablette solda liste başlığı
    // (`tüm görevler · 76`, kaynak `L.listTitle`).
    if (tablet)
      NzKicker(
        '${l.viewListTitle(state.view)} · ${list.length}',
        emphasis: true,
        action: sort,
      )
    else
      Align(alignment: Alignment.centerRight, child: sort),
    Gap(tablet ? NizamioSpacing.space3 : NizamioSpacing.space1),
    ...rows,
    if (list.isEmpty)
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
/// Grup başlığının kısa kodu: sunucu kataloğunda grup anahtarı departman kimliğidir, gösterilen
/// departmanın kodudur (yoksa adı, [TaskDepartment.label]).
String _groupCode(TaskCatalog catalog, String key) {
  for (final d in catalog.departments) {
    if (d.id == key) return d.label;
  }
  return key;
}

class _GroupHead extends StatelessWidget {
  const _GroupHead({
    required this.group,
    required this.name,
    required this.code,
    required this.open,
    required this.onTap,
  });

  final TaskGroup group;
  final String name;

  /// Kısa kod (`ALT`); sunucu kataloğunda departman kodu, kimlik değil.
  final String code;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      expanded: open,
      label: '$name, $code, ${group.tasks.length}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.list.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Gap(NizamioSpacing.space2),
                      Text(
                        code,
                        maxLines: 1,
                        style: t.kicker.copyWith(color: c.textFaint),
                      ),
                    ],
                  ),
                ),
                const Gap(NizamioSpacing.space2),
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
    this.fill = false,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final VoidCallback onTap;
  final bool showGroup;

  /// Izgara satırında satır boyuna uzar ([NzTaskCard.fill]).
  final bool fill;

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
      fill: fill,
      code: task.displayCode,
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
      subtaskProgress: subTotal == 0 ? null : subDone / subTotal,
      subtaskText: subTotal == 0 ? null : l.subtaskLine(subDone, subTotal),
      assignees: names.take(3).toList(),
      assigneeText: names.isEmpty
          ? null
          : names.length > 1
          ? '${names.first} +${names.length - 1}'
          : names.first,
      // Gecikme rozeti yok: bitiş tarihi kırmızı çizilir ([NzTaskCardDate.overdue]).
      trailing: [
        // Bekleyen tarih talebi: ünlem ikonu (metin rozeti yerine; ayrıntı ekranda).
        if (req != null && req.isPending)
          Semantics(
            label: 'Tarih değişikliği talebi · ${TaskDates.short(req.due)}',
            child: ExcludeSemantics(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NzAlertIcon(color: c.warning, size: NizamioSize.iconSizeSm),
                    const Gap(4),
                    Text(
                      TaskDates.short(req.due),
                      style: context.text.caption.copyWith(color: c.warning),
                    ),
                  ],
                ),
              ),
            ),
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
