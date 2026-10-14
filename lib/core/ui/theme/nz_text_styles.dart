import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/generated/tokens.gen.dart';

/// Anlamsal metin rolleri (ADR-0003, A1). Ekran ham `TextStyle` yazmaz; rol seçer ve gerekirse
/// `copyWith(color:/fontWeight:)` ile değiştirir. Boyut/ağırlık/satır yüksekliği token'dan
/// (`NizamioTypography`); renk varsayılanı `NizamioColors.text`.
@immutable
class NzTextStyles extends ThemeExtension<NzTextStyles> {
  const NzTextStyles({
    required this.displayLg,
    required this.titleLg,
    required this.titleMd,
    required this.titleSm,
    required this.bodyLg,
    required this.bodyMd,
    required this.bodySm,
    required this.labelLg,
    required this.labelMd,
    required this.caption,
    required this.mono,
  });

  /// Yazı tipi dosyaları uygulamayla gelir (assets/fonts); `GoogleFonts` ağdan indirmez
  /// (bootstrap'te kapatılır). `TextStyle(...)` yapıcısı yerine `GoogleFonts.*` kullanılır.
  factory NzTextStyles.fromColors(NizamioColors c) {
    TextStyle sans(double size, FontWeight weight, double height) =>
        GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          height: height,
          color: c.text,
        ).copyWith(fontFamilyFallback: NizamioTypography.familySansFallback);

    return NzTextStyles(
      displayLg: sans(
        NizamioTypography.size3xl,
        NizamioTypography.weightBold,
        NizamioTypography.lineHeightTight,
      ),
      titleLg: sans(
        NizamioTypography.size2xl,
        NizamioTypography.weightSemibold,
        NizamioTypography.lineHeightTight,
      ),
      titleMd: sans(
        NizamioTypography.sizeXl,
        NizamioTypography.weightSemibold,
        NizamioTypography.lineHeightTight,
      ),
      titleSm: sans(
        NizamioTypography.sizeLg,
        NizamioTypography.weightSemibold,
        NizamioTypography.lineHeightTight,
      ),
      bodyLg: sans(
        NizamioTypography.sizeMd,
        NizamioTypography.weightRegular,
        NizamioTypography.lineHeightNormal,
      ),
      bodyMd: sans(
        NizamioTypography.sizeSm,
        NizamioTypography.weightRegular,
        NizamioTypography.lineHeightNormal,
      ),
      bodySm: sans(
        NizamioTypography.sizeXs,
        NizamioTypography.weightRegular,
        NizamioTypography.lineHeightNormal,
      ),
      labelLg: sans(
        NizamioTypography.sizeMd,
        NizamioTypography.weightMedium,
        NizamioTypography.lineHeightTight,
      ),
      labelMd: sans(
        NizamioTypography.sizeSm,
        NizamioTypography.weightMedium,
        NizamioTypography.lineHeightTight,
      ),
      caption: sans(
        NizamioTypography.sizeXs,
        NizamioTypography.weightRegular,
        NizamioTypography.lineHeightNormal,
      ),
      mono: GoogleFonts.jetBrainsMono(
        fontSize: NizamioTypography.sizeSm,
        fontWeight: NizamioTypography.weightRegular,
        height: NizamioTypography.lineHeightNormal,
        color: c.text,
      ).copyWith(fontFamilyFallback: NizamioTypography.familyMonoFallback),
    );
  }

  final TextStyle displayLg;
  final TextStyle titleLg;
  final TextStyle titleMd;
  final TextStyle titleSm;
  final TextStyle bodyLg;
  final TextStyle bodyMd;
  final TextStyle bodySm;
  final TextStyle labelLg;
  final TextStyle labelMd;
  final TextStyle caption;
  final TextStyle mono;

  @override
  NzTextStyles copyWith({
    TextStyle? displayLg,
    TextStyle? titleLg,
    TextStyle? titleMd,
    TextStyle? titleSm,
    TextStyle? bodyLg,
    TextStyle? bodyMd,
    TextStyle? bodySm,
    TextStyle? labelLg,
    TextStyle? labelMd,
    TextStyle? caption,
    TextStyle? mono,
  }) {
    return NzTextStyles(
      displayLg: displayLg ?? this.displayLg,
      titleLg: titleLg ?? this.titleLg,
      titleMd: titleMd ?? this.titleMd,
      titleSm: titleSm ?? this.titleSm,
      bodyLg: bodyLg ?? this.bodyLg,
      bodyMd: bodyMd ?? this.bodyMd,
      bodySm: bodySm ?? this.bodySm,
      labelLg: labelLg ?? this.labelLg,
      labelMd: labelMd ?? this.labelMd,
      caption: caption ?? this.caption,
      mono: mono ?? this.mono,
    );
  }

  @override
  NzTextStyles lerp(NzTextStyles? other, double t) {
    if (other == null) return this;
    TextStyle l(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return NzTextStyles(
      displayLg: l(displayLg, other.displayLg),
      titleLg: l(titleLg, other.titleLg),
      titleMd: l(titleMd, other.titleMd),
      titleSm: l(titleSm, other.titleSm),
      bodyLg: l(bodyLg, other.bodyLg),
      bodyMd: l(bodyMd, other.bodyMd),
      bodySm: l(bodySm, other.bodySm),
      labelLg: l(labelLg, other.labelLg),
      labelMd: l(labelMd, other.labelMd),
      caption: l(caption, other.caption),
      mono: l(mono, other.mono),
    );
  }

  /// Material widget'ları aynı rolleri görsün diye `TextTheme` doldurma eşlemesi.
  TextTheme toTextTheme() => TextTheme(
    displayLarge: displayLg,
    displayMedium: titleLg,
    displaySmall: titleMd,
    headlineLarge: titleLg,
    headlineMedium: titleMd,
    headlineSmall: titleSm,
    titleLarge: titleMd,
    titleMedium: titleSm,
    titleSmall: labelLg,
    bodyLarge: bodyLg,
    bodyMedium: bodyMd,
    bodySmall: bodySm,
    labelLarge: labelMd,
    labelMedium: caption,
    labelSmall: caption,
  );
}
