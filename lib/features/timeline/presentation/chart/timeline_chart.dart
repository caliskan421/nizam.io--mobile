import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'timeline_layout.dart';
import 'timeline_painters.dart';

/// Dikey Gantt gövdesi: yatay + dikey kaydırılan çizim alanı (tek `CustomPainter`,
/// `RepaintBoundary`), yapışkan tarih sütunu, boş durum, alttaki sezon şeridi ve "bugüne dön".
/// Durum taşımaz; dokunma/sürükleme geri çağrılarla controller'a gider.
class TimelineChart extends StatefulWidget {
  const TimelineChart({
    super.key,
    required this.view,
    required this.onSelect,
    required this.onOverview,
    required this.onDrag,
    required this.bottomInset,
  });

  final TimelineView view;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onOverview;

  /// Seçili çubuğu basılı tutup sürükleme: kayıtlı aralığa göre gün farkı.
  final ValueChanged<int> onDrag;

  /// Alt güvenli alan (şerit ve düğme bunun üstünde durur).
  final double bottomInset;

  /// Çizim alanının anahtarı (testler çubuk konumunu buradan hesaplar).
  static const canvasKey = ValueKey('timeline-canvas');

  @override
  State<TimelineChart> createState() => _TimelineChartState();
}

class _TimelineChartState extends State<TimelineChart> {
  ScrollController? _v;
  final _h = ScrollController();
  double _viewportH = 0;
  TimelineLayout? _layout;
  String? _dragCode;
  double _dragStartY = 0;

