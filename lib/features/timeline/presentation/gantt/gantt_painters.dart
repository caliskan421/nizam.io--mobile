import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../tasks/tasks.dart';
import '../../domain/horizontal_timeline.dart';
import 'gantt_geometry.dart';

/// Durum rengi (prototip `SC`: `--gp-*`).
Color ganttStatusColor(NizamioColors c, TaskStatus s) => switch (s) {
  TaskStatus.todo => c.ganttTodo,
  TaskStatus.inProgress => c.ganttDoing,
  TaskStatus.review => c.ganttReview,
  TaskStatus.returned => c.ganttBack,
  TaskStatus.done => c.ganttDone,
  // Tanımsız sunucu durumu: nötr görünüm.
  TaskStatus.unknown => c.ganttTodo,
};

/// `repeating-linear-gradient(135deg, late 0 band, late %45 band 2·band)`: [rrect] içinde açık
/// zemin üstüne `/` yönünde dolu şeritler.
void paintGanttHatch(Canvas canvas, RRect rrect, Color color, double band) {
  final r = rrect.outerRect;
  canvas
    ..save()
    ..clipRRect(rrect)
    ..drawRect(
      r,
      Paint()..color = color.withValues(alpha: GanttGeometry.hatchSoft),
    );
  // Eğim yönünde dönem 2·band; x eksenindeki karşılığı √2 katı.
  final step = 2 * band * math.sqrt2;
  final p = Paint()
    ..color = color
    ..strokeWidth = band
    ..isAntiAlias = true;
  final h = r.height;
  for (var x = r.left - h; x < r.right + step; x += step) {
    final c = x + band * math.sqrt2 / 2;
    canvas.drawLine(Offset(c, r.bottom), Offset(c + h, r.top), p);
  }
  canvas.restore();
}

/// Tarih alanı zemini (tarih alanı koordinatı): grup satırı zemini ve özet
/// çizgisi, seçili satır zemini, haftalık ızgara, gecikme şeritleri. Kaydırmadan bağımsızdır;
/// yalnız yerleşim ya da renkler değişince yeniden çizilir.
class GanttBodyPainter extends CustomPainter {
  GanttBodyPainter({required this.layout, required this.colors});

  final GanttLayout layout;
  final NizamioColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    final p = Paint();
    final grid = layout.gridLines.toList();
    for (final b in layout.rows) {
      final row = Rect.fromLTWH(0, b.top, size.width, GanttGeometry.row);
      switch (b.row) {
        case GanttHeadRow():
          canvas
            ..drawRect(row, p..color = c.surface)
            ..drawRect(
              Rect.fromLTWH(0, b.top, size.width, NizamioSize.borderWidth),
              p..color = c.border,
            );
          final s = b.summary!;
          canvas.drawRRect(
            RRect.fromRectAndRadius(s, Radius.circular(s.height / 2)),
            p..color = c.borderStrong,
          );
        case GanttTaskRow(:final selected):
          if (selected) {
            canvas.drawRect(
              row,
              p
                ..color = c.text.withValues(
                  alpha: GanttGeometry.selectedRowAlpha,
                ),
            );
          }
          p.color = c.border;
          for (final x in grid) {
            canvas.drawRect(
              Rect.fromLTWH(x, b.top, NizamioSize.borderWidth, row.height),
              p,
            );
          }
          if (b.late case final late?) {
            paintGanttHatch(
              canvas,
              RRect.fromRectAndCorners(
                late,
                topRight: const Radius.circular(GanttGeometry.barRadius),
                bottomRight: const Radius.circular(GanttGeometry.barRadius),
              ),
              c.ganttLate,
              GanttGeometry.hatch,
            );
          }
      }
    }
  }

  @override
  bool shouldRepaint(GanttBodyPainter old) =>
      old.layout != layout || old.colors != colors;
}

/// Seçim halkasının geçişi: [selected] halkaya [fromIn]'den, [previous] halkadan [fromOut]'tan
/// başlayarak [t] ile (0 → 1, doğrusal) geçer; diğer çubuklarda halka yoktur.
@immutable
final class GanttRing {
  const GanttRing({
    required this.t,
    this.selected,
    this.previous,
    this.fromIn = 1,
    this.fromOut = 0,
  });

  final Animation<double> t;
  final String? selected;
  final String? previous;
  final double fromIn;
  final double fromOut;

  /// [code] çubuğunun halka saydamlığı (0–1).
  double alphaOf(String code) => code == selected
      ? fromIn + (1 - fromIn) * t.value
      : code == previous
      ? fromOut * (1 - t.value)
      : 0;

  @override
  bool operator ==(Object other) =>
      other is GanttRing &&
      other.t == t &&
      other.selected == selected &&
      other.previous == previous &&
      other.fromIn == fromIn &&
      other.fromOut == fromOut;

  @override
  int get hashCode => Object.hash(t, selected, previous, fromIn, fromOut);
}

/// Görev çubukları (tarih alanı koordinatı): yalnız [visible] satırları çizer — durum rengi,
/// seçili halka ([ring] ile geçişli), sığan başlık çubuğun içinde, sığmayan çubuğun sağında.
/// Okuyucu düğümleri de yalnız görünür çubuklar içindir ([semantics]; çağıran kurar).
class GanttBarsPainter extends CustomPainter {
  GanttBarsPainter({
    required this.layout,
    required this.visible,
    required this.colors,
    required this.barStyle,
    required this.outsideStyle,
    required this.textScaler,
    required this.ring,
    required this.semantics,
  }) : super(repaint: ring.t);

  final GanttLayout layout;

