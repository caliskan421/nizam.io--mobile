// CoordinatorshipPage: kimlik + eylemler, sekmeler (Genel / Birimler / Ekip / Hakkında), gezinme
// hedefleri, tostlar, diğer işlemler alt sayfası, kısayol menüsü (diğer koordinatörlükler),
// bilinmeyen kod, taşma matrisi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/presentation/coordinatorship_page.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  String code = 'ALT',
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-1');
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    CoordinatorshipPage(code: code),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return (h, nav);
}

/// Sayfanın kendi kaydırmasıyla [f]'yi dokunulabilir yapar (`ensureVisible` dıştaki
/// `NzPage.fill` görünümünü de kaydırdığından kullanılmaz); yapışkan sekmelerin altında
/// kalan öğe için yukarı, ekran altındaki için aşağı sürükler.
Future<void> _reveal(WidgetTester tester, Finder f) async {
  for (var i = 0; i < 40; i++) {
    if (f.hitTestable().evaluate().isNotEmpty) return;
    final vp = tester.getRect(_pageScroll);
    final above =
        f.evaluate().isNotEmpty && tester.getCenter(f).dy < vp.top + 140;
    await tester.drag(_pageScroll, Offset(0, above ? 120 : -120));
    await tester.pump();
  }
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  final inPage = find
      .descendant(of: _pageScroll, matching: f)
      .evaluate()
      .isNotEmpty;
  if (inPage) {
    await _reveal(tester, f);
  } else {
    // Kısayol menüsü gibi katmanlar kendi kaydırmasında.
    await tester.ensureVisible(f);
    await tester.pump();
  }
  await tester.tap(f);
  await settle(tester);
}

/// Tostu kaldırır (alttaki satırların üstünü örtmesin).
Future<void> _dismissToast(WidgetTester tester) async {
  ScaffoldMessenger.of(tester.element(find.byType(CoordinatorshipPage)))
      .removeCurrentSnackBar();
  await settle(tester);
}

/// Sayfanın kendi dikey kaydırması (dıştaki `NzPage.fill` kaydırmaz).
final _pageScroll = find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    )
    .at(1);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('sekmeler: Birimler, Ekip (açılır üyeler), Hakkında', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.text(_l.uiCoordTabUnits));
    expect(find.text(_l.uiCoordUnits), findsOneWidget);
    expect(find.text('Depolama ve hidrofor'), findsOneWidget);
    expect(find.text('1/5'), findsOneWidget);
    await _tap(tester, find.text('Arıtma tesisi'));
    expect(
      find.text('Arıtma tesisi ${_l.uiCoordToastUnitTail}'),
      findsOneWidget,
    );
    await _dismissToast(tester);

    await _tap(tester, find.text(_l.uiCoordTabTeam));
    expect(find.text('ekip · 9'), findsOneWidget);
    expect(find.text('Abdullah Ateş'), findsOneWidget);
    expect(find.text(_l.uiCoordRoleLead), findsNWidgets(2));
    expect(find.text('7 üye daha'), findsOneWidget);
    await _tap(tester, find.text('7 üye daha'));
    expect(find.text(_l.uiCoordCollapse), findsOneWidget);
    expect(find.text('Kadir Özbek'), findsOneWidget);
    await _tap(tester, find.text(_l.uiCoordCollapse));
    expect(find.text('7 üye daha'), findsOneWidget);
    await _tap(tester, find.text(_l.uiCoordAddMember));
    expect(find.text(_l.uiHomeQaInviteLong), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await settle(tester);

    await _tap(tester, find.text(_l.uiCoordTabAbout));
    expect(find.textContaining('Havalimanı yerleşkesinin'), findsOneWidget);
    expect(find.text('10.06.2026'), findsOneWidget);
    expect(find.text(_l.uiCoordFeed), findsOneWidget);
    expect(find.text('19.10'), findsOneWidget);
  });

  testWidgets('bilinmeyen kod: boş durum', (tester) async {
    await _open(tester, code: 'YOK');
    expect(find.text(_l.uiCoordNotFound), findsOneWidget);
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
            Future<void> scroll() async {
              final s = _pageScroll;
              for (var i = 0; i < 8; i++) {
                await tester.drag(s, const Offset(0, -300));
                await tester.pump();
              }
              for (var i = 0; i < 8; i++) {
                await tester.drag(s, const Offset(0, 300));
                await tester.pump();
              }
            }

            await scroll();
            for (final tab in [
              _l.uiCoordTabUnits,
              _l.uiCoordTabTeam,
              _l.uiCoordTabAbout,
            ]) {
              await _tap(tester, find.text(tab).first);
              if (tab == _l.uiCoordTabTeam) {
                await _tap(tester, find.text('7 üye daha'));
              }
              await scroll();
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
