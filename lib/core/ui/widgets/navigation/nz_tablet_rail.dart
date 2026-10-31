import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_pane.dart';
import '../../theme/nz_motion.dart';
import '../buttons/nz_pressable.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

/// Ray öğesi: ikon (telefon alt menüsüyle aynı [NzIcons] çifti), etiket ve isteğe bağlı sayı
/// rozeti.
@immutable
class NzRailItem {
  const NzRailItem({
    required this.icon,
    IconData? selectedIcon,
    required this.label,
    this.badge,
  }) : selectedIcon = selectedIcon ?? icon;

  final IconData icon;

  /// Etkinken çizilen ikon (dolu varyant); verilmezse [icon].
  final IconData selectedIcon;
  final String label;

  /// Sayı rozeti (`t-badge--count`, accent); null ya da 0 → yok.
  final int? badge;
}

/// Tablet gezinme rayı (prototip `nav[aria-label="Ana menü"]`; ikonlar telefonla aynı [NzIcons]): 100 genişlik, `bg-base`,
/// sağda 1 px `border-subtle`; üstte 36 px ürün işareti ([brand]), altında modül öğeleri
/// (60×34 kapsül, etkinken `nav-highlight` dolgu ve `accent-text` ikon; 10.5/13 etiket),
/// boşluk, en altta bildirim zili (44), tüm modüller menüsü (44 cam daire) ve asistan
/// (56 cam daire, `accent` ikon). Renk geçişleri prototipteki gibi .3 s / .35 s; basınca .96.
class NzTabletRail extends StatelessWidget {
  const NzTabletRail({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    required this.semanticLabel,
    required this.brand,
    required this.bellLabel,
    this.onBell,
    required this.menuLabel,
    required this.onMenu,
    required this.assistantLabel,
    required this.onAssistant,
    this.bellDot = false,
  });

  final List<NzRailItem> items;

  /// Etkin öğe; null → hiçbiri.
  final int? currentIndex;
  final ValueChanged<int> onSelect;

  /// Rayın okuyucu etiketi.
  final String semanticLabel;

  /// 36 px ürün işareti.
  final Widget brand;

  final String bellLabel;
  final bool bellDot;

  /// null → yalnız etiketli düğme.
  final VoidCallback? onBell;
  final String menuLabel;
  final VoidCallback onMenu;
  final String assistantLabel;
  final VoidCallback onAssistant;

