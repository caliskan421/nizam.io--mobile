import 'dart:math' as math;

import 'package:flutter/gestures.dart' show kPrimaryButton;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../../theme/nz_surfaces.dart';
import '../buttons/nz_pressable.dart';
import '../nz_icon.dart';
import '../surfaces/nz_glass.dart';

/// Alt menü öğesi: ikon, etiket ve etkinken görünen mono alt yazı.
@immutable
class NzNavItem {
  const NzNavItem({
    required this.icon,
    required this.label,
    this.caption,
    this.wide = false,
  });

  final IconData icon;
  final String label;
  final String? caption;

  /// Uzun etiket (ör. "Koordinatörlükler"): etkinken öğe daha çok genişler, diğerleri daralır,
  /// etiket bir punto küçülür (prototip `longSlot`).
  final bool wide;
}

/// Kapsülün sağındaki ayrı cam daire (asistan).
@immutable
class NzNavAction {
  const NzNavAction({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
}

/// Yüzen cam alt menü (tasarım `BottomNav`): ekran kenarından `m-gutter`, alttan ev çubuğunun
/// `space2` üstünde (güvenli alan yoksa `m-gap-xl` içeride), `m-nav` (64) yüksekliğinde kapsül; etkin öğe genişler (etiket + alt yazı), vurgu
/// `nav-highlight` ile `easeSpring` / `durNav` kayar. Etkin öğeye yeniden dokunmak da
/// [onSelect]'i çağırır (kabuk kısayol menüsünü açar): parmak kalkınca değil, BASILDIĞI AN
/// (menü basılı tutulurken açılır; bırakış ikinci kez tetiklemez). Diğer öğeler dokunuşta
/// (bırakınca) geçer. `Scaffold.bottomNavigationBar` olarak
/// kullanılır; `extendBody` ile içerik altından geçer ve gövdenin alt dolgusu [reservedHeight]
/// kadar artar.
///
/// Etiket metni en çok [maxTextScale] kadar büyür (sabit 64 px kapsül; tam ad okuyucu
/// etiketinde ve öğe semantiğindedir).
class NzFloatingNav extends StatelessWidget {
  const NzFloatingNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    required this.semanticLabel,
    this.action,
  });

  final List<NzNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final String semanticLabel;
  final NzNavAction? action;

  static const maxTextScale = 1.3;

  // Prototip yerleşimi (buildNav): kapsül iç boşluğu ve öğe arası 4, kapalı öğe 58, etkin
  // öğe en çok 142; dar ekranda etkin öğe daralır (en az [_activeMin]).
  static const _pad = NizamioSpacing.space1;
  static const _itemW = NizamioSize.tap + NizamioSpacing.rowPad;
  static const _activeMax = 142.0;
  static const _activeMin = 96.0;
  // Uzun etiketli öğe etkinken: kapalı öğeler 48, etkin en çok 174 (prototip [48, 48, 174]).
  static const _itemWideMode = NizamioSpacing.space12;
  static const _activeMaxWide = 174.0;

  /// Gövdenin altta ayırması gereken yükseklik (kapsül + alt boşluk + güvenli alan).
  // Sabit anahtar: her kurulumda yeni anahtar BackdropGroup bağımlılarını yeniden kurdurur.
  static final _backdropKey = BackdropKey();

  static double reservedHeight(BuildContext context) =>
      NizamioSize.nav + _bottomGap(MediaQuery.paddingOf(context).bottom);

