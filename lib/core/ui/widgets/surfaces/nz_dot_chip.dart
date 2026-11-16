import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import 'nz_status_label.dart';

/// Noktalı kapsül (prototip "● 4 geciken", "● Koordinatör · Altyapı"): renk noktası, isteğe
/// bağlı kalın sayı ([count]) ve etiket; dolu `surfaceOverlay` zemin. [onTap] verilirse
/// dokunulur (okuyucuya düğme).
class NzDotChip extends StatelessWidget {
  const NzDotChip({
    super.key,
    required this.color,
    required this.label,
    this.count,
    this.onTap,
  });

  final Color color;
  final String label;
  final String? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final count = this.count;
    final chip = DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceOverlay,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space3,
          vertical: NizamioSpacing.space2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NzDot(color: color),
            const Gap(NizamioSpacing.space2),
            if (count != null) ...[
              Text(
                count,
                style: t.bodySm.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodySm.copyWith(
                  color: count == null ? c.text : c.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final onTap = this.onTap;
    final text = [?count, label].join(' ');
    if (onTap == null) {
      return Semantics(label: text, excludeSemantics: true, child: chip);
    }
    return Semantics(
      button: true,
      label: text,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: chip,
      ),
    );
  }
}
