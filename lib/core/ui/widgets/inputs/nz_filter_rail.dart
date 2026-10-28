import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';

/// Filtre seçeneği: etiket + isteğe bağlı sayaç ve renk noktası (prototip `.rp-dot`, ör.
/// işlem geçmişinde kayıt türü rengi; anlamı etiket taşır).
@immutable
class NzFilterOption {
  const NzFilterOption({required this.label, this.count, this.dot});

  final String label;
  final int? count;

  /// Etiketin solunda 8 px nokta rengi; null → yok.
  final Color? dot;
}

/// Tek seçimli filtre rayı (prototip `.rp-seg`): `bg-raised` ray, 1 px `border-subtle`, köşe
/// `m-r-group`; seçenekler yatay kayar, seçili parça zemin rengine oturur (koyu: `bg-base` +
/// `border-strong` iç çizgi; açık: `bg-surface` + `border-subtle`). Öğe yüksekliği `m-tab-h`
/// (36); dokunma alanı rayın iç yüksekliği kadardır.
class NzFilterRail extends StatelessWidget {
  const NzFilterRail({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.semanticLabel,
  });

  final List<NzFilterOption> options;
  final int selected;
  final ValueChanged<int> onSelected;

  /// Grubun okuyucu adı (ör. "Koordinatörlük durumu").
  final String semanticLabel;

  static const _pad = NizamioSpacing.space1;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          border: Border.all(color: c.border, width: NizamioSize.borderWidth),
          borderRadius: BorderRadius.circular(NizamioRadius.group),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(_pad),
          child: Row(
            spacing: NizamioSpacing.space1 / 2,
            children: [
              for (var i = 0; i < options.length; i++)
                _RailItem(
                  option: options[i],
                  selected: i == selected,
                  onTap: () => onSelected(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final NzFilterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final dark = context.theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(NizamioRadius.tile);
    final count = option.count;
    final dot = option.dot;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: count == null ? option.label : '${option.label}, $count',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: NzMotion.of(context, NizamioMotion.durExit),
          curve: NizamioMotion.easeOut,
          height: NizamioSize.tabH,
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: selected
                ? (dark ? c.background : c.surface)
                : c.surfaceRaised.withValues(alpha: 0),
            borderRadius: radius,
            border: Border.all(
              color: selected
                  ? (dark ? c.borderStrong : c.border)
                  : c.border.withValues(alpha: 0),
              width: NizamioSize.borderWidth,
            ),
            boxShadow: selected && !dark ? context.shadows.thumb : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dot != null) ...[
                DecoratedBox(
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(NizamioSize.dot / 2),
                  ),
                ),
                const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
              ],
              Text(
                option.label,
                maxLines: 1,
                style: t.labelMd.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected ? c.text : c.textMuted,
                ),
              ),
              if (count != null) ...[
                const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
                // Sayaç: prototip `ink-faint`; açık temada `bg-raised` üzerinde 4.34 kaldığı için
                // ikincil metin rolü (her iki temada ≥ 4.5).
                Text(
                  '$count',
                  maxLines: 1,
                  style: t.kicker.copyWith(
                    fontWeight: FontWeight.w400,
                    color: c.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
