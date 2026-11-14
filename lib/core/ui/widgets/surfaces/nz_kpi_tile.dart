import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../feedback/nz_progress_bar.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
import 'nz_card.dart';
import 'nz_icon_tile.dart';

/// KPI kutucuğu (tasarım `KpiTile`): üst satırda anlam renginde ikon çipi, etiket ve çapraz ok;
/// büyük rakam (`m-kpi`), 4 px çubuk ve açıklama. İç boşluk `m-row-pad` (14). Dokununca
/// [onTap] (ilgili liste); ok yalnız dokunulabilirken çizilir. Çubuk tek değerli ([progress]),
/// parçalı ([segments]) ya da yerine serbest görsel ([footer], ör. avatar yığını) olur.
/// [caption] yoksa açıklama satırı çizilmez. [horizontal]: ikon, etiket, rakam ve ok tek satırda,
/// çubuk altta (dar ekranda tam genişlik şerit).
class NzKpiTile extends StatelessWidget {
  const NzKpiTile({
    super.key,
    required this.icon,
    required this.tone,
    required this.label,
    required this.value,
    this.progress,
    this.segments = const [],
    this.footer,
    this.caption,
    this.horizontal = false,
    this.valueColor,
    this.onTap,
    this.semanticLabel,
  });

  final IconData icon;

  /// Anlam rengi (ikon ve çubuk): tamamlanan `taskDone`, devam `inProgress`, gecikme `danger`,
  /// onay `warning`.
  final Color tone;
  final String label;
  final String value;

  /// 0–1 (tek değerli çubuk, [tone] renginde).
  final double? progress;

  /// Parçalı çubuk ([progress] yerine).
  final List<NzBarSegment> segments;

  /// Çubuk yerine görsel (ör. avatar yığını).
  final Widget? footer;
  final String? caption;
  final bool horizontal;

  /// null → `text` (gecikmede `danger`).
  final Color? valueColor;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final labelText = Text(
      label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: t.caption.copyWith(color: c.textMuted),
    );
    final valueText = Text(
      value,
      maxLines: 1,
      style: t.numeral.copyWith(color: valueColor ?? c.text),
    );
    final arrow = onTap == null
        ? null
        : ExcludeSemantics(
            child: NzIcon(
              NzIcons.northEast,
              size: NizamioSize.iconSizeSm,
              color: c.textFaint,
            ),
          );
    final bar = switch (footer) {
      final f? => f,
      null when segments.isNotEmpty => NzProgressBar.segments(
        segments: segments,
      ),
      null => NzProgressBar(value: progress ?? 0, color: tone),
    };
    final captionText = switch (caption) {
      final text? => [
        const Gap(NizamioSpacing.gapMd),
        Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: t.caption.copyWith(color: c.textMuted),
        ),
      ],
      null => const <Widget>[],
    };
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.rowPad),
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: horizontal
            ? [
                Row(
                  children: [
                    NzIconTile(icon: icon, color: tone),
                    const Gap(NizamioSpacing.space2),
                    Expanded(child: labelText),
                    const Gap(NizamioSpacing.space2),
                    valueText,
                    if (arrow != null) ...[
                      const Gap(NizamioSpacing.space2),
                      arrow,
                    ],
                  ],
                ),
                const Gap(NizamioSpacing.gapMd),
                bar,
                ...captionText,
              ]
            : [
                Row(
                  children: [
                    NzIconTile(icon: icon, color: tone),
                    const Gap(NizamioSpacing.space2),
                    Expanded(child: labelText),
                    ?arrow,
                  ],
                ),
                const Gap(NizamioSpacing.gapMd),
                valueText,
                const Gap(NizamioSpacing.gapMd),
                bar,
                ...captionText,
              ],
      ),
    );
  }
}
