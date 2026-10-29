// NzTextStyles: tasarım stili eşlemesi, yerel yazı tipi kaydı (pubspec `fonts:`), ağırlık
// eşlemesi (gerçek dosya çizimi), copyWith ve tema geçişi.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/theme/nz_text_styles.dart';

import '../../../support/golden.dart';

/// `FontManifest.json` (pubspec `fonts:`): aile → ağırlık → varlık yolu.
Future<Map<String, Map<int, String>>> _manifest() async {
  final raw = json.decode(
    await rootBundle.loadString('FontManifest.json'),
  ) as List<dynamic>;
  return {
    for (final e in raw.cast<Map<String, dynamic>>())
      e['family'] as String: {
        for (final f in (e['fonts'] as List).cast<Map<String, dynamic>>())
          (f['weight'] as int? ?? 400): f['asset'] as String,
      },
  };
}

/// Tablet tasarımının Google Fonts CSS bağlantısındaki aile → ağırlık kümesi
/// (`family=Inter:wght@400;500;600;700&family=…`).
Map<String, Set<int>> _designWeights() {
  final html = File('docs/design/tablet/12-Tablet.dc.html').readAsStringSync();
  final href = RegExp(r'fonts\.googleapis\.com/css2\?([^"]+)')
      .firstMatch(html)!
      .group(1)!
      .replaceAll('&amp;', '&');
  return {
    for (final m in RegExp(r'family=([^:&]+):wght@([\d;]+)').allMatches(href))
      m.group(1)!.replaceAll('+', ' '): m
          .group(2)!
          .split(';')
          .map(int.parse)
          .toSet(),
  };
}

/// TrueType tablo dizini → tablo başlangıcı.
int _table(ByteData d, String tag) {
  final n = d.getUint16(4);
  for (var i = 0; i < n; i++) {
    final r = 12 + 16 * i;
    if (String.fromCharCodes(d.buffer.asUint8List(r, 4)) == tag) {
      return d.getUint32(r + 8);
    }
  }
  throw StateError('$tag tablosu yok');
}

/// Dosyanın kendi beyan ettiği ağırlık (`OS/2.usWeightClass`).
int _weightClass(ByteData d) => d.getUint16(_table(d, 'OS/2') + 4);

/// Ad tablosundaki tipografik (16) ya da aile (1) adı, Windows/Unicode kaydı.
String _familyName(ByteData d) {
  final t = _table(d, 'name');
  final count = d.getUint16(t + 2);
  final strings = t + d.getUint16(t + 4);
  final byId = <int, String>{};
  for (var i = 0; i < count; i++) {
    final r = t + 6 + 12 * i;
    if (d.getUint16(r) != 3 || d.getUint16(r + 2) != 1) continue;
    final len = d.getUint16(r + 8);
    final off = strings + d.getUint16(r + 10);
    byId[d.getUint16(r + 6)] = String.fromCharCodes([
      for (var j = 0; j < len; j += 2) d.getUint16(off + j),
    ]);
  }
  return byId[16] ?? byId[1]!;
}

const _sample = 'Görev Şubat İğdır 0123456789 · Kaydet';

