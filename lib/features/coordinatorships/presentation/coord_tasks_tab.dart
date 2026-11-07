import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';
import 'coord_widgets.dart';

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
        if (view.filter.matches(task) &&
            (view.person == null || task.assignees.contains(view.person)))
          task,
    ];
    final person = people.where((p) => p.id == view.person).firstOrNull;
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
                  onPressed: () => _showFilter(
                    context,
                    ref,
                    code,
                    all,
                    view.filter,
                    view.person,
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                NzIconButton.circle(
                  icon: NzIcons.northEast,
                  semanticLabel: l.uiCoordOpenInTasks,
                  onPressed: () => context.appNav.openTasks(
                    view: _taskView(view.filter),
                    people: [?view.person],
                  ),
                ),
              ],
            ),
            if (person != null)
              Padding(
                padding: const EdgeInsets.only(top: NizamioSpacing.space2),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: NizamioSpacing.space2,
                  children: [
                    InputChip(
                      label: Text(person.name),
                      onDeleted: () => commands.setPerson(null),
                    ),
                    CoordLink(
                      label: l.uiCoordClear,
                      onTap: commands.clearFilter,
                    ),
                  ],
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

/// Süzgeç alt sayfası (prototip `tf`): durum (sayılarıyla) ve atanan kişi; seçim sayfayı kapatır.
void _showFilter(
  BuildContext context,
  WidgetRef ref,
  String code,
  List<TaskItem> all,
  CoordTaskFilter filter,
  String? person,
) {
  final l = context.l10n;
  final commands = ref.read(
    coordinatorshipDetailControllerProvider(code).notifier,
  );
  final catalog = ref.read(taskCatalogControllerProvider).value;
  final assignees = <String>{for (final t in all) ...t.assignees};
  NzBottomSheet.show<void>(
    context,
    title: l.uiCoordFilter,
    builder: (sheet) {
      Widget check(bool on) => on
          ? NzIcon(NzIcons.check, color: sheet.colors.accentText)
          : const SizedBox.shrink();
      void pick(VoidCallback f) {
        Navigator.of(sheet).pop();
        f();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NizamioSpacing.gapMd,
        children: [
          NzMenuGroup(
            label: l.uiCoordFilterStatus,
            rows: [
              for (final f in CoordTaskFilter.values)
                NzMenuRow(
                  icon: f == filter ? NzIcons.checkCircle : NzIcons.tasks,
                  label:
                      '${l.coordFilterLabel(f)} · ${all.where(f.matches).length}',
                  current: f == filter,
                  trailing: check(f == filter),
                  onTap: () => pick(() => commands.setFilter(f)),
                ),
            ],
          ),
          if (assignees.isNotEmpty)
            NzMenuGroup(
              label: l.uiCoordFilterPerson,
              rows: [
                NzMenuRow(
                  icon: NzIcons.group,
                  label: l.uiCoordEveryone,
                  current: person == null,
                  trailing: check(person == null),
                  onTap: () => pick(() => commands.setPerson(null)),
                ),
                for (final id in assignees)
                  NzMenuRow(
                    icon: NzIcons.person,
                    label: catalog?.nameOf(id) ?? id,
                    current: person == id,
                    trailing: check(person == id),
                    onTap: () => pick(() => commands.setPerson(id)),
                  ),
              ],
            ),
        ],
      );
    },
  );
}
