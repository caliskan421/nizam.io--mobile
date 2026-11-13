part of 'gantt_chart.dart';

/// Yapışkan tarih başlığı: sol "koordinatörlük · görev" hücresi, ay adları, gün işaretleri ve
/// "bugün" hapı.
class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.layout,
    required this.sticky,
    this.onToggleLabels,
  });

  final GanttLayout layout;
  final Widget Function(Widget) sticky;
  final VoidCallback? onToggleLabels;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final v = layout.view;
    final side = BorderSide(color: c.border);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.background,
        border: Border(bottom: side),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: layout.labelWidth,
            top: 0,
            width: layout.width,
            height: GanttGeometry.stickyHeader,
            child: ExcludeSemantics(
              child: RepaintBoundary(
                child: CustomPaint(
                  key: GanttChart.headerKey,
                  painter: GanttHeaderPainter(
                    layout: layout,
                    monthLabels: [
                      for (var m = 1; m <= 12; m++) l.ganttMonth(m, v.year),
                    ],
                    colors: c,
                    // Ağırlık rolün kendisinden (600); `copyWith(fontWeight:)`
                    // gömülü yazı tipinde başka ağırlık dosyası seçmez.
                    monthStyle: t.labelMd.copyWith(
                      fontSize: GanttGeometry.monthFontSize,
                      height:
                          GanttGeometry.headLine / GanttGeometry.monthFontSize,
                    ),
                    tickStyle: t.monoSm.copyWith(
                      fontSize: GanttGeometry.tickFontSize,
                      height:
                          GanttGeometry.headLine / GanttGeometry.tickFontSize,
                    ),
                    textScaler: MediaQuery.textScalerOf(context),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: layout.labelWidth + layout.todayX,
            top: GanttGeometry.tickTop,
            child: FractionalTranslation(
              translation: const Offset(-0.5, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.ganttLateLine,
                  borderRadius: BorderRadius.circular(NizamioRadius.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GanttGeometry.pillPad,
                  ),
                  child: Text(
                    l.uiTimelineGanttTodayPill,
                    maxLines: 1,
                    style: t.monoSm.copyWith(
                      fontSize: GanttGeometry.pillFontSize,
                      height:
                          GanttGeometry.headLine / GanttGeometry.pillFontSize,
                      fontWeight: FontWeight.w600,
                      color: c.onDanger,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            width: layout.labelWidth,
            height: GanttGeometry.stickyHeader,
            child: sticky(
              _labelGlass(
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.glassBar,
                    border: Border(right: side, bottom: side),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      GanttGeometry.labelHeadPad,
                      0,
                      GanttGeometry.labelHeadPad,
                      GanttGeometry.labelHeadBottom,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              layout.labelWidth < 300 ? 'KOD' : 'GÖREV',
                              style: t.kicker,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (onToggleLabels != null)
                          Tooltip(
                            message: layout.labelWidth < 300
                                ? 'Görev adlarını göster'
                                : 'Yalnız kodları göster',
                            child: Semantics(
                              button: true,
                              label: layout.labelWidth < 300
                                  ? 'Görev adlarını göster'
                                  : 'Yalnız kodları göster',
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor: WidgetStatePropertyAll(
                                    c.surface.withValues(alpha: 0),
                                  ),
                                  onTap: onToggleLabels,
                                  child: SizedBox.square(
                                    dimension: 32,
                                    child: CustomPaint(
                                      painter: _ColumnIconPainter(
                                        color: c.textMuted,
                                        expand: layout.labelWidth < 300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
