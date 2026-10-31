import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/horizontal_timeline.dart';
import 'gantt_geometry.dart';
import 'gantt_painters.dart';
import 'gantt_texts.dart';

/// Bugüne ortalama isteği: [serial] değişince çizelge bugünü ortalar ([smooth] → kayarak).
@immutable
final class GanttCenterRequest {
  const GanttCenterRequest(this.serial, {this.smooth = false});

  final int serial;
  final bool smooth;
}

/// Yatay Gantt gövdesi (prototip `chartRef` kabı): yatay + dikey kaydırma, yapışkan tarih
/// başlığı (52) ve yapışkan sol etiket sütunu (300), Teknofest gölgesi, bugün çizgisi, grup
/// başlıkları (aç/kapat) ve görev çubukları (gerçek dokunma alanı ve okuyucu etiketi).
///
/// Dış görünüm yatay kayar; başlık ve gövde birlikte kayar, sol sütun ve başlığın sol hücresi
/// kaydırma ofseti kadar geri ötelenir (CSS `position: sticky; left: 0`). Zemin, ızgara ve
/// başlık işaretleri yerleşim değişince bir kez çizilir; kaydırma yeniden çizdirmez.
class GanttChart extends StatefulWidget {
  const GanttChart({
    super.key,
    required this.layout,
    required this.center,
    required this.onToggleGroup,
    required this.onPick,
  });

  final GanttLayout layout;
  final GanttCenterRequest center;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onPick;

  static const horizontalKey = ValueKey('gantt-scroll-x');
  static const verticalKey = ValueKey('gantt-scroll-y');
  static const bodyKey = ValueKey('gantt-body');
  static const headerKey = ValueKey('gantt-dates');
  static const todayKey = ValueKey('gantt-today');
  static const labelsKey = ValueKey('gantt-labels');

  /// Görev çubuğunun anahtarı.
  static ValueKey<String> barKey(String code) => ValueKey('gantt-bar-$code');

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  final _h = ScrollController();
  final _v = ScrollController();

  @override
  void initState() {
    super.initState();
    _schedule(smooth: false);
  }

  @override
  void didUpdateWidget(GanttChart old) {
    super.didUpdateWidget(old);
    if (old.center.serial != widget.center.serial) {
      _schedule(smooth: widget.center.smooth);
    }
  }

  @override
  void dispose() {
    _h.dispose();
    _v.dispose();
    super.dispose();
  }

