import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/task_list_filter.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';
import 'task_view_grid.dart';

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
  final truncated =
      container.read(taskListCatalogProvider).value?.truncated ?? false;
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
          count: '${truncated ? '≥' : ''}${r.counts[v] ?? 0}',
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