  /// Kapsülün altındaki toplam boşluk: alt güvenli alan varsa (ev çubuğu) onun `space2`
  /// üstünde, yoksa ekran kenarından `gapXl` içeride.
  static double _bottomGap(double safeBottom) => safeBottom > 0
      ? safeBottom + NizamioSpacing.space2
      : NizamioSpacing.gapXl;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: maxTextScale,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          NizamioSpacing.gutter,
          0,
          NizamioSpacing.gutter,
          _bottomGap(bottom),
        ),
        child: SizedBox(
          height: NizamioSize.nav,
          child: LayoutBuilder(
            builder: (context, box) {
              final action = this.action;
              final room =
                  box.maxWidth -
                  (action == null
                      ? 0
                      : NizamioSize.nav + NizamioSpacing.space3);
              final wide = items[currentIndex].wide;
              final itemW = wide ? _itemWideMode : _itemW;
              final fixed = 2 * _pad + (items.length - 1) * (itemW + _pad);
              final active = math.max(
                _activeMin,
                math.min(wide ? _activeMaxWide : _activeMax, room - fixed),
              );
              // Kapsül ve asistan dairesi örtüşmeyen iki cam: tek arka plan okumasını paylaşır
              // (BackdropGroup; her karede iki ayrı bulanıklık girişi yerine bir).
              return BackdropGroup(
                backdropKey: _backdropKey,
                child: Row(
                  children: [
                    _Capsule(
                      items: items,
                      current: currentIndex,
                      activeWidth: active,
                      itemWidth: itemW,
                      onSelect: onSelect,
                      semanticLabel: semanticLabel,
                    ),
                    const Spacer(),
                    if (action != null) _ActionCircle(action: action),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Capsule extends StatelessWidget {
  const _Capsule({
    required this.items,
    required this.current,
    required this.activeWidth,
    required this.itemWidth,
    required this.onSelect,
    required this.semanticLabel,
  });

  final List<NzNavItem> items;
  final int current;
  final double activeWidth;
  final double itemWidth;
  final ValueChanged<int> onSelect;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const pad = NzFloatingNav._pad;
    final widths = [
      for (var i = 0; i < items.length; i++)
        i == current ? activeWidth : itemWidth,
    ];
    final xs = <double>[];
    var x = pad;
    for (final w in widths) {
      xs.add(x);
      x += w + pad;
    }
    final width = x;
    final duration = NzMotion.of(context, NizamioMotion.durNav);
    const curve = NizamioMotion.easeSpring;
    const itemH = NizamioSize.nav - 2 * pad - 2 * NizamioSize.borderWidth;
    final pill = BorderRadius.circular(NizamioRadius.pill);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        width: width,
        child: NzGlass(
          tone: NzGlassTone.float,
          borderRadius: pill,
          shadow: context.shadows.float,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                left: xs[current],
                width: widths[current],
                top: pad,
                height: itemH,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.navHighlight,
                    borderRadius: pill,
                  ),
                  child: CustomPaint(
                    foregroundPainter: NzEdgeLightPainter(
                      color: c.edgeLight,
                      borderRadius: pill,
                      inset: 0,
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < items.length; i++)
                AnimatedPositioned(
                  duration: duration,
                  curve: curve,
                  left: xs[i],
                  width: widths[i],
                  top: pad,
                  height: itemH,
                  child: _NavButton(
                    item: items[i],
                    active: i == current,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NzNavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final caption = item.caption;
    final duration = NzMotion.of(context, NizamioMotion.durNav);
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      onTap: onTap,
      excludeSemantics: true,
      // Etkin öğe: basış anında (pointer down) tetiklenir; kısayol menüsü parmak kalkmadan açılır.
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: active
            ? (e) {
                if (e.buttons == kPrimaryButton) onTap();
              }
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: active ? null : onTap,
          child: ClipRect(
            child: AnimatedPadding(
              duration: duration,
              curve: NizamioMotion.easeSpring,
              padding: EdgeInsets.symmetric(
                horizontal: active ? NizamioSpacing.rowPad : 0,
              ),
              child: Row(
                mainAxisAlignment: active
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  NzPressable(
                    child: NzIcon(
                      item.icon,
                      size: NizamioSize.iconSize,
                      color: active ? c.glassInk : c.textMuted,
                    ),
                  ),
                  if (active) ...[
                    const Gap(NizamioSpacing.gapMd),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: t.navLabel.copyWith(
                              color: c.glassInk,
                              fontSize: item.wide
                                  ? t.caption.fontSize
                                  : t.navLabel.fontSize,
                            ),
                          ),
                          if (caption != null)
                            Text(
                              caption,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: t.program.copyWith(color: c.glassInkFaint),
                            ),
                        ],
                      ),
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

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({required this.action});

  // Prototip asistan ikonu 26 px (ikon ölçüsünün 1.3 katı).
  static const _actionIcon = NizamioSize.iconSize * 1.3;

  final NzNavAction action;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    label: action.semanticLabel,
    onTap: action.onPressed,
    excludeSemantics: true,
    child: NzPressable(
      child: NzGlass.circle(
        tone: NzGlassTone.float,
        shadow: context.shadows.float,
        child: InkWell(
          onTap: action.onPressed,
          customBorder: const CircleBorder(),
          splashFactory: NoSplash.splashFactory,
          child: SizedBox.square(
            dimension: NizamioSize.nav,
            child: NzIcon(
              action.icon,
              size: _actionIcon,
              color: context.colors.accentText,
            ),
          ),
        ),
      ),
    ),
  );
}
