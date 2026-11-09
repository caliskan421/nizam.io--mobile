import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/nz_progress_bar.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';

class AdminUserTaskSummary extends StatelessWidget {
  const AdminUserTaskSummary({
    super.key,
    required this.tasks,
    required this.truncated,
    required this.onFilter,
  });
  final List<TaskItem> tasks;
  final bool truncated;
  final ValueChanged<int> onFilter;
  static const _wideWidth = 720.0;
  static const _singleWidth = 280.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final done = tasks.where((t) => t.isDone).length;
    final open = tasks.length - done;
    final late = tasks.where((t) => !t.isDone && t.isOverdue).length;
    final review = tasks.where((t) => t.status == TaskStatus.review).length;
    final completion = tasks.isEmpty ? 0.0 : done / tasks.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.uiUsersScopeNote, style: context.text.caption),
        if (truncated) Text(l.uiUsersPartial, style: context.text.caption),
        const Gap(NizamioSpacing.gapMd),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= _wideWidth
                ? 4
                : constraints.maxWidth < _singleWidth
                ? 1
                : 2;
            final width =
                (constraints.maxWidth - (columns - 1) * NizamioSpacing.gapMd) /
                columns;
            final cards = [
              NzKpiTile(
                icon: NzIcons.checkCircle,
                tone: c.accentText,
                label: l.uiUsersKpiCompletion,
                value: '${(completion * 100).round()}%',
                progress: completion,
                caption: '$done / ${tasks.length} ${l.uiUsersTasks}',
                onTap: () => onFilter(4),
              ),
              NzKpiTile(
                icon: NzIcons.tasks,
                tone: c.inProgress,
                label: l.uiUsersKpiOpen,
                value: '$open',
                progress: tasks.isEmpty ? 0 : open / tasks.length,
                caption: l.uiUsersTasks,
                onTap: () => onFilter(1),
              ),
              NzKpiTile(
                icon: NzIcons.clock,
                tone: c.danger,
                label: l.uiUsersKpiLate,
                value: '$late',
                progress: tasks.isEmpty ? 0 : late / tasks.length,
                caption: l.uiUsersTasks,
                onTap: () => onFilter(2),
              ),
              NzKpiTile(
                icon: NzIcons.checkAll,
                tone: c.warning,
                label: l.uiUsersKpiReview,
                value: '$review',
                progress: tasks.isEmpty ? 0 : review / tasks.length,
                caption: l.uiUsersTasks,
                onTap: () => onFilter(3),
              ),
            ];
            return Wrap(
              spacing: NizamioSpacing.gapMd,
              runSpacing: NizamioSpacing.gapMd,
              children: [
                for (final card in cards) SizedBox(width: width, child: card),
              ],
            );
          },
        ),
        const Gap(NizamioSpacing.gapMd),
        Text(l.uiUsersDistribution, style: context.text.labelLg),
        for (final status in TaskStatus.values)
          if (tasks.any((task) => task.status == status)) ...[
            const Gap(NizamioSpacing.space2),
            Text(
              '${switch (status) {
                TaskStatus.todo => l.uiUsersNotStarted,
                TaskStatus.inProgress => l.uiUsersInProgress,
                TaskStatus.review => l.uiUsersReview,
                TaskStatus.returned => l.uiUsersReturned,
                TaskStatus.done => l.uiUsersDone,
                TaskStatus.unknown => l.uiUsersUnknownStatus,
              }} · ${tasks.where((task) => task.status == status).length} · ${(tasks.where((task) => task.status == status).length / tasks.length * 100).round()}%',
              style: context.text.caption,
            ),
            NzProgressBar(
              value:
                  tasks.where((task) => task.status == status).length /
                  tasks.length,
              color: c.accentText,
            ),
          ],
        const Gap(NizamioSpacing.gapMd),
      ],
    );
  }
}
