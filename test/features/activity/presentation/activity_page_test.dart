// ActivityPage: başlık + CSV tostu, açıklama, tür rayı (sayılar), gün grupları, daha fazla
// göster, arama, çipler, filtre alt sayfası, görev hedefli kayıt → görev, kabuk kısayol menüsü
// (yalnız sekme 0), taşma matrisi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_checkbox.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_filter_rail.dart';
import 'package:nizamio/features/activity/presentation/activity_page.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

/// [tall]: liste tembel kurulduğundan (yalnız görünen satırlar) içerik denetimi yapan testler
/// bütün kayıtları tek ekrana sığdıran uzun bir yüzeyde açar.
Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  bool dark = false,
  bool tall = false,
}) async {
  if (tall) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 4200);
    addTearDown(tester.view.reset);
  }
  final h = await real(tester, () => pilotHarness(PilotBackend()));
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const ActivityPage(), nav: nav, dark: dark);
  await settle(tester);
  return (h, nav);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

Future<void> _dismissToast(WidgetTester tester) async {
  ScaffoldMessenger.of(tester.element(find.byType(ActivityPage)))
      .removeCurrentSnackBar();
  await settle(tester);
}

Finder _rail(String label) =>
    find.descendant(of: find.byType(NzFilterRail), matching: find.text(label));

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('bölümler: başlık, açıklama, tür rayı, gün başlığı, sayaç', (
    tester,
  ) async {
    await _open(tester, tall: true);
    expect(find.text(_l.uiActivityTitle), findsOneWidget);
    expect(find.text(_l.uiActivityIntro), findsOneWidget);
    expect(find.text(_l.uiActivityTypeAll), findsOneWidget);
    expect(find.text('38'), findsOneWidget);
    expect(find.text('bugün · 21 ekim 2026'), findsOneWidget);
    expect(find.text('Gündem maddesini işaretledi'), findsWidgets);
    expect(find.text('14:27'), findsOneWidget);
    await _tap(tester, find.byIcon(Icons.download_rounded));
    expect(
      find.text('${_l.uiActivityCsvExport} ${_l.uiActivitySoonTail}'),
      findsOneWidget,
    );
    await _dismissToast(tester);
    await _tap(tester, find.text(_l.uiActivityMore));
    expect(find.text('38 / 38 ${_l.uiActivityShownTail}'), findsOneWidget);
    expect(find.text('18 ekim 2026 pazar'), findsOneWidget);
    expect(find.text(_l.uiActivityMore), findsNothing);
  });

  testWidgets('tür süzgeci çip gösterir; çip ve tümünü temizle kaldırır', (
    tester,
  ) async {
    await _open(tester, tall: true);
    await _tap(tester, _rail(_l.uiActivityTypeFile));
    final chip = '${_l.uiActivityChipType} ${_l.uiActivityTypeFile}';
    expect(find.text(chip), findsOneWidget);
    expect(find.text('Dosya yükledi'), findsOneWidget);
    expect(find.text('Oturum açtı'), findsNothing);
    await _tap(tester, find.text(chip));
    expect(find.text(chip), findsNothing);
    expect(find.text('Oturum açtı'), findsWidgets);

    await _tap(tester, _rail(_l.uiActivityTypeMessage));
    await _tap(tester, find.text(_l.uiActivityClearAll));
    expect(find.textContaining(_l.uiActivityChipType), findsNothing);
  });

  testWidgets('arama süzer; eşleşme yoksa boş durum ve temizle', (
    tester,
  ) async {
    await _open(tester);
    await tester.enterText(find.byType(TextField), 'tedaş');
    await settle(tester);
    expect(find.textContaining('TEDAŞ'), findsWidgets);
    expect(find.text('Oturum açtı'), findsNothing);
    await tester.enterText(find.byType(TextField), 'zzzz');
    await settle(tester);
    expect(find.text(_l.uiActivityEmpty), findsOneWidget);
    expect(find.text('0 / 0 ${_l.uiActivityShownTail}'), findsOneWidget);
  });

  testWidgets('filtre alt sayfası: kişi ve koordinatörlük; nokta ve çipler', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.byIcon(Icons.tune_rounded));
    expect(find.text(_l.uiActivityByRole), findsOneWidget);
    expect(find.byType(NzCheckbox), findsNWidgets(10));
    expect(find.text('${_l.uiActivityRoleAdmin} · 4'), findsOneWidget);
    Finder box(String label) => find.descendant(
      of: find.byType(NzCheckbox),
      matching: find.text(label),
    );
    await _tap(tester, box('Kerem Özdal'));
    expect(find.text('4 ${_l.uiActivityApplyTail}'), findsOneWidget);
    await _tap(tester, box('Kerem Özdal'));
    await _tap(tester, box('Eğitim ve Arge'));
    final apply = find.textContaining(_l.uiActivityApplyTail);
    await _tap(tester, apply);
    expect(find.text(_l.uiActivityByRole), findsNothing);
    // Çip: koordinatörlük adı; yalnız EĞİ kişileri.
    expect(find.text('Eğitim ve Arge'), findsOneWidget);
    expect(find.text('Oturum açtı'), findsWidgets);
    expect(find.textContaining('Kerem Özdal'), findsNothing);
    await _tap(tester, find.text('Eğitim ve Arge'));
    expect(find.textContaining('Kerem Özdal'), findsWidgets);
  });

  testWidgets('alt sayfa: "Temizle" başlık satırında; kişi satırında avatar', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.byIcon(Icons.tune_rounded));
    expect(find.text('KÖ'), findsOneWidget);
    final title = tester.getRect(find.text(_l.uiActivityFilters));
    final clear = tester.getRect(find.text(_l.uiActivityClear));
    expect((clear.center.dy - title.center.dy).abs(), lessThan(8));
    await _tap(
      tester,
      find.descendant(
        of: find.byType(NzCheckbox),
        matching: find.text('Kerem Özdal'),
      ),
    );
    expect(find.text('4 ${_l.uiActivityApplyTail}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiActivityClear));
    expect(find.text('38 ${_l.uiActivityApplyTail}'), findsOneWidget);
  });

  testWidgets('kayıt satırları tembel kurulur (yalnız görünen bölge)', (
    tester,
  ) async {
    await _open(tester);
    final rows = find.byWidgetPredicate(
      (w) => w.runtimeType.toString() == '_EntryRow',
    );
    // 30 kayıt gösterilir; ilk karede yalnız ekrana (+ önbellek bölgesine) düşenler kurulur.
    expect(rows.evaluate().length, inExclusiveRange(1, 30));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
    await tester.pump();
    expect(find.text('30 / 38 ${_l.uiActivityShownTail}'), findsOneWidget);
  });

  testWidgets('geri dönüşte süzgeç korunur (prototip: alt durum kalıcı)', (
    tester,
  ) async {
    final h = await real(tester, () => pilotHarness(PilotBackend()));
    await pumpScreen(tester, h, const ActivityPage());
    await settle(tester);
    await _tap(tester, _rail(_l.uiActivityTypeFile));
    await pumpScreen(tester, h, const SizedBox.shrink());
    await settle(tester);
    await pumpScreen(tester, h, const ActivityPage());
    await settle(tester);
    expect(
      find.text('${_l.uiActivityChipType} ${_l.uiActivityTypeFile}'),
      findsOneWidget,
    );
  });

  testWidgets('görev hedefli kayıt görevi açar', (tester) async {
    final (_, nav) = await _open(tester, tall: true);
    await _tap(tester, find.text('Toplantı notundan oluşturuldu'));
    expect(nav.calls, ['task:ALT-16']);
  });

  testWidgets(
    'kısayol menüsü: tür, filtre, ana sayfaya dön; başka sekme açmaz',
    (tester) async {
      final (h, _) = await _open(tester);
      void fire(int tab) =>
          h.read(shellReselectEventsProvider.notifier).fire(tab);
      fire(1);
      await settle(tester);
      expect(find.text(_l.uiActivitySectionType), findsNothing);
      fire(ActivityPage.shellTab);
      await settle(tester);
      expect(find.text(_l.uiActivitySectionType), findsOneWidget);
      expect(find.text(_l.uiActivityFlyHome), findsOneWidget);
      await _tap(tester, find.text(_l.uiActivityTypeMeeting).last);
      expect(
        find.text('${_l.uiActivityChipType} ${_l.uiActivityTypeMeeting}'),
        findsOneWidget,
      );
      fire(ActivityPage.shellTab);
      await settle(tester);
      await _tap(tester, find.text(_l.uiActivityFlyFilter));
      expect(find.text(_l.uiActivityByRole), findsOneWidget);
    },
  );

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
            await _tap(tester, _rail(_l.uiActivityTypeTask));
            await _tap(tester, _rail(_l.uiActivityTypeAll));
            await _tap(tester, find.byIcon(Icons.tune_rounded));
            await tester.tapAt(const Offset(10, 10));
            await settle(tester);
            final s = find.byType(Scrollable).first;
            for (var i = 0; i < 20; i++) {
              await tester.drag(s, const Offset(0, -400));
              await tester.pump();
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
