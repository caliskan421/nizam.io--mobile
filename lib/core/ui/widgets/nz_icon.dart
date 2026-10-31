import 'package:flutter/widgets.dart';

/// Uygulamanın ikon bileşeni ([Icon] yerine): ikon [NzIcons]'tan gelir, telefon ve tablette
/// aynı çizilir. Boyut ve renk [Icon] ile aynı kurallardır ([IconTheme]).
class NzIcon extends StatelessWidget {
  const NzIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final IconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) =>
      Icon(icon, size: size, color: color, semanticLabel: semanticLabel);
}
