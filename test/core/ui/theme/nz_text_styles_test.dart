// NzTextStyles: tasarım stili eşlemesi, yerel yazı tipi dosyaları, copyWith ve tema geçişi.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/theme/nz_text_styles.dart';

/// google_fonts varlık adı: `Geist Mono` + w500 → `GeistMono-Medium.ttf`.
String _assetFile(String family, FontWeight w) {
  const names = {400: 'Regular', 500: 'Medium', 600: 'SemiBold', 700: 'Bold'};
  return 'assets/fonts/${family.replaceAll(' ', '')}-${names[w.value]}.ttf';
}

void main() {
  // Yazı tipleri gerçekten varlıktan yüklensin (binding yoksa google_fonts yükleyemez).
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final light = NzTextStyles.fromColors(NizamioColors.light);
  final dark = NzTextStyles.fromColors(NizamioColors.dark);

  // Rol → tasarım stili (nz_text_styles.dart belge yorumu ile aynı tablo).
  final roles = <String, (TextStyle, NizamioTypeSpec)>{
    'displayLg': (light.displayLg, NizamioTypography.greet),
    'titleLg': (light.titleLg, NizamioTypography.h1),
    'titleMd': (light.titleMd, NizamioTypography.h1Detail),
    'titleSm': (light.titleSm, NizamioTypography.sheetTitle),
    'bodyLg': (light.bodyLg, NizamioTypography.input),
    'bodyMd': (light.bodyMd, NizamioTypography.body),
    'bodySm': (light.bodySm, NizamioTypography.caption),
    'labelLg': (light.labelLg, NizamioTypography.cardTitle),
    'labelMd': (light.labelMd, NizamioTypography.tab),
    'caption': (light.caption, NizamioTypography.caption),
    'mono': (light.mono, NizamioTypography.code),
    'kicker': (light.kicker, NizamioTypography.kicker),
    'monoSm': (light.monoSm, NizamioTypography.monoSm),
    'numeral': (light.numeral, NizamioTypography.kpi),
  };

  test('roller tasarım stilinin boyut/ağırlık/satır yüksekliği/harf aralığını taşır', () {
    for (final MapEntry(key: name, value: (style, spec)) in roles.entries) {
      expect(style.fontSize, spec.size, reason: name);
      expect(style.fontWeight, spec.weight, reason: name);
      // CSS px satır yüksekliği → oran; render yüksekliği px ile aynı.
      expect(
        style.height! * style.fontSize!,
        closeTo(spec.lineHeight, 1e-9),
        reason: name,
      );
      expect(
        style.letterSpacing,
        closeTo(spec.letterSpacingEm * spec.size, 1e-9),
        reason: name,
      );
      expect(
        style.leadingDistribution,
        TextLeadingDistribution.even,
        reason: name,
      );
      expect(
        style.fontFamily,
        startsWith(spec.family.replaceAll(' ', '')),
        reason: name,
      );
    }
  });

  test('aileler: başlık Poppins, gövde Inter, kod/sayaç Geist Mono', () {
    expect(NizamioTypography.familyDisplay, 'Poppins');
    expect(NizamioTypography.familySans, 'Inter');
    expect(NizamioTypography.familyMono, 'Geist Mono');
    expect(light.titleLg.fontFamily, startsWith('Poppins'));
    expect(light.bodyMd.fontFamily, startsWith('Inter'));
    expect(light.mono.fontFamily, startsWith('GeistMono'));
    expect(
      light.bodyMd.fontFamilyFallback,
      NizamioTypography.familySansFallback,
    );
    expect(
      light.titleLg.fontFamilyFallback,
      NizamioTypography.familyDisplayFallback,
    );
    expect(light.mono.fontFamilyFallback, NizamioTypography.familyMonoFallback);
  });

  test('kod, sayaç ve rakam rolleri tabular rakam ister', () {
    for (final s in [light.mono, light.kicker, light.monoSm, light.numeral]) {
      expect(s.fontFeatures, contains(const FontFeature.tabularFigures()));
    }
    expect(light.bodyMd.fontFeatures, isNull);
  });

  test(
    'her rolün aile+ağırlık dosyası yerel varlıkta var; fazla dosya yok',
    () {
      // Tasarımın bütün stilleri (henüz role bağlanmamışlar dahil: m-list/m-tab 500).
      final needed = {
        for (final spec in NizamioTypography.styles.values)
          _assetFile(spec.family, spec.weight),
      };
      for (final f in needed) {
        expect(
          File(f).existsSync(),
          isTrue,
          reason: '$f eksik (sessiz yedek olur)',
        );
      }
      final shipped = Directory('assets/fonts')
          .listSync()
          .map((e) => e.path)
          .where((p) => p.endsWith('.ttf'))
          .toSet();
      expect(shipped, needed, reason: 'yalnız gerekli ağırlıklar dağıtılır');
      for (final family in ['Inter', 'Poppins', 'GeistMono']) {
        expect(File('assets/fonts/OFL-$family.txt').existsSync(), isTrue);
      }
    },
  );

  testWidgets('bütün roller ağ olmadan yerel varlıktan yüklenir', (
    tester,
  ) async {
    NzTextStyles.fromColors(NizamioColors.dark);
    Object? error;
    await tester.runAsync(() async {
      try {
        await GoogleFonts.pendingFonts();
      } on Object catch (e) {
        error = e;
      }
    });
    expect(error, isNull);
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
    expect(light.lerp(dark, 0.5).titleLg.fontSize, NizamioTypography.h1.size);
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
