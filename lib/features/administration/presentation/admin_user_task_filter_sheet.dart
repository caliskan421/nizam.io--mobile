import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/nz_check_circle.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
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
  showHeader: false,
  actionsDivider: false,
  backgroundColor: context.colors.background,
  builder: (_) => _Filters(accountId: accountId),
  // Tek ortak slot içinde eşit sütunlar: genel 1:2 form-footer davranışı değişmez.
  actions: (sheet) => [
    Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(adminUserTaskPanelProvider(accountId));
        final ctl = ref.read(adminUserTaskPanelProvider(accountId).notifier);
        final catalog = ref.watch(taskCatalogControllerProvider);
        final tasks =
            catalog.value?.tasks.where(
              (t) => t.assignees.contains(accountId),
            ) ??
            const <TaskItem>[];
        final count =
            '${state.select(tasks).length}${catalog.value?.truncated == true ? '+' : ''}';
        return Row(
          spacing: 8,
          children: [
            Expanded(
              child: NzButton.secondary(
                label: context.l10n.uiTasksClear,
                expand: true,
                onPressed: ctl.clear,
              ),
            ),
            Expanded(
              child: NzButton.primary(
                label: '$count ${context.l10n.uiUsersTaskShowCount}',
                expand: true,
                onPressed: () => Navigator.of(sheet).pop(),
              ),
            ),
          ],
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
        !ref.watch(effectiveAccessProvider).canAdminister) {
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
    Widget kicker(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 0, 6),
      child: Text(
        text,
        style: context.text.monoSm.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: context.colors.textFaint,
          letterSpacing: .24,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        context.l10n.uiUsersTaskFilters,
                        style: context.text.titleSm,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${number(state.select(tasks).length)} ${context.l10n.uiUsersTaskFilterCountHint}',
                      style: context.text.caption.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NzIconButton(
              icon: NzIcons.close,
              semanticLabel: context.l10n.uiCommonClose,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const Gap(14),
        kicker(context.l10n.uiUsersTaskStatusGroup),
        _OptionGroup(
          children: [
            for (final status in UserTaskStatus.values)
              _Option(
                label: userTaskFilterLabel(context, status),
                selected: state.statuses.contains(status),
                count: number(
                  tasks
                      .where(
                        (t) =>
                            state.matchesPriority(t) &&
                            userTaskHasStatus(t, status),
                      )
                      .length,
                ),
                onTap: () => ctl.toggleStatus(status),
              ),
          ],
        ),
        const Gap(14),
        kicker(context.l10n.uiUsersTaskPriorityGroup),
        _OptionGroup(
          separated: true,
          children: [
            for (final priority in priorities)
              _Option(
                label: userTaskPriorityLabel(context, priority),
                selected: state.priorities.contains(priority),
                count: number(
                  tasks
                      .where(
                        (t) => state.matchesStatus(t) && t.priority == priority,
                      )
                      .length,
                ),
                onTap: () => ctl.togglePriority(priority),
              ),
          ],
        ),
      ],
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({required this.children, this.separated = false});
  final List<Widget> children;
  final bool separated;
  @override
  Widget build(BuildContext context) {
    if (separated) {
      return Column(
        spacing: NizamioSpacing.space2,
        children: [
          for (final child in children)
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface,
                border: Border.all(color: context.colors.border),
                borderRadius: BorderRadius.circular(NizamioRadius.tile),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(NizamioRadius.tile),
                child: Material(type: MaterialType.transparency, child: child),
              ),
            ),
        ],
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(NizamioRadius.card),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NizamioRadius.card),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    color: context.colors.border,
                  ),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Option extends StatefulWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.count,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final String count;
  final VoidCallback onTap;
  @override
  State<_Option> createState() => _OptionState();
}

class _OptionState extends State<_Option> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      checked: widget.selected,
      label: '${widget.label}, ${widget.count}',
      onTap: widget.onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IgnorePointer(
                  child: AnimatedScale(
                    scale: _down ? .88 : 1,
                    duration: NzMotion.of(
                      context,
                      const Duration(milliseconds: 300),
                    ),
                    curve: const Cubic(.34, 1.56, .64, 1),
                    child: SizedBox(
                      width: 22,
                      child: NzCheckCircle(
                        value: widget.selected,
                        label: widget.label,
                        selectedColor: c.primary,
                        unselectedBorderColor: c.borderControl,
                        onChanged: widget.onTap,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: context.text.bodyMd.copyWith(fontSize: 14),
                  ),
                ),
                const Gap(12),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 44),
                  child: Text(
                    widget.count,
                    textAlign: TextAlign.right,
                    style: context.text.monoSm.copyWith(
                      fontSize: 11,
                      color: c.textFaint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
