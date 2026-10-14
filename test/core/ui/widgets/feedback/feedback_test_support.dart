// Feedback kiti testlerinin ortak düzeneği (yalnız test): açık/koyu × compact/expanded ×
// metin 1.0/2.0 matrisini tek tabakta (golden dosyası bileşen başına bir tane) çizer; piksel
// okuma yardımcıları etiketsiz piksel/boyut kanıtı içindir.
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';

const sheetKey = ValueKey('feedback-sheet');
const sheetWidth = 1024.0;
const compactWidth = 360.0;

/// Matris hücresi: tema × genişlik (compact 360 / expanded 1024) × metin ölçeği.
class SheetCell {
  const SheetCell(this.dark, this.width, this.scale);

  final bool dark;
  final double width;
  final double scale;
}

final matrixCells = <SheetCell>[
  for (final dark in [false, true])
    for (final width in [compactWidth, sheetWidth])
      for (final scale in [1.0, 2.0]) SheetCell(dark, width, scale),
];

void setUpFonts() =>
    setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

// Tema yazı tipi ayarından sonra (setUpFonts) ilk kullanımda kurulur.
ThemeData? _lightCache;
ThemeData? _darkCache;
ThemeData theme(bool dark) => dark
    ? (_darkCache ??= AppTheme.dark())
    : (_lightCache ??= AppTheme.light());

const testLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

Widget _app(Widget home, {ThemeData? themeData}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: themeData ?? theme(false),
  locale: const Locale('tr'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: testLocalizationDelegates,
  home: home,
);

/// Davranış testleri için: tek bileşen, Scaffold içinde.
Widget testApp(Widget child, {bool dark = false}) =>
    _app(Scaffold(body: child), themeData: theme(dark));

/// Matris tabakası: her hücrede [variants] o hücrenin tema/genişlik/ölçeğiyle kurulur.
Widget sheet(WidgetBuilder variants) => _app(
  SingleChildScrollView(
    child: Align(
      alignment: Alignment.topLeft,
      child: RepaintBoundary(
        key: sheetKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final cell in matrixCells)
              Builder(
                builder: (context) {
                  final base = MediaQueryData.fromView(View.of(context));
                  return MediaQuery(
                    data: base.copyWith(
                      size: Size(cell.width, base.size.height),
                      textScaler: TextScaler.linear(cell.scale),
                    ),
                    child: Theme(
                      data: theme(cell.dark),
                      child: Builder(
                        builder: (context) => Material(
                          color: context.colors.background,
                          child: SizedBox(
                            width: sheetWidth,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: cell.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    NizamioSpacing.space4,
                                  ),
                                  child: variants(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    ),
  ),
);

/// Geniş yüzey (dpr 1) ve "hareketi azalt" (iskelet durağan); test sonunda sıfırlanır.
void useSheetSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(sheetWidth, 2400);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

/// Tabakayı kurar; animasyonlar sabit süre sonrası kareye oturur (pumpAndSettle yok).
Future<void> pumpSheet(WidgetTester tester, WidgetBuilder variants) async {
  useSheetSurface(tester);
  await tester.pumpWidget(sheet(variants));
  await tester.pump(const Duration(milliseconds: 500));
}

/// Çizilmiş tabakanın ham RGBA pikselleri.
class Pixels {
  Pixels(this.width, this.height, this._bytes);

  final int width;
  final int height;
  final ByteData _bytes;

  List<int> at(int x, int y) {
    final o = (y * width + x) * 4;
    return [for (var i = 0; i < 4; i++) _bytes.getUint8(o + i)];
  }

  bool contains(Color c) {
    final want = rgba(c);
    for (var i = 0; i < width * height; i++) {
      if (_bytes.getUint8(i * 4) == want[0] &&
          _bytes.getUint8(i * 4 + 1) == want[1] &&
          _bytes.getUint8(i * 4 + 2) == want[2] &&
          _bytes.getUint8(i * 4 + 3) == want[3]) {
        return true;
      }
    }
    return false;
  }
}

List<int> rgba(Color c) => [
  (c.r * 255).round(),
  (c.g * 255).round(),
  (c.b * 255).round(),
  (c.a * 255).round(),
];

/// [sheetKey] sınırını görüntüye çevirir; boyut yerleşimle birebir doğrulanır.
Future<Pixels> capture(WidgetTester tester) async {
  final size = tester.getSize(find.byKey(sheetKey));
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(sheetKey),
  );
  final bytes = (await tester.runAsync(() async {
    final image = await boundary.toImage();
    expect(
      (image.width, image.height),
      (size.width.round(), size.height.round()),
    );
    return image.toByteData(format: ui.ImageByteFormat.rawRgba);
  }))!;
  return Pixels(size.width.round(), size.height.round(), bytes);
}

/// Tabaka kanıtı: genişlik 1024, ilk hücre açık zemin, son hücre koyu zemin, hiç saydam piksel yok
/// (köşeler), [expected] renkleri tabakada bulunur.
Future<void> expectSheetPixels(
  WidgetTester tester,
  List<Color> expected,
) async {
  final px = await capture(tester);
  expect(px.width, sheetWidth.toInt());
  expect(px.height, greaterThan(100));
  expect(px.at(0, 0), rgba(NizamioColors.light.background));
  expect(
    px.at(px.width - 1, px.height - 1),
    rgba(NizamioColors.dark.background),
  );
  for (final c in expected) {
    expect(px.contains(c), isTrue, reason: 'renk bulunamadı: $c');
  }
  expect(tester.takeException(), isNull);
}

/// Çıplak boşluk bileşeni (testlerde hücre içi ayırıcı).
const cellGap = Gap(NizamioSpacing.space2);
