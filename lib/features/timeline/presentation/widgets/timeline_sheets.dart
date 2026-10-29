import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/timeline_controller.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'timeline_controls.dart';

/// Filtre alt sayfası (prototip `modal: 'filter'`): başlık satırında "Temizle" (kişi + öncelik);
/// durum (sayılı), kişi, öncelik; koordinatörlük ipucu ve "N görevi göster". Ölçek, genel bakış
/// ve lejant çizelgenin üstündeki kontrollerdedir ([TimelineZoomControls]).
Future<void> showTimelineFilterSheet(
  BuildContext context, {
  required String? coordinatorship,
}) => NzBottomSheet.show<void>(
  context,
  title: context.l10n.uiTimelineFilters,
  headerAction: Consumer(
    builder: (context, ref, _) => NzButton.ghost(
      label: context.l10n.uiTimelineClear,
      size: NzSize.sm,
      onPressed: ref
          .read(timelineControllerProvider(coordinatorship).notifier)
          .clearFilters,
    ),
  ),
  builder: (_) => _FilterBody(coordinatorship: coordinatorship),
);

/// Lejant alt sayfası: durum renkleri, gecikme, talep çerçevesi ve kullanım ipuçları.
Future<void> showTimelineLegendSheet(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTimelineLegend,
      builder: (_) => const _LegendBody(),
    );

class _FilterBody extends ConsumerWidget {
  const _FilterBody({required this.coordinatorship});

  final String? coordinatorship;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final view = ref.watch(timelineViewProvider(coordinatorship)).value;
    if (view == null) return const SizedBox.shrink();
    final s = view.state;
    final ctrl = ref.read(timelineControllerProvider(coordinatorship).notifier);
    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
      child: Text(text, style: t.labelMd.copyWith(color: c.textMuted)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label(l.uiTimelineStatus),
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
        label(l.uiTimelinePerson),
        Wrap(
          spacing: NizamioSpacing.space2,
          children: [
            for (final p in view.personOptions)
              TimelineChip(
                label: p.name,
                count: p.count,
                selected: p.selected,
                onTap: () => ctrl.togglePerson(p.id),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        label(l.uiTimelinePriority),
        Wrap(
          spacing: NizamioSpacing.space2,
          children: [
            for (final (p, level) in const [
              (TaskPriority.high, 3),
              (TaskPriority.medium, 2),
              (TaskPriority.low, 1),
            ])
              TimelineChip(
                label: l.priorityLabel(p),
                leading: NzPriorityBars(level: level),
                selected: s.priorities.contains(p),
                onTap: () => ctrl.togglePriority(p),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        Text(
          l.uiTimelineCoordHint,
          style: t.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space3),
        NzButton.primary(
          label: l.showTasks(view.shown.length),
          size: NzSize.lg,
          expand: true,
          onPressed: () => Navigator.of(context).pop(),
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
