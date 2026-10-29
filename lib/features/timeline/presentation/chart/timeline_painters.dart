import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../tasks/tasks.dart';
import '../../domain/timeline.dart';
import 'timeline_layout.dart';

/// Çizelge renk/yazı girdileri (temadan; painter `BuildContext` taşımaz).
final class TimelineInk {
  const TimelineInk({
    required this.colors,
    required this.mono,
    required this.label,
    required this.textScaler,
  });

  final NizamioColors colors;

  /// Mono küçük yazı (tarih etiketleri, sayaçlar).
  final TextStyle mono;

  /// Çubuk/grup adı yazısı.
  final TextStyle label;
  final TextScaler textScaler;

  Color fill(TaskStatus s) => switch (s) {
    TaskStatus.todo => colors.ganttTodo,
    TaskStatus.inProgress => colors.ganttDoing,
    TaskStatus.review => colors.ganttReview,
    TaskStatus.returned => colors.ganttBack,
    TaskStatus.done => colors.ganttDone,
  };

  /// Prototip `SC`: çubuk kenarı / durum noktası.
  Color stroke(TaskStatus s) => switch (s) {
    TaskStatus.todo => colors.textFaint,
    TaskStatus.inProgress => colors.inProgress,
    TaskStatus.review => colors.warning,
    TaskStatus.returned => colors.danger,
    TaskStatus.done => colors.accentText,
  };

  TextPainter text(
    String s,
    TextStyle style, {
    double maxWidth = double.infinity,
    bool ellipsis = false,
  }) => TextPainter(
    text: TextSpan(text: s, style: style),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
    maxLines: ellipsis ? 1 : null,
    ellipsis: ellipsis ? '…' : null,
  )..layout(maxWidth: maxWidth);
}

/// Kesik çizgili yol (dash/gap uzunlukları px).
Path dashed(Path source, {double dash = 4, double gap = 3}) {
  final out = Path();
  for (final m in source.computeMetrics()) {
    var d = 0.0;
    while (d < m.length) {
      out.addPath(m.extractPath(d, math.min(d + dash, m.length)), Offset.zero);
      d += dash + gap;
    }
  }
  return out;
}

/// Çizelge gövdesi (içerik koordinatı): ızgara, bugün çizgisi, genel bakış sütunları, ayırıcılar,
/// görev çubukları ve talep çerçeveleri. Kaydırmadan bağımsızdır (dinleyici yok): kaydırırken
/// yeniden kaydedilmez, yalnız kayar. Yapışkan etiketler [TimelineStickyPainter]'dadır.
class TimelineChartPainter extends CustomPainter {
  TimelineChartPainter({required this.layout, required this.ink});

  final TimelineLayout layout;
  final TimelineInk ink;

