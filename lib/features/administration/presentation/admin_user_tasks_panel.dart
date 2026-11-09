import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../calendar/calendar.dart';
import '../../tasks/tasks.dart';
import '../application/admin_user_task_panel_controller.dart';
import '../domain/admin_user_tasks.dart';
import 'admin_user_task_filter_sheet.dart';
import 'admin_user_task_row.dart';
import 'admin_user_task_summary.dart';
import 'admin_user_task_texts.dart';

/// Profilin NzPage.feed.after listesine doğrudan yayılır. Gruplar ve her görev ayrı
/// sliver-list öğesidir; uzun görev dizini tek Column içinde kurulmaz.
List<Widget> adminUserTaskPanelChildren(
  BuildContext context,
  WidgetRef ref, {
  required String accountId,
  required TaskCatalog catalog,
}) {
  final provider = adminUserTaskPanelProvider(accountId);
  final state = ref.watch(provider);
  final ctl = ref.read(provider.notifier);
  final tasks = catalog.tasks
      .where((t) => t.assignees.contains(accountId))
      .toList();
  final shown = state.select(tasks);
  final c = context.colors;
  final l = context.l10n;
  final result = <Widget>[
    AdminUserTaskSummary(tasks: tasks, truncated: catalog.truncated),
    const Gap(12),
    Row(
      children: [
        SizedBox(
          width: 170,
          child: NzPillTabs(
            compact: true,
            semanticLabel: l.uiUsersTasks,
            tabs: [
              NzPillTab(label: l.uiTasksModeList),
              NzPillTab(label: l.uiUsersCalendar),
            ],
            selected: state.view.index,
            onSelected: (i) => ctl.show(UserTaskView.values[i]),
          ),
        ),
        const Spacer(),
        NzIconButton.circle(
          icon: NzIcons.filter,
          semanticLabel: l.uiUsersTaskFilters,
          dot: state.filtered ? c.accentText : null,
          onPressed: () => showAdminUserTaskFilters(context, accountId),
        ),
      ],
    ),
  ];
  if (state.filtered) {
    result.add(
      Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final status in UserTaskStatus.values)
            if (state.statuses.contains(status))
              InputChip(
                label: Text(userTaskFilterLabel(context, status)),
                onDeleted: () => ctl.toggleStatus(status),
              ),
          for (final priority in TaskPriority.values)
            if (state.priorities.contains(priority))
              InputChip(
                label: Text(
                  '${userTaskPriorityLabel(context, priority)} ${l.uiUsersTaskPriorityChip}',
                ),
                onDeleted: () => ctl.togglePriority(priority),
              ),
          TextButton(onPressed: ctl.clear, child: Text(l.uiTasksClear)),
        ],
      ),
    );
  }
  if (catalog.truncated) {
    result.add(
      Text(
        l.uiUsersPartial,
        style: context.text.caption.copyWith(color: c.textMuted),
      ),
    );
  }
  result.add(
    Padding(
      key: ValueKey(('person-calendar', accountId)),
      padding: EdgeInsets.only(
        top: state.view == UserTaskView.calendar ? 12 : 0,
      ),
      child: PersonTaskCalendar(
        accountId: accountId,
        visible: state.view == UserTaskView.calendar,
      ),
    ),
  );
  if (state.view == UserTaskView.calendar) {
    return result;
  }
  if (shown.isEmpty) {
    result.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(l.uiUsersNoTasks, style: context.text.caption),
      ),
    );
  }
  for (final group in UserTaskGroup.values) {
    final rows = shown
        .where((t) => userTaskGroup(t, catalog.today) == group)
        .toList();
    if (rows.isEmpty) continue;
    result.add(
      Padding(
        key: ValueKey(('group', group)),
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
        child: Row(
          children: [
            Text(
              userTaskGroupLabel(context, group),
              style: context.text.caption.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: group == UserTaskGroup.late
                    ? c.danger
                    : group == UserTaskGroup.done
                    ? c.accentText
                    : c.textMuted,
              ),
            ),
            const Gap(8),
            Text(
              '${rows.length}${catalog.truncated ? '+' : ''}',
              style: context.text.monoSm.copyWith(
                fontSize: 11,
                color: c.textFaint,
              ),
            ),
          ],
        ),
      ),
    );
    for (final (i, task) in rows.indexed)
      result.add(
        NzEntrance(
          key: ValueKey(('user-task', task.code)),
          replay: (
            accountId,
            state.view,
            state.statuses,
            state.priorities,
            task.code,
          ),
          index: 0,
          child: AdminUserTaskRow(
            task: task,
            today: catalog.today,
            first: i == 0,
            last: i == rows.length - 1,
          ),
        ),
      );
  }
  return result;
}
