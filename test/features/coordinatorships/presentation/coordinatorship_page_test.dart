// CoordinatorshipPage (sunucu verisiyle): bilinmeyen kimlik boş durum; taşma matrisi bütün
// segmentli bölümleri (Genel / Görevler / Üyeler / Arşiv / Toplantı) açarak gezer.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/features/coordinatorships/presentation/coord_archive_meetings_tabs.dart';
import 'package:nizamio/features/coordinatorships/presentation/coord_general_tab.dart';
import 'package:nizamio/features/coordinatorships/presentation/coord_people_sheet.dart';
import 'package:nizamio/features/coordinatorships/presentation/coord_tasks_tab.dart';
import 'package:nizamio/features/coordinatorships/presentation/coordinatorship_page.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

final _l = AppLocalizationsTr();

Future<(Harness, CoordBackend)> _open(
  WidgetTester tester, {
  String code = dAlt,
  bool dark = false,
}) async {
  final backend = CoordBackend();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    CoordinatorshipPage(code: code),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return (h, backend);
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

/// Sayfanın dikey kaydırması.
final _pageScroll = find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    )
    .first;

/// Bölüm hapı (pinli sekme şeridi; Genel'deki özet kartlarında aynı ad geçer).
Finder _tab(String label) =>
    find.descendant(of: find.byType(NzPillTabs), matching: find.text(label));

List<(String, Type)> get _tabs => [
  (_l.uiCoordTabTasks, CoordTasksTab),
  (_l.uiCoordTabMembers, CoordMembersTab),
  (_l.uiCoordTabArchive, CoordArchiveTab),
  (_l.uiCoordTabMeetings, CoordMeetingsTab),
  (_l.uiCoordTabGeneral, CoordGeneralTab),
];

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // Kısa kod ('ALT') sunucu kimliği (`department_id`) değildir.
  for (final code in ['ALT', 'YOK']) {
    testWidgets('bilinmeyen kimlik ($code): boş durum', (tester) async {
      await _open(tester, code: code);
      expect(find.text(_l.uiCoordNotFound), findsOneWidget);
      expect(find.byType(NzPillTabs), findsNothing);
    });
  }

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
            final (_, backend) = await _open(tester, dark: dark);
            // Sunucu kaydı açıldı: kısa kod üst çubukta, Genel bölümü çizili.
            expect(find.text('ALT'), findsWidgets);
            expect(find.byType(CoordGeneralTab), findsOneWidget);
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
            for (final (label, type) in _tabs) {
              await _tap(tester, _tab(label));
              expect(find.byType(type), findsOneWidget, reason: label);
              await scroll();
            }
            expect(tester.takeException(), isNull);
            expect(backend.unhandled, isEmpty);
          },
        );
      }
    }
  }
}
