import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_surfaces.dart';
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
  }) : _glass = false;

  /// Cam daire (README `m-glassbtn`, yalnız üst çubuktaki menü): `glass-float` dolgu, bulanıklık,
  /// `glass-edge` kenar; 40 görsel, 48 dokunma; basınca `.96`.
  const NzIconButton.glass({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  }) : size = NzSize.md,
       dot = null,
       _glass = true;

  final IconData icon;
  final String semanticLabel;

  /// null → devre dışı.
  final VoidCallback? onPressed;
  final NzSize size;

  /// Dikkat noktası rengi (null → yok).
  final Color? dot;
  final bool _glass;

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
    child: _glass
        ? _GlassCircle(icon: icon, onPressed: onPressed)
        : IconButton(
            onPressed: onPressed,
            iconSize: _iconExtent,
            style: _resolveStyle(context),
            icon: dot == null ? Icon(icon) : _Dotted(icon: icon, dot: dot!),
          ),
  );
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
      Icon(icon),
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
                child: Icon(
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
