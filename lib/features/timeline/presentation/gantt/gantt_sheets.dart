import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/gantt_provider.dart';
import '../../application/horizontal_timeline_controller.dart';
import '../../application/horizontal_timeline_view.dart';
import '../../domain/horizontal_timeline.dart';
import '../timeline_texts.dart';
import 'gantt_texts.dart';

/// Görev listesiyle aynı çoklu seçim düzeni; seçimler çizelgeye hemen yansır.
Future<void> showGanttFilterSheet(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTasksFilters,
      actions: (sheet) => [
        Consumer(
          builder: (context, ref, _) => NzButton.secondary(
            label: context.l10n.uiTasksClear,
            onPressed: ref
                .read(horizontalTimelineControllerProvider.notifier)
                .clearFilters,
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final catalog = ref.watch(timelineCatalogProvider).value;
            final state = ref.watch(horizontalTimelineControllerProvider);
            final count = catalog == null
                ? 0
                : horizontalTimelineView(catalog, state).visible;
            return NzButton.primary(
              label: context.l10n.showTasks(count),
              onPressed: () => Navigator.of(sheet).maybePop(),
            );
          },
        ),
      ],
      builder: (_) => const _FilterBody(),
    );

class _FilterBody extends ConsumerWidget {
  const _FilterBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(timelineCatalogProvider).value;
    if (catalog == null) return const SizedBox.shrink();
    final state = ref.watch(horizontalTimelineControllerProvider);
    final ctl = ref.read(horizontalTimelineControllerProvider.notifier);
    final view = horizontalTimelineView(catalog, state);
    final l = context.l10n;
    final c = context.colors;
    Widget option(
      String label,
      String count,
      bool selected,
      VoidCallback toggle,
    ) => InkWell(
      onTap: toggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space3,
          vertical: NizamioSpacing.space1,
        ),
        child: Row(
          children: [
            NzCheckCircle(value: selected, label: label, onChanged: toggle),
            const Gap(NizamioSpacing.space2),
            Expanded(child: Text(label, style: context.text.list)),
            Text(
              count,
              style: context.text.monoSm.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    );
    Widget group(String label, int selected, List<Widget> rows) =>
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            label,
            style: context.text.list.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            selected == 0
                ? l.uiTasksAllLc
                : '$selected ${l.uiTasksSelectedTail}',
            style: context.text.caption.copyWith(
              color: selected == 0 ? c.textFaint : c.accentText,
            ),
          ),
          children: [NzMenuGroup(rows: rows)],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.uiTimelineStatus,
          style: context.text.labelMd.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space2),
        NzFilterRail(
          semanticLabel: l.uiTimelineGanttFilter,
          selected: state.filter.index,
          onSelected: (i) => ctl.setFilter(GanttFilter.values[i]),
          options: [
            for (final f in GanttFilter.values)
              NzFilterOption(label: l.ganttFilterLabel(f, view.lateAll)),
          ],
        ),
        group(l.uiTasksGroupPeople, state.people.length, [
          for (final person in catalog.people)
            option(
              person.name,
              '${catalog.tasks.where((t) => t.assignees.contains(person.id)).length}',
              state.people.contains(person.id),
              () => ctl.togglePerson(person.id),
            ),
        ]),
        group(l.uiTasksGroupCoord, state.coords.length, [
          for (final coord in catalog.coordinatorships)
            option(
              coord.name,
              '${catalog.tasks.where((t) => t.coordinatorship == coord.code).length}',
              state.coords.contains(coord.code),
              () => ctl.toggleCoord(coord.code),
            ),
        ]),
        NzFormRows(
          rows: [
            NzFormRow.custom(
              label: l.uiTasksPriority,
              leading: const NzPriorityBars(level: 2),
              trailing: TaskSegmented(
                compact: true,
                semanticLabel: l.uiTasksPriority,
                labels: [
                  for (final p in TaskPriority.pickable) l.priorityLabel(p),
                ],
                selected: -1,
                selectedIndices: {
                  for (final (i, p) in TaskPriority.pickable.indexed)
                    if (state.priorities.contains(p)) i,
                },
                onSelected: (i) => ctl.togglePriority(TaskPriority.pickable[i]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
