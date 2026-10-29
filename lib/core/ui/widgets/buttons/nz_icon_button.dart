import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_surfaces.dart';
import '../nz_icon.dart';
import '../nz_size.dart';
import '../surfaces/nz_glass.dart';
import 'nz_pressable.dart';

/// Yalnız ikonlu düğme. [semanticLabel] zorunludur (görünmez erişilebilirlik etiketi).
/// Dokunma alanı her boyutta >= 48; [onPressed] null → devre dışı. [dot] verilirse ikonun sağ
/// üstünde dikkat noktası (ör. bildirim; anlamı [semanticLabel] taşır).
class NzIconButton extends StatelessWidget {
  const NzIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = NzSize.md,
    this.dot,
  }) : _variant = _IconVariant.plain;

  /// Cam daire (README `m-glassbtn`, yalnız üst çubuktaki menü): `glass-float` dolgu, bulanıklık,
  /// `glass-edge` kenar; 40 görsel, 48 dokunma; basınca `.96`.
  const NzIconButton.glass({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  }) : size = NzSize.md,
       dot = null,
       _variant = _IconVariant.glass;

  /// Sayfa başlığı dairesi (bundle.css `.m-circle`; prototip ara/filtre): 44 görsel, 48 dokunma,
  /// `bg-surface` dolgu + 1 px `border-control` kenar, ikon 16; basınca `.96`. [dot] verilirse
  /// sağ üstte nokta (prototip `hasExtra`: filtre etkin → `context.colors.accentText`).
  const NzIconButton.circle({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.dot,
  }) : size = NzSize.md,
       _variant = _IconVariant.circle;

  /// Vurgulu daire (`.m-circle--accent`): `accent` dolgu, `accent-ink` ikon. Sayfada yalnız
  /// "yeni" eylemi için (tek ana eylem).
  const NzIconButton.circleAccent({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  }) : size = NzSize.md,
       dot = null,
       _variant = _IconVariant.circleAccent;

  final IconData icon;
  final String semanticLabel;

  /// null → devre dışı.
  final VoidCallback? onPressed;
  final NzSize size;

  /// Dikkat noktası rengi (null → yok).
  final Color? dot;
  final _IconVariant _variant;

  static const _disabledContentAlpha = 0.38;
  static const _overlayAlpha = 0.12;
  static const _focusWidth = NizamioSize.focusRingWidth;

  double get _extent => size.pick(
    sm: NizamioSpacing.space10,
    md: NizamioSpacing.space12,
    lg: NizamioSpacing.space12 + NizamioSpacing.space2,
  );

  double get _iconExtent => size.pick(
    sm: NizamioSpacing.space5,
    md: NizamioSpacing.space6,
    lg: NizamioSpacing.space8,
  );

  ButtonStyle _resolveStyle(BuildContext context) {
    final c = context.colors;
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.square(_extent)),
      fixedSize: WidgetStatePropertyAll(Size.square(_extent)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.padded,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.group),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled)
            ? c.text.withValues(alpha: _disabledContentAlpha)
            : c.text,
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.hovered) ||
                s.contains(WidgetState.pressed) ||
                s.contains(WidgetState.focused)
            ? c.text.withValues(alpha: _overlayAlpha)
            : null,
      ),
      side: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.focused)
            ? BorderSide(color: c.focusRing, width: _focusWidth)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    enabled: onPressed != null,
    focusable: onPressed != null,
    label: semanticLabel,
    onTap: onPressed,
    excludeSemantics: true,
    child: switch (_variant) {
      _IconVariant.glass => _GlassCircle(icon: icon, onPressed: onPressed),
      _IconVariant.circle || _IconVariant.circleAccent => _SolidCircle(
        icon: icon,
        onPressed: onPressed,
        accent: _variant == _IconVariant.circleAccent,
        dot: dot,
      ),
      _IconVariant.plain => IconButton(
        onPressed: onPressed,
        iconSize: _iconExtent,
        style: _resolveStyle(context),
        icon: dot == null ? NzIcon(icon) : _Dotted(icon: icon, dot: dot!),
      ),
    },
  );
}

enum _IconVariant { plain, glass, circle, circleAccent }

/// Dolu daire (`.m-circle` / `--accent`). Nokta kenarı daire dolgusuyla aynı renkte 2 px halka.
class _SolidCircle extends StatelessWidget {
  const _SolidCircle({
    required this.icon,
    required this.onPressed,
    required this.accent,
    required this.dot,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool accent;
  final Color? dot;

  // Prototip noktası: daire içinde üstten/sağdan 6 px.
  static const _dotInset = NizamioSpacing.space1 + NizamioSpacing.space1 / 2;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    final fill = accent ? c.primary : c.surface;
    final ink = accent ? c.onPrimary : c.text;
    final dot = this.dot;
    return SizedBox.square(
      dimension: NizamioSpacing.space12,
      child: Center(
        child: NzPressable(
          enabled: enabled,
          child: Opacity(
            opacity: enabled ? 1 : NzIconButton._disabledContentAlpha,
            child: Material(
              color: fill,
              shape: CircleBorder(
                side: accent
                    ? BorderSide.none
                    : BorderSide(
                        color: c.borderControl,
                        width: NizamioSize.borderWidth,
                      ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.resolveWith(
                  (s) =>
                      s.contains(WidgetState.focused) ||
                          s.contains(WidgetState.hovered)
                      ? ink.withValues(alpha: NzIconButton._overlayAlpha)
                      : null,
                ),
                child: SizedBox.square(
                  dimension: NizamioSize.tap,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      NzIcon(icon, size: NizamioSize.iconSizeSm, color: ink),
                      if (dot != null)
                        PositionedDirectional(
                          top: _dotInset,
                          end: _dotInset,
                          child: SizedBox.square(
                            dimension: NizamioSize.dot,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: dot,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// İkon + sağ üst dikkat noktası (zemin rengiyle 2 px halka; prototip zil noktası).
class _Dotted extends StatelessWidget {
  const _Dotted({required this.icon, required this.dot});

  final IconData icon;
  final Color dot;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      NzIcon(icon),
      PositionedDirectional(
        top: 0,
        end: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: dot,
            shape: BoxShape.circle,
            border: Border.all(
              color: context.colors.background,
              width: NizamioSize.focusRingWidth,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(
              NizamioSize.statusDot / 2 + NizamioSize.focusRingWidth,
            ),
          ),
        ),
      ),
    ],
  );
}

class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox.square(
      dimension: NizamioSpacing.space12,
      child: Center(
        child: NzPressable(
          enabled: onPressed != null,
          child: NzGlass.circle(
            tone: NzGlassTone.float,
            shadow: context.shadows.float,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              splashFactory: NoSplash.splashFactory,
              child: SizedBox.square(
                dimension: NizamioSize.glassButton,
                child: NzIcon(
                  icon,
                  size: NizamioSize.iconSize,
                  color: c.glassInk,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
