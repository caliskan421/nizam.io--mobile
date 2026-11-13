import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/inputs/nz_filter_choice.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
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
            expand: true,
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
              expand: true,
              onPressed: () => Navigator.of(sheet).maybePop(),
            );
          },
        ),
      ],
      builder: (_) => const _FilterBody(),
    );

/// Görevler filtresiyle aynı gövde: durum rayı, ardından açılır Kişi / Koordinatörlük satırları
/// ve öncelik ([NzFormRows]).
class _FilterBody extends ConsumerStatefulWidget {
  const _FilterBody();

  @override
  ConsumerState<_FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends ConsumerState<_FilterBody> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(timelineCatalogProvider).value;
    if (catalog == null) return const SizedBox.shrink();
    final state = ref.watch(horizontalTimelineControllerProvider);
    final ctl = ref.read(horizontalTimelineControllerProvider.notifier);
    final view = horizontalTimelineView(catalog, state);
    final l = context.l10n;
    final c = context.colors;
    String selection(int count) =>
        count == 0 ? l.uiTasksAllLc : '$count ${l.uiTasksSelectedTail}';
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
        const Gap(NizamioSpacing.space4),
        NzFormRows(
          expandedIndex: _open,
          onToggle: (i) => setState(() => _open = _open == i ? null : i),
          rows: [
            NzFormRow(
              label: l.uiTasksGroupPeople,
              icon: NzIcons.person,
              value: selection(state.people.length),
              valueSet: state.people.isNotEmpty,
              content: NzFilterChoices(
                children: [
                  for (final person in catalog.people)
                    NzFilterChoice(
                      label: person.name,
                      count:
                          '${catalog.tasks.where((t) => t.assignees.contains(person.id)).length}',
                      selected: state.people.contains(person.id),
                      onTap: () => ctl.togglePerson(person.id),
                    ),
                ],
              ),
            ),
            NzFormRow(
              label: l.uiTasksGroupCoord,
              icon: NzIcons.coordinatorships,
              value: selection(state.coords.length),
              valueSet: state.coords.isNotEmpty,
              content: NzFilterChoices(
                children: [
                  for (final coord in catalog.coordinatorships)
                    NzFilterChoice(
                      label: coord.name,
                      count:
                          '${catalog.tasks.where((t) => t.coordinatorship == coord.code).length}',
                      selected: state.coords.contains(coord.code),
                      onTap: () => ctl.toggleCoord(coord.code),
                    ),
                ],
              ),
            ),
            NzFormRow.custom(
              label: l.uiTasksPriority,
              leading: const NzPriorityBars(level: 2),
              trailing: TaskSegmented(
                filterSpacing: true,
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
