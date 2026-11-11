import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';

/// Görevler bölümü (prototip `tTask`): "Açık · 8 görev", süz ve "Görevler sayfasında aç"
/// düğmeleri, kişi süzgeci çipi, görev kartları (genişte iki sütun).
class CoordTasksTab extends ConsumerWidget {
  const CoordTasksTab({
    super.key,
    required this.code,
    required this.catalog,
    required this.people,
  });

  final String code;
  final TaskCatalog catalog;
  final List<CoordPerson> people;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final provider = coordinatorshipDetailControllerProvider(code);
    final view = ref.watch(provider);
    final commands = ref.read(provider.notifier);
    final all = coordSortedTasks(catalog.tasksOf(code));
    final list = [
      for (final task in all)
        if (view.filter.matches(task) && view.extra.matches(task, catalog))
          task,
    ];
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth >= coordWideWidth ? 2 : 1;
        final cards = [
          for (final task in list)
            TaskCardView(
              task: task,
              catalog: catalog,
              showGroup: false,
              fill: columns > 1,
              onTap: () => context.appNav.openTask(task.code),
            ),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CoordSubhead(
              label: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: l.coordFilterLabel(view.filter),
                      style: t.bodySm.copyWith(
                        color: c.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' · ${l.coordTaskCount(list.length)}'),
                  ],
                ),
                style: t.bodySm.copyWith(color: c.textMuted),
              ),
              actions: [
                NzIconButton.circle(
                  icon: NzIcons.filter,
                  semanticLabel: l.uiCoordFilter,
                  dot: view.filtered ? c.accentText : null,
                  onPressed: () => _showFilter(context, ref, code, all),
                ),
                const Gap(NizamioSpacing.space2),
                NzIconButton.circle(
                  icon: NzIcons.northEast,
                  semanticLabel: l.uiCoordOpenInTasks,
                  onPressed: () => context.appNav.openTasks(
                    view: _taskView(view.filter),
                    people: view.extra.people.toList(),
                    coordinatorship: code,
                  ),
                ),
              ],
            ),
            if (view.extra.hasExtra)
              Padding(
                padding: const EdgeInsets.only(top: NizamioSpacing.space2),
                child: TaskFilterGroups(
                  filter: view.extra,
                  catalog: catalog,
                  onEdit: (group) =>
                      _showFilter(context, ref, code, all, initialGroup: group),
                  onRemove: commands.clearGroup,
                  onClear: commands.clearExtra,
                ),
              ),
            const Gap(NizamioSpacing.space3),
            if (cards.isEmpty)
              CoordEmpty(l.uiCoordNoTasks)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  for (var i = 0; i < cards.length; i += columns)
                    columns == 1
                        ? cards[i]
                        : TaskCardRow(
                            cards: cards.sublist(
                              i,
                              (i + columns).clamp(0, cards.length),
                            ),
                            columns: columns,
                          ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// Açık görevler bitişe göre önce, sonra bitenler (yeniden eskiye).
List<TaskItem> coordSortedTasks(List<TaskItem> tasks) {
  final open = tasks.where((t) => !t.isDone).toList()
    ..sort((a, b) => a.due.compareTo(b.due));
  final done = tasks.where((t) => t.isDone).toList()
    ..sort((a, b) => b.due.compareTo(a.due));
  return [...open, ...done];
}

NzTaskView _taskView(CoordTaskFilter f) => switch (f) {
  CoordTaskFilter.open || CoordTaskFilter.all => NzTaskView.all,
  CoordTaskFilter.late => NzTaskView.late,
  CoordTaskFilter.review => NzTaskView.review,
  CoordTaskFilter.dateRequest => NzTaskView.dateRequest,
  CoordTaskFilter.notStarted => NzTaskView.notStarted,
  CoordTaskFilter.done => NzTaskView.done,
};

void _showFilter(
  BuildContext context,
  WidgetRef ref,
  String code,
  List<TaskItem> all, {
  TaskFilterGroup? initialGroup,
}) {
  final provider = coordinatorshipDetailControllerProvider(code);
  final catalog = ref.read(taskCatalogControllerProvider).value!;
  final scoped = catalog.filtered(
    codes: [for (final task in all) task.code],
    truncated: catalog.truncated,
  );
  showSharedTasksFilterSheet(
    context,
    initialGroup: initialGroup,
    data: (ref) {
      final view = ref.watch(provider);
      final ctl = ref.read(provider.notifier);
      return TasksFilterSheetData(
        filter: view.extra,
        options: filterOptions(scoped),
        truncated: scoped.truncated,
        count: all
            .where(
              (t) => view.filter.matches(t) && view.extra.matches(t, scoped),
            )
            .length,
        onClear: ctl.clearExtra,
        onPerson: ctl.togglePerson,
        onCoordinatorship: ctl.toggleCoordinatorship,
        onPriority: ctl.togglePriority,
      );
    },
  );
}
