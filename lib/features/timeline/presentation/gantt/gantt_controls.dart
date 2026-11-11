import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../tasks/tasks.dart';
import '../../domain/horizontal_timeline.dart';
import '../timeline_texts.dart';
import 'gantt_geometry.dart';
import 'gantt_painters.dart';
import 'gantt_texts.dart';

/// Üst başlık: liste sayfasıyla aynı "Görevler" başlığı (`NzPageHeader`), altında sayı satırı;
/// sağda Liste / Zaman çizelgesi anahtarı (listeye dönüş, [onList]), ara ve yetki varsa yeni
/// görev. Üst boşluk tablet liste bölmesiyle aynıdır (başlık geçişte aynı yerde kalır); eylem
/// grubu geçişte liste bölmesindeki yerinden kayar ([TasksHeaderSlide]).
class GanttTopBar extends StatelessWidget {
  const GanttTopBar({
    super.key,
    required this.view,
    required this.onList,
    required this.onSearch,
    this.onNewTask,
  });

  final GanttView view;
  final VoidCallback onList;
  final VoidCallback onSearch;

  /// null → yeni görev düğmesi yok (yetki yok).
  final VoidCallback? onNewTask;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final onNewTask = this.onNewTask;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GanttGeometry.headerPadRight,
        NzTabletMetrics.paneTop,
        GanttGeometry.headerPadRight,
        NizamioSpacing.space3,
      ),
      child: NzPageHeader(
        title: l.uiTasksTitle,
        subtitle: l.ganttCountLine(view),
        actions: [
          TasksHeaderSlide(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TasksModeToggle(
                  selected: 1,
                  onSelected: (i) {
                    if (i == 0) onList();
                  },
                ),
                const Gap(NizamioSpacing.space1),
                NzIconButton.circle(
                  icon: NzIcons.search,
                  semanticLabel: l.uiTasksSearch,
                  onPressed: onSearch,
                ),
                if (onNewTask != null) ...[
                  const Gap(NizamioSpacing.space1),
                  NzIconButton.circleAccent(
                    icon: NzIcons.add,
                    semanticLabel: l.uiTasksNewTask,
                    onPressed: onNewTask,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Araç satırı: solda telefondaki gibi tek düğmeli koordinatörlük seçimi ve filtre (seçim
/// sayısı rozette; alt sayfa açar), sağda ölçek (Günlük / Haftalık) ve Bugün.
class GanttToolbar extends StatelessWidget {
  const GanttToolbar({
    super.key,
    required this.view,
    required this.layout,
    required this.scroll,
    required this.onFilter,
    required this.onZoom,
    required this.onToday,
  });

  final GanttView view;
  final GanttLayout layout;
  final ScrollController scroll;
  final VoidCallback onFilter;
  final ValueChanged<GanttZoom> onZoom;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GanttGeometry.headerPadRight,
        0,
        GanttGeometry.headerPadRight,
        NizamioSpacing.space3,
      ),
      child: Row(
        children: [
          NzIconButton.circle(
            icon: NzIcons.filter,
            semanticLabel: l.uiTimelineFilters,
            dot:
                view.state.filter == GanttFilter.all &&
                    view.state.coords.isEmpty &&
                    view.state.people.isEmpty &&
                    view.state.priorities.isEmpty
                ? null
                : context.colors.accentText,
            onPressed: onFilter,
          ),
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: _GanttSeasonStrip(layout: layout, scroll: scroll),
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
          _ToolButton(label: l.uiTimelineToday, onTap: onToday),
        ],
      ),
    );
  }
}

/// Yıllık görev yoğunluğu ve yatay çizelgenin görünen aralığı.
class _GanttSeasonStrip extends StatelessWidget {
  const _GanttSeasonStrip({required this.layout, required this.scroll});
  final GanttLayout layout;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: context.l10n.uiTimelineSeasonMap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceRaised.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(NizamioRadius.attach),
          border: Border.all(color: c.border),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
          child: LayoutBuilder(
            builder: (context, box) {
              void at(Offset point) {
                if (!scroll.hasClients || box.maxWidth <= 0) return;
                final pos = scroll.position;
                final fraction = (point.dx / box.maxWidth).clamp(0.0, 1.0);
                final available = (pos.viewportDimension - layout.labelWidth)
                    .clamp(0.0, double.infinity);
                final target = fraction * layout.width - available / 2;
                scroll.jumpTo(target.clamp(0.0, pos.maxScrollExtent));
              }

              return GestureDetector(
                key: const ValueKey('gantt-season-strip'),
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => at(details.localPosition),
                onHorizontalDragStart: (details) => at(details.localPosition),
                onHorizontalDragUpdate: (details) => at(details.localPosition),
                child: CustomPaint(
                  size: Size(box.maxWidth, 32),
                  painter: _GanttStripPainter(
                    layout: layout,
                    scroll: scroll,
                    colors: c,
                    textStyle: context.text.monoSm,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GanttStripPainter extends CustomPainter {
  _GanttStripPainter({
    required this.layout,
    required this.scroll,
    required this.colors,
    required this.textStyle,
  }) : super(repaint: scroll);
  final GanttLayout layout;
  final ScrollController scroll;
  final NizamioColors colors;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final weeks = layout.view.weeks;
    final maxCount = weeks.fold<int>(1, (a, w) => a > w.count ? a : w.count);
    final width = size.width / weeks.length;
    for (var i = 0; i < weeks.length; i++) {
      final week = weeks[i];
      final h = week.count == 0
          ? 2.0
          : 3 + (week.count / maxCount * 15).roundToDouble();
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * width,
            22 - h,
            (width - 1).clamp(0.5, double.infinity),
            h,
          ),
          const Radius.circular(1),
        ),
        Paint()
          ..color = week.late
              ? colors.danger
              : week.count > 0
              ? colors.textFaint
              : colors.text.withValues(alpha: .12),
      );
    }
    final fmt = DateFormat('MMM', 'tr');
    for (var m = 0; m < 12; m++) {
      final tp = TextPainter(
        text: TextSpan(
          text: fmt.format(DateTime(layout.view.year, m + 1)).toLowerCase(),
          style: textStyle.copyWith(
            fontSize: 8,
            height: 1.1,
            color: colors.textFaint,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: size.width / 12);
      tp.paint(canvas, Offset(m * size.width / 12, size.height - 9));
    }
    final pos = scroll.hasClients ? scroll.position : null;
    final start = ((pos?.pixels ?? 0) / layout.width).clamp(0.0, 1.0);
    final viewport =
        ((pos?.viewportDimension ?? layout.labelWidth) - layout.labelWidth)
            .clamp(0.0, layout.width);
    final end = (start + viewport / layout.width).clamp(start, 1.0);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(start * size.width, 0, end * size.width, 23),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, Paint()..color = colors.text.withValues(alpha: .08));
    canvas.drawRRect(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = colors.text,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        layout.view.today / layout.view.days * size.width,
        0,
        2,
        23,
      ),
      Paint()..color = colors.primary,
    );
  }

  @override
  bool shouldRepaint(_GanttStripPainter old) =>
      old.layout != layout ||
      old.colors != colors ||
      old.textStyle != textStyle ||
      old.scroll != scroll;
}

/// Çizelgeyi bugüne taşıyan kapsül düğme.
class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: GanttGeometry.todayButton,
          padding: const EdgeInsets.symmetric(
            horizontal: GanttGeometry.todayButtonPad,
          ),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
            border: Border.all(color: c.borderControl),
          ),
          alignment: Alignment.center,
          child: Text(label, style: context.text.labelMd),
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

/// Lejant (40): beş durum, gecikme deseni.
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
      height: GanttGeometry.legend + MediaQuery.paddingOf(context).bottom,
      padding: EdgeInsets.only(
        left: GanttGeometry.legendPad,
        right: GanttGeometry.legendPad,
        bottom: MediaQuery.paddingOf(context).bottom,
      ),
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
        ],
      ),
    );
  }
}
