import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/nz_group_filter_chip.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';

/// Görev filtre türlerini tek birer düzenlenebilir çip halinde sunar.
class TaskFilterGroups extends StatelessWidget {
  const TaskFilterGroups({
    super.key,
    required this.filter,
    required this.catalog,
    required this.onEdit,
    required this.onRemove,
    required this.onClear,
  });
  final TaskFilter filter;
  final TaskCatalog catalog;
  final ValueChanged<TaskFilterGroup> onEdit;
  final ValueChanged<TaskFilterGroup> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!filter.hasExtra) return const SizedBox.shrink();
    Widget chip(
      TaskFilterGroup group,
      String kind,
      String value, {
      String? keyLabel,
    }) => NzGroupFilterChip(
      key: ValueKey(group),
      label: keyLabel,
      value: value,
      editLabel:
          '$kind ${l.uiTasksFilterEdit.split(':').first}: $value · ${l.uiTasksFilterEdit.split(':').last.trim()}',
      removeLabel: '$kind ${l.uiTasksFilterRemove}',
      onEdit: () => onEdit(group),
      onRemove: () => onRemove(group),
    );
    final person = filter.people.length == 1
        ? catalog.nameOf(filter.people.first) ?? l.uiTasksUnknownPerson
        : '${filter.people.length} ${l.uiTasksPeopleCount}';
    final coord = filter.coordinatorships.length == 1
        ? catalog.coordinatorship(filter.coordinatorships.first)?.name ??
              filter.coordinatorships.first
        : '${filter.coordinatorships.length} ${l.uiTasksCoordCount}';
    final priority = [
      for (final p in [
        TaskPriority.high,
        TaskPriority.medium,
        TaskPriority.low,
        TaskPriority.urgent,
        TaskPriority.unknown,
      ])
        if (filter.priorities.contains(p)) l.priorityLabel(p),
    ].join(', ');
    return Semantics(
      label: l.uiTasksActiveFilters,
      explicitChildNodes: true,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (filter.people.isNotEmpty)
            chip(
              TaskFilterGroup.people,
              l.uiTasksGroupPeople,
              person,
              keyLabel: l.uiTasksGroupPeople,
            ),
          if (filter.coordinatorships.isNotEmpty)
            chip(
              TaskFilterGroup.coordinatorship,
              l.uiTasksGroupCoord,
              coord,
              keyLabel: filter.coordinatorships.length > 1
                  ? l.uiTasksGroupCoord
                  : null,
            ),
          if (filter.priorities.isNotEmpty)
            chip(
              TaskFilterGroup.priority,
              l.uiTasksPriority,
              priority,
              keyLabel: l.uiTasksPriority,
            ),
          Semantics(
            button: true,
            label: l.uiTasksClear,
            child: InkWell(
              onTap: onClear,
              child: SizedBox(
                height: 26,
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    l.uiTasksClear,
                    style: context.text.caption.copyWith(
                      fontSize: 12,
                      color: context.colors.textMuted,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
