import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/inputs/nz_filter_choice.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_list_filter.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';
import '../task_widgets.dart';

/// Filtre alt sayfası (prototip görevler `sheet`): Kişi, Koordinatörlük, Öncelik açılır
/// grupları; seçenekte sayı (tüm görevler üzerinden); "N görevi göster" seçili görünümün
/// sonucu.
Future<void> showTasksFilterSheet(
  BuildContext context, {
  required TasksListControllerProvider provider,
  TaskFilterGroup? initialGroup,
}) {
  return showSharedTasksFilterSheet(
    context,
    initialGroup: initialGroup,
    data: (ref) {
      final state = ref.watch(provider);
      final ctl = ref.read(provider.notifier);
      final options = ref.watch(taskFilterOptionsProvider);
      final result = ref.watch(tasksListResultOf(provider));
      final truncated =
          ref.watch(taskListCatalogProvider).value?.truncated ?? false;
      return TasksFilterSheetData(
        filter: state.filter,
        options: options,
        count: result?.tasks.length,
        truncated: truncated,
        onClear: ctl.clearExtra,
        onPerson: ctl.togglePerson,
        onCoordinatorship: ctl.toggleCoordinatorship,
        onPriority: ctl.togglePriority,
      );
    },
  );
}

/// Ortak filtre paneli; çağıran kapsam ve denetleyici durumunu sağlar.
Future<void> showSharedTasksFilterSheet(
  BuildContext context, {
  required TasksFilterSheetData Function(WidgetRef) data,
  TaskFilterGroup? initialGroup,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiTasksFilters,
    headerAction: Consumer(
      builder: (_, ref, _) =>
          TaskLink(label: l.uiTasksClearAll, onTap: data(ref).onClear),
    ),
    actions: (sheet) => [
      Consumer(
        builder: (_, ref, _) => NzButton.secondary(
          label: l.uiTasksClear,
          expand: true,
          onPressed: data(ref).onClear,
        ),
      ),
      Consumer(
        builder: (_, ref, _) {
          final d = data(ref);
          final n = d.count == null
              ? '—'
              : '${d.truncated ? '≥' : ''}${d.count}';
          return NzButton.primary(
            label: '$n ${l.uiTasksShowTasksTail}',
            expand: true,
            onPressed: () => Navigator.of(sheet).maybePop(),
          );
        },
      ),
    ],
    builder: (_) => Consumer(
      builder: (_, ref, _) =>
          _FilterBody(data: data(ref), initialGroup: initialGroup),
    ),
  );
}

class TasksFilterSheetData {
  const TasksFilterSheetData({
    required this.filter,
    required this.options,
    required this.count,
    required this.truncated,
    required this.onClear,
    required this.onPerson,
    required this.onCoordinatorship,
    required this.onPriority,
  });
  final TaskFilter filter;
  final TaskFilterOptions? options;
  final int? count;
  final bool truncated;
  final VoidCallback onClear;
  final ValueChanged<String> onPerson;
  final ValueChanged<String> onCoordinatorship;
  final ValueChanged<TaskPriority> onPriority;
}

class _FilterBody extends StatefulWidget {
  const _FilterBody({required this.data, this.initialGroup});
  final TasksFilterSheetData data;
  final TaskFilterGroup? initialGroup;
  @override
  State<_FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<_FilterBody> {
  int? _open;
  @override
  void initState() {
    super.initState();
    _open = switch (widget.initialGroup) {
      TaskFilterGroup.people => 0,
      TaskFilterGroup.coordinatorship => 1,
      TaskFilterGroup.priority || null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final filter = widget.data.filter;
    final options = widget.data.options;
    final truncated = widget.data.truncated;
    if (options == null) return const SizedBox.shrink();

    String selection(int count) =>
        count == 0 ? l.uiTasksAllLc : '$count ${l.uiTasksSelectedTail}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzFormRows(
          expandedIndex: _open,
          onToggle: (index) =>
              setState(() => _open = _open == index ? null : index),
          rows: [
            NzFormRow(
              label: l.uiTasksGroupPeople,
              icon: NzIcons.person,
              value: selection(filter.people.length),
              valueSet: filter.people.isNotEmpty,
              content: NzFilterChoices(
                children: [
                  for (final (p, n) in options.people)
                    NzFilterChoice(
                      label: p.name,
                      count: '${truncated ? '≥' : ''}$n',
                      selected: filter.people.contains(p.id),
                      onTap: () => widget.data.onPerson(p.id),
                    ),
                ],
              ),
            ),
            if (options.coordinatorships.isNotEmpty)
              NzFormRow(
                label: l.uiTasksGroupCoord,
                icon: NzIcons.coordinatorships,
                value: selection(filter.coordinatorships.length),
                valueSet: filter.coordinatorships.isNotEmpty,
                content: NzFilterChoices(
                  children: [
                    for (final (co, n) in options.coordinatorships)
                      NzFilterChoice(
                        label: co.name,
                        count: '${truncated ? '≥' : ''}$n',
                        selected: filter.coordinatorships.contains(co.code),
                        onTap: () => widget.data.onCoordinatorship(co.code),
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
                    if (filter.priorities.contains(p)) i,
                },
                onSelected: (i) =>
                    widget.data.onPriority(TaskPriority.pickable[i]),
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

String taskPriorityLabel(AppLocalizations l, TaskPriority priority) =>
    l.priorityLabel(priority);
