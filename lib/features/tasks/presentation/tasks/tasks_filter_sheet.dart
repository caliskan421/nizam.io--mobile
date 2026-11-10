import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_catalog.dart';
import '../quick/quick_parts.dart';
import '../task_texts.dart';
import '../task_widgets.dart';

/// Filtre alt sayfası (prototip görevler `sheet`): Kişi, Koordinatörlük, Öncelik açılır
/// grupları; seçenekte sayı (tüm görevler üzerinden); "N görevi göster" seçili görünümün
/// sonucu.
Future<void> showTasksFilterSheet(
  BuildContext context, {
  required TasksListControllerProvider provider,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiTasksFilters,
    headerAction: Consumer(
      builder: (context, ref, _) => TaskLink(
        label: l.uiTasksClearAll,
        onTap: ref.read(provider.notifier).clearExtra,
      ),
    ),
    actions: (sheet) => [
      Consumer(
        builder: (context, ref, _) => NzButton.secondary(
          label: l.uiTasksClear,
          expand: true,
          onPressed: ref.read(provider.notifier).clearExtra,
        ),
      ),
      Consumer(
        builder: (context, ref, _) {
          final n = ref.watch(tasksListResultOf(provider))?.tasks.length ?? 0;
          return NzButton.primary(
            label: '$n ${l.uiTasksShowTasksTail}',
            expand: true,
            onPressed: () => Navigator.of(sheet).maybePop(),
          );
        },
      ),
    ],
    builder: (_) => _FilterBody(provider: provider),
  );
}

class _FilterBody extends ConsumerWidget {
  const _FilterBody({required this.provider});

  final TasksListControllerProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final s = ref.watch(provider);
    final ctl = ref.read(provider.notifier);
    final options = ref.watch(taskFilterOptionsProvider);
    if (options == null) return const SizedBox.shrink();

    final groups = <TaskFilterGroup>[
      TaskFilterGroup.people,
      if (options.coordinatorships.isNotEmpty) TaskFilterGroup.coordinatorship,
    ];
    final open = groups.indexWhere(s.openFilterGroups.contains);
    String selection(int count) =>
        count == 0 ? l.uiTasksAllLc : '$count ${l.uiTasksSelectedTail}';
    Widget choices(List<Widget> rows) =>
        QuickPane(child: Column(children: rows));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzFormRows(
          expandedIndex: open < 0 ? null : open,
          onToggle: (index) {
            final target = groups[index];
            final shouldOpen = open != index;
            for (final group in s.openFilterGroups.toList()) {
              ctl.toggleFilterGroup(group);
            }
            if (shouldOpen) ctl.toggleFilterGroup(target);
          },
          rows: [
            NzFormRow(
              label: l.uiTasksGroupPeople,
              icon: NzIcons.person,
              value: selection(s.filter.people.length),
              valueSet: s.filter.people.isNotEmpty,
              content: choices([
                for (final (p, n) in options.people)
                  TaskCheckRow(
                    label: p.name,
                    count: n,
                    square: true,
                    selected: s.filter.people.contains(p.id),
                    leading: NzAvatar.initials(
                      name: p.name,
                      extent: NzAvatarSize.sm,
                    ),
                    onTap: () => ctl.togglePerson(p.id),
                  ),
              ]),
            ),
            if (options.coordinatorships.isNotEmpty)
              NzFormRow(
                label: l.uiTasksGroupCoord,
                icon: NzIcons.coordinatorships,
                value: selection(s.filter.coordinatorships.length),
                valueSet: s.filter.coordinatorships.isNotEmpty,
                content: choices([
                  for (final (co, n) in options.coordinatorships)
                    TaskCheckRow(
                      label: co.name,
                      count: n,
                      square: true,
                      selected: s.filter.coordinatorships.contains(co.code),
                      onTap: () => ctl.toggleCoordinatorship(co.code),
                    ),
                ]),
              ),
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
                    if (s.filter.priorities.contains(p)) i,
                },
                onSelected: (i) => ctl.togglePriority(TaskPriority.pickable[i]),
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        Text(
          l.uiTasksFilterHint,
          style: context.text.caption.copyWith(color: c.textMuted),
        ),
      ],
    );
  }
}
