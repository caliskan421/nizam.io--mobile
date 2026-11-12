import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import 'mobile_timeline_layout.dart';

/// Yılın gerçek görev yoğunluğu; görünen yatay pencere ve bugün işareti.
class MobileTimelineStrip extends StatelessWidget {
  const MobileTimelineStrip({
    super.key,
    required this.layout,
    required this.scroll,
    required this.onScrub,
    required this.onToday,
  });
  final MobileTimelineLayout layout;
  final ScrollController scroll;
  final ValueChanged<double> onScrub;
  final VoidCallback onToday;
  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.uiTimelineSeasonMap,
    child: Material(
      color: context.colors.surfaceRaised.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            void scrub(double x) {
              if (!scroll.hasClients) return;
              final day = (x / box.maxWidth).clamp(0.0, 1.0) * layout.view.days;
              onScrub(
                layout.x(day.round()) - scroll.position.viewportDimension / 2,
              );
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (e) => scrub(e.localPosition.dx),
              onHorizontalDragStart: (e) => scrub(e.localPosition.dx),
              onHorizontalDragUpdate: (e) => scrub(e.localPosition.dx),
              onDoubleTap: onToday,
              child: AnimatedBuilder(
                animation: scroll,
                builder: (context, _) => CustomPaint(
                  size: Size(box.maxWidth, 34),
                  painter: _StripPainter(
                    layout: layout,
                    offset: scroll.hasClients ? scroll.offset : 0,
                    viewport: scroll.hasClients
                        ? scroll.position.viewportDimension
                        : 0,
                    colors: context.colors,
                    style: context.text.monoSm,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _StripPainter extends CustomPainter {
  _StripPainter({
    required this.layout,
    required this.offset,
    required this.viewport,
    required this.colors,
    required this.style,
  });
  final MobileTimelineLayout layout;
  final double offset;
  final double viewport;
  final NizamioColors colors;
  final TextStyle style;
  @override
  void paint(Canvas canvas, Size size) {
    final weeks = layout.view.weeks;
    final maxCount = weeks.fold<int>(1, (n, w) => math.max(n, w.count));
    final w = size.width / math.max(1, weeks.length);
    final p = Paint();
    for (final (i, week) in weeks.indexed) {
      final height = week.count == 0 ? 2.0 : 3 + week.count / maxCount * 15;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(i * w, 20 - height, math.max(1, w - 1), height),
          const Radius.circular(1),
        ),
        p
          ..color = week.late
              ? colors.danger
              : week.count > 0
              ? colors.textMuted
              : colors.border,
      );
    }
    for (var m = 1; m <= 12; m++) {
      final text = TextPainter(
        text: TextSpan(
          text: DateFormat.MMM('tr')
              .format(DateTime(layout.view.year, m))
              .toLowerCase(),
          style: style.copyWith(fontSize: 8, color: colors.textMuted),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width / 12);
      text.paint(canvas, Offset((m - 1) * size.width / 12, 23));
    }
    final first = ((offset - MobileTimelineLayout.leftPad) / layout.ppd).clamp(
      0.0,
      layout.view.days.toDouble(),
    );
    final visible = viewport / layout.ppd;
    final rect = Rect.fromLTWH(
      first / layout.view.days * size.width,
      -1,
      math.min(
        size.width - first / layout.view.days * size.width,
        math.max(6, visible / layout.view.days * size.width),
      ),
      23,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()
        ..color = colors.text
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final today = layout.view.today / layout.view.days * size.width;
    canvas.drawRect(
      Rect.fromLTWH(today, -2, 2, 25),
      p..color = colors.accentText,
    );
  }

  @override
  bool shouldRepaint(covariant _StripPainter old) =>
      old.layout != layout ||
      old.offset != offset ||
      old.viewport != viewport ||
      old.colors != colors;
}
