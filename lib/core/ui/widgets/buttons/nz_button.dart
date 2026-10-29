import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_surfaces.dart';
import '../nz_icon.dart';
import '../nz_size.dart';
import 'nz_pressable.dart';

enum _ButtonVariant { primary, secondary, ghost, danger }

/// Metinli düğme. Varyantlar isimli yapıcıdır; görünüm farkı tek `_resolveStyle`'dadır.
/// Tasarım (`.m-btn`): ana eylem `accent-top → accent`, ikincil `btn-top → btn-bottom` degradesi,
/// üst iç ışık, Inter 14/20 600; basınca `.96` (`NzPressable`).
///
/// - [onPressed] null → devre dışı.
/// - [loading] true → dokunma kapalı ([onPressed] çağrılmaz), gösterge çizilir, anlamsal durum
///   "meşgul" olur; görünüm devre dışı gibi sönmez.
/// - [expand] true → üst kısıtın genişliğini kaplar.
/// Dokunma alanı her boyutta >= 48 (görsel yükseklik prototip kontrolü: sm 36 · md 44 · lg 52).
class NzButton extends StatelessWidget {
  const NzButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = NzSize.md,
    this.loading = false,
    this.icon,
    this.expand = false,
  }) : _variant = _ButtonVariant.primary;

  const NzButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = NzSize.md,
    this.loading = false,
    this.icon,
    this.expand = false,
  }) : _variant = _ButtonVariant.secondary;

  const NzButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = NzSize.md,
    this.loading = false,
    this.icon,
    this.expand = false,
  }) : _variant = _ButtonVariant.ghost;

  const NzButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = NzSize.md,
    this.loading = false,
    this.icon,
    this.expand = false,
  }) : _variant = _ButtonVariant.danger;

  final String label;

  /// null → devre dışı.
  final VoidCallback? onPressed;
  final NzSize size;
  final bool loading;
  final IconData? icon;

  /// true → üst kısıt genişliği.
  final bool expand;
  final _ButtonVariant _variant;

  static const _borderWidth = NizamioSize.borderWidth;
  static const _focusWidth = NizamioSize.focusRingWidth;
  static const _disabledContentAlpha = 0.38;
  static const _disabledFillAlpha = 0.12;
  static const _overlayAlpha = 0.12;

  bool get _active => onPressed != null && !loading;

  double get _height => size.pick(
    sm: NizamioSize.controlSm,
    md: NizamioSize.controlMd,
    lg: NizamioSize.controlLg,
  );

  double get _radius => size.pick(
    sm: NizamioRadius.tile,
    md: NizamioRadius.group,
    lg: NizamioRadius.group,
  );

  double get _iconExtent => size.pick(
    sm: NizamioSpacing.space4,
    md: NizamioSpacing.space5,
    lg: NizamioSpacing.space6,
  );

  ButtonStyle _resolveStyle(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final v = _variant;
    // Yüklenirken dokunma kapalıdır ama görünüm sönmez.
    bool disabled(Set<WidgetState> s) =>
        s.contains(WidgetState.disabled) && !loading;
    bool hot(Set<WidgetState> s) =>
        s.contains(WidgetState.hovered) || s.contains(WidgetState.pressed);

    final Color foreground = switch (v) {
      _ButtonVariant.primary => c.onPrimary,
      // accent (lime) yalnız dolgudur; yazı rengi olarak ikincil `text`, hayalet `accentText`.
      _ButtonVariant.secondary => c.text,
      _ButtonVariant.ghost => c.accentText,
      _ButtonVariant.danger => c.onDanger,
    };
    final LinearGradient? gradient = switch (v) {
      _ButtonVariant.primary => c.primaryFill,
      _ButtonVariant.secondary => c.secondaryFill,
      _ => null,
    };
    final Color accent = switch (v) {
      _ButtonVariant.danger => c.danger,
      _ButtonVariant.primary => c.primary,
      _ => c.accentText,
    };

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(NizamioSpacing.space16, _height),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: size.pick(
            sm: NizamioSpacing.space3,
            md: NizamioSpacing.space4,
            lg: NizamioSpacing.space6,
          ),
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
      ),
      // `.m-btn` 14/20 600: ayrı tasarım stili yok — gövde rolü + kart başlığı ağırlığı.
      textStyle: WidgetStatePropertyAll(
        t.bodyMd.copyWith(fontWeight: t.labelLg.fontWeight),
      ),
      backgroundBuilder: gradient == null
          ? null
          : (context, states, child) => disabled(states)
                ? child ?? const SizedBox.shrink()
                : DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(_radius),
                    ),
                    child: CustomPaint(
                      foregroundPainter: NzEdgeLightPainter(
                        color: c.edgeLight,
                        borderRadius: BorderRadius.circular(_radius),
                        inset: v == _ButtonVariant.secondary ? _borderWidth : 0,
                      ),
                      child: child,
                    ),
                  ),
      backgroundColor: switch (v) {
        _ButtonVariant.primary ||
        _ButtonVariant.danger => WidgetStateProperty.resolveWith(
          (s) => disabled(s)
              ? c.text.withValues(alpha: _disabledFillAlpha)
              : accent,
        ),
        _ => const WidgetStatePropertyAll(null),
      },
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => disabled(s)
            ? c.text.withValues(alpha: _disabledContentAlpha)
            : foreground,
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (s) => hot(s) || s.contains(WidgetState.focused)
            ? (v == _ButtonVariant.primary || v == _ButtonVariant.danger
                      ? foreground
                      : accent)
                  .withValues(alpha: _overlayAlpha)
            : null,
      ),
      side: WidgetStateProperty.resolveWith((s) {
        if (disabled(s)) {
          return v == _ButtonVariant.secondary
              ? BorderSide(
                  color: c.text.withValues(alpha: _disabledFillAlpha),
                  width: _borderWidth,
                )
              : null;
        }
        if (s.contains(WidgetState.focused)) {
          return BorderSide(color: c.focusRing, width: _focusWidth);
        }
        return v == _ButtonVariant.secondary
            ? BorderSide(color: c.buttonBorder, width: _borderWidth)
            : null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    final handler = _active ? onPressed : null;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          _Spinner(extent: _iconExtent)
        else if (icon != null)
          ExcludeSemantics(child: NzIcon(icon, size: _iconExtent)),
        if (loading || icon != null) const Gap(NizamioSpacing.space2),
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );

    final button = switch (_variant) {
      _ButtonVariant.primary || _ButtonVariant.danger => FilledButton(
        onPressed: handler,
        style: style,
        child: content,
      ),
      _ButtonVariant.secondary => OutlinedButton(
        onPressed: handler,
        style: style,
        child: content,
      ),
      _ButtonVariant.ghost => TextButton(
        onPressed: handler,
        style: style,
        child: content,
      ),
    };

    return Semantics(
      container: true,
      button: true,
      enabled: _active,
      focusable: _active,
      label: label,
      value: loading ? context.l10n.uiButtonsBusy : null,
      onTap: handler,
      excludeSemantics: true,
      child: NzPressable(
        enabled: _active,
        child: expand
            ? SizedBox(width: double.infinity, child: button)
            : button,
      ),
    );
  }
}

/// Yükleniyor göstergesi: rengi düğmenin ön plan rolünü izler (IconTheme).
class _Spinner extends StatelessWidget {
  const _Spinner({required this.extent});

  final double extent;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: extent,
    height: extent,
    child: CircularProgressIndicator(
      color: IconTheme.of(context).color,
      strokeWidth: NizamioSpacing.space1 / 2,
    ),
  );
}