  @override
  void paint(Canvas canvas, Size size) {
    final c = ink.colors;
    final l = layout;
    final p = Paint();

    // Izgara zemini ve sol kenar.
    canvas.drawRect(
      Rect.fromLTRB(TimelineGeometry.dateColumn, 0, size.width, size.height),
      p..color = c.surface,
    );
    _hLine(
      canvas,
      TimelineGeometry.dateColumn,
      0,
      0,
      c.border,
      vertical: size.height,
    );

    _grid(canvas, size);

    // Bugün çizgisi.
    canvas.drawRect(
      Rect.fromLTWH(
        TimelineGeometry.dateColumn,
        l.todayY - 1,
        size.width - TimelineGeometry.dateColumn,
        2,
      ),
      p..color = c.accentText,
    );

    // Genel bakış.
    for (final o in l.overview) {
      if (o.group.total > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(o.column, const Radius.circular(6)),
          p..color = c.text.withValues(alpha: 0.04),
        );
      }
      for (final (t, r, planH) in o.strips) {
        _fill(canvas, t, r, planH, const Radius.circular(2));
        if (t.late) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(r, const Radius.circular(2)),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = c.danger,
          );
        }
      }
    }

    // Koordinatörlük ayırıcıları.
    for (final x in l.separators) {
      canvas.drawRect(
        Rect.fromLTWH(x, 0, 1, size.height),
        p..color = c.borderStrong,
      );
    }

    // Çubuklar: seçim varken diğerleri tek katmanda soluk (0.35; şeritler çakışmadığından
    // çubuk başına `saveLayer` ile aynı görünüm), seçili çubuk en üstte (prototip z 4).
    final sel = l.view.state.selected;
    TimelineBarGeom? selected;
    final dimmed = <TimelineBarGeom>[];
    for (final b in l.bars) {
      if (b.task.code == sel) {
        selected = b;
      } else if (sel != null) {
        dimmed.add(b);
      } else {
        _bar(canvas, b, false);
      }
    }
    if (dimmed.isNotEmpty) {
      var bounds = dimmed.first.rect;
      for (final b in dimmed) {
        bounds = bounds
            .expandToInclude(b.rect)
            .expandToInclude(b.request ?? b.rect);
      }
      canvas.saveLayer(
        bounds.inflate(4),
        Paint()..color = c.text.withValues(alpha: 0.35),
      );
      for (final b in dimmed) {
        _bar(canvas, b, false);
      }
      canvas.restore();
    }
    if (selected != null) _bar(canvas, selected, true);
  }

  void _grid(Canvas canvas, Size size) {
    final c = ink.colors;
    final l = layout;
    final year = l.view.year;
    final scale = l.view.state.scale;
    final w = size.width;
    final p = Paint();
    if (scale == TimelineScale.day) {
      for (var d = 0; d < l.view.days; d++) {
        final wd = seasonDate(d, year).weekday;
        if (wd == DateTime.saturday || wd == DateTime.sunday) {
          canvas.drawRect(
            Rect.fromLTRB(
              TimelineGeometry.dateColumn + 1,
              l.yOf(d),
              w,
              l.yOf(d + 1),
            ),
            p..color = c.text.withValues(alpha: 0.03),
          );
        }
      }
    }
    for (var d = 0; d < l.view.days; d++) {
      final date = seasonDate(d, year);
      final y = l.yOf(d);
      if (date.day == 1) {
        _hLine(canvas, TimelineGeometry.dateColumn, w, y, c.borderStrong);
        if (scale == TimelineScale.month) {
          _hLine(
            canvas,
            TimelineGeometry.dateColumn + 1,
            w,
            l.yOf(d + 14),
            c.border.withValues(alpha: 0.6),
          );
        }
        continue;
      }
      if (scale == TimelineScale.day) {
        _hLine(
          canvas,
          TimelineGeometry.dateColumn + 1,
          w,
          y,
          date.weekday == DateTime.monday
              ? c.border
              : c.border.withValues(alpha: 0.45),
        );
      } else if (scale == TimelineScale.week &&
          date.weekday == DateTime.monday) {
        _hLine(canvas, TimelineGeometry.dateColumn + 1, w, y, c.border);
      }
    }
  }

  void _hLine(
    Canvas canvas,
    double x0,
    double x1,
    double y,
    Color color, {
    double? vertical,
  }) {
    final p = Paint()..color = color;
    if (vertical != null) {
      canvas.drawRect(Rect.fromLTWH(x0, 0, 1, vertical), p);
    } else {
      canvas.drawRect(Rect.fromLTRB(x0, y, x1, y + 1), p);
    }
  }

  /// Planlanan kısım durum rengi, taşan kısım `ganttLate`.
  void _fill(
    Canvas canvas,
    TimelineTask t,
    Rect r,
    double planH,
    Radius radius, {
    bool squareBottom = false,
  }) {
    final rr = RRect.fromRectAndCorners(
      r,
      topLeft: radius,
      topRight: radius,
      bottomLeft: squareBottom ? Radius.zero : radius,
      bottomRight: squareBottom ? Radius.zero : radius,
    );
    canvas
      ..save()
      ..clipRRect(rr)
      ..drawRect(r, Paint()..color = ink.fill(t.status));
    if (t.overrun && planH < r.height) {
      canvas.drawRect(
        Rect.fromLTRB(r.left, r.top + planH, r.right, r.bottom),
        Paint()..color = ink.colors.ganttLate,
      );
    }
    canvas.restore();
  }

  void _bar(Canvas canvas, TimelineBarGeom b, bool selected) {
    final c = ink.colors;
    final t = b.task;
    final r = b.rect;
    const radius = Radius.circular(8);
    final hasReq = b.request != null;
    final rr = RRect.fromRectAndCorners(
      r,
      topLeft: radius,
      topRight: radius,
      bottomLeft: hasReq ? Radius.zero : radius,
      bottomRight: hasReq ? Radius.zero : radius,
    );
    if (selected) {
      canvas.drawRRect(
        rr.shift(const Offset(0, 8)).inflate(2),
        Paint()
          ..color = c.background.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }
    _fill(canvas, t, r, b.planHeight, radius, squareBottom: hasReq);
    if (t.overrun && b.planHeight < r.height) {
      canvas.drawRect(
        Rect.fromLTWH(r.left, r.top + b.planHeight - 1, r.width, 2),
        Paint()..color = c.ganttInk.withValues(alpha: 0.45),
      );
    }
    final border = Paint()..style = PaintingStyle.stroke;
    if (t.late) {
      border
        ..strokeWidth = 1.5
        ..color = c.danger;
      canvas.drawPath(dashed(Path()..addRRect(rr.deflate(0.75))), border);
    } else {
      border
        ..strokeWidth = 1
        ..color = ink.stroke(t.status).withValues(alpha: 0.7);
      canvas.drawRRect(rr.deflate(0.5), border);
    }
    if (selected) {
      canvas.drawRRect(
        rr.inflate(2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = c.text,
      );
    }
    final req = b.request;
    if (req != null) {
      final path = Path()
        ..moveTo(req.left + 0.75, req.top)
        ..lineTo(req.left + 0.75, req.bottom - 8)
        ..arcToPoint(
          Offset(req.left + 8, req.bottom - 0.75),
          radius: const Radius.circular(8),
          clockwise: false,
        )
        ..lineTo(req.right - 8, req.bottom - 0.75)
        ..arcToPoint(
          Offset(req.right - 0.75, req.bottom - 8),
          radius: const Radius.circular(8),
          clockwise: false,
        )
        ..lineTo(req.right - 0.75, req.top);
      canvas.drawPath(
        dashed(path),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = c.accentText,
      );
    }
  }

  @override
  bool shouldRepaint(TimelineChartPainter old) =>
      old.layout != layout || old.ink.colors != ink.colors;
}

/// Kaydırmaya bağlı ince katman (içerik koordinatı): çubukların yapışkan dikey etiketleri ve
/// çoklu / genel bakışta yapışkan grup başlıkları. Yalnız bu katman kaydırmada yeniden çizilir;
/// etiket metinleri örnek ömrünce önbellekte tutulur (görünür uzunluk değişmedikçe yeniden
/// dizilmez).
class TimelineStickyPainter extends CustomPainter {
  TimelineStickyPainter({
    required this.layout,
    required this.ink,
    required this.scroll,
    required this.viewportHeight,
  }) : super(repaint: scroll);

  final TimelineLayout layout;
  final TimelineInk ink;
  final ScrollController scroll;
  final double viewportHeight;

  final _labels = <(bool, String), (int, TextPainter)>{};

  double get _offset => scroll.hasClients ? scroll.offset : 0;

  @override
  void paint(Canvas canvas, Size size) {
    final c = ink.colors;
    final l = layout;
    final off = _offset;
    final sel = l.view.state.selected;
    final vTop = off + TimelineGeometry.header + 4;
    final vBot = off + viewportHeight - 8;
    final style = ink.label.copyWith(color: c.ganttInk);
    final dimStyle = ink.label.copyWith(
      color: c.ganttInk.withValues(alpha: 0.35),
    );
    for (final b in l.bars) {
      if (b.rect.bottom < vTop || b.rect.top > vBot) continue;
      final visible =
          math.min(b.rect.bottom, vBot) - math.max(b.rect.top, vTop);
      final maxLen = (visible - 12).floor();
      if (maxLen <= 12) continue;
      final dim = sel != null && sel != b.task.code;
      final key = (dim, b.task.code);
      final cached = _labels[key];
      final TextPainter tp;
      if (cached != null && cached.$1 == maxLen) {
        tp = cached.$2;
      } else {
        cached?.$2.dispose();
        tp = ink.text(
          b.task.item.title,
          dim ? dimStyle : style,
          maxWidth: maxLen.toDouble(),
          ellipsis: true,
        );
        _labels[key] = (maxLen, tp);
      }
      final top = math.max(b.rect.top, off + l.stickTop) + 6;
      canvas
        ..save()
        ..clipRect(b.rect)
        ..translate(b.rect.center.dx + tp.height / 2, top)
        ..rotate(math.pi / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }
    _heads(canvas, size, off);
  }

  /// Çoklu / genel bakış: dikeyde yapışkan grup başlık satırı.
  void _heads(Canvas canvas, Size size, double off) {
    final l = layout;
    if (l.heads.isEmpty) return;
    final c = ink.colors;
    final top = off + TimelineGeometry.header;
    canvas
      ..drawRect(
        Rect.fromLTWH(0, top, size.width, TimelineGeometry.groupHeader),
        Paint()..color = c.background.withValues(alpha: 0.92),
      )
      ..drawRect(
        Rect.fromLTWH(0, top + TimelineGeometry.groupHeader - 1, size.width, 1),
        Paint()..color = c.border,
      );
    final overview = l.view.state.overview;
    for (final h in l.heads) {
      if (!h.first) {
        canvas.drawRect(
          Rect.fromLTWH(h.x, top, 1, TimelineGeometry.groupHeader),
          Paint()..color = c.borderStrong,
        );
      }
      final count = overview
          ? (h.group.late > 0 ? '${h.group.late}!' : '·')
          : '${h.group.done}/${h.group.total}';
      final countTp = ink.text(
        count,
        ink.mono.copyWith(
          color: overview && h.group.late > 0 ? c.danger : c.textFaint,
          fontSize: 10,
        ),
      );
      final pad = overview ? 2.0 : 8.0;
      final nameTp = ink.text(
        overview ? h.group.code : h.group.name,
        ink.label.copyWith(color: c.text, fontSize: overview ? 9 : 12),
        maxWidth: math.max(0, h.width - 2 * pad - countTp.width - 6),
        ellipsis: true,
      );
      final cy = top + TimelineGeometry.groupHeader / 2;
      canvas
        ..save()
        ..clipRect(
          Rect.fromLTWH(h.x, top, h.width, TimelineGeometry.groupHeader),
        );
      nameTp.paint(canvas, Offset(h.x + pad, cy - nameTp.height / 2));
      if (!overview) {
        countTp.paint(
          canvas,
          Offset(h.x + pad + nameTp.width + 6, cy - countTp.height / 2),
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(TimelineStickyPainter old) =>
      old.layout != layout ||
      old.ink.colors != ink.colors ||
      old.viewportHeight != viewportHeight;
}

/// Yapışkan tarih sütunu (ekran koordinatı): ay etiketleri (dikey, yapışkan), gün/hafta
/// etiketleri ve bugün rozeti.
class TimelineDatePainter extends CustomPainter {
  TimelineDatePainter({
    required this.layout,
    required this.ink,
    required this.scroll,
  }) : super(repaint: scroll);

  final TimelineLayout layout;
  final TimelineInk ink;
  final ScrollController scroll;

  @override
  void paint(Canvas canvas, Size size) {
    final c = ink.colors;
    final l = layout;
    final off = scroll.hasClients ? scroll.offset : 0.0;
    final year = l.view.year;
    final today = l.view.today;
    final scale = l.view.state.scale;
    canvas
      ..drawRect(Offset.zero & size, Paint()..color = c.background)
      ..drawRect(
        Rect.fromLTWH(size.width - 1, 0, 1, size.height),
        Paint()..color = c.border,
      )
      ..save()
      ..translate(0, -off);
    final visTop = off - 40;
    final visBot = off + size.height + 40;

    // Ay etiketleri.
    final full = DateFormat('MMMM y', 'tr');
    final short = DateFormat('MMM', 'tr');
    final todayMonth = seasonDate(today, year).month;
    for (var m = 1; m <= 12; m++) {
      final first = seasonDay(DateTime(year, m), year);
      final next = seasonDay(DateTime(year, m + 1), year);
      final top = l.yOf(first);
      final h = (next - first) * l.ppd;
      if (top + h < visTop || top > visBot) continue;
      final date = DateTime(year, m);
      final label = (h >= 120 ? full.format(date) : short.format(date))
          .toUpperCase();
      final tp = ink.text(
        label,
        ink.mono.copyWith(
          fontSize: 10,
          letterSpacing: 1.4,
          color: m == todayMonth ? c.text : c.textFaint,
        ),
      );
      final span = tp.width + 16;
      final y = math.min(
        math.max(top, off + TimelineGeometry.header),
        top + h - span,
      );
      if (y < top) continue;
      canvas
        ..save()
        ..translate(4, y + 8 + tp.width)
        ..rotate(-math.pi / 2);
      tp.paint(canvas, Offset(0, (14 - tp.height) / 2));
      canvas.restore();
    }

    // Gün / hafta / ay ortası etiketleri.
    final todayY = l.todayY;
    final wd = DateFormat('E', 'tr');
    void tick(double y, String label, {String? sub, bool strong = false}) {
      if (y < visTop || y > visBot) return;
      final tp = ink.text(
        label,
        ink.mono.copyWith(
          fontSize: 11,
          fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
          color: c.textMuted,
        ),
      );
      tp.paint(canvas, Offset(44 - tp.width, y - tp.height / 2));
      if (sub != null) {
        final sp = ink.text(
          sub,
          ink.mono.copyWith(fontSize: 9, color: c.textFaint),
        );
        sp.paint(
          canvas,
          Offset(44 - tp.width - 4 - sp.width, y - sp.height / 2),
        );
      }
    }

    // Yalnız görünür günler (kaydırmanın her karesinde 365 gün dolaşılmaz).
    final d0 = math.max(
      0,
      ((visTop - TimelineGeometry.topPad) / l.ppd).floor() - 1,
    );
    final d1 = math.min(
      l.view.days,
      ((visBot - TimelineGeometry.topPad) / l.ppd).ceil() + 1,
    );
    for (var d = d0; d < d1; d++) {
      final date = seasonDate(d, year);
      final y = l.yOf(d);
      if (scale == TimelineScale.day) {
        if (d == today) continue;
        tick(
          y + l.ppd / 2,
          '${date.day}',
          sub: wd.format(date).toLowerCase(),
          strong: date.weekday == DateTime.monday,
        );
      } else if (scale == TimelineScale.week &&
          date.weekday == DateTime.monday) {
        if ((y - todayY).abs() < 16) continue;
        tick(y, '${date.day}');
      } else if (scale == TimelineScale.month && date.day == 15) {
        if ((y - todayY).abs() < 16) continue;
        tick(y, '15');
      }
    }

    // Bugün rozeti.
    final badge = RRect.fromRectAndRadius(
      Rect.fromLTWH(18, todayY - 9, 30, 18),
      const Radius.circular(9),
    );
    canvas.drawRRect(badge, Paint()..color = c.primary);
    final tp = ink.text(
      '${seasonDate(today, year).day}',
      ink.mono.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: c.onPrimary,
        height: 1,
      ),
    );
    tp.paint(
      canvas,
      Offset(badge.center.dx - tp.width / 2, badge.center.dy - tp.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(TimelineDatePainter old) =>
      old.layout != layout || old.ink.colors != ink.colors;
}

/// Sezon şeridi: hafta yoğunluk histogramı, ay adları, görünür pencere çerçevesi, bugün işareti.
class TimelineStripPainter extends CustomPainter {
  TimelineStripPainter({
    required this.layout,
    required this.ink,
    required this.scroll,
    required this.viewportHeight,
  }) : super(repaint: scroll);

  final TimelineLayout layout;
  final TimelineInk ink;
  final ScrollController scroll;
  final double viewportHeight;

  static const labelBand = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final c = ink.colors;
    final v = layout.view;
    final weeks = v.weeks;
    final barsBottom = size.height - 10;
    final mx = weeks.fold<int>(1, (a, w) => math.max(a, w.count));
    final n = weeks.length;
    final bw = (size.width - (n - 1)) / n;
    for (var i = 0; i < n; i++) {
      final w = weeks[i];
      final h = w.count > 0 ? 3 + (w.count / mx * 15).roundToDouble() : 2.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(i * (bw + 1), barsBottom - h, bw, h),
          const Radius.circular(1),
        ),
        Paint()
          ..color = w.late
              ? c.danger
              : w.count > 0
              ? c.textFaint
              : c.text.withValues(alpha: 0.12),
      );
    }
    final mw = size.width / 12;
    final todayMonth = seasonDate(v.today, v.year).month;
    final fmt = DateFormat('MMM', 'tr');
    for (var m = 0; m < 12; m++) {
      final tp = ink.text(
        fmt.format(DateTime(v.year, m + 1)).toLowerCase(),
        ink.mono.copyWith(
          fontSize: 8,
          height: 1.1,
          color: m + 1 == todayMonth ? c.text : c.textFaint,
        ),
        maxWidth: mw,
      );
      tp.paint(canvas, Offset(m * mw, size.height - labelBand));
    }
    // Görünür pencere.
    final off = scroll.hasClients ? scroll.offset : 0.0;
    final d0 = math.max(
      0,
      (off + TimelineGeometry.header - TimelineGeometry.topPad) / layout.ppd,
    );
    final dv = math.max(
      1,
      (viewportHeight - TimelineGeometry.header) / layout.ppd,
    );
    final l = math.min(1.0, d0 / v.days);
    final wFrac = math.min(1 - l, dv / v.days);
    final win = Rect.fromLTRB(
      l * size.width,
      -2,
      l * size.width + math.max(6, wFrac * size.width),
      size.height - labelBand,
    );
    final rr = RRect.fromRectAndRadius(win, const Radius.circular(4));
    canvas
      ..drawRRect(rr, Paint()..color = c.text.withValues(alpha: 0.08))
      ..drawRRect(
        rr.deflate(0.75),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = c.text,
      )
      ..drawRect(
        Rect.fromLTWH(
          v.today / v.days * size.width,
          -3,
          2,
          size.height - labelBand + 3,
        ),
        Paint()..color = c.primary,
      );
  }

  @override
  bool shouldRepaint(TimelineStripPainter old) =>
      old.layout != layout ||
      old.ink.colors != ink.colors ||
      old.viewportHeight != viewportHeight;
}