  /// Çizilecek görev satırlarının sırası ([GanttLayout.visibleBars]).
  final List<int> visible;
  final NizamioColors colors;
  final TextStyle barStyle;
  final TextStyle outsideStyle;
  final TextScaler textScaler;
  final GanttRing ring;
  final List<CustomPainterSemantics> semantics;

  TextPainter _text(String s, TextStyle style, double maxWidth) => TextPainter(
    text: TextSpan(text: s, style: style),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
    maxLines: 1,
    ellipsis: '…',
  )..layout(maxWidth: math.max(0, maxWidth));

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    final p = Paint();
    const radius = Radius.circular(GanttGeometry.barRadius);
    for (final i in visible) {
      final b = layout.rows[i];
      if (b.row case GanttTaskRow(:final task)) {
        final bar = b.bar!;
        final alpha = ring.alphaOf(task.code);
        if (alpha > 0) {
          // `BoxShadow(spreadRadius: 2)`: aynı köşeyle 2 px büyütülmüş dolgu.
          canvas.drawRRect(
            RRect.fromRectAndRadius(bar.inflate(GanttGeometry.ring), radius),
            p..color = c.text.withValues(alpha: c.text.a * alpha),
          );
        }
        final shape = RRect.fromRectAndRadius(bar, radius);
        canvas.drawRRect(shape, p..color = ganttStatusColor(c, task.status));
        if (b.inside) {
          final tp = _text(
            task.item.title,
            barStyle,
            bar.width - 2 * GanttGeometry.barPad,
          );
          canvas
            ..save()
            ..clipRRect(shape);
          tp.paint(
            canvas,
            Offset(
              bar.left + GanttGeometry.barPad,
              bar.top + (bar.height - tp.height) / 2,
            ),
          );
          canvas.restore();
        }
      }
    }
    for (final i in visible) {
      final b = layout.rows[i];
      if (b.row case GanttTaskRow(:final task) when !b.inside) {
        _text(
          task.item.title,
          outsideStyle,
          GanttGeometry.outsideMax,
        ).paint(canvas, Offset(b.outsideX, b.top + GanttGeometry.outsideTop));
      }
    }
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder =>
      (_) => semantics;

  @override
  bool shouldRepaint(GanttBarsPainter old) =>
      old.layout != layout ||
      !listEquals(old.visible, visible) ||
      old.colors != colors ||
      old.barStyle != barStyle ||
      old.outsideStyle != outsideStyle ||
      old.textScaler != textScaler ||
      old.ring != ring;

  @override
  bool shouldRebuildSemantics(GanttBarsPainter oldDelegate) =>
      oldDelegate.layout != layout || !listEquals(oldDelegate.visible, visible);
}

/// Yapışkan tarih başlığının ay adları ve gün işaretleri (tarih alanı koordinatı). Metinler
/// çağırandan gelir (ARB/`intl`); ressam `BuildContext` taşımaz.
class GanttHeaderPainter extends CustomPainter {
  GanttHeaderPainter({
    required this.layout,
    required this.monthLabels,
    required this.colors,
    required this.monthStyle,
    required this.tickStyle,
    required this.textScaler,
  });

  final GanttLayout layout;

  /// 12 ay adı (sezon ölçeğinde kısa).
  final List<String> monthLabels;
  final NizamioColors colors;
  final TextStyle monthStyle;
  final TextStyle tickStyle;
  final TextScaler textScaler;

  TextPainter _text(String s, TextStyle style, double maxWidth) => TextPainter(
    text: TextSpan(text: s, style: style),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
    maxLines: 1,
  )..layout(maxWidth: math.max(0, maxWidth));

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    final line = Paint()..color = c.borderStrong;
    for (final m in layout.months) {
      canvas.drawRect(
        Rect.fromLTWH(
          m.x,
          GanttGeometry.monthTop,
          NizamioSize.borderWidth,
          GanttGeometry.headLine,
        ),
        line,
      );
      final label = monthLabels[m.month - 1];
      canvas
        ..save()
        ..clipRect(Rect.fromLTWH(m.x, 0, m.width, GanttGeometry.stickyHeader));
      _text(label, monthStyle, m.width - GanttGeometry.monthPad).paint(
        canvas,
        Offset(m.x + GanttGeometry.monthPad, GanttGeometry.monthTop),
      );
      canvas.restore();
    }
    for (final t in layout.ticks) {
      final style = tickStyle.copyWith(
        color: t.today
            ? c.danger
            : t.weekend && layout.view.state.zoom == GanttZoom.week
            ? c.textFaint
            : c.textMuted,
        fontWeight: t.today ? FontWeight.w600 : FontWeight.w400,
      );
      _text('${t.date}', style, double.infinity).paint(
        canvas,
        Offset(t.x + GanttGeometry.tickPad, GanttGeometry.tickTop),
      );
    }
  }

  @override
  bool shouldRepaint(GanttHeaderPainter old) =>
      old.layout != layout ||
      old.colors != colors ||
      old.monthStyle != monthStyle ||
      old.tickStyle != tickStyle ||
      old.textScaler != textScaler ||
      !_same(old.monthLabels, monthLabels);

  static bool _same(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Gecikme lejantı örneği (14 × 8, köşe 3, çizgi 3 + 3).
class GanttHatchSwatchPainter extends CustomPainter {
  GanttHatchSwatchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) => paintGanttHatch(
    canvas,
    RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(GanttGeometry.swatchRadius),
    ),
    color,
    GanttGeometry.swatchHatch,
  );

  @override
  bool shouldRepaint(GanttHatchSwatchPainter old) => old.color != color;
}
