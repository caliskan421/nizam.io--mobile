// CoordinatorshipsPage (sunucu verisiyle): özet satırı ve kartlar departmanlardan, ekiplerden
// ve görevlerden; kart → ayrıntı (departman kimliğiyle); taşma matrisi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/presentation/coordinatorships_page.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(CoordBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram(coordProgram);
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

  testWidgets('özet satırı ve kartlar sunucu verisinden; kart ayrıntıyı açar', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    expect(find.text(_l.uiCoordTitle), findsOneWidget);
    expect(
      find.text('4 koordinatörlük · 9 görev · 2 koordinatörlükte gecikme'),
      findsOneWidget,
    );
    expect(_cardOrder(tester), [dAlt, dEgi, dEle, dIda]);
    expect(find.text('2/4 bitti'), findsOneWidget);
    expect(find.text('2 gecikmede'), findsOneWidget);
    expect(find.text('Abdullah Ateş, Ali Avcı'), findsOneWidget);
    expect(find.text('Koordinatör yok · Bahar Kılıç (üye)'), findsOneWidget);
    await tester.tap(find.text('Altyapı ve tesisat'));
    await settle(tester);
    expect(nav.calls, ['coord:$dAlt']);
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
            expect(find.byType(CoordinatorshipCard), findsWidgets);
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
