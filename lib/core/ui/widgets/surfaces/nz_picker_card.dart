import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
import 'nz_card.dart';

/// Seçici kartı (kenar çubuğu program / rol / koordinatörlük seçicisi, `sidebar-rol.png`):
/// küçük mono üst [label], [leading] (rozet, monogram ya da nokta) + [title], sağ üstte ↓
/// simgesi. [highlight] verilirse kenarlık o rengin %45'i (seçili vurgu; ör. rol rengi), yoksa
/// ince `border`. [trailing] başlık satırının sonunda durur (ör. okunmamış rozeti). Dokununca
/// [onTap] (seçenek listesi ya da akış açılır); okuyucuya "[label], [title]" okunur.
class NzPickerCard extends StatelessWidget {
  const NzPickerCard({
    super.key,
    required this.label,
    required this.title,
    this.leading,
    this.trailing,
    this.highlight,
    required this.onTap,
  });

  final String label;
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Color? highlight;
  final VoidCallback onTap;

  static const _highlightAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final edge = highlight?.withValues(alpha: _highlightAlpha) ?? c.border;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(color: edge, width: NizamioSize.borderWidth),
        borderRadius: BorderRadius.circular(NizamioRadius.card),
      ),
      child: NzCard.filled(
        padding: const EdgeInsets.fromLTRB(
          NizamioSpacing.space3,
          NizamioSpacing.space2,
          NizamioSpacing.space2,
          NizamioSpacing.space3,
        ),
        onTap: onTap,
        semanticLabel: '$label, $title',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.monoSm.copyWith(color: c.textMuted),
                  ),
                ),
                NzIcon(
                  NzIcons.chevronDown,
                  size: NizamioSize.iconSizeSm,
                  color: c.textMuted,
                ),
              ],
            ),
            const Gap(NizamioSpacing.space1),
            Row(
              children: [
                if (leading case final lead?) ...[
                  lead,
                  const Gap(NizamioSpacing.space2),
                ],
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (trailing case final trail?) ...[
                  const Gap(NizamioSpacing.space2),
                  trail,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Kısa mono kod etiketi (koordinatörlük kodu "ALT"): yükseltilmiş zeminde soluk mono metin.
class NzMonoTag extends StatelessWidget {
  const NzMonoTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceOverlay,
          borderRadius: BorderRadius.circular(NizamioRadius.tile),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space2,
            vertical: NizamioSpacing.space1,
          ),
          child: Text(
            text,
            maxLines: 1,
            style: context.text.monoSm.copyWith(
              color: c.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
