import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Yalnız ikonlu düğme. [semanticLabel] zorunludur (görünmez erişilebilirlik etiketi).
/// Dokunma alanı her boyutta >= 48; [onPressed] null → devre dışı.
class NzIconButton extends StatelessWidget {
  const NzIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = NzSize.md,
  });

  final IconData icon;
  final String semanticLabel;

  /// null → devre dışı.
  final VoidCallback? onPressed;
  final NzSize size;

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
    child: IconButton(
      onPressed: onPressed,
      iconSize: _iconExtent,
      style: _resolveStyle(context),
      icon: Icon(icon),
    ),
  );
}
