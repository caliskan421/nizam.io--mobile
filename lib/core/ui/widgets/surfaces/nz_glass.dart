import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_surfaces.dart';

/// Cam yüzey (README "Cam"): arkasındaki içeriği bulanıklaştırır (`NizamioBlur` + doygunluk),
/// üstüne [tone] dolgusunu ve isteğe bağlı 1 px `glass-edge` kenarını koyar. Gölge kırpılmaz
/// (dışarıda), bulanıklık şekle kırpılır. Tek katmanlı bulanıklık: iç içe cam kullanmayın.
class NzGlass extends StatelessWidget {
  const NzGlass({
    super.key,
    required this.tone,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.edge = true,
    this.shadow = const [],
  }) : circle = false;

  const NzGlass.circle({
    super.key,
    required this.tone,
    required this.child,
    this.edge = true,
    this.shadow = const [],
  }) : circle = true,
       borderRadius = BorderRadius.zero;

  final NzGlassTone tone;
  final Widget child;
  final BorderRadius borderRadius;
  final bool circle;
  final bool edge;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final side = edge
        ? BorderSide(color: c.glassEdge, width: NizamioSize.borderWidth)
        : BorderSide.none;
    final ShapeBorder shape = circle
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(borderRadius: borderRadius, side: side);
    return DecoratedBox(
      decoration: ShapeDecoration(shape: shape, shadows: shadow),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: BackdropFilter(
          filter: tone.filter(),
          child: Material(color: tone.fill(c), shape: shape, child: child),
        ),
      ),
    );
  }
}
