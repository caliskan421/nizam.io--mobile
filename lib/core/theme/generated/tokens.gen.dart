// BU DOSYA ÜRETİLMİŞTİR — elle düzenlenmez. `make gen` (tool/gen.dart) ile yeniden üretilir.
// Kaynak: caliskan421/nizam.io--frontend commit 54afb002428e09fdc2727565e226880c1a25bb8c — tokens/tokens.json
//
// Değerler YER TUTUCUDUR (F14 kapsam 8); ürün tasarımı sonra gelir. Web ile tek kaynak.

import 'package:flutter/material.dart';

/// Palet (açık/koyu rollerin başvurduğu tonlar).
abstract final class NizamioPalette {
  static const primary50 = Color(0xFFEEF4FA);
  static const primary100 = Color(0xFFD5E3F1);
  static const primary200 = Color(0xFFADC8E3);
  static const primary300 = Color(0xFF7FA7D0);
  static const primary400 = Color(0xFF4F82B6);
  static const primary500 = Color(0xFF2F6699);
  static const primary600 = Color(0xFF1F4E79);
  static const primary700 = Color(0xFF1A4165);
  static const primary800 = Color(0xFF163552);
  static const primary900 = Color(0xFF122A41);
  static const primary950 = Color(0xFF0B1A29);
  static const surface0 = Color(0xFFFFFFFF);
  static const surface50 = Color(0xFFF8FAFC);
  static const surface100 = Color(0xFFF1F5F9);
  static const surface200 = Color(0xFFE2E8F0);
  static const surface300 = Color(0xFFCBD5E1);
  static const surface400 = Color(0xFF94A3B8);
  static const surface500 = Color(0xFF64748B);
  static const surface600 = Color(0xFF475569);
  static const surface700 = Color(0xFF334155);
  static const surface800 = Color(0xFF1E293B);
  static const surface900 = Color(0xFF0F172A);
  static const surface950 = Color(0xFF020617);
  static const danger100 = Color(0xFFFDE2E1);
  static const danger300 = Color(0xFFF8A5A0);
  static const danger500 = Color(0xFFDC2626);
  static const danger700 = Color(0xFFB91C1C);
  static const success100 = Color(0xFFDCFCE7);
  static const success300 = Color(0xFF86EFAC);
  static const success500 = Color(0xFF16A34A);
  static const success700 = Color(0xFF15803D);
  static const warning100 = Color(0xFFFEF3C7);
  static const warning300 = Color(0xFFFCD34D);
  static const warning500 = Color(0xFFD97706);
  static const warning700 = Color(0xFFB45309);
  static const info100 = Color(0xFFDBEAFE);
  static const info300 = Color(0xFF93C5FD);
  static const info500 = Color(0xFF2563EB);
  static const info700 = Color(0xFF1D4ED8);
}

/// Mod rolleri — Material temasına ThemeExtension olarak eklenir.
@immutable
class NizamioColors extends ThemeExtension<NizamioColors> {
  const NizamioColors({
    required this.background,
    required this.backgroundMuted,
    required this.border,
    required this.danger,
    required this.info,
    required this.onPrimary,
    required this.primary,
    required this.primaryHover,
    required this.success,
    required this.text,
    required this.textMuted,
    required this.warning,
  });

  final Color background;
  final Color backgroundMuted;
  final Color border;
  final Color danger;
  final Color info;
  final Color onPrimary;
  final Color primary;
  final Color primaryHover;
  final Color success;
  final Color text;
  final Color textMuted;
  final Color warning;

  static const light = NizamioColors(
    background: Color(0xFFFFFFFF),
    backgroundMuted: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0),
    danger: Color(0xFFB91C1C),
    info: Color(0xFF1D4ED8),
    onPrimary: Color(0xFFFFFFFF),
    primary: Color(0xFF1F4E79),
    primaryHover: Color(0xFF1A4165),
    success: Color(0xFF15803D),
    text: Color(0xFF0F172A),
    textMuted: Color(0xFF64748B),
    warning: Color(0xFFB45309),
  );

  static const dark = NizamioColors(
    background: Color(0xFF020617),
    backgroundMuted: Color(0xFF0F172A),
    border: Color(0xFF334155),
    danger: Color(0xFFF8A5A0),
    info: Color(0xFF93C5FD),
    onPrimary: Color(0xFF020617),
    primary: Color(0xFF7FA7D0),
    primaryHover: Color(0xFFADC8E3),
    success: Color(0xFF86EFAC),
    text: Color(0xFFF8FAFC),
    textMuted: Color(0xFF94A3B8),
    warning: Color(0xFFFCD34D),
  );

  @override
  NizamioColors copyWith({
    Color? background,
    Color? backgroundMuted,
    Color? border,
    Color? danger,
    Color? info,
    Color? onPrimary,
    Color? primary,
    Color? primaryHover,
    Color? success,
    Color? text,
    Color? textMuted,
    Color? warning,
  }) {
    return NizamioColors(
      background: background ?? this.background,
      backgroundMuted: backgroundMuted ?? this.backgroundMuted,
      border: border ?? this.border,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      onPrimary: onPrimary ?? this.onPrimary,
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      success: success ?? this.success,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      warning: warning ?? this.warning,
    );
  }

  @override
  NizamioColors lerp(NizamioColors? other, double t) {
    if (other == null) return this;
    return NizamioColors(
      background: Color.lerp(background, other.background, t)!,
      backgroundMuted: Color.lerp(backgroundMuted, other.backgroundMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      success: Color.lerp(success, other.success, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

/// Boşluk ölçeği (mantıksal piksel).
abstract final class NizamioSpacing {
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
}

/// Köşe yarıçapları (mantıksal piksel).
abstract final class NizamioRadius {
  static const double radiusNone = 0.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radiusFull = 9999.0;
}

/// Tipografi.
abstract final class NizamioTypography {
  static const familySans = 'Inter';
  static const familySansFallback = <String>[
    'system-ui',
    '-apple-system',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];
  static const familyMono = 'JetBrains Mono';
  static const familyMonoFallback = <String>[
    'ui-monospace',
    'SFMono-Regular',
    'Menlo',
    'monospace',
  ];
  static const double sizeXs = 12.0;
  static const double sizeSm = 14.0;
  static const double sizeMd = 16.0;
  static const double sizeLg = 18.0;
  static const double sizeXl = 20.0;
  static const double size2xl = 24.0;
  static const double size3xl = 30.0;
  static const weightRegular = FontWeight.w400;
  static const weightMedium = FontWeight.w500;
  static const weightSemibold = FontWeight.w600;
  static const weightBold = FontWeight.w700;
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
}
