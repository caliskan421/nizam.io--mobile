import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart' show SemanticsProperties;
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../tasks/tasks.dart' show Subtask;
import '../../domain/horizontal_timeline.dart';
import 'gantt_geometry.dart';
import 'gantt_painters.dart';
import 'gantt_texts.dart';

/// Yapışkan sol sütunun camı: çizelgeyi 10 piksel bulanıklaştırır; dolguyu
/// satırlar verir (görev satırı `glassBar`, grup satırı aynı saydamlıkta `surface`). Altından
/// kayan çubuklar bulanık görünür. Gövdede cam, dikey kaydırmanın dışında görünür alan
/// boyunda tek sabit paneldir; etiketler üstünde kayar.
Widget _labelGlass(Widget child) => ClipRect(
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: child,
  ),
);

/// Grup satırının cam dolgusu: `surface`, üst çubuk camıyla aynı saydamlıkta.
Color _groupGlass(NizamioColors c) => c.surface.withValues(alpha: c.glassBar.a);

/// Bugüne ortalama isteği: [serial] değişince çizelge bugünü ortalar ([smooth] → kayarak).
@immutable
final class GanttCenterRequest {
  const GanttCenterRequest(this.serial, {this.smooth = false});

  final int serial;
  final bool smooth;
}

/// Yatay Gantt gövdesi (prototip `chartRef` kabı): yatay + dikey kaydırma, yapışkan tarih
/// başlığı (52) ve yapışkan sol etiket sütunu (300), bugün çizgisi, grup
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
    this.horizontalController,
    this.onToggleLabels,
    this.expandedTasks = const {},
    this.onToggleSubtasks,
  });

  final GanttLayout layout;
  final GanttCenterRequest center;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onPick;
  final ScrollController? horizontalController;
  final VoidCallback? onToggleLabels;
  final Set<String> expandedTasks;
  final ValueChanged<String>? onToggleSubtasks;

  static const horizontalKey = ValueKey('gantt-scroll-x');
  static const verticalKey = ValueKey('gantt-scroll-y');
  static const bodyKey = ValueKey('gantt-body');
  static const headerKey = ValueKey('gantt-dates');
  static const todayKey = ValueKey('gantt-today');
  static const labelsKey = ValueKey('gantt-labels');

  /// Görev çubuklarının tek ressamı (dokunma algılayıcısının çocuğu).
  static const barsKey = ValueKey('gantt-bars');

  /// Görev çubuğunun okuyucu düğümü anahtarı.
  static ValueKey<String> barKey(String code) => ValueKey('gantt-bar-$code');

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  late final ScrollController _h =
      widget.horizontalController ?? ScrollController();
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
    if (widget.horizontalController == null) _h.dispose();
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
      columnWidth: widget.layout.labelWidth,
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
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: l.totalWidth,
            height: box.maxHeight,
            child: Column(
              children: [
                SizedBox(
                  height: GanttGeometry.stickyHeader,
                  child: _DateHeader(
                    layout: l,
                    sticky: _sticky,
                    onToggleLabels: widget.onToggleLabels,
                  ),
                ),
                // Tek dikey kaydırma: gövde ve etiket sütunu aynı ofseti paylaşan iki
                // görünümde kayar; aralarındaki cam panel kaymaz, görünür alan boyundadır
                // (tüm satır boyunda bulanıklık katmanı kurulmaz). Sürükleme her yerde kaydırır.
                Expanded(
                  child: Scrollable(
                    key: GanttChart.verticalKey,
                    controller: _v,
                    physics: const ClampingScrollPhysics(),
                    viewportBuilder: (context, offset) => Stack(
                      fit: StackFit.expand,
                      children: [
                        _scrolled(
                          offset,
                          SizedBox(
                            height: height,
                            child: _Body(
                              layout: l,
                              height: height,
                              viewport: Size(box.maxWidth, viewport),
                              h: _h,
                              v: _v,
                              onPick: widget.onPick,
                            ),
                          ),
                        ),
                        if (!l.view.empty)
                          Positioned(
                            left: 0,
                            top: 0,
                            width: l.labelWidth,
                            height: math.min(viewport, l.rowsHeight),
                            child: _sticky(
                              _labelGlass(const SizedBox.expand()),
                            ),
                          ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: l.view.empty ? box.maxWidth : l.labelWidth,
                          child: _sticky(
                            _Labels(
                              layout: l,
                              offset: offset,
                              height: height,
                              onToggleGroup: widget.onToggleGroup,
                              expandedTasks: widget.expandedTasks,
                              onToggleSubtasks: widget.onToggleSubtasks,
                              onPick: widget.onPick,
                            ),
                          ),
                        ),
                      ],
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
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor: const WidgetStatePropertyAll(
                                    Colors.transparent,
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

/// Gövdeyi dikey kaydırma ofsetiyle gösteren görünüm. Etiket sütunu ([_Labels]) aynı ofseti
/// kendi görünümünde paylaşır; ikisi de aynı kaydırma sınırını bildirir (içerik boyu
/// [_GanttChartState] `height`; satırlar görünür alandan kısaysa ikisinde de sınır 0).
Widget _scrolled(ViewportOffset offset, Widget child) => Viewport(
  offset: offset,
  slivers: [SliverToBoxAdapter(child: child)],
);

/// Gövde: zemin ressamı, çubuklar ([_Bars]), bugün çizgisi.
class _Body extends StatelessWidget {
  const _Body({
    required this.layout,
    required this.height,
    required this.viewport,
    required this.h,
    required this.v,
    required this.onPick,
  });

  final GanttLayout layout;
  final double height;

  /// Görünür alan: yatay kaydırma genişliği × dikey kaydırma yüksekliği.
  final Size viewport;
  final ScrollController h;
  final ScrollController v;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: layout.labelWidth,
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
          left: layout.labelWidth,
          top: 0,
          width: layout.width,
          height: height,
          child: _Bars(
            layout: layout,
            viewport: viewport,
            h: h,
            v: v,
            onPick: onPick,
          ),
        ),
        Positioned(
          key: GanttChart.todayKey,
          left: layout.labelWidth + layout.todayX - GanttGeometry.todayLine / 2,
          top: 0,
          width: GanttGeometry.todayLine,
          height: height,
          child: IgnorePointer(child: ColoredBox(color: c.ganttLateLine)),
        ),
      ],
    );
  }
}

/// Görev çubukları (prototip `button[aria-label]`): tek ressam yalnız görünür alanla kesişen
/// çubukları çizer ([GanttLayout.visibleBars]); okuyucu düğümü (etiket, seçili, dokunma eylemi)
/// de yalnız onlar içindir. Dokunma tek algılayıcıdan, konum yerleşimde aranır
/// ([GanttLayout.barAt]). Görünür küme kaydırmayla değişince yeniden kurulur; seçili halka
/// [GanttGeometry.ringDuration] içinde geçer.
class _Bars extends StatefulWidget {
  const _Bars({
    required this.layout,
    required this.viewport,
    required this.h,
    required this.v,
    required this.onPick,
  });

  final GanttLayout layout;
  final Size viewport;
  final ScrollController h;
  final ScrollController v;
  final ValueChanged<String> onPick;

  @override
  State<_Bars> createState() => _BarsState();
}

class _BarsState extends State<_Bars> with SingleTickerProviderStateMixin {
  late final _ring = AnimationController(vsync: this, value: 1);
  String? _previous;
  double _fromIn = 1;
  double _fromOut = 0;
  List<int> _visible = const [];

  @override
  void initState() {
    super.initState();
    widget.h.addListener(_sync);
    widget.v.addListener(_sync);
    _visible = _window();
  }

  @override
  void didUpdateWidget(_Bars old) {
    super.didUpdateWidget(old);
    if (old.h != widget.h) {
      old.h.removeListener(_sync);
      widget.h.addListener(_sync);
    }
    if (old.v != widget.v) {
      old.v.removeListener(_sync);
      widget.v.addListener(_sync);
    }
    final was = old.layout.view.state.selected;
    final now = widget.layout.view.state.selected;
    if (was != now) {
      final before = _ringOf(was);
      _fromOut = was == null ? 0 : before.alphaOf(was);
      _fromIn = now == null ? 1 : before.alphaOf(now);
      _previous = was;
      _ring
        ..duration = NzMotion.of(context, GanttGeometry.ringDuration)
        ..forward(from: 0);
    }
    _visible = _window();
    // Yerleşim kaydırma sınırını düzeltebilir (bildirim olmadan); kare sonunda yeniden bakılır.
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    widget.h.removeListener(_sync);
    widget.v.removeListener(_sync);
    _ring.dispose();
    super.dispose();
  }

  GanttRing _ringOf(String? selected) => GanttRing(
    t: _ring,
    selected: selected,
    previous: _previous,
    fromIn: _fromIn,
    fromOut: _fromOut,
  );

  static double _offsetOf(ScrollController c) =>
      c.hasClients && c.position.hasPixels ? c.offset : 0;

  /// Görünür alan (tarih alanı koordinatı; etiket sütununun altı dahil, cam altından görünür).
  List<int> _window() => widget.layout.visibleBars(
    Rect.fromLTWH(
      _offsetOf(widget.h) - widget.layout.labelWidth,
      _offsetOf(widget.v),
      widget.viewport.width,
      widget.viewport.height,
    ),
  );

  void _sync() {
    if (!mounted) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Kurulum/yerleşim sırasında gelen ofset bildirimi: kare sonunda.
      SchedulerBinding.instance.addPostFrameCallback((_) => _sync());
      return;
    }
    final next = _window();
    if (!listEquals(next, _visible)) setState(() => _visible = next);
  }

  void _tap(TapUpDetails d) {
    if (widget.layout.barAt(d.localPosition) case final code?) {
      widget.onPick(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final layout = widget.layout;
    final year = layout.view.year;
    final base = DefaultTextStyle.of(context).style;
    final bold = MediaQuery.boldTextOf(context);
    TextStyle effective(TextStyle s) {
      final merged = base.merge(s);
      return bold ? merged.copyWith(fontWeight: FontWeight.bold) : merged;
    }

    final direction = Directionality.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: _tap,
      child: RepaintBoundary(
        child: CustomPaint(
          key: GanttChart.barsKey,
          painter: GanttBarsPainter(
            layout: layout,
            visible: _visible,
            colors: c,
            barStyle: effective(
              t.labelMd.copyWith(
                fontSize: GanttGeometry.barFontSize,
                color: c.ganttInk,
              ),
            ),
            outsideStyle: effective(
              t.bodySm.copyWith(
                color: c.textMuted,
                height: GanttGeometry.outsideLine / t.bodySm.fontSize!,
              ),
            ),
            textScaler: MediaQuery.textScalerOf(context),
            ring: _ringOf(layout.view.state.selected),
            scroll: widget.h,
            semantics: [
              for (final i in _visible)
                if (layout.rows[i] case GanttRowBox(
                  :final bar?,
                  row: final GanttTaskRow r,
                ))
                  CustomPainterSemantics(
                    key: GanttChart.barKey(r.task.code),
                    rect: bar,
                    properties: SemanticsProperties(
                      button: true,
                      selected: r.selected,
                      label: l.ganttBarLabel(r, year),
                      textDirection: direction,
                      onTap: () => widget.onPick(r.task.code),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Yapışkan sol etiket sütunu (saydam zemin; camı altındaki sabit panel verir) ya da boş
/// durum metni. Sabit satır yüksekliğiyle yalnız görünür (ve önbellek payındaki) satırlar
/// kurulur; dikey ofset gövdeyle aynıdır.
class _Labels extends StatelessWidget {
  const _Labels({
    required this.layout,
    required this.offset,
    required this.height,
    required this.onToggleGroup,
    required this.expandedTasks,
    required this.onToggleSubtasks,
    required this.onPick,
  });

  final GanttLayout layout;
  final Set<String> expandedTasks;
  final ValueChanged<String>? onToggleSubtasks;
  final ViewportOffset offset;

  /// Gövdeyle aynı içerik boyu (boş durumda).
  final double height;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final rows = layout.rows;
    return Viewport(
      key: GanttChart.labelsKey,
      offset: offset,
      slivers: [
        if (layout.view.empty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: GanttGeometry.emptyPad,
                      ),
                      child: Text(
                        context.l10n.uiTimelineGanttEmpty,
                        textAlign: TextAlign.center,
                        style: context.text.bodyMd.copyWith(
                          color: context.colors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverFixedExtentList(
            itemExtent: GanttGeometry.row,
            delegate: SliverChildBuilderDelegate(
              (context, i) => switch (rows[i].row) {
                final GanttHeadRow h => _GroupLabel(
                  head: h,
                  compact: layout.labelWidth < 300,
                  onTap: () => onToggleGroup(h.code),
                ),
                final GanttSubtaskRow s => _SubtaskLabel(subtask: s.subtask),
                final GanttTaskRow r => _TaskLabel(
                  row: r,
                  expanded: expandedTasks.contains(r.task.code),
                  onToggleSubtasks: onToggleSubtasks == null
                      ? null
                      : () => onToggleSubtasks!(r.task.code),
                  compact: layout.labelWidth < 300,
                  onTap: () => onPick(r.task.code),
                ),
              },
              childCount: rows.length,
            ),
          ),
      ],
    );
  }
}

/// Grup başlığı (prototip `button[aria-expanded]`): ok, kod, ad, gecikme sayısı, görev sayısı.
class _GroupLabel extends StatelessWidget {
  const _GroupLabel({
    required this.head,
    required this.onTap,
    required this.compact,
  });

  final GanttHeadRow head;
  final bool compact;
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
      label: [
        if (head.label != head.name) head.label,
        head.name,
        ?late,
        '${head.count}',
      ].join(' '),
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _groupGlass(c),
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
                // Etiket ve ad tek satır: sığmazsa sonu soluklaşır (satır dışına taşmaz).
                // Departman kodu yoksa etiket addır; o zaman yalnız ad yazılır.
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        if (head.label != head.name) ...[
                          TextSpan(
                            text: head.label,
                            style: t.monoSm.copyWith(color: c.textFaint),
                          ),
                          const TextSpan(text: '  '),
                        ],
                        if (head.name.isNotEmpty) ...[
                          TextSpan(
                            text: head.name,
                            style: t.labelMd.copyWith(
                              fontSize: GanttGeometry.groupNameSize,
                            ),
                          ),
                        ],
                      ],
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (late != null && !compact) ...[
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

/// Görev satırının sol etiketi (prototip `button[aria-pressed]`): gri anahtar (koordinatörlük
/// etiketi + sıra; gecikmede kırmızı) ve beyaz, kalın başlık; dokununca seçer. Uzun etiket ve
/// başlık sonda soluklaşır, numara görünür kalır.
class _TaskLabel extends StatelessWidget {
  const _TaskLabel({
    required this.row,
    required this.onTap,
    required this.compact,
    required this.expanded,
    this.onToggleSubtasks,
  });

  final GanttTaskRow row;
  final bool expanded;
  final VoidCallback? onToggleSubtasks;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final task = row.task;
    final keyStyle = t.monoSm.copyWith(
      color: task.late ? c.danger : c.textFaint,
    );
    return Semantics(
      button: true,
      selected: row.selected,
      label: context.l10n.ganttRowLabel(row),
      excludeSemantics: false,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.glassBar,
            border: Border(right: BorderSide(color: c.border)),
          ),
          child: Tooltip(
            message: compact ? '${row.key} · ${task.item.title}' : '',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      row.key.toLowerCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: keyStyle,
                    ),
                  ),
                  const Gap(10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: ganttStatusColor(c, task.status),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                  if (compact && task.item.subtaskTotal > 0) const Spacer(),
                  if (!compact) ...[
                    const Gap(10),
                    Expanded(
                      child: Text(
                        task.item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMd.copyWith(
                          fontSize: GanttGeometry.rowTitleSize,
                          fontWeight: FontWeight.w600,
                          color: c.text,
                        ),
                      ),
                    ),
                  ],
                  if (task.item.subtaskTotal > 0 && onToggleSubtasks != null)
                    Tooltip(
                      message: expanded
                          ? 'Alt görevleri kapat'
                          : 'Alt görevleri göster',
                      child: InkWell(
                        onTap: onToggleSubtasks,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 5,
                          ),
                          child: Text(
                            '${task.item.subtaskDoneTotal}/${task.item.subtaskTotal}',
                            style: t.monoSm.copyWith(color: c.textMuted),
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
    );
  }
}

class _SubtaskLabel extends StatelessWidget {
  const _SubtaskLabel({required this.subtask});
  final Subtask subtask;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.glassBar,
        border: Border(right: BorderSide(color: c.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              subtask.done
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: subtask.done ? c.accentText : c.textMuted,
            ),
            const Gap(10),
            Expanded(
              child: Text(
                subtask.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnIconPainter extends CustomPainter {
  const _ColumnIconPainter({required this.color, required this.expand});
  final Color color;
  final bool expand;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate((size.width - 24) / 2, (size.height - 24) / 2);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawRect(const Rect.fromLTWH(4, 4, 16, 16), p);
    canvas.drawLine(const Offset(9, 4), const Offset(9, 20), p);
    final path = Path()
      ..moveTo(expand ? 13 : 15, 10)
      ..lineTo(expand ? 15 : 13, 12)
      ..lineTo(expand ? 13 : 15, 14);
    canvas.drawPath(path, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ColumnIconPainter old) =>
      old.color != color || old.expand != expand;
}
