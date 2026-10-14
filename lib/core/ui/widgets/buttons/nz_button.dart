import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

enum _ButtonVariant { primary, secondary, ghost, danger }

/// Metinli düğme. Varyantlar isimli yapıcıdır; görünüm farkı tek `_resolveStyle`'dadır.
///
/// - [onPressed] null → devre dışı.
/// - [loading] true → dokunma kapalı ([onPressed] çağrılmaz), gösterge çizilir, anlamsal durum
///   "meşgul" olur; görünüm devre dışı gibi sönmez.
/// - [expand] true → üst kısıtın genişliğini kaplar.
/// Dokunma alanı her boyutta >= 48 (görsel yükseklik sm 40 · md 48 · lg 56).
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

  static const _borderWidth = 1.0;
  static const _focusWidth = 2.0;
  static const _disabledContentAlpha = 0.38;
  static const _disabledFillAlpha = 0.12;
  static const _overlayAlpha = 0.12;

  bool get _active => onPressed != null && !loading;

  double get _height => size.pick(
    sm: NizamioSpacing.space10,
    md: NizamioSpacing.space12,
    lg: NizamioSpacing.space12 + NizamioSpacing.space2,
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
      _ButtonVariant.secondary || _ButtonVariant.ghost => c.primary,
      _ButtonVariant.danger => c.onPrimary,
    };
    final Color accent = switch (v) {
      _ButtonVariant.danger => c.danger,
      _ => c.primary,
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
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.radiusLg),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        size == NzSize.sm ? t.labelMd : t.labelLg,
      ),
      backgroundColor: switch (v) {
        _ButtonVariant.primary ||
        _ButtonVariant.danger => WidgetStateProperty.resolveWith(
          (s) => disabled(s)
              ? c.text.withValues(alpha: _disabledFillAlpha)
              : v == _ButtonVariant.primary && hot(s)
              ? c.primaryHover
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
          return BorderSide(color: c.text, width: _focusWidth);
        }
        return v == _ButtonVariant.secondary
            ? BorderSide(color: c.border, width: _borderWidth)
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
          ExcludeSemantics(child: Icon(icon, size: _iconExtent)),
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
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
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
