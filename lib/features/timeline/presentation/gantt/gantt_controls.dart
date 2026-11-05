import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
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
    required this.onCoord,
    required this.onFilter,
    required this.onZoom,
    required this.onToday,
  });

  final GanttView view;
  final VoidCallback onCoord;
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
          _ToolButton(
            icon: NzIcons.coordinatorships,
            label: l.uiTimelineCoord,
            count: view.state.coords.length,
            onTap: onCoord,
          ),
          const Gap(NizamioSpacing.space2),
          _ToolButton(
            icon: NzIcons.filter,
            label: l.uiTimelineFilters,
            count: view.state.filter == GanttFilter.all ? 0 : 1,
            accent: true,
            onTap: onFilter,
          ),
          const Spacer(),
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

/// Araç satırı düğmesi (kapsül, Bugün düğmesiyle aynı ölçü): isteğe bağlı ikon ve sayı rozeti
/// (telefondaki yüzen düğmelerin rozeti: filtrede vurgu, koordinatörlükte açık zemin).
class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.count = 0,
    this.accent = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final int count;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final icon = this.icon;
    return Semantics(
      button: true,
      label: count > 0 ? '$label · $count' : label,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.text),
                const Gap(NizamioSpacing.space2),
              ],
              Text(label, style: t.labelMd),
              if (count > 0) ...[
                const Gap(NizamioSpacing.space2),
                Container(
                  constraints: const BoxConstraints(
                    minWidth: GanttGeometry.badge,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.space1,
                  ),
                  alignment: Alignment.center,
                  height: GanttGeometry.badge,
                  decoration: BoxDecoration(
                    color: accent ? c.primary : c.text,
                    borderRadius: BorderRadius.circular(NizamioRadius.pill),
                  ),
                  child: Text(
                    '$count',
                    style: t.caption.copyWith(
                      color: accent ? c.onPrimary : c.background,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
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
