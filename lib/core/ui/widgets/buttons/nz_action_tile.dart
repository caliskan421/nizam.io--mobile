import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_pane.dart';
import '../nz_icon.dart';
import 'nz_pressable.dart';

/// Hızlı işlem kutucuğu (ana sayfa 4'lü ızgara): 40 px ikon kutusu + altında kısa etiket;
/// `bg-surface`, 1 px `border-subtle`, köşe `m-r-group`. [primary] yalnız ekrandaki tek "yeni"
/// eylemi içindir (ikon kutusu `accent` dolgusu). Basınca `.96`.
class NzActionTile extends StatelessWidget {
  const NzActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String label;

  /// null → devre dışı.
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(NizamioRadius.group);
    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: NzPressable(
        enabled: onPressed != null,
        child: Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: c.border, width: NizamioSize.borderWidth),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            splashFactory: NoSplash.splashFactory,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: NizamioSpacing.space12,
                minWidth: double.infinity,
              ),
              child: Padding(
                // Tablet kaynağı: `padding: 12px 4px` + 1 px kenarlık (border-box).
                padding: EdgeInsets.symmetric(
                  vertical:
                      NizamioSpacing.space3 +
                      (NzTabletMetrics.tabletVisualAt(
                            MediaQuery.sizeOf(context).width,
                          )
                          ? NizamioSize.borderWidth
                          : 0),
                  horizontal: NizamioSpacing.space1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: primary ? c.primary : c.surfaceOverlay,
                        borderRadius: BorderRadius.circular(NizamioRadius.tile),
                      ),
                      child: SizedBox.square(
                        dimension: NizamioSize.iconTileLg,
                        child: NzIcon(
                          icon,
                          size: NizamioSize.iconSizeSm,
                          color: primary ? c.onPrimary : c.text,
                        ),
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
