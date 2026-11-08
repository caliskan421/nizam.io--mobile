import 'package:flutter/widgets.dart';

import '../../theme/generated/tokens.gen.dart';

/// Ünlem ikonu (daire içinde ünlem): kaynak `design/icons/unlem-ikon.svg` (24×24, çizgi 2.2,
/// yuvarlak uç). Projede SVG çizici yok (ikonlar Material); yol aynı ölçülerle elde çizilir.
/// [tinted] → ikon, rozetlerle aynı yarı saydam ton dolgulu dairenin içinde
/// ([NzStatusLabel.badge] dolgusu: renk %16).
class NzAlertIcon extends StatelessWidget {
  const NzAlertIcon({
    super.key,
    required this.color,
    this.size = 16,
    this.tinted = false,
    this.semanticLabel,
  });

  final Color color;
  final double size;
  final bool tinted;
  final String? semanticLabel;

  static const _tintAlpha = 0.16;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    excludeSemantics: semanticLabel != null,
    child: tinted
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: _tintAlpha),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(NizamioSpacing.space1),
              child: _glyph(),
            ),
          )
        : _glyph(),
  );

  Widget _glyph() => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _AlertPainter(color)),
  );
}

class _AlertPainter extends CustomPainter {
  const _AlertPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      // M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18z
      ..drawCircle(const Offset(12, 12), 9, p)
      // M12 7.5v5.5
      ..drawLine(const Offset(12, 7.5), const Offset(12, 13), p)
      // M12 16.5h.01
      ..drawLine(const Offset(12, 16.5), const Offset(12.01, 16.5), p);
  }

  @override
  bool shouldRepaint(_AlertPainter old) => old.color != color;
}
