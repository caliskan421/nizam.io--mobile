import 'package:flutter/widgets.dart';

import '../extensions/context_ext.dart';
import '../icons/icon_resolver.dart';
import 'nz_alert_icon.dart';
import 'nz_glyph.dart';
import 'nz_icons.dart';

/// Ortak ikon: mevcut özel SVG'yi, özel karşılığı yoksa Material ikonunu çizer.
/// Katalog kimliği, IconTheme, boyut, renk ve erişilebilirlik etiketi korunur.
class NzIcon extends Icon {
  const NzIcon(
    super.icon, {
    super.key,
    super.size,
    super.color,
    super.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final glyph = resolveNzGlyph(icon);
    final alert = icon == NzIcons.error;
    if (glyph == null && !alert) return super.build(context);
    final theme = IconTheme.of(context);
    final side = size ?? theme.size ?? 24;
    final ink = color ?? theme.color ?? context.colors.text;
    final opacity = theme.opacity ?? 1;
    final resolved = opacity == 1
        ? ink
        : ink.withValues(alpha: ink.a * opacity);
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: alert
            ? NzAlertIcon(size: side, color: resolved)
            : NzGlyphIcon(glyph!, size: side, color: resolved),
      ),
    );
  }
}
