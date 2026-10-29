import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../tasks/tasks.dart';
import '../../domain/horizontal_timeline.dart';
import '../timeline_texts.dart';
import 'gantt_geometry.dart';
import 'gantt_painters.dart';
import 'gantt_texts.dart';

/// Üst başlık (72): "Görevler" geri düğmesi, başlık + sayı satırı, durum süzgeci, ölçek, Bugün.
class GanttTopBar extends StatelessWidget {
  const GanttTopBar({
    super.key,
    required this.view,
    required this.onBack,
    required this.onFilter,
    required this.onZoom,
    required this.onToday,
  });

  final GanttView view;
  final VoidCallback onBack;
  final ValueChanged<GanttFilter> onFilter;
  final ValueChanged<GanttZoom> onZoom;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    return SizedBox(
      height: GanttGeometry.header,
      child: Padding(
        padding: const EdgeInsets.only(
          left: GanttGeometry.headerPadLeft,
          right: GanttGeometry.headerPadRight,
        ),
        child: Row(
          children: [
            Semantics(
              button: true,
              label: l.uiTimelineGanttBackLabel,
              excludeSemantics: true,
              onTap: onBack,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBack,
                child: SizedBox(
                  height: GanttGeometry.backHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: GanttGeometry.backPadLeft,
                      right: GanttGeometry.backPadRight,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NzPathIcon(GanttGeometry.chevronLeft, color: c.text),
                        const Gap(NizamioSpacing.space1),
                        Text(
                          l.uiTimelineGanttBack,
                          style: t.list.copyWith(
                            fontSize: GanttGeometry.backFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Gap(NizamioSpacing.space3),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l.uiTimelineTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleLg.copyWith(
                        fontSize: GanttGeometry.titleSize,
                        height:
                            GanttGeometry.titleLine / GanttGeometry.titleSize,
                      ),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    l.ganttCountLine(view),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.monoSm.copyWith(color: c.textFaint),
                  ),
                ],
              ),
            ),
            const Gap(NizamioSpacing.space3),
            GanttSegments<GanttFilter>(
              label: l.uiTimelineGanttFilter,
              values: GanttFilter.values,
              selected: view.state.filter,
              labelOf: (f) => l.ganttFilterLabel(f, view.lateAll),
              onSelected: onFilter,
            ),
            const Gap(NizamioSpacing.space3),
            GanttSegments<GanttZoom>(
              label: l.uiTimelineScale,
              values: GanttZoom.values,
              selected: view.state.zoom,
              labelOf: l.ganttZoomLabel,
              onSelected: onZoom,
            ),
            const Gap(NizamioSpacing.space3),
            Semantics(
              button: true,
              label: l.uiTimelineToday,
              excludeSemantics: true,
              onTap: onToday,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onToday,
                child: Container(
                  height: GanttGeometry.todayButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: GanttGeometry.todayButtonPad,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    border: Border.all(color: c.borderControl),
                  ),
                  child: Text(l.uiTimelineToday, style: t.labelMd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kapsül içinde tek seçimli düğmeler (prototip `role="group"` + `aria-pressed`): 3 dolgu, 34
/// düğme; seçili `bg-overlay` zemin, mürekkep, 600.
class GanttSegments<T> extends StatelessWidget {
  const GanttSegments({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final d = NzMotion.of(context, GanttGeometry.segDuration);
    return Semantics(
      container: true,
      label: label,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(NizamioRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(GanttGeometry.segPad),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final v in values)
                Semantics(
                  button: true,
                  selected: v == selected,
                  label: labelOf(v),
                  excludeSemantics: true,
                  onTap: () => onSelected(v),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelected(v),
                    child: AnimatedContainer(
                      duration: d,
                      height: GanttGeometry.segButton,
                      padding: const EdgeInsets.symmetric(
                        horizontal: GanttGeometry.segButtonPad,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: v == selected
                            ? c.surfaceOverlay
                            : c.surfaceOverlay.withValues(alpha: 0),
                        borderRadius: BorderRadius.circular(NizamioRadius.pill),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: d,
                        // Seçili 600 (`tab`), seçili değil 500 (`list`).
                        style: v == selected
                            ? t.labelMd.copyWith(color: c.text)
                            : t.list.copyWith(
                                fontSize: t.labelMd.fontSize,
                                height: t.labelMd.height,
                                color: c.textMuted,
                              ),
                        child: Text(labelOf(v), maxLines: 1, softWrap: false),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Koordinatörlük çipleri (prototip `coordChips`): "Tüm koordinatörlükler" + kodlar; çoklu
/// seçim, yatay kayar. Kodun tam adı ipucudur (`title`).
class GanttCoordChips extends StatelessWidget {
  const GanttCoordChips({
    super.key,
    required this.view,
    required this.onAll,
    required this.onToggle,
  });

  final GanttView view;
  final VoidCallback onAll;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SizedBox(
      height: GanttGeometry.chip + NizamioSpacing.space3,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: GanttGeometry.headerPadRight,
          right: GanttGeometry.headerPadRight,
          bottom: NizamioSpacing.space3,
        ),
        children: [
          _Chip(
            label: l.uiTimelineGanttAllCoords,
            tooltip: l.uiTimelineGanttAllCoords,
            selected: view.state.coords.isEmpty,
            onTap: onAll,
          ),
          for (final c in view.chips) ...[
            const Gap(GanttGeometry.chipGap),
            _Chip(
              label: c.code,
              tooltip: c.name,
              selected: c.selected,
              onTap: () => onToggle(c.code),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final d = NzMotion.of(context, GanttGeometry.chipDuration);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      tooltip: tooltip,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: d,
          height: GanttGeometry.chip,
          padding: const EdgeInsets.symmetric(
            horizontal: GanttGeometry.chipPad,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.text : c.surfaceRaised,
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
          ),
          child: AnimatedDefaultTextStyle(
            duration: d,
            style: (selected ? t.labelMd : t.list).copyWith(
              fontSize: GanttGeometry.chipFontSize,
              height: t.labelMd.height,
              color: selected ? c.background : c.textMuted,
            ),
            child: Text(label, maxLines: 1, softWrap: false),
          ),
        ),
      ),
    );
  }
}

/// Lejant (40): beş durum, gecikme deseni; sağda Teknofest günleri.
class GanttLegend extends StatelessWidget {
  const GanttLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final style = t.caption.copyWith(color: c.textMuted);
    Widget item(Widget swatch, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: SizedBox(
            width: GanttGeometry.swatchWidth,
            height: GanttGeometry.swatchHeight,
            child: swatch,
          ),
        ),
        const Gap(GanttGeometry.chipGap),
        Text(label, style: style, maxLines: 1),
      ],
    );
    Widget solid(Color color) => DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(GanttGeometry.swatchRadius),
      ),
    );
    return Container(
      height: GanttGeometry.legend,
      padding: const EdgeInsets.symmetric(horizontal: GanttGeometry.legendPad),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          for (final s in TaskStatus.known) ...[
            item(solid(ganttStatusColor(c, s)), l.statusLabel(s)),
            const Gap(GanttGeometry.legendGap),
          ],
          item(
            CustomPaint(painter: GanttHatchSwatchPainter(c.ganttLate)),
            l.uiTimelineGanttLegendLate,
          ),
          const Spacer(),
          item(
            solid(c.danger.withValues(alpha: GanttGeometry.festLegendAlpha)),
            l.uiTimelineGanttLegendFest,
          ),
        ],
      ),
    );
  }
}
