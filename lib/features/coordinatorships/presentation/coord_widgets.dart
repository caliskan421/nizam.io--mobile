import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';

/// Prototip satır grubu (`bg-raised`, köşe 18, satırlar arası 1 px `border-subtle`).
class CoordGroup extends StatelessWidget {
  const CoordGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(NizamioRadius.row),
      child: ColoredBox(
        color: c.surfaceRaised,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0)
                Divider(
                  height: NizamioSize.borderWidth,
                  thickness: NizamioSize.borderWidth,
                  color: c.border,
                ),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

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
