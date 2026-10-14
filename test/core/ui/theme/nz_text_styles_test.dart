// NzTextStyles: token değerleri, copyWith ve tema geçişi için lerp.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/theme/nz_text_styles.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final light = NzTextStyles.fromColors(NizamioColors.light);
  final dark = NzTextStyles.fromColors(NizamioColors.dark);

  test('roller token boyut/ağırlık/satır yüksekliğini taşır', () {
    expect(light.displayLg.fontSize, NizamioTypography.size3xl);
    expect(light.displayLg.fontWeight, NizamioTypography.weightBold);
    expect(light.titleLg.fontSize, NizamioTypography.size2xl);
    expect(light.titleMd.fontSize, NizamioTypography.sizeXl);
    expect(light.titleSm.fontSize, NizamioTypography.sizeLg);
    expect(light.bodyLg.fontSize, NizamioTypography.sizeMd);
    expect(light.bodyMd.fontSize, NizamioTypography.sizeSm);
    expect(light.bodySm.fontSize, NizamioTypography.sizeXs);
    expect(light.labelLg.fontWeight, NizamioTypography.weightMedium);
    expect(light.labelMd.fontSize, NizamioTypography.sizeSm);
    expect(light.caption.fontSize, NizamioTypography.sizeXs);
    expect(light.bodyMd.height, NizamioTypography.lineHeightNormal);
    expect(light.titleMd.height, NizamioTypography.lineHeightTight);
    expect(
      light.bodyMd.fontFamilyFallback,
      NizamioTypography.familySansFallback,
    );
    expect(light.mono.fontFamilyFallback, NizamioTypography.familyMonoFallback);
    expect(light.mono.fontFamily, contains('JetBrainsMono'));
    expect(light.bodyMd.fontFamily, contains('Inter'));
  });

  test('renk varsayılanı moddaki text rengidir', () {
    for (final s in [
      light.displayLg,
      light.bodyMd,
      light.caption,
      light.mono,
    ]) {
      expect(s.color, NizamioColors.light.text);
    }
    expect(dark.bodyMd.color, NizamioColors.dark.text);
  });

  test('copyWith yalnız verilen rolü değiştirir', () {
    final custom = light.bodyMd.copyWith(color: NizamioColors.light.danger);
    final c = light.copyWith(bodyMd: custom);
    expect(c.bodyMd, custom);
    expect(c.bodyLg, light.bodyLg);
    expect(c.mono, light.mono);
    expect(light.copyWith().titleSm, light.titleSm);
  });

  test('lerp uçlarda kaynak/hedef, ortada renk karışımı verir', () {
    expect(light.lerp(dark, 0).bodyMd.color, NizamioColors.light.text);
    expect(light.lerp(dark, 1).bodyMd.color, NizamioColors.dark.text);
    expect(
      light.lerp(dark, 0.5).bodyMd.color,
      Color.lerp(NizamioColors.light.text, NizamioColors.dark.text, 0.5),
    );
    expect(light.lerp(dark, 0.5).titleLg.fontSize, NizamioTypography.size2xl);
    expect(light.lerp(null, 0.5), same(light));
  });

  testWidgets('ThemeData geçişinde uzantı lerp edilir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [light]),
        darkTheme: ThemeData(extensions: [dark]),
        themeMode: ThemeMode.light,
        home: Builder(
          builder: (c) =>
              Text('x', style: Theme.of(c).extension<NzTextStyles>()!.bodyMd),
        ),
      ),
    );
    final lerped = ThemeData.lerp(
      ThemeData(extensions: [light]),
      ThemeData(extensions: [dark]),
      0.5,
    ).extension<NzTextStyles>()!;
    expect(
      lerped.bodyMd.color,
      Color.lerp(NizamioColors.light.text, NizamioColors.dark.text, 0.5),
    );
  });
}