  /// Yerleşimden sonra (yeni genişlik ve kaydırma sınırı belliyken) ortalar.
  void _schedule({required bool smooth}) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _center(smooth));

  void _center(bool smooth) {
    if (!mounted || !_h.hasClients) return;
    final pos = _h.position;
    final target = GanttGeometry.centerOffset(
      today: widget.layout.view.today,
      ppd: widget.layout.ppd,
      viewport: pos.viewportDimension,
      maxExtent: pos.maxScrollExtent,
    );
    if (smooth && !NzMotion.reduced(context)) {
      _h.animateTo(
        target,
        duration: GanttGeometry.centerDuration,
        curve: NizamioMotion.easeOut,
      );
    } else {
      _h.jumpTo(target);
    }
  }

  /// [child]'ı yatay kaydırma kadar geri öteler (yapışkan sol).
  Widget _sticky(Widget child) => AnimatedBuilder(
    animation: _h,
    builder: (context, child) => Transform.translate(
      offset: Offset(_h.hasClients ? _h.offset : 0, 0),
      child: child,
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final l = widget.layout;
    return LayoutBuilder(
      builder: (context, box) {
        final viewport = math.max(
          0.0,
          box.maxHeight - GanttGeometry.stickyHeader,
        );
        final height = math.max(l.rowsHeight, viewport);
        return SingleChildScrollView(
          key: GanttChart.horizontalKey,
          controller: _h,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: l.totalWidth,
            height: box.maxHeight,
            child: Column(
              children: [
                SizedBox(
                  height: GanttGeometry.stickyHeader,
                  child: _DateHeader(layout: l, sticky: _sticky),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: GanttChart.verticalKey,
                    controller: _v,
                    child: SizedBox(
                      width: l.totalWidth,
                      height: height,
                      child: _Body(
                        layout: l,
                        height: height,
                        emptyWidth: box.maxWidth,
                        sticky: _sticky,
                        onToggleGroup: widget.onToggleGroup,
                        onPick: widget.onPick,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Yapışkan tarih başlığı: sol "koordinatörlük · görev" hücresi, ay adları, gün işaretleri ve
/// "bugün" hapı.
class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.layout, required this.sticky});

  final GanttLayout layout;
  final Widget Function(Widget) sticky;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final v = layout.view;
    final short = v.state.zoom == GanttZoom.season;
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
            left: GanttGeometry.labelWidth,
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
                      for (var m = 1; m <= 12; m++)
                        l.ganttMonth(m, v.year, short: short),
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
            left: GanttGeometry.labelWidth + layout.todayX,
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
            width: GanttGeometry.labelWidth,
            height: GanttGeometry.stickyHeader,
            child: sticky(
              DecoratedBox(
                decoration: BoxDecoration(
                  color: c.background,
                  border: Border(right: side, bottom: side),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    GanttGeometry.labelHeadPad,
                    0,
                    GanttGeometry.labelHeadPad,
                    GanttGeometry.labelHeadBottom,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      l.uiTimelineGanttLabelHead,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.kicker,
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

/// Gövde: zemin ressamı, çubuklar, dış başlıklar, bugün çizgisi, yapışkan etiket sütunu.
class _Body extends StatelessWidget {
  const _Body({
    required this.layout,
    required this.height,
    required this.emptyWidth,
    required this.sticky,
    required this.onToggleGroup,
    required this.onPick,
  });

  final GanttLayout layout;
  final double height;

  /// Boş durum metninin genişliği (görünür alan).
  final double emptyWidth;
  final Widget Function(Widget) sticky;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final year = layout.view.year;
    final outside = t.bodySm.copyWith(
      color: c.textMuted,
      height: GanttGeometry.outsideLine / t.bodySm.fontSize!,
    );
    final tasks = [
      for (final b in layout.rows)
        if (b.row case GanttTaskRow(:final task, :final selected))
          (b, task, selected),
    ];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: GanttGeometry.labelWidth,
          top: 0,
          width: layout.width,
          height: height,
          child: RepaintBoundary(
            child: CustomPaint(
              key: GanttChart.bodyKey,
              painter: GanttBodyPainter(layout: layout, colors: c),
            ),
          ),
        ),
        Positioned(
          left: GanttGeometry.labelWidth,
          top: 0,
          width: layout.width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final (b, task, selected) in tasks)
                Positioned.fromRect(
                  rect: b.bar!,
                  child: _Bar(
                    key: GanttChart.barKey(task.code),
                    task: task,
                    selected: selected,
                    inside: b.inside,
                    label: l.ganttBarLabel(task, year),
                    onTap: () => onPick(task.code),
                  ),
                ),
              for (final (b, task, _) in tasks)
                if (!b.inside)
                  Positioned(
                    left: b.outsideX,
                    top: b.top + GanttGeometry.outsideTop,
                    child: IgnorePointer(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: GanttGeometry.outsideMax,
                        ),
                        child: Text(
                          task.item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: outside,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
        Positioned(
          key: GanttChart.todayKey,
          left:
              GanttGeometry.labelWidth +
              layout.todayX -
              GanttGeometry.todayLine / 2,
          top: 0,
          width: GanttGeometry.todayLine,
          height: height,
          child: IgnorePointer(child: ColoredBox(color: c.ganttLateLine)),
        ),
        Positioned(
          left: 0,
          top: 0,
          width: layout.view.empty ? emptyWidth : GanttGeometry.labelWidth,
          child: sticky(
            layout.view.empty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: GanttGeometry.emptyPad,
                    ),
                    child: Text(
                      l.uiTimelineGanttEmpty,
                      textAlign: TextAlign.center,
                      style: t.bodyMd.copyWith(color: c.textMuted),
                    ),
                  )
                : Column(
                    key: GanttChart.labelsKey,
                    children: [
                      for (final b in layout.rows)
                        SizedBox(
                          height: GanttGeometry.row,
                          child: switch (b.row) {
                            final GanttHeadRow h => _GroupLabel(
                              head: h,
                              onTap: () => onToggleGroup(h.code),
                            ),
                            GanttTaskRow(:final task, :final selected) =>
                              _TaskLabel(
                                task: task,
                                selected: selected,
                                onTap: () => onPick(task.code),
                              ),
                          },
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// Görev çubuğu (prototip `button[aria-label]`): durum rengi, seçiliyken 2 px halka, sığarsa
/// başlık.
class _Bar extends StatelessWidget {
  const _Bar({
    super.key,
    required this.task,
    required this.selected,
    required this.inside,
    required this.label,
    required this.onTap,
  });

  final GanttTask task;
  final bool selected;
  final bool inside;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: NzMotion.of(context, GanttGeometry.ringDuration),
          padding: const EdgeInsets.symmetric(horizontal: GanttGeometry.barPad),
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: ganttStatusColor(c, task.status),
            borderRadius: BorderRadius.circular(GanttGeometry.barRadius),
            boxShadow: [
              BoxShadow(
                color: selected ? c.text : c.text.withValues(alpha: 0),
                spreadRadius: GanttGeometry.ring,
              ),
            ],
          ),
          child: inside
              ? Text(
                  task.item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: t.labelMd.copyWith(
                    fontSize: GanttGeometry.barFontSize,
                    color: c.ganttInk,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Grup başlığı (prototip `button[aria-expanded]`): ok, kod, ad, gecikme sayısı, görev sayısı.
class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.head, required this.onTap});

  final GanttHeadRow head;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final side = BorderSide(color: c.border);
    final late = head.late > 0 ? l.ganttGroupLate(head.late) : null;
    return Semantics(
      button: true,
      expanded: head.open,
      label: [head.code, head.name, ?late, '${head.count}'].join(' '),
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: side, right: side),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: GanttGeometry.groupPadLeft,
              right: GanttGeometry.groupPadRight,
            ),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: head.open ? 0.25 : 0,
                  duration: NzMotion.of(context, GanttGeometry.chevronDuration),
                  curve: NizamioMotion.easeSpring,
                  child: NzIcon(
                    NzIcons.chevronRight,
                    size: NizamioSize.iconSizeSm,
                    color: c.textFaint,
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Text(head.code, style: t.monoSm.copyWith(color: c.textFaint)),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: Text(
                    head.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.labelMd.copyWith(
                      fontSize: GanttGeometry.groupNameSize,
                    ),
                  ),
                ),
                if (late != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Text(
                    late,
                    style: t.monoSm.copyWith(
                      fontSize: GanttGeometry.tickFontSize,
                      color: c.danger,
                    ),
                  ),
                ],
                const Gap(NizamioSpacing.space2),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: GanttGeometry.countMinWidth,
                  ),
                  child: Text(
                    '${head.count}',
                    textAlign: TextAlign.right,
                    style: t.monoSm.copyWith(color: c.textMuted),
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

/// Görev satırının sol etiketi (prototip `button[aria-pressed]`): kod (gecikmede kırmızı) ve
/// başlık; dokununca seçer.
class _TaskLabel extends StatelessWidget {
  const _TaskLabel({
    required this.task,
    required this.selected,
    required this.onTap,
  });

  final GanttTask task;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      selected: selected,
      label: context.l10n.ganttRowLabel(task),
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.background,
            border: Border(right: BorderSide(color: c.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: GanttGeometry.taskPadLeft,
              right: GanttGeometry.groupPadRight,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: GanttGeometry.idColumn,
                  child: Text(
                    task.code,
                    maxLines: 1,
                    style: t.monoSm.copyWith(
                      color: task.late ? c.danger : c.textFaint,
                    ),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: Text(
                    task.item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMd.copyWith(
                      fontSize: GanttGeometry.rowTitleSize,
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
