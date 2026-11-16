import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';

class ProfileWork extends ConsumerWidget {
  const ProfileWork({super.key, required this.catalog});
  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final view = ref.watch(effectiveAccessProvider);
    if (!view.known) return const SizedBox.shrink();
    final visible = scopedTasks(
      catalog.tasks,
      role: view.role,
      departmentId: view.departmentId,
      me: catalog.me,
    );
    final personal = visible
        .where((task) => task.assignees.contains(catalog.me))
        .toList();
    final department = view.departmentId;
    final coordinated = [
      for (final task in catalog.tasks)
        if (view.isCoordinatorView && task.departmentId == department) task,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (catalog.truncated) ...[
          Text(
            l.uiIdentityProfilePartial,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          const Gap(NizamioSpacing.space4),
        ],
        _WorkSummary(
          title: l.uiIdentityProfilePersonalWork,
          tasks: personal,
          truncated: catalog.truncated,
          open: (filter) =>
              context.appNav.openTasks(view: filter, people: [catalog.me]),
        ),
        if (view.isCoordinatorView && department != null) ...[
          const Gap(NizamioSpacing.space6),
          _WorkSummary(
            title: view.departmentName ?? l.uiIdentityProfileTeamWork,
            tasks: coordinated,
            truncated: catalog.truncated,
            review: true,
            open: (filter) => context.appNav.openTasks(
              view: filter,
              coordinatorship: department,
            ),
          ),
        ],
        if (view.isAdminView || department != null) ...[
          const Gap(NizamioSpacing.space6),
          NzMenuGroup(
            rows: [
              NzMenuRow(
                icon: NzIcons.group,
                label: view.isAdminView
                    ? l.uiHomeModuleUsers
                    : l.uiHomeModuleTeam,
                onTap: () => context.appNav.openUsers(),
              ),
              if (view.isAdminView)
                NzMenuRow(
                  icon: NzIcons.coordinatorships,
                  label: l.uiHomeCoordinatorships,
                  onTap: () => context.appNav.openCoordinatorships(),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _WorkSummary extends StatelessWidget {
  const _WorkSummary({
    required this.title,
    required this.tasks,
    required this.truncated,
    required this.open,
    this.review = false,
  });
  final String title;
  final List<TaskItem> tasks;
  final bool truncated;
  final bool review;
  final ValueChanged<NzTaskView> open;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final metrics = [
      (
        label: l.uiUsersTasks,
        count: tasks.length,
        filter: NzTaskView.all,
        tone: c.primary,
        icon: NzIcons.tasks,
      ),
      (
        label: l.uiHomeKpiDoing,
        count: tasks.where((t) => t.status == TaskStatus.inProgress).length,
        filter: NzTaskView.inProgress,
        tone: c.inProgress,
        icon: NzIcons.clock,
      ),
      (
        label: l.uiHomeKpiLate,
        count: tasks.where((t) => t.lateness?.isOverdue ?? t.isOverdue).length,
        filter: NzTaskView.late,
        tone: c.danger,
        icon: NzIcons.error,
      ),
      (
        label: review ? l.uiHomeKpiReview : l.uiTasksStatusDone,
        count: tasks
            .where(
              (t) => t.status == (review ? TaskStatus.review : TaskStatus.done),
            )
            .length,
        filter: review ? NzTaskView.review : NzTaskView.done,
        tone: review ? c.warning : c.taskDone,
        icon: NzIcons.checkCircle,
      ),
    ];
    return NzSection(
      title: title,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns =
              constraints.maxWidth >= 320 &&
                  MediaQuery.textScalerOf(context).scale(1) <= 1.3
              ? 2
              : 1;
          final width =
              (constraints.maxWidth - NizamioSpacing.space3 * (columns - 1)) /
              columns;
          return Wrap(
            spacing: NizamioSpacing.space3,
            runSpacing: NizamioSpacing.space3,
            children: [
              for (final metric in metrics)
                SizedBox(
                  width: width,
                  child: NzKpiTile(
                    label: metric.label,
                    value: '${metric.count}${truncated ? '+' : ''}',
                    tone: metric.tone,
                    icon: metric.icon,
                    onTap: () => open(metric.filter),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
