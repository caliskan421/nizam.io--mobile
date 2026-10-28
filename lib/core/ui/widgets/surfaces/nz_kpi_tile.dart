import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../feedback/nz_progress_bar.dart';
import 'nz_card.dart';
import 'nz_icon_tile.dart';

/// KPI kutucuğu (tasarım `KpiTile`): üst satırda anlam renginde ikon çipi, etiket ve çapraz ok;
/// büyük rakam (`m-kpi`), 4 px çubuk ve açıklama. İç boşluk `m-row-pad` (14). Dokununca
/// [onTap] (ilgili liste); ok yalnız dokunulabilirken çizilir.
class NzKpiTile extends StatelessWidget {
  const NzKpiTile({
    super.key,
    required this.icon,
    required this.tone,
    required this.label,
    required this.value,
    required this.progress,
    required this.caption,
    this.valueColor,
    this.onTap,
    this.semanticLabel,
  });

  final IconData icon;

  /// Anlam rengi (ikon ve çubuk): tamamlanan `accentText`, devam `inProgress`, gecikme `danger`,
  /// onay `warning`.
  final Color tone;
  final String label;
  final String value;

  /// 0–1.
  final double progress;
  final String caption;

  /// null → `text` (gecikmede `danger`).
  final Color? valueColor;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.rowPad),
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NzIconTile(icon: icon, color: tone),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.caption.copyWith(color: c.textMuted),
                ),
              ),
              if (onTap != null)
                ExcludeSemantics(
                  child: Icon(
                    Icons.north_east_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.textFaint,
                  ),
                ),
            ],
          ),
          const Gap(NizamioSpacing.gapMd),
          Text(
            value,
            maxLines: 1,
            style: t.numeral.copyWith(color: valueColor ?? c.text),
          ),
          const Gap(NizamioSpacing.gapMd),
          NzProgressBar(value: progress, color: tone),
          const Gap(NizamioSpacing.gapMd),
          Text(
            caption,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ],
      ),
    );
  }
}
