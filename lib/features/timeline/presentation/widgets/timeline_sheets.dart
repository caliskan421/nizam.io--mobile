import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/inputs/nz_filter_choice.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/timeline_controller.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';

/// Telefon çizelgesinin kişi, koordinatörlük ve öncelik filtreleri.
Future<void> showTimelineFilterSheet(
  BuildContext context, {
  required String? coordinatorship,
}) => NzBottomSheet.show<void>(
  context,
  title: context.l10n.uiTimelineFilters,
  actions: (sheet) => [
    Consumer(
      builder: (context, ref, _) => NzButton.secondary(
        label: context.l10n.uiTimelineClear,
        onPressed: ref
            .read(timelineControllerProvider(coordinatorship).notifier)
            .clearSheetFilters,
      ),
    ),
    Consumer(
      builder: (context, ref, _) {
        final view = ref.watch(timelineViewProvider(coordinatorship)).value;
        return NzButton.primary(
          label: context.l10n.showTasks(view?.shown.length ?? 0),
          onPressed: () => Navigator.of(sheet).maybePop(),
        );
      },
    ),
  ],
  builder: (_) => _FilterBody(coordinatorship: coordinatorship),
);

/// Lejant alt sayfası: durum renkleri, gecikme, talep çerçevesi ve kullanım ipuçları.
Future<void> showTimelineLegendSheet(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTimelineLegend,
      builder: (_) => const _LegendBody(),
    );

class _FilterBody extends ConsumerStatefulWidget {
  const _FilterBody({required this.coordinatorship});
  final String? coordinatorship;

  @override
  ConsumerState<_FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends ConsumerState<_FilterBody> {
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final view = ref.watch(timelineViewProvider(widget.coordinatorship)).value;
    if (view == null) return const SizedBox.shrink();
    final s = view.state;
    final ctrl = ref.read(
      timelineControllerProvider(widget.coordinatorship).notifier,
    );
    String summary(int selected) =>
        selected == 0 ? l.uiTasksAllLc : '$selected ${l.uiTasksSelectedTail}';
    Widget option(
      String label,
      int? count,
      bool selected,
      VoidCallback onTap,
    ) => NzFilterChoice(
      label: label,
      count: count?.toString(),
      selected: selected,
      onTap: onTap,
    );
    Widget choices(List<Widget> children) =>
        NzFilterChoices(children: children);
    final coordCount = view.allSelected
        ? 0
        : view.selectedCoordinatorships.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.uiTimelineStatus,
          style: context.text.labelMd.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space2),
        NzFilterRail(
          semanticLabel: l.uiTimelineStatus,
          selected: s.status.index,
          onSelected: (i) => ctrl.setStatus(TimelineStatusFilter.values[i]),
          options: [
            for (final f in TimelineStatusFilter.values)
              NzFilterOption(
                label: l.statusFilterLabel(f),
                count: f == TimelineStatusFilter.all
                    ? null
                    : view.statusCounts[f],
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        NzFormRows(
          expandedIndex: _expanded,
          onToggle: (i) =>
              setState(() => _expanded = _expanded == i ? null : i),
          rows: [
            NzFormRow(
              label: l.uiTimelinePerson,
              icon: NzIcons.person,
              value: summary(s.people.length),
              valueSet: s.people.isNotEmpty,
              content: choices([
                for (final p in view.personOptions)
                  option(
                    p.name,
                    p.count,
                    p.selected,
                    () => ctrl.togglePerson(p.id),
                  ),
              ]),
            ),
            NzFormRow(
              label: l.uiTimelineCoord,
              icon: NzIcons.coordinatorships,
              value: view.allSelected
                  ? l.uiTasksAllLc
                  : '$coordCount ${l.uiTasksSelectedTail}',
              valueSet: !view.allSelected,
              content: choices([
                option(
                  view.allSelected
                      ? l.uiTimelineCoordClear
                      : l.uiTimelineCoordSelectAll,
                  null,
                  view.allSelected,
                  () {
                    if (view.allSelected || view.noneSelected) {
                      ctrl.toggleAllCoordinatorships();
                    } else {
                      for (final coord in view.coordOptions.where(
                        (o) => !o.selected,
                      )) {
                        ctrl.toggleCoordinatorship(coord.code);
                      }
                    }
                  },
                ),
                for (final coord in view.coordOptions)
                  option(
                    coord.name,
                    coord.count,
                    coord.selected,
                    () => ctrl.toggleCoordinatorship(coord.code),
                  ),
              ]),
            ),
            NzFormRow.custom(
              label: l.uiTimelinePriority,
              leading: const NzPriorityBars(level: 2),
              trailing: TaskSegmented(
                filterSpacing: true,
                compact: true,
                semanticLabel: l.uiTimelinePriority,
                labels: [
                  for (final p in TaskPriority.pickable) l.priorityLabel(p),
                ],
                selected: -1,
                selectedIndices: {
                  for (final (i, p) in TaskPriority.pickable.indexed)
                    if (s.priorities.contains(p)) i,
                },
                onSelected: (i) =>
                    ctrl.togglePriority(TaskPriority.pickable[i]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendBody extends StatelessWidget {
  const _LegendBody();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final items = <(String, Color, Color?, bool)>[
      (l.uiTimelineStTodo, c.ganttTodo, null, false),
      (l.uiTimelineStDoing, c.ganttDoing, null, false),
      (l.uiTimelineStReview, c.ganttReview, null, false),
      (l.uiTimelineStBack, c.ganttBack, null, false),
      (l.uiTimelineStDone, c.ganttDone, null, false),
      (l.uiTimelineStDoneLate, c.ganttDone, c.ganttLate, false),
      (l.uiTimelineStLate, c.ganttDoing, c.ganttLate, true),
      (l.uiTimelineStRequest, c.surface, null, true),
    ];
    Widget hint(Widget swatch, String text) => Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
      child: Row(
        children: [
          swatch,
          const Gap(NizamioSpacing.gapMd),
          Expanded(
            child: Text(text, style: t.caption.copyWith(color: c.textMuted)),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, box) => Wrap(
            runSpacing: NizamioSpacing.space3,
            children: [
              for (final (i, (label, fill, late, dashed)) in items.indexed)
                SizedBox(
                  width: box.maxWidth / 2,
                  child: Row(
                    children: [
                      _Swatch(
                        fill: fill,
                        late: late,
                        border: dashed
                            ? (i == items.length - 1 ? c.accentText : c.danger)
                            : null,
                      ),
                      const Gap(NizamioSpacing.gapMd),
                      Expanded(
                        child: Text(
                          label,
                          style: t.labelMd.copyWith(color: c.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const Gap(NizamioSpacing.space3),
        const NzDivider.horizontal(),
        const Gap(NizamioSpacing.space3),
        hint(
          ColoredBox(
            color: c.accentText,
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 12, height: 2),
            ),
          ),
          l.uiTimelineLegendToday,
        ),
        hint(
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: c.text, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 12, height: 12),
            ),
          ),
          l.uiTimelineLegendStrip,
        ),
        hint(
          DecoratedBox(
            decoration: BoxDecoration(
              color: c.ganttDoing,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 12, height: 12),
            ),
          ),
          l.uiTimelineLegendBar,
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.fill, this.late, this.border});

  final Color fill;
  final Color? late;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    final late = this.late;
    final border = this.border;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: border == null ? null : Border.all(color: border, width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 0.5],
          colors: [fill, late ?? fill],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 12, height: 24),
      ),
    );
  }
}
