// CoordinatorshipsPage: başlık + özet satırı, 11 kart (katalogdan), kart → ayrıntı; kabukta
// yeniden dokunma kısayol menüsü (zaman çizelgesi, ekle tostu, sıralama); taşma matrisi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/features/coordinatorships/presentation/coordinatorships_page.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-2');
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    const CoordinatorshipsPage(),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return (h, nav);
}

List<String> _cardOrder(WidgetTester tester) => tester
    .widgetList<CoordinatorshipCard>(find.byType(CoordinatorshipCard))
    .map((c) => c.stats.code)
    .toList();

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('başlık, özet satırı, kart içeriği; kart ayrıntıyı açar', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    expect(find.text(_l.uiCoordTitle), findsOneWidget);
    expect(
      find.text('11 koordinatörlük · 76 görev · 7 koordinatörlükte gecikme'),
      findsOneWidget,
    );
    expect(find.text('Altyapı ve tesisat'), findsOneWidget);
    expect(find.text('9/13 bitti'), findsOneWidget);
    expect(find.text('3 gecikmede'), findsWidgets);
    expect(
      find.text('Abdullah Ateş, Ali Avcı · Kadir Özbek (üye)'),
      findsOneWidget,
    );
    expect(find.text('Koordinatör yok · Bahar Kılıç (üye)'), findsOneWidget);
    expect(_cardOrder(tester).take(3), ['ALT', 'EĞİ', 'ELE']);
    await tester.tap(find.text('Altyapı ve tesisat'));
    await settle(tester);
    expect(nav.calls, ['coord:ALT']);
  });

  testWidgets('kısayol menüsü: sıralama, zaman çizelgesi, ekleme tostu', (
    tester,
  ) async {
    final (h, nav) = await _open(tester);
    void fire(int tab) =>
        h.read(shellReselectEventsProvider.notifier).fire(tab);

    // Başka sekmenin olayı menü açmaz.
    fire(0);
    await settle(tester);
    expect(find.text(_l.uiCoordFlyTimelineAll), findsNothing);

    fire(CoordinatorshipsPage.shellTab);
    await settle(tester);
    expect(find.text(_l.uiCoordFlyTimelineAll), findsOneWidget);
    expect(find.text(_l.uiCoordSortProgress), findsOneWidget);
    await tester.tap(find.text(_l.uiCoordSortLate));
    await settle(tester);
    expect(_cardOrder(tester).take(3), ['İDA', 'ALT', 'ULA']);

    fire(CoordinatorshipsPage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiCoordSortProgress));
    await settle(tester);
    expect(_cardOrder(tester).first, 'MEK');

    fire(CoordinatorshipsPage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiCoordFlyAdd));
    await settle(tester);
    expect(find.text(_l.uiCoordToastAddForm), findsOneWidget);

    fire(CoordinatorshipsPage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiCoordFlyTimelineAll));
    await settle(tester);
    // Prototip: bütün koordinatörlükler seçili açılır.
    expect(nav.calls, ['timeline:*']);
  });

  for (final width in [360.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      for (final dark in [false, true]) {
        testWidgets(
          'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
          (tester) async {
            tester.view.devicePixelRatio = 1;
            tester.view.physicalSize = Size(width, 844);
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(tester.view.reset);
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            await _open(tester, dark: dark);
            final scrollable = find.byType(Scrollable).first;
            for (var i = 0; i < 12; i++) {
              await tester.drag(scrollable, const Offset(0, -300));
              await tester.pump();
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