  /// Etiket en çok bu kadar büyür (sabit 100 px ray; tam ad okuyucu etiketindedir).
  static const maxTextScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final padding = MediaQuery.paddingOf(context);
    final column = Column(
      children: [
        SizedBox.square(dimension: NzTabletMetrics.railBrand, child: brand),
        const Gap(NzTabletMetrics.railBrandGap + NzTabletMetrics.railGap),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Gap(NzTabletMetrics.railGap),
          _RailButton(
            item: items[i],
            selected: i == currentIndex,
            onTap: () => onSelect(i),
          ),
        ],
        const Spacer(),
        const Gap(NzTabletMetrics.railGap),
        _BellButton(label: bellLabel, dot: bellDot, onTap: onBell),
        const Gap(NzTabletMetrics.railGap),
        _GlassButton(
          label: menuLabel,
          extent: NzTabletMetrics.railButton,
          icon: NzIcon(
            NzIcons.menu,
            size: NizamioSize.iconSize,
            color: c.glassInk,
          ),
          onTap: onMenu,
        ),
        const Gap(NzTabletMetrics.railGap + NzTabletMetrics.railAssistantGap),
        _GlassButton(
          label: assistantLabel,
          extent: NzTabletMetrics.railAssistant,
          icon: NzIcon(
            NzIcons.assistant,
            size: NizamioSpacing.space6,
            color: c.accentText,
          ),
          onTap: onAssistant,
        ),
      ],
    );
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.background,
          border: Border(right: BorderSide(color: c.border)),
        ),
        child: SizedBox(
          width: NzTabletMetrics.railWidth,
          height: double.infinity,
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: maxTextScale,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: padding.top + NzTabletMetrics.railPadV,
                  bottom: padding.bottom + NzTabletMetrics.railPadV,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        (constraints.maxHeight -
                                padding.vertical -
                                2 * NzTabletMetrics.railPadV)
                            .clamp(0, double.infinity),
                  ),
                  child: IntrinsicHeight(child: column),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final NzRailItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final ink = selected ? c.text : c.textMuted;
    final badge = item.badge ?? 0;
    return Semantics(
      button: true,
      selected: selected,
      label: badge > 0 ? '${item.label} · $badge' : item.label,
      excludeSemantics: true,
      onTap: onTap,
      child: NzPressable(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: NzTabletMetrics.railItemWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: NzTabletMetrics.railItemPadV,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: NzMotion.of(
                          context,
                          NzTabletMetrics.railPillFade,
                        ),
                        width: NzTabletMetrics.railPillWidth,
                        height: NzTabletMetrics.railPillHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? c.navHighlight
                              : c.navHighlight.withValues(alpha: 0),
                          borderRadius: BorderRadius.circular(
                            NizamioRadius.pill,
                          ),
                        ),
                        child: NzIcon(
                          selected ? item.selectedIcon : item.icon,
                          size: NizamioSize.iconSize,
                          color: selected ? c.accentText : ink,
                        ),
                      ),
                      if (badge > 0)
                        Positioned(
                          top: NzTabletMetrics.railBadgeTop,
                          right: NzTabletMetrics.railBadgeRight,
                          child: _CountBadge(count: badge),
                        ),
                    ],
                  ),
                  const Gap(NzTabletMetrics.railLabelGap),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: NzTabletMetrics.railLabelMaxWidth,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: NzMotion.of(
                        context,
                        NzTabletMetrics.railInkFade,
                      ),
                      style: t.navLabel.copyWith(
                        fontSize: NzTabletMetrics.railLabelSize,
                        height:
                            NzTabletMetrics.railLabelLine /
                            NzTabletMetrics.railLabelSize,
                        letterSpacing:
                            NzTabletMetrics.railLabelTracking *
                            NzTabletMetrics.railLabelSize,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: ink,
                      ),
                      child: Text(
                        item.label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `t-badge t-badge--count`: en az 16, 16 yükseklik, 0 4 dolgu, 12/16 600; `accent` zemin,
/// `accent-ink` metin, 2 px `bg-base` halka.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        boxShadow: [
          BoxShadow(color: c.background, spreadRadius: NzTabletMetrics.dotRing),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: NzTabletMetrics.railBadgeSize,
          minHeight: NzTabletMetrics.railBadgeSize,
          maxHeight: NzTabletMetrics.railBadgeSize,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space1,
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              '$count',
              textScaler: TextScaler.noScaling,
              style: context.text.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: c.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bildirim zili (44, çerçevesiz); bekleyen iş varsa 7 px `danger` nokta.
class _BellButton extends StatelessWidget {
  const _BellButton({
    required this.label,
    required this.dot,
    required this.onTap,
  });

  final String label;
  final bool dot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: NzTabletMetrics.railButton,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NzIcon(NzIcons.bell, size: NizamioSize.iconSize, color: c.text),
              if (dot)
                Positioned(
                  top: NzTabletMetrics.bellDotTop,
                  right: NzTabletMetrics.bellDotRight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.danger,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: c.background,
                          spreadRadius: NzTabletMetrics.dotRing,
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(NizamioSize.statusDot / 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cam daire (`glass-float` zemin, 1 px `glass-edge` kenar); basınca .96.
class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.label,
    required this.icon,
    required this.extent,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final double extent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: NzPressable(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.glassFloat,
              shape: BoxShape.circle,
              border: Border.all(color: c.glassEdge),
            ),
            child: SizedBox.square(
              dimension: extent,
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