/// Metni gerçek rasterle çizer; aynı piksel = aynı yazı tipi dosyası ve aynı sentez.
Future<Uint8List> _raster(TextStyle style) async {
  final p = TextPainter(
    text: TextSpan(text: _sample, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  final rec = ui.PictureRecorder();
  p.paint(Canvas(rec), Offset.zero);
  final img = await rec.endRecording().toImage(
    p.width.ceil() + 2,
    p.height.ceil() + 2,
  );
  final bytes = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
  img.dispose();
  return bytes!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
    'brand': (light.brand, NizamioTypography.brand),
    'program': (light.program, NizamioTypography.program),
    'navLabel': (light.navLabel, NizamioTypography.navLabel),
    'list': (light.list, NizamioTypography.list),
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
      // Mantıksal aile adı (ağırlığa göre adlandırılmış google_fonts ailesi değil).
      expect(style.fontFamily, spec.family, reason: name);
    }
  });

  test('aileler: başlık Poppins, gövde Inter, kod/sayaç Geist Mono', () {
    expect(NizamioTypography.familyDisplay, 'Poppins');
    expect(NizamioTypography.familySans, 'Inter');
    expect(NizamioTypography.familyMono, 'Geist Mono');
    expect(light.titleLg.fontFamily, 'Poppins');
    expect(light.bodyMd.fontFamily, 'Inter');
    expect(light.mono.fontFamily, 'Geist Mono');
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

  test('kayıt: ağırlıklar tasarım CSS\'i ile aynı; her token stili kayıtlı; '
      'dosya ad/ağırlık beyanı kayıtla uyumlu; fazla dosya yok', () async {
    final manifest = await _manifest();
    final fonts = {
      for (final MapEntry(:key, :value) in manifest.entries)
        if (key != 'MaterialIcons') key: value,
    };

    expect({
      for (final e in fonts.entries) e.key: e.value.keys.toSet(),
    }, _designWeights());

    // Bilinmeyen aile ya da eksik ağırlık sessiz yedeğe (sistem yazı tipi / yakın ağırlık)
    // düşer; token'daki her stil birebir kayıtlı olmalı.
    for (final MapEntry(key: name, value: spec)
        in NizamioTypography.styles.entries) {
      expect(
        fonts[spec.family]?.keys,
        contains(spec.weight.value),
        reason: '$name: ${spec.family} ${spec.weight.value} kayıtlı değil',
      );
    }

    for (final MapEntry(key: family, value: byWeight) in fonts.entries) {
      for (final MapEntry(key: weight, value: asset) in byWeight.entries) {
        final d = ByteData.sublistView(File(asset).readAsBytesSync());
        expect(_weightClass(d), weight, reason: asset);
        expect(_familyName(d), startsWith(family), reason: asset);
      }
      expect(
        File('assets/fonts/OFL-${family.replaceAll(' ', '')}.txt').existsSync(),
        isTrue,
      );
    }

    final shipped = Directory('assets/fonts')
        .listSync()
        .map((e) => e.path)
        .where((p) => p.endsWith('.ttf'))
        .toSet();
    expect(shipped, {
      for (final w in fonts.values) ...w.values,
    }, reason: 'yalnız kayıtlı ağırlıklar dağıtılır');
  });

  testWidgets(
    'copyWith(fontWeight:) gerçek ağırlık dosyasını çizer (piksel karşılaştırması)',
    (tester) async {
      await tester.runAsync(() async {
        await loadAppFonts();
        final manifest = await _manifest();
        // Referans: her dosya tek başına ayrı bir ailede.
        final probes = <String, String>{};
        for (final byWeight in manifest.values) {
          for (final asset in byWeight.values) {
            final probe = 'probe:$asset';
            await (FontLoader(probe)..addFont(rootBundle.load(asset))).load();
            probes[asset] = probe;
          }
        }

        final bases = {
          NizamioTypography.familySans: light.bodyMd,
          NizamioTypography.familyDisplay: light.titleLg,
          NizamioTypography.familyMono: light.mono,
        };
        final testFont = await _raster(
          light.bodyMd.copyWith(
            fontFamily: 'FlutterTest',
            fontFamilyFallback: [],
          ),
        );
        for (final MapEntry(key: family, value: base) in bases.entries) {
          final drawn = <Uint8List>[];
          for (final MapEntry(key: weight, value: asset)
              in manifest[family]!.entries) {
            final w = FontWeight.values.firstWhere((f) => f.value == weight);
            final actual = await _raster(base.copyWith(fontWeight: w));
            final expected = await _raster(
              base.copyWith(
                fontFamily: probes[asset],
                fontFamilyFallback: [],
                fontWeight: w,
              ),
            );
            expect(actual, expected, reason: '$family $weight → $asset');
            drawn.add(actual);
          }
          // Ağırlıklar birbirinden ve test yazı tipinden (yüklenmemiş aile) ayrışır.
          for (var i = 0; i < drawn.length; i++) {
            expect(drawn[i], isNot(testFont), reason: family);
            for (var j = i + 1; j < drawn.length; j++) {
              expect(drawn[i], isNot(drawn[j]), reason: '$family $i/$j');
            }
          }
        }

        // Kayıtsız ağırlık en yakın gerçek dosyaya düşer (CSS eşlemesi: >500 → önce ağır,
        // yoksa hafif). Geist Mono 600 tasarım CSS'inde yok → Medium (sentetik kalın yok).
        expect(
          await _raster(light.monoSm.copyWith(fontWeight: FontWeight.w600)),
          await _raster(
            light.monoSm.copyWith(
              fontFamily: probes['assets/fonts/GeistMono-Medium.ttf'],
              fontFamilyFallback: [],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      });
    },
  );

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
