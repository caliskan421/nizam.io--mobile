// CoordinatorshipPage: kimlik + eylemler, sekmeler (Genel / Birimler / Ekip / Hakkında), gezinme
// hedefleri, tostlar, diğer işlemler alt sayfası, kısayol menüsü (diğer koordinatörlükler),
// bilinmeyen kod, taşma matrisi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
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
  final h = await real(tester, () => pilotHarness(PilotBackend()));
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

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

/// Tostu kaldırır (alttaki satırların üstünü örtmesin).
Future<void> _dismissToast(WidgetTester tester) async {
  ScaffoldMessenger.of(tester.element(find.byType(CoordinatorshipPage)))
      .removeCurrentSnackBar();
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Genel: kimlik, özet, dikkat gerektirenler, kısayollar', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    expect(find.text('ALT'), findsOneWidget);
    expect(find.text('Altyapı ve tesisat'), findsOneWidget);
    expect(
      find.textContaining('Teknik altyapı · 3 alt birim · 9 kişi · '),
      findsOneWidget,
    );
    expect(find.text('%69'), findsOneWidget);
    expect(find.text(_l.uiCoordKpiOpen), findsOneWidget);
    expect(
      find.text('13 görevden 9 tamamlandı · sezon ortalaması %51'),
      findsOneWidget,
    );
    expect(find.text(_l.uiCoordAttention), findsOneWidget);
    expect(find.text('98 gün gecikti'), findsOneWidget);
    expect(find.text('ALT-5 · Kerem Özdal'), findsOneWidget);

    await _tap(tester, find.text(_l.uiCoordMessageTeam));
    await _tap(tester, find.text('Su deposu temel betonunun yapılması'));
    await _tap(tester, find.text(_l.uiCoordAllTasks));
    await _tap(tester, find.text(_l.uiCoordKpiLate));
    await _tap(tester, find.text(_l.uiCoordLinkTimeline));
    await _tap(tester, find.text(_l.uiCoordLinkArchive));
    expect(nav.calls, [
      'chat:hid',
      'task:ALT-5',
      'tasks',
      'tasks',
      'timeline:ALT',
      'folder:ALT',
    ]);
    await _tap(tester, find.text(_l.uiCoordLinkMeetings));
    expect(
      find.text('Altyapı ve tesisat ${_l.uiCoordToastMeetingsTail}'),
      findsOneWidget,
    );
    expect(find.text('15 dosya'), findsOneWidget);
    expect(find.text('2 planlı'), findsOneWidget);
  });

  testWidgets('Görev ata görevler feature alt sayfasını açar', (tester) async {
    await _open(tester);
    await _tap(tester, find.text(_l.uiCoordAssignTask));
    expect(find.text(_l.uiHomeQaTaskLong), findsOneWidget);
  });

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
    expect(find.text('Deniz Aydemir'), findsOneWidget);
    expect(find.text(_l.uiCoordRoleLead), findsNWidgets(2));
    expect(find.text('7 üye daha'), findsOneWidget);
    await _tap(tester, find.text('7 üye daha'));
    expect(find.text(_l.uiCoordCollapse), findsOneWidget);
    expect(find.text('Kerem Özdal'), findsOneWidget);
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

  testWidgets('koordinatörsüz: "Koordinatör atanmamış" satırı ve tost', (
    tester,
  ) async {
    await _open(tester, code: 'İDA');
    await _tap(tester, find.text(_l.uiCoordTabTeam));
    expect(find.text(_l.uiCoordUnassigned), findsOneWidget);
    await _tap(tester, find.text(_l.uiCoordUnassigned));
    expect(
      find.text('İdari işler ${_l.uiCoordToastPickLeadTail}'),
      findsOneWidget,
    );
  });

  testWidgets('diğer işlemler alt sayfası: pasifleştir tostu', (tester) async {
    await _open(tester);
    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    expect(find.text('Altyapı ve tesisat işlemleri'), findsOneWidget);
    expect(find.text(_l.uiCoordMenuMerge), findsOneWidget);
    await _tap(tester, find.text(_l.uiCoordMenuDeactivate));
    expect(
      find.text('Altyapı ve tesisat ${_l.uiCoordToastDeactivatedTail}'),
      findsOneWidget,
    );
  });

  testWidgets('kısayol menüsü: diğer koordinatörlükler ve tüm liste', (
    tester,
  ) async {
    final (h, nav) = await _open(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(CoordinatorshipPage.shellTab);
    await settle(tester);
    expect(find.text('ALT · 9/13 bitti · 3 gecikmede'), findsOneWidget);
    await tester.tap(find.text('Mekanik sistemler'));
    await settle(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(CoordinatorshipPage.shellTab);
    await settle(tester);
    await _tap(tester, find.text(_l.uiCoordFlyAllList));
    expect(nav.calls, ['coord:MEK', 'coordinatorships']);
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
              final s = find.byType(Scrollable).first;
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
