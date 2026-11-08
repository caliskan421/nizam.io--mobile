import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';

/// Grup içi dokunulabilir satır (en az [minHeight], yatay 14 iç boşluk).
class CoordRow extends StatelessWidget {
  const CoordRow({
    super.key,
    required this.child,
    required this.onTap,
    required this.semanticLabel,
    this.minHeight = NizamioSize.row,
    this.vertical = NizamioSpacing.space2,
    this.expanded,
  });

  final Widget child;
  final VoidCallback onTap;
  final String semanticLabel;
  final double minHeight;
  final double vertical;

  /// Açılır satır (aria-expanded) için durum; null → düz düğme.
  final bool? expanded;

  /// Üzerine gelme / odak katmanı (basmada efekt yok: dalga ve vurgu kapalı, NzCard gibi).
  static const _overlayAlpha = 0.12;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    expanded: expanded,
    label: semanticLabel,
    excludeSemantics: true,
    onTap: onTap,
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith(
          (s) => context.colors.text.withValues(
            alpha:
                s.contains(WidgetState.hovered) ||
                    s.contains(WidgetState.focused)
                ? _overlayAlpha
                : 0,
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: NizamioSpacing.rowPad,
              vertical: vertical,
            ),
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
        ),
      ),
    ),
  );
}

/// Bölüm başlığının sağındaki metin bağlantısı (prototip `accent-text` 13; dokunma ≥ 44).
class CoordLink extends StatelessWidget {
  const CoordLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    onTap: onTap,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NizamioRadius.tile),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NizamioSize.tap,
          minWidth: NizamioSize.tap,
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            label,
            style: context.text.labelMd.copyWith(
              color: context.colors.accentText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );
}
