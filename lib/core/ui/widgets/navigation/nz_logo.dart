import 'package:flutter/widgets.dart';

import '../../theme/nz_fixed_colors.dart';
import 'nz_path_icon.dart';

/// Ürün logosu (tasarım `assets/7a16…svg`, birebir): 32×32 viewBox, `rx 10` karo üstten alta
/// `#d8f866 → #c8f53c`, içinde `translate(6 6) scale(.8333)` roket yolu, 2 px yuvarlak uçlu
/// `#0b0b0b` çizgi. Renkler temadan bağımsızdır (SVG sabit). Tablet rayı (36) ve tablet girişi
/// (44) kullanır; telefon kök çubuğu [NzBrandMark]'ta kalır.
class NzLogo extends StatelessWidget {
  const NzLogo({super.key, this.extent = 32});

  final double extent;

  /// Kaynak roket yolu (24×24 iç koordinat).
  static const rocket =
      'M5 19c1-4 3-6 6-7M13 11c2-4 5-6 8-7-1 3-3 6-7 8M9 15l-3 3M11 8 8 7 5 9l3 1M16 13l1 3-2 3-1-3';

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: extent,
      child: const CustomPaint(painter: _LogoPainter()),
    ),
  );
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  static const _viewBox = 32.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.shortestSide / _viewBox);
    const tile = Rect.fromLTWH(0, 0, _viewBox, _viewBox);
    canvas.drawRRect(
      RRect.fromRectAndRadius(tile, const Radius.circular(10)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [NzFixedColors.logoTop, NzFixedColors.logoBottom],
        ).createShader(tile),
    );
    canvas
      ..translate(6, 6)
      ..scale(0.8333)
      ..drawPath(
        NzPathIcon.pathOf(NzLogo.rocket),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = NzFixedColors.logoInk,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_LogoPainter old) => false;
}
