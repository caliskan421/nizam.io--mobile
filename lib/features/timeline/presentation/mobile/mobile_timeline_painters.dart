import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../domain/timeline.dart';
import '../gantt/gantt_painters.dart';
import 'mobile_timeline_layout.dart';

void _text(
  Canvas canvas,
  String text,
  TextStyle style,
  Offset at,
  double width,
) {
  if (width <= 0) return;
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 1,
    ellipsis: '…',
  )..layout(maxWidth: width);
  painter.paint(canvas, at);
}

/// Izgara ve çubuklar tek resimdir. Kaydırma yalnız görünür çubuk içi başlık konumunu değiştirir.
class MobileTimelinePainter extends CustomPainter {
  MobileTimelinePainter({
    required this.layout,
    required this.colors,
    required this.style,
    required this.scroll,
    required this.viewport,
    required this.vertical,
    required this.viewportHeight,
  }) : super(repaint: Listenable.merge([scroll, vertical]));
  final MobileTimelineLayout layout;
  final NizamioColors colors;
  final TextStyle style;
  final ScrollController scroll;
  final double viewport;
  final ScrollController vertical;
  final double viewportHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    final c = colors;
    final l = layout;
    final left = scroll.hasClients ? scroll.offset : 0.0;
    final right = left + viewport;
    final top = vertical.hasClients ? vertical.offset : 0.0;
    final bottom = top + viewportHeight;
    final firstDay = math.max(
      0,
      ((left - MobileTimelineLayout.leftPad) / l.ppd).floor(),
    );
    final lastDay = math.min(
      l.view.days,
      ((right - MobileTimelineLayout.leftPad) / l.ppd).ceil(),
    );
    for (var day = firstDay; day < lastDay; day++) {
      final date = seasonDate(day, l.view.year);
      final x = l.x(day);
      if (l.view.state.scale == TimelineScale.day && date.weekday > 5) {
        canvas.drawRect(
          Rect.fromLTWH(x, 0, l.ppd, size.height),
          p..color = c.text.withValues(alpha: .03),
        );
      }
      final line = switch (l.view.state.scale) {
        TimelineScale.day => true,
        TimelineScale.week => date.weekday == DateTime.monday,
        TimelineScale.month => date.day == 1 || date.day == 15,
      };
      if (line) {
        canvas.drawRect(
          Rect.fromLTWH(x, 0, 1, size.height),
          p..color = c.border,
        );
      }
    }
    for (final head in l.heads) {
      if (head.top + MobileTimelineLayout.groupHeight < top ||
          head.top > bottom) {
        continue;
      }
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          head.top,
          size.width,
          MobileTimelineLayout.groupHeight,
        ),
        p..color = c.surface,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            l.x(head.start),
            head.top + 18,
            math.max(4, (head.end - head.start) * l.ppd),
            4,
          ),
          const Radius.circular(2),
        ),
        p..color = c.borderStrong,
      );
    }
    for (final bar in l.bars) {
      if (bar.rect.right + bar.requestWidth < left ||
          bar.rect.left > right ||
          bar.rect.bottom < top ||
          bar.rect.top > bottom) {
        continue;
      }
      final t = bar.task;
      final selected = l.view.state.selected == t.code;
      final dim = l.view.selection != null && !selected;
      canvas.save();
      Color fade(Color color) =>
          dim ? color.withValues(alpha: color.a * .35) : color;
      final r = RRect.fromRectAndRadius(bar.rect, const Radius.circular(8));
      canvas.drawRRect(r, p..color = fade(ganttStatusColor(c, t.status)));
      if (t.overrun && bar.planWidth < bar.rect.width) {
        canvas.save();
        canvas.clipRRect(r);
        canvas.drawRect(
          Rect.fromLTRB(
            bar.rect.left + bar.planWidth,
            bar.rect.top,
            bar.rect.right,
            bar.rect.bottom,
          ),
          p..color = fade(c.ganttLate),
        );
        canvas.restore();
      }
      if (t.late) {
        final dash = Paint()
          ..color = fade(c.danger)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        for (
          var x =
              bar.rect.left +
              5 +
              math.max(0, ((left - bar.rect.left - 5) / 8).floor()) * 8;
          x < math.min(right, bar.rect.right - 5);
          x += 8
        ) {
          canvas.drawLine(
            Offset(x, bar.rect.top),
            Offset(math.min(x + 4, bar.rect.right - 5), bar.rect.top),
            dash,
          );
          canvas.drawLine(
            Offset(x, bar.rect.bottom),
            Offset(math.min(x + 4, bar.rect.right - 5), bar.rect.bottom),
            dash,
          );
        }
      }
      if (bar.requestWidth > 0) {
        final req = Rect.fromLTWH(
          bar.rect.right,
          bar.rect.top,
          bar.requestWidth,
          bar.rect.height,
        );
        final dash = Paint()
          ..color = fade(c.accentText)
          ..strokeWidth = 1.5;
        for (
          var x = req.left + math.max(0, ((left - req.left) / 8).floor()) * 8;
          x < math.min(right, req.right);
          x += 8
        ) {
          canvas.drawLine(
            Offset(x, req.top),
            Offset(math.min(x + 4, req.right), req.top),
            dash,
          );
          canvas.drawLine(
            Offset(x, req.bottom),
            Offset(math.min(x + 4, req.right), req.bottom),
            dash,
          );
        }
        for (var y = req.top; y < req.bottom; y += 8) {
          canvas.drawLine(
            Offset(req.right, y),
            Offset(req.right, math.min(y + 4, req.bottom)),
            dash,
          );
        }
      }
      if (selected) {
        canvas.drawRRect(
          r.inflate(2),
          Paint()
            ..color = c.text
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
      final visibleLeft = math.max(bar.rect.left, left);
      final visibleRight = math.min(bar.rect.right, right);
      if (visibleRight - visibleLeft >= 84) {
        canvas.save();
        canvas.clipRRect(r);
        _text(
          canvas,
          t.item.title,
          style.copyWith(color: fade(c.ganttInk)),
          Offset(visibleLeft + 8, bar.rect.top + 6),
          visibleRight - visibleLeft - 16,
        );
        canvas.restore();
      }
      canvas.restore();
      canvas.drawLine(
        Offset(0, bar.top + 44),
        Offset(size.width, bar.top + 44),
        Paint()..color = c.border.withValues(alpha: .7),
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(l.todayX - 1, 0, 2, size.height),
      p..color = c.accentText,
    );
  }

  @override
  bool shouldRepaint(covariant MobileTimelinePainter old) =>
      old.layout != layout ||
      old.colors != colors ||
      old.style != style ||
      old.viewport != viewport;
}

class MobileTimelineAxisPainter extends CustomPainter {
  MobileTimelineAxisPainter({
    required this.layout,
    required this.colors,
    required this.style,
    required this.scroll,
  }) : super(repaint: scroll);
  final MobileTimelineLayout layout;
  final NizamioColors colors;
  final TextStyle style;
  final ScrollController scroll;
  @override
  void paint(Canvas canvas, Size size) {
    final l = layout;
    final c = colors;
    canvas.drawRect(Offset.zero & size, Paint()..color = c.background);
    final left = scroll.hasClients ? scroll.offset : 0.0;
    for (var m = 1; m <= 12; m++) {
      final start = seasonDay(DateTime(l.view.year, m), l.view.year);
      final end = seasonDay(DateTime(l.view.year, m + 1), l.view.year);
      final x = l.x(start);
      final w = (end - start) * l.ppd;
      final textX = math.max(x + 8, left + 8);
      _text(
        canvas,
        DateFormat(
          w >= 90 ? 'MMMM yyyy' : 'MMM',
          'tr',
        ).format(DateTime(l.view.year, m)).toUpperCase(),
        style.copyWith(fontSize: 10, color: c.textFaint),
        Offset(textX, 4),
        x + w - textX - 4,
      );
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, 20),
        Paint()..color = c.borderStrong,
      );
    }
    for (var d = 0; d < l.view.days; d++) {
      final date = seasonDate(d, l.view.year);
      final tick = switch (l.view.state.scale) {
        TimelineScale.day => true,
        TimelineScale.week => date.weekday == 1,
        TimelineScale.month => date.day == 15,
      };
      final x =
          l.x(d) + (l.view.state.scale == TimelineScale.day ? l.ppd / 2 : 0);
      if (tick && (x - l.todayX).abs() > 22) {
        _text(
          canvas,
          '${date.day}',
          style.copyWith(fontSize: 11, color: c.textMuted),
          Offset(x - 8, 25),
          26,
        );
      }
    }
    final pill = Rect.fromCenter(
      center: Offset(l.todayX, 33),
      width: 30,
      height: 18,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(pill, const Radius.circular(9)),
      Paint()..color = c.primary,
    );
    _text(
      canvas,
      '${seasonDate(l.view.today, l.view.year).day}',
      style.copyWith(fontSize: 11, color: c.onPrimary),
      pill.topLeft + const Offset(6, 2),
      24,
    );
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      Paint()..color = c.border,
    );
  }

  @override
  bool shouldRepaint(covariant MobileTimelineAxisPainter old) =>
      old.layout != layout || old.colors != colors || old.style != style;
}
