import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/generated/tokens.gen.dart';

/// Anlamsal metin rolleri (ADR-0003, A1). Ekran ham `TextStyle` yazmaz; rol seçer ve gerekirse
/// `copyWith(color:/fontWeight:)` ile değiştirir. Aile/boyut/ağırlık/satır yüksekliği/harf aralığı
/// tasarım metin stillerinden (`NizamioTypography`, ADR-0003 karar 24); renk varsayılanı
/// `NizamioColors.text`.
///
/// Rol → tasarım stili: displayLg `m-greet` · titleLg `m-h1` · titleMd `m-h1-detail` ·
/// titleSm `m-sheet-title` · bodyLg `m-input` · bodyMd `m-body` · bodySm/caption `m-caption` ·
/// labelLg `m-card-title` · labelMd `m-tab` · mono `m-code` · kicker `m-kicker` ·
/// monoSm `m-mono-sm` · numeral `m-kpi`.
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
    required this.kicker,
    required this.monoSm,
    required this.numeral,
  });

  /// Yazı tipi dosyaları uygulamayla gelir (assets/fonts); `GoogleFonts` ağdan indirmez
  /// (bootstrap'te kapatılır). Aile adı token'dan `GoogleFonts.getFont`'a gider: bilinmeyen aile
  /// ya da eksik ağırlık dosyası sessiz yedeğe düşmez (test: nz_text_styles_test).
  factory NzTextStyles.fromColors(NizamioColors c) {
    const fallbacks = {
      NizamioTypography.familySans: NizamioTypography.familySansFallback,
      NizamioTypography.familyDisplay: NizamioTypography.familyDisplayFallback,
      NizamioTypography.familyMono: NizamioTypography.familyMonoFallback,
    };
    TextStyle role(NizamioTypeSpec t, {bool tabular = false}) =>
        GoogleFonts.getFont(
          t.family,
          fontSize: t.size,
          fontWeight: t.weight,
          // CSS satır yüksekliği px; Flutter oran ister. Boşluk CSS gibi üst/alta eşit dağılır.
          height: t.lineHeight / t.size,
          letterSpacing: t.letterSpacingEm * t.size,
          color: c.text,
        ).copyWith(
          fontFamilyFallback: fallbacks[t.family],
          leadingDistribution: TextLeadingDistribution.even,
          fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
        );

    return NzTextStyles(
      displayLg: role(NizamioTypography.greet),
      titleLg: role(NizamioTypography.h1),
      titleMd: role(NizamioTypography.h1Detail),
      titleSm: role(NizamioTypography.sheetTitle),
      bodyLg: role(NizamioTypography.input),
      bodyMd: role(NizamioTypography.body),
      bodySm: role(NizamioTypography.caption),
      labelLg: role(NizamioTypography.cardTitle),
      labelMd: role(NizamioTypography.tab),
      caption: role(NizamioTypography.caption),
      mono: role(NizamioTypography.code, tabular: true),
      kicker: role(NizamioTypography.kicker, tabular: true),
      monoSm: role(NizamioTypography.monoSm, tabular: true),
      // Poppins'te `tnum` yok; özellik zararsızdır ama rakamlar orantılı kalır (docs/design-tokens.md).
      numeral: role(NizamioTypography.kpi, tabular: true),
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

  /// Küçük harfli mono bölüm etiketi (`tüm görevler · 76`).
  final TextStyle kicker;

  /// Rozet sayısı, sayaç, flyout başlığı.
  final TextStyle monoSm;

  /// KPI büyük rakamı.
  final TextStyle numeral;

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
    TextStyle? kicker,
    TextStyle? monoSm,
    TextStyle? numeral,
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
      kicker: kicker ?? this.kicker,
      monoSm: monoSm ?? this.monoSm,
      numeral: numeral ?? this.numeral,
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
      kicker: l(kicker, other.kicker),
      monoSm: l(monoSm, other.monoSm),
      numeral: l(numeral, other.numeral),
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