  @override
  void didUpdateWidget(TimelineChart old) {
    super.didUpdateWidget(old);
    final oldScale = old.view.state.scale;
    final scale = widget.view.state.scale;
    final v = _v;
    if (oldScale != scale && v != null && v.hasClients) {
      _keepAnchor(v, oldScale, scale);
    }
    final sel = widget.view.state.selected;
    if (sel != null && sel != old.view.state.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(sel));
    }
  }

  /// Ölçek değişince bugün (görünüyorsa) ya da ekranın ortası yerinde kalır (prototip `zoom`).
  void _keepAnchor(ScrollController v, TimelineScale from, TimelineScale to) {
    final oldPpd = TimelineGeometry.pixelsPerDay(from);
    final newPpd = TimelineGeometry.pixelsPerDay(to);
    final off = v.offset;
    final vh = _viewportH;
    final today = widget.view.today;
    final tScr = TimelineGeometry.topPad + today * oldPpd - off;
    final todayIn = tScr > TimelineGeometry.header && tScr < vh - 60;
    final anchor = todayIn ? tScr : vh / 2;
    final day = todayIn
        ? today.toDouble()
        : (off + anchor - TimelineGeometry.topPad) / oldPpd;
    final next = TimelineGeometry.topPad + day * newPpd - anchor;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!v.hasClients) return;
      v.jumpTo(next.clamp(0, v.position.maxScrollExtent));
    });
  }

  void _animateTo(double y) {
    final v = _v;
    if (v == null || !v.hasClients) return;
    final target = y.clamp(0.0, v.position.maxScrollExtent);
    final d = NzMotion.of(context, NizamioMotion.durSheet);
    if (d == Duration.zero) {
      v.jumpTo(target);
    } else {
      v.animateTo(target, duration: d, curve: NizamioMotion.easeSheet);
    }
  }

  /// Seçilen çubuğun başı görünür alanın üstüne gelir.
  void _reveal(String code) {
    final b = _layout?.barOf(code);
    if (b != null) _animateTo(b.rect.top - TimelineGeometry.header - 16);
  }

  void _goToday() {
    final l = _layout;
    if (l != null) _animateTo(l.todayOffset);
  }

  /// Sezon şeridinde [f] (0–1) oranındaki güne kaydırır (pencere ortalanır).
  void _scrub(double f) {
    final l = _layout;
    final v = _v;
    if (l == null || v == null || !v.hasClients) return;
    final vis = _viewportH - TimelineGeometry.header;
    final y =
        TimelineGeometry.topPad +
        f.clamp(0.0, 1.0) * l.view.days * l.ppd -
        TimelineGeometry.header -
        vis / 2;
    v.jumpTo(y.clamp(0, v.position.maxScrollExtent));
  }

  void _tap(Offset p) {
    final l = _layout;
    if (l == null) return;
    final o = l.overviewAt(p);
    if (o != null) {
      widget.onOverview(o.group.code);
      return;
    }
    final b = l.barAt(p);
    if (b != null) widget.onSelect(b.task.code);
  }

  void _longPressStart(LongPressStartDetails d) {
    final b = _layout?.barAt(d.localPosition);
    if (b == null) return;
    if (widget.view.state.selected != b.task.code) widget.onSelect(b.task.code);
    _dragCode = b.task.code;
    _dragStartY = d.localPosition.dy;
  }

  void _longPressMove(LongPressMoveUpdateDetails d) {
    final l = _layout;
    if (_dragCode == null || l == null) return;
    widget.onDrag(((d.localPosition.dy - _dragStartY) / l.ppd).round());
  }

  @override
  void dispose() {
    _v?.dispose();
    _h.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final ink = TimelineInk(
      colors: c,
      mono: t.monoSm,
      label: t.labelMd.copyWith(
        fontSize: 11,
        height: 14 / 11,
        fontWeight: FontWeight.w600,
      ),
      // Çizelge geometrisi sabit; etiketler en çok 1.3× büyür (tam metin okuyucu etiketinde).
      textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3),
    );
    return LayoutBuilder(
      builder: (context, box) {
        final layout = TimelineLayout.of(widget.view, box.maxWidth);
        _layout = layout;
        _viewportH = box.maxHeight;
        final v = _v ??= ScrollController(
          initialScrollOffset: math.max(0, layout.todayOffset),
        );
        final view = widget.view;
        final selection = view.state.selected != null;
        return Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: v,
                child: SingleChildScrollView(
                  controller: _h,
                  scrollDirection: Axis.horizontal,
                  child: GestureDetector(
                    key: TimelineChart.canvasKey,
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (d) => _tap(d.localPosition),
                    onLongPressStart: _longPressStart,
                    onLongPressMoveUpdate: _longPressMove,
                    onLongPressEnd: (_) => _dragCode = null,
                    child: RepaintBoundary(
                      child: SizedBox(
                        width: layout.contentWidth,
                        height: layout.bodyHeight,
                        child: CustomPaint(
                          painter: TimelineChartPainter(
                            layout: layout,
                            ink: ink,
                            scroll: v,
                            viewportHeight: box.maxHeight,
                          ),
                          child: _BarSemantics(
                            layout: layout,
                            onSelect: widget.onSelect,
                            onOverview: widget.onOverview,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: TimelineGeometry.dateColumn,
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: Semantics(
                    label: l10n.todayLabel(seasonDate(view.today, view.year)),
                    child: CustomPaint(
                      painter: TimelineDatePainter(
                        layout: layout,
                        ink: ink,
                        scroll: v,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (view.empty && !view.state.overview)
              Positioned(
                left: 72,
                right: 12,
                top: TimelineGeometry.header + 60,
                child: Text(
                  view.noneSelected
                      ? l10n.uiTimelineEmptyNoCoord
                      : l10n.uiTimelineEmpty,
                  style: t.bodyMd.copyWith(color: c.textMuted),
                ),
              ),
            if (!selection)
              Positioned(
                left: NizamioSpacing.gutter,
                right: NizamioSpacing.gutter,
                bottom: NizamioSpacing.gutter + widget.bottomInset,
                child: _SeasonStrip(
                  layout: layout,
                  ink: ink,
                  scroll: v,
                  viewportHeight: box.maxHeight,
                  onScrub: _scrub,
                ),
              ),
            if (!selection)
              Positioned.fill(
                child: ListenableBuilder(
                  listenable: v,
                  builder: (context, _) {
                    final off = v.hasClients ? v.offset : v.initialScrollOffset;
                    final ty = layout.todayY;
                    final above = ty < off + TimelineGeometry.header + 10;
                    final below = ty > off + box.maxHeight - 20;
                    return Stack(
                      children: [
                        if (above || below)
                          Positioned(
                            top: above ? TimelineGeometry.header + 10 : null,
                            bottom: above ? null : 70 + widget.bottomInset,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _TodayButton(
                                up: above,
                                onPressed: _goToday,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Çubuk ve sütunların okuyucu düğümleri (çizimle aynı dikdörtgenler).
class _BarSemantics extends StatelessWidget {
  const _BarSemantics({
    required this.layout,
    required this.onSelect,
    required this.onOverview,
  });

  final TimelineLayout layout;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onOverview;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final year = layout.view.year;
    return Stack(
      children: [
        for (final o in layout.overview)
          Positioned.fromRect(
            rect: o.column,
            child: Semantics(
              button: true,
              label: l.overviewLabel(o.group),
              onTap: () => onOverview(o.group.code),
              child: const SizedBox.shrink(),
            ),
          ),
        for (final b in layout.bars)
          Positioned.fromRect(
            rect: b.rect,
            child: Semantics(
              button: true,
              selected: layout.view.state.selected == b.task.code,
              label: l.barLabel(b.task, year),
              onTap: () => onSelect(b.task.code),
              child: const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }
}

class _SeasonStrip extends StatelessWidget {
  const _SeasonStrip({
    required this.layout,
    required this.ink,
    required this.scroll,
    required this.viewportHeight,
    required this.onScrub,
  });

  final TimelineLayout layout;
  final TimelineInk ink;
  final ScrollController scroll;
  final double viewportHeight;
  final ValueChanged<double> onScrub;

  // Prototip: 42 yükseklik, 14 köşe, iç dolgu 6/10/4.
  static const height = 42.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      label: context.l10n.uiTimelineSeasonMap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceRaised.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(NizamioRadius.attach),
          border: Border.all(color: c.border),
          boxShadow: context.shadows.float,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
          child: LayoutBuilder(
            builder: (context, box) {
              void at(Offset p) => onScrub(p.dx / box.maxWidth);
              return GestureDetector(
                key: const ValueKey('timeline-strip'),
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => at(d.localPosition),
                onHorizontalDragStart: (d) => at(d.localPosition),
                onHorizontalDragUpdate: (d) => at(d.localPosition),
                child: CustomPaint(
                  size: Size(box.maxWidth, height - 10),
                  painter: TimelineStripPainter(
                    layout: layout,
                    ink: ink,
                    scroll: scroll,
                    viewportHeight: viewportHeight,
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

class _TodayButton extends StatelessWidget {
  const _TodayButton({required this.up, required this.onPressed});

  final bool up;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NizamioSpacing.space12,
            ),
            child: Center(
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.surfaceRaised.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(NizamioRadius.pill),
                  border: Border.all(color: c.border),
                  boxShadow: context.shadows.float,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: NizamioSpacing.space2,
                  ),
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.3,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          up
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: NizamioSize.iconSizeSm,
                          color: c.text,
                        ),
                        const Gap(6),
                        Text(
                          context.l10n.uiTimelineToday,
                          style: context.text.labelMd.copyWith(color: c.text),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
