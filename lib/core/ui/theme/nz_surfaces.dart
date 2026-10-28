import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/generated/tokens.gen.dart';

/// Ortak yüzey dolguları (README "Yüzeyler ve derinlik"): kart, ikincil ve ana eylem degradeleri.
/// Renkler token rollerinden; bileşenler bu tek yerden okur (aynı degrade iki yerde yazılmaz).
extension NzSurfaceFills on NizamioColors {
  /// Kart / KPI / panel: `surface-top → bg-surface`.
  LinearGradient get cardFill => _vertical(surfaceTop, surface);

  /// İkincil düğme ve ikon düğmesi: `btn-top → btn-bottom`.
  LinearGradient get secondaryFill => _vertical(buttonTop, buttonBottom);

  /// Ana eylem: `accent-top → accent`.
  LinearGradient get primaryFill => _vertical(primaryTop, primary);

  static LinearGradient _vertical(Color top, Color bottom) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, bottom],
  );
}

/// Cam yüzey tonları (README "Cam"): üst çubuk, yüzen kontroller, flyout.
enum NzGlassTone { bar, float, menu }

/// Cam yüzeyin dolgu rengi ve bulanıklığı (CSS `blur(r) saturate(s)`; blur yarıçapı σ'dır).
extension NzGlassSpec on NzGlassTone {
  Color fill(NizamioColors c) => switch (this) {
    NzGlassTone.bar => c.glassBar,
    NzGlassTone.float => c.glassFloat,
    NzGlassTone.menu => c.glassMenu,
  };

  ImageFilter filter() {
    final (sigma, saturation) = switch (this) {
      NzGlassTone.bar => (NizamioBlur.bar, 1.4),
      NzGlassTone.float => (NizamioBlur.float, 1.5),
      NzGlassTone.menu => (NizamioBlur.menu, 1.6),
    };
    return ImageFilter.compose(
      outer: ImageFilter.blur(
        sigmaX: sigma,
        sigmaY: sigma,
        tileMode: TileMode.mirror,
      ),
      inner: ColorFilter.matrix(_saturate(saturation)),
    );
  }

  // CSS saturate() filtre matrisi (Filter Effects 1, feColorMatrix type="saturate").
  static List<double> _saturate(double s) => [
    0.213 + 0.787 * s, 0.715 - 0.715 * s, 0.072 - 0.072 * s, 0, 0, //
    0.213 - 0.213 * s, 0.715 + 0.285 * s, 0.072 - 0.072 * s, 0, 0, //
    0.213 - 0.213 * s, 0.715 - 0.715 * s, 0.072 + 0.928 * s, 0, 0, //
    0, 0, 0, 1, 0, //
  ];
}

/// Üst iç ışık (CSS `box-shadow: inset 0 1px 0 edge-light`): kenarlığın içinde, üst kıvrımı
/// izleyen 1 px'lik şerit. Kart ve degradeli düğmeler ön plan boyayıcısı olarak kullanır.
class NzEdgeLightPainter extends CustomPainter {
  const NzEdgeLightPainter({
    required this.color,
    required this.borderRadius,
    this.inset = NizamioSize.borderWidth,
  });

  final Color color;
  final BorderRadius borderRadius;

  /// Kenarlık kalınlığı (ışık kenarlığın içinden başlar).
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final inner = borderRadius.toRRect(Offset.zero & size).deflate(inset);
    final band = Path.combine(
      PathOperation.difference,
      Path()..addRRect(inner),
      Path()..addRRect(inner.shift(const Offset(0, NizamioSize.borderWidth))),
    );
    canvas.drawPath(band, Paint()..color = color);
  }

  @override
  bool shouldRepaint(NzEdgeLightPainter old) =>
      old.color != color ||
      old.borderRadius != borderRadius ||
      old.inset != inset;
}
