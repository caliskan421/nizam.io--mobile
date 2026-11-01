import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/tasks_list_controller.dart';
import '../../domain/task_catalog.dart';
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
    final t = context.text;
    final s = ref.watch(provider);
    final ctl = ref.read(provider.notifier);
    final options = ref.watch(taskFilterOptionsProvider);
    if (options == null) return const SizedBox.shrink();

    Widget group(
      TaskFilterGroup g,
      String label,
      int selectedCount,
      List<Widget> options,
    ) {
      final open = s.openFilterGroups.contains(g);
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: c.border, width: NizamioSize.borderWidth),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              button: true,
              expanded: open,
              label: label,
              excludeSemantics: true,
              child: InkWell(
                onTap: () => ctl.toggleFilterGroup(g),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: NizamioSize.row),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: t.list.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        selectedCount > 0
                            ? '$selectedCount ${l.uiTasksSelectedTail}'
                            : l.uiTasksAllLc,
                        style: t.caption.copyWith(
                          color: selectedCount > 0 ? c.accentText : c.textFaint,
                        ),
                      ),
                      const Gap(NizamioSpacing.gapMd),
                      AnimatedRotation(
                        turns: open ? 0 : -0.25,
                        duration: NzMotion.of(context, NizamioMotion.durPress),
                        child: NzIcon(
                          NzIcons.chevronDown,
                          size: NizamioSize.iconSizeSm,
                          color: c.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            NzReveal(
              open: open,
              child: Padding(
                padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
                child: Column(children: options),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        group(
          TaskFilterGroup.people,
          l.uiTasksGroupPeople,
          s.filter.people.length,
          [
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
          ],
        ),
        // Sunucu kataloğunda seçenek yok (departman süzgeci sunucudadır).
        if (options.coordinatorships.isNotEmpty)
          group(
            TaskFilterGroup.coordinatorship,
            l.uiTasksGroupCoord,
            s.filter.coordinatorships.length,
            [
              for (final (co, n) in options.coordinatorships)
                TaskCheckRow(
                  label: co.name,
                  count: n,
                  square: true,
                  selected: s.filter.coordinatorships.contains(co.code),
                  onTap: () => ctl.toggleCoordinatorship(co.code),
                ),
            ],
          ),
        group(
          TaskFilterGroup.priority,
          l.uiTasksPriority,
          s.filter.priorities.length,
          [
            for (final p in TaskPriority.pickable.reversed)
              TaskCheckRow(
                label: l.priorityLabel(p),
                count: options.priorities[p] ?? 0,
                square: true,
                selected: s.filter.priorities.contains(p),
                leading: NzPriorityBars(level: priorityLevel(p)),
                onTap: () => ctl.togglePriority(p),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space1),
        Text(
          l.uiTasksFilterHint,
          style: t.caption.copyWith(color: c.textMuted),
        ),
      ],
    );
  }
}
