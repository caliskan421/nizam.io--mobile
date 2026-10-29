import 'package:flutter/material.dart';

import '../layout/nz_pane.dart';
import 'navigation/nz_path_icon.dart';

/// Uygulamanın ikon bileşeni ([Icon] yerine). Telefonda birebir [Icon]. Tablet genişliğinde
/// (çift bölme, ≥ 840) Material ikonunun tasarımdaki karşılığı varsa kaynak SVG yolu çizilir
/// ([NzIconPaths.material], `.t-icon` 1.75 çizgi): ekranlar Material `IconData` vermeye devam
/// eder, eşleme tek yerdedir. Boyut ve renk [Icon] ile aynı kurallardır ([IconTheme]).
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
  Widget build(BuildContext context) {
    final path =
        NzTabletMetrics.tabletVisualAt(MediaQuery.sizeOf(context).width)
        ? NzIconPaths.material[icon]
        : null;
    if (path == null) {
      return Icon(icon, size: size, color: color, semanticLabel: semanticLabel);
    }
    final theme = IconTheme.of(context);
    final drawn = NzPathIcon(
      path,
      size: size ?? theme.size ?? 24,
      color: color ?? theme.color,
    );
    final label = semanticLabel;
    return label == null ? drawn : Semantics(label: label, child: drawn);
  }
}
