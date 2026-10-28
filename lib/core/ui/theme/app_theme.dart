import 'package:flutter/material.dart';

import '../../theme/generated/tokens.gen.dart';
import 'nz_text_styles.dart';

/// Tasarım kaynağında karşılığı olmayan değerler (Material yüksekliği, durum opaklıkları).
/// Tasarım `tokens.json`'a eklenince buradan kalkar; başka yerde elle sabit tutulmaz. Gölge,
/// ikon boyutu ve çizgi kalınlıkları token'a bağlandı (ADR-0003 karar 24).
// TOKEN-BEKLİYOR
abstract final class _Pending {
  /// Material yükseklik gölgesi kapalı; derinlik `NizamioShadows` ile verilir.
  static const double elevation = 0;
  static const double disabledContentOpacity = 0.38;
  static const double disabledFillOpacity = 0.12;
  static const double selectedFillOpacity = 0.12;
}

/// `ThemeData` kurucusu (ADR-0003, A1): `ColorScheme` tohumdan değil token rollerinden kurulur,
/// `TextTheme` `NzTextStyles` rollerinden, bileşen temaları token yarıçap/boşluğundan.
abstract final class AppTheme {
  static ThemeData light() =>
      _build(Brightness.light, NizamioColors.light, NizamioShadows.light);

  static ThemeData dark() =>
      _build(Brightness.dark, NizamioColors.dark, NizamioShadows.dark);

  /// Rol → `ColorScheme` eşlemesi (test edilir). Zemin `background` (bg-base), Material yüzeyi
  /// `surface` (bg-surface; kart, sayfa), kapsayıcılar `surfaceRaised`/`surfaceOverlay`.
  /// `primary` (accent) yalnız dolgudur; vurgulu yazı/ikon `secondary` = `accentText`.
  /// Ters yüzeydeki (snackbar) vurgu, karşı modun `accentText`'idir.
  static ColorScheme colorScheme(Brightness brightness, NizamioColors c) {
    final inverse = brightness == Brightness.light
        ? NizamioColors.dark
        : NizamioColors.light;
    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.accentText,
      onSecondary: c.background,
      error: c.danger,
      onError: c.onDanger,
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.textMuted,
      outline: c.borderControl,
      outlineVariant: c.border,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surfaceRaised,
      surfaceContainerHigh: c.surfaceRaised,
      surfaceContainerHighest: c.surfaceOverlay,
      inverseSurface: c.text,
      onInverseSurface: c.background,
      inversePrimary: inverse.accentText,
      scrim: c.scrim,
    );
  }

  static ThemeData _build(
    Brightness brightness,
    NizamioColors c,
    NizamioShadows shadows,
  ) {
    final nzText = NzTextStyles.fromColors(c);
    final scheme = colorScheme(brightness, c);

    // Düğme, giriş ve snackbar köşesi `m-r-group` (16; bundle.css `.m-btn`, prototip girişi).
    final shapeControl = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(NizamioRadius.group),
    );
    const sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(NizamioRadius.sheet),
      ),
    );

    Color disabledFill() =>
        c.text.withValues(alpha: _Pending.disabledFillOpacity);
    Color disabledContent() =>
        c.text.withValues(alpha: _Pending.disabledContentOpacity);
    Color selectedFill() =>
        c.primary.withValues(alpha: _Pending.selectedFillOpacity);

    // Asgari hedef `m-tap` (44); Material dokunma alanı dolgusu (48) ayrıca korunur.
    const minButton = Size(0, NizamioSize.tap);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: NizamioSpacing.space5,
    );
    // `.m-btn`: Inter 14/20 600 — ayrı tasarım stili yok; gövde rolü + kart başlığı ağırlığı.
    final buttonText = nzText.bodyMd.copyWith(
      fontWeight: nzText.labelLg.fontWeight,
    );

    OutlineInputBorder inputBorder(Color color, [double? width]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          borderSide: BorderSide(
            color: color,
            width: width ?? NizamioSize.borderWidth,
          ),
        );

    final icon = IconThemeData(color: c.text, size: NizamioSize.iconSize);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      dividerColor: c.border,
      textTheme: nzText.toTextTheme(),
      iconTheme: icon,
      extensions: [c, nzText, shadows],
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minButton),
          padding: const WidgetStatePropertyAll(buttonPadding),
          elevation: const WidgetStatePropertyAll(_Pending.elevation),
          shape: WidgetStatePropertyAll(shapeControl),
          textStyle: WidgetStatePropertyAll(buttonText),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) =>
                s.contains(WidgetState.disabled) ? disabledFill() : c.primary,
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
          shape: WidgetStatePropertyAll(shapeControl),
          textStyle: WidgetStatePropertyAll(buttonText),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) =>
                s.contains(WidgetState.disabled) ? disabledContent() : c.text,
          ),
          side: WidgetStateProperty.resolveWith(
            (s) => BorderSide(
              color: s.contains(WidgetState.disabled)
                  ? disabledFill()
                  : s.contains(WidgetState.focused)
                  ? c.focusRing
                  : c.borderControl,
              width: NizamioSize.borderWidth,
            ),
          ),
          overlayColor: WidgetStatePropertyAll(selectedFill()),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space4,
          vertical: NizamioSpacing.rowPad,
        ),
        labelStyle: nzText.bodyMd.copyWith(color: c.textMuted),
        floatingLabelStyle: nzText.bodySm.copyWith(color: c.accentText),
        hintStyle: nzText.bodyMd.copyWith(color: c.textMuted),
        helperStyle: nzText.bodySm.copyWith(color: c.textMuted),
        errorStyle: nzText.bodySm.copyWith(color: c.danger),
        border: inputBorder(c.borderControl),
        enabledBorder: inputBorder(c.borderControl),
        disabledBorder: inputBorder(disabledFill()),
        focusedBorder: inputBorder(c.focusRing, NizamioSize.focusRingWidth),
        errorBorder: inputBorder(c.danger),
        focusedErrorBorder: inputBorder(c.danger, NizamioSize.focusRingWidth),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: _Pending.elevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.card),
          side: BorderSide(color: c.border, width: NizamioSize.borderWidth),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: NizamioSize.borderWidth,
        space: NizamioSize.borderWidth,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.text,
        contentTextStyle: nzText.bodyMd.copyWith(color: c.background),
        actionTextColor: scheme.inversePrimary,
        elevation: _Pending.elevation,
        shape: shapeControl,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        modalBarrierColor: c.scrim,
        elevation: _Pending.elevation,
        modalElevation: _Pending.elevation,
        shape: sheetShape,
        showDragHandle: true,
        dragHandleColor: c.borderStrong,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.background,
        indicatorColor: selectedFill(),
        elevation: _Pending.elevation,
        height: NizamioSpacing.space16,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => icon.copyWith(
            color: s.contains(WidgetState.selected)
                ? c.accentText
                : c.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => nzText.caption.copyWith(
            color: s.contains(WidgetState.selected)
                ? c.accentText
                : c.textMuted,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.background,
        indicatorColor: selectedFill(),
        elevation: _Pending.elevation,
        selectedIconTheme: icon.copyWith(color: c.accentText),
        unselectedIconTheme: icon.copyWith(color: c.textMuted),
        selectedLabelTextStyle: nzText.caption.copyWith(color: c.accentText),
        unselectedLabelTextStyle: nzText.caption.copyWith(color: c.textMuted),
      ),
    );
  }
}
