import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../nz_icon.dart';

/// Hap sekmenin bir öğesi: [label], isteğe bağlı [count] (mono sayaç; sayı dışı sayaç, ör.
/// gündem "2/3", [countText]) ve baştaki [icon] (ör. Görevler "Liste / Zaman çizelgesi").
@immutable
class NzPillTab {
  const NzPillTab({required this.label, this.count, this.countText, this.icon})
    : assert(count == null || countText == null, 'count ya da countText');

  final String label;
  final int? count;
  final String? countText;
  final IconData? icon;
}

/// Eşit sütunlu hap sekmeler (tasarım `PillTabs`, bundle.css `.m-tabs`): ray `bg-raised` + 1 px
/// `border-subtle`, kayan başparmak `bg-overlay` + `m-sh-thumb` (`easeSpring`, `durSheet`),
/// sekme `m-tab-h` 36 görsel; dokunma alanı her sekmede 48 yükseklik. Seçili etiket 600 `ink`,
/// diğerleri 500 `ink-muted`; sayaç `monoSm` `ink-muted` (küçük metin kontrastı; tasarım
/// `ink-faint`). Denetimli: [selected] çağıranındır. Okuyucuda her sekme seçili/seçilmemiş
/// tek seçimli grup öğesidir.
class NzPillTabs extends StatelessWidget {
  const NzPillTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
    this.semanticLabel,
    this.iconsOnly = false,
  }) : assert(tabs.length >= 2, 'en az iki sekme');

  final bool iconsOnly;
  final List<NzPillTab> tabs;
  final int selected;
  final ValueChanged<int> onSelected;

  /// Grubun okuyucu etiketi (ör. "Görünüm").
  final String? semanticLabel;

  // `.m-tabs` iç dolgu 3 + kenar 1; ray 44 → dokunma 48 için üst/alt 2 px dış pay.
  static const _pad = 3.0;
  static const _outer = (NizamioSpacing.space12 - NizamioSize.controlMd) / 2;
  static const _inset = _pad + NizamioSize.borderWidth;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final n = tabs.length;
    final railRadius = BorderRadius.circular(NizamioRadius.pill);
    return Semantics(
      container: true,
      label: semanticLabel,
      explicitChildNodes: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final inner = constraints.maxWidth - 2 * _inset;
          final w = inner <= 0 ? 0.0 : inner / n;
          return Stack(
            children: [
              Positioned.fill(
                top: _outer,
                bottom: _outer,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.surfaceRaised,
                    borderRadius: railRadius,
                    border: Border.all(
                      color: c.border,
                      width: NizamioSize.borderWidth,
                    ),
                  ),
                ),
              ),
              // Yaylı eğri hedefi hafifçe aşar (kaynak `--m-ease-spring`); ilk/son sekmede
              // başparmak rayın dışına taşmasın diye konum ray sınırına kırpılır.
              TweenAnimationBuilder<double>(
                tween: Tween(end: _inset + selected.clamp(0, n - 1) * w),
                duration: NzMotion.of(context, NizamioMotion.durSheet),
                curve: NizamioMotion.easeSpring,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.surfaceOverlay,
                    borderRadius: railRadius,
                    boxShadow: context.shadows.thumb,
                  ),
                ),
                builder: (context, left, thumb) => Positioned(
                  top: _outer + _inset,
                  bottom: _outer + _inset,
                  left: left.clamp(_inset, _inset + (n - 1) * w),
                  width: w,
                  child: thumb!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _inset),
                child: Row(
                  children: [
                    for (var i = 0; i < n; i++)
                      Expanded(
                        child: _Tab(
                          tab: tabs[i],
                          iconsOnly: iconsOnly,
                          selected: i == selected,
                          onTap: () => onSelected(i),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.tab,
    required this.selected,
    required this.onTap,
    required this.iconsOnly,
  });

  final bool iconsOnly;
  final NzPillTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final color = selected ? c.text : c.textMuted;
    final count = tab.countText ?? tab.count?.toString();
    final icon = tab.icon;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: count == null ? tab.label : '${tab.label}, $count',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: NzPillTabs._outer + NzPillTabs._inset,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: NizamioSize.tabH),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    NzIcon(icon, size: NizamioSize.iconSizeSm, color: color),
                    if (!iconsOnly) const Gap(NizamioSpacing.space1 + 1),
                  ],
                  if (!iconsOnly)
                    Flexible(
                      child: Text(
                        tab.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.labelMd.copyWith(
                          color: color,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  if (count != null) ...[
                    const Gap(NizamioSpacing.space1 + 1),
                    Text(
                      count,
                      maxLines: 1,
                      style: t.monoSm.copyWith(color: c.textMuted),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
