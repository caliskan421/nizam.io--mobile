import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/admin_user_task_panel_controller.dart';
import '../domain/admin_user_tasks.dart';
import 'admin_user_task_texts.dart';

Future<void> showAdminUserTaskFilters(
  BuildContext context,
  String accountId,
) => NzBottomSheet.show<void>(
  context,
  title: context.l10n.uiUsersTaskFilters,
  description: context.l10n.uiUsersTaskFilterHint,
  builder: (_) => _Filters(accountId: accountId),
  actions: (sheet) => [
    Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(adminUserTaskPanelProvider(accountId));
        final catalog = ref.watch(taskCatalogControllerProvider);
        final tasks =
            catalog.value?.tasks.where(
              (t) => t.assignees.contains(accountId),
            ) ??
            const <TaskItem>[];
        return NzButton.primary(
          label:
              '${state.select(tasks).length} ${context.l10n.uiUsersTaskShowCount}',
          expand: true,
          onPressed: () => Navigator.of(sheet).pop(),
        );
      },
    ),
  ],
);

class _Filters extends ConsumerWidget {
  const _Filters({required this.accountId});
  final String accountId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminUserTaskPanelProvider(accountId);
    final state = ref.watch(provider);
    final ctl = ref.read(provider.notifier);
    final catalog = ref.watch(taskCatalogControllerProvider);
    if (catalog.isReloading ||
        catalog.hasError ||
        catalog.value?.access?.companyAdmin != true) {
      return const SizedBox.shrink();
    }
    final tasks = catalog.requireValue.tasks
        .where((t) => t.assignees.contains(accountId))
        .toList();
    String number(int n) => '$n${catalog.requireValue.truncated ? '+' : ''}';
    final priorities = <TaskPriority>[
      TaskPriority.high,
      TaskPriority.medium,
      TaskPriority.low,
      if (tasks.any((t) => t.priority == TaskPriority.urgent))
        TaskPriority.urgent,
      if (tasks.any((t) => t.priority == TaskPriority.unknown))
        TaskPriority.unknown,
    ];
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NizamioSpacing.space2,
        mainAxisSize: MainAxisSize.min,
        children: [
          NzKicker(context.l10n.uiUsersTaskStatusGroup),
          for (final status in UserTaskStatus.values)
            NzCheckbox(
              label: userTaskFilterLabel(context, status),
              value: state.statuses.contains(status),
              trailing: Text(
                number(
                  tasks
                      .where(
                        (t) =>
                            state.matchesPriority(t) &&
                            userTaskHasStatus(t, status),
                      )
                      .length,
                ),
                style: context.text.monoSm,
              ),
              onChanged: (_) => ctl.toggleStatus(status),
            ),
          NzKicker(context.l10n.uiUsersTaskPriorityGroup),
          for (final priority in priorities)
            NzCheckbox(
              label: userTaskPriorityLabel(context, priority),
              value: state.priorities.contains(priority),
              trailing: Text(
                number(
                  tasks
                      .where(
                        (t) => state.matchesStatus(t) && t.priority == priority,
                      )
                      .length,
                ),
                style: context.text.monoSm,
              ),
              onChanged: (_) => ctl.togglePriority(priority),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: NzButton.ghost(
              label: context.l10n.uiTasksClearFilters,
              onPressed: ctl.clear,
            ),
          ),
        ],
      ),
    );
  }
}
