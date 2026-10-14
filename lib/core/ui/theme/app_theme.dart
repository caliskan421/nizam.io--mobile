import 'package:flutter/material.dart';

import '../../theme/generated/tokens.gen.dart';
import 'nz_text_styles.dart';

/// Token'da henüz karşılığı olmayan değerler (gölge/yükseklik, opaklık, ikon boyutu). Web ile
/// birlikte `tokens.json`'a eklenince buradan kalkar; başka yerde elle sabit tutulmaz.
// TOKEN-BEKLİYOR
abstract final class _Pending {
  /// Düz yüzey: gölge yok, ayrım kenarlıkla.
  static const double elevation = 0;
  static const double iconSize = 24;
  static const double disabledContentOpacity = 0.38;
  static const double disabledFillOpacity = 0.12;
  static const double selectedFillOpacity = 0.12;
  static const double focusedBorderWidth = 2;
  static const double borderWidth = 1;
}

/// `ThemeData` kurucusu (ADR-0003, A1): `ColorScheme` tohumdan değil token rollerinden kurulur,
/// `TextTheme` `NzTextStyles` rollerinden, bileşen temaları token yarıçap/boşluğundan.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light, NizamioColors.light);

  static ThemeData dark() => _build(Brightness.dark, NizamioColors.dark);

  /// Rol → `ColorScheme` eşlemesi (test edilir). Roadmap A1: `primary`, `onPrimary`,
  /// `surface` = `background`, `error` = `danger`, `outline` = `border`.
  static ColorScheme colorScheme(Brightness brightness, NizamioColors c) {
    final isLight = brightness == Brightness.light;
    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.primaryHover,
      onSecondary: c.onPrimary,
      error: c.danger,
      onError: c.background,
      surface: c.background,
      onSurface: c.text,
      onSurfaceVariant: c.textMuted,
      outline: c.border,
      outlineVariant: c.border,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: c.backgroundMuted,
      surfaceContainer: c.backgroundMuted,
      surfaceContainerHigh: c.backgroundMuted,
      surfaceContainerHighest: c.backgroundMuted,
      inverseSurface: c.text,
      onInverseSurface: c.background,
      inversePrimary: isLight
          ? NizamioPalette.primary300
          : NizamioPalette.primary600,
    );
  }

  static ThemeData _build(Brightness brightness, NizamioColors c) {
    final nzText = NzTextStyles.fromColors(c);
    final scheme = colorScheme(brightness, c);

    final shapeLg = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(NizamioRadius.radiusLg),
    );
    const sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(NizamioRadius.radiusXl),
      ),
    );

    Color disabledFill() =>
        c.text.withValues(alpha: _Pending.disabledFillOpacity);
    Color disabledContent() =>
        c.text.withValues(alpha: _Pending.disabledContentOpacity);
    Color selectedFill() =>
        c.primary.withValues(alpha: _Pending.selectedFillOpacity);

    // 48 dp: asgari dokunma alanı (space12).
    const minButton = Size(0, NizamioSpacing.space12);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: NizamioSpacing.space4,
    );

    OutlineInputBorder inputBorder(Color color, [double? width]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.radiusLg),
          borderSide: BorderSide(
            color: color,
            width: width ?? _Pending.borderWidth,
          ),
        );

    final icon = IconThemeData(color: c.text, size: _Pending.iconSize);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      dividerColor: c.border,
      textTheme: nzText.toTextTheme(),
      iconTheme: icon,
      extensions: [c, nzText],
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minButton),
          padding: const WidgetStatePropertyAll(buttonPadding),
          elevation: const WidgetStatePropertyAll(_Pending.elevation),
          shape: WidgetStatePropertyAll(shapeLg),
          textStyle: WidgetStatePropertyAll(nzText.labelLg),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? disabledFill()
                : s.contains(WidgetState.hovered) ||
                      s.contains(WidgetState.pressed)
                ? c.primaryHover
                : c.primary,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? disabledContent()
                : c.onPrimary,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minButton),
          padding: const WidgetStatePropertyAll(buttonPadding),
          elevation: const WidgetStatePropertyAll(_Pending.elevation),
          shape: WidgetStatePropertyAll(shapeLg),
          textStyle: WidgetStatePropertyAll(nzText.labelLg),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? disabledContent()
                : c.primary,
          ),
          side: WidgetStateProperty.resolveWith(
            (s) => BorderSide(
              color: s.contains(WidgetState.disabled)
                  ? disabledFill()
                  : s.contains(WidgetState.focused)
                  ? c.primary
                  : c.border,
              width: _Pending.borderWidth,
            ),
          ),
          overlayColor: WidgetStatePropertyAll(selectedFill()),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.backgroundMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space4,
          vertical: NizamioSpacing.space3,
        ),
        labelStyle: nzText.bodyMd.copyWith(color: c.textMuted),
        floatingLabelStyle: nzText.bodySm.copyWith(color: c.primary),
        hintStyle: nzText.bodyMd.copyWith(color: c.textMuted),
        helperStyle: nzText.bodySm.copyWith(color: c.textMuted),
        errorStyle: nzText.bodySm.copyWith(color: c.danger),
        border: inputBorder(c.border),
        enabledBorder: inputBorder(c.border),
        disabledBorder: inputBorder(disabledFill()),
        focusedBorder: inputBorder(c.primary, _Pending.focusedBorderWidth),
        errorBorder: inputBorder(c.danger),
        focusedErrorBorder: inputBorder(c.danger, _Pending.focusedBorderWidth),
      ),
      cardTheme: CardThemeData(
        color: c.background,
        elevation: _Pending.elevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.radiusXl),
          side: BorderSide(color: c.border, width: _Pending.borderWidth),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: _Pending.borderWidth,
        space: _Pending.borderWidth,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.text,
        contentTextStyle: nzText.bodyMd.copyWith(color: c.background),
        actionTextColor: scheme.inversePrimary,
        elevation: _Pending.elevation,
        shape: shapeLg,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.background,
        modalBackgroundColor: c.background,
        elevation: _Pending.elevation,
        modalElevation: _Pending.elevation,
        shape: sheetShape,
        showDragHandle: true,
        dragHandleColor: c.border,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.background,
        indicatorColor: selectedFill(),
        elevation: _Pending.elevation,
        height: NizamioSpacing.space16,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => icon.copyWith(
            color: s.contains(WidgetState.selected) ? c.primary : c.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => nzText.caption.copyWith(
            color: s.contains(WidgetState.selected) ? c.primary : c.textMuted,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.background,
        indicatorColor: selectedFill(),
        elevation: _Pending.elevation,
        selectedIconTheme: icon.copyWith(color: c.primary),
        unselectedIconTheme: icon.copyWith(color: c.textMuted),
        selectedLabelTextStyle: nzText.caption.copyWith(color: c.primary),
        unselectedLabelTextStyle: nzText.caption.copyWith(color: c.textMuted),
      ),
    );
  }
}
