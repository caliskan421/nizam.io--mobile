import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';

/// İkon çipi (prototip `.rp-ichip`): 36 px, `bg-raised` + 1 px `border-subtle`, köşe `m-r-tile`;
/// 16 px ikon. Görseldir (anlam yanındaki metindedir).
class NzIconTile extends StatelessWidget {
  const NzIconTile({super.key, required this.icon, this.color});

  final IconData icon;

  /// null → `textMuted`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          border: Border.all(color: c.border, width: NizamioSize.borderWidth),
          borderRadius: BorderRadius.circular(NizamioRadius.tile),
        ),
        child: SizedBox.square(
          dimension: NizamioSize.iconTile,
          child: NzIcon(
            icon,
            size: NizamioSize.iconSizeSm,
            color: color ?? c.textMuted,
          ),
        ),
      ),
    );
  }
}
