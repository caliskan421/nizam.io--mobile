// ArchivePage: bölümler, sıralama döngüsü, arama, etiket paneli (süzgeç + yeni etiket),
// yükleme tostu, klasör → klasör ayrıntısı, kısayol menüsü, dar ekran / 2.0 / koyu.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/features/archive/archive.dart';

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
  h.read(scopeControllerProvider).selectSample();
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const ArchivePage(), nav: nav, dark: dark);
  await settle(tester);
  return (h, nav);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'bölümler: başlık, etiket hapı, depolama, klasörler; klasör açılır',
    (tester) async {
      final (_, nav) = await _open(tester);
      expect(find.text(_l.uiArchiveTitle), findsOneWidget);
      expect(find.text('${_l.uiArchiveTags} · 3'), findsOneWidget);
      expect(find.textContaining('559,3', findRichText: true), findsOneWidget);
      expect(find.text('227 dosya · 11 klasör'), findsOneWidget);
      expect(find.text('koordinatörlükler · 11'), findsOneWidget);
      expect(find.text(_l.uiArchiveSortRecent), findsOneWidget);
      expect(find.text('İdari işler'), findsOneWidget);
      expect(find.text('78 dosya'), findsOneWidget);
      await _tap(tester, find.text('Operasyon'));
      expect(nav.calls, ['folder:OPE']);
    },
  );

  testWidgets('sıralama döngüsü ve arama; eşleşme yoksa boş metni', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.text(_l.uiArchiveSortRecent));
    expect(find.text(_l.uiArchiveSortName), findsOneWidget);
    await _tap(tester, find.text(_l.uiArchiveSortName));
    expect(find.text(_l.uiArchiveSortSize), findsOneWidget);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await settle(tester);
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(TextField).first, 'fuar');
    await settle(tester);
    expect(find.text('koordinatörlükler · 1'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'yok böyle');
    await settle(tester);
    expect(find.text(_l.uiArchiveEmptySearch), findsOneWidget);
  });

  testWidgets('geri dönüşte arama kutusu sorguyu korur', (tester) async {
    final (h, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(TextField).first, 'fuar');
    await settle(tester);
    await pumpScreen(tester, h, const SizedBox.shrink());
    await settle(tester);
    await pumpScreen(tester, h, const ArchivePage());
    await settle(tester);
    expect(find.text('fuar'), findsOneWidget);
    expect(find.text('koordinatörlükler · 1'), findsOneWidget);
  });

  testWidgets(
    'etiket: seç → klasör sayıları süzülür; temizle; yeni etiket tostu',
    (tester) async {
      await _open(tester);
      await _tap(tester, find.text('${_l.uiArchiveTags} · 3'));
      await _tap(tester, find.text(_l.uiArchiveTagField).last);
      expect(find.text('39 dosya'), findsOneWidget);
      await _tap(tester, find.text(_l.uiArchiveTagsClear));
      expect(find.text('78 dosya'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, _l.uiArchiveNewTag),
        'Teslim',
      );
      await settle(tester);
      await _tap(tester, find.bySemanticsLabel(_l.uiArchiveAddTag));
      expect(find.text('“Teslim” ${_l.uiArchiveTagAdded}'), findsOneWidget);
      expect(find.text('${_l.uiArchiveTags} · 4'), findsOneWidget);
    },
  );

  testWidgets('yükle tostu; kısayol menüsü satırları ve gezinme', (
    tester,
  ) async {
    final (h, nav) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.arrow_upward_rounded));
    expect(find.text(_l.uiArchiveUploadSoon), findsOneWidget);
    h.read(shellReselectEventsProvider.notifier).fire(ArchivePage.shellTab);
    await settle(tester);
    expect(find.text(_l.uiArchiveDownloadAll), findsOneWidget);
    expect(find.text(_l.uiArchiveCreateFolder), findsOneWidget);
    await tester.tap(find.text(_l.uiArchiveGoCoordinatorships));
    await settle(tester);
    expect(nav.calls, ['coordinatorships']);
    h.read(shellReselectEventsProvider.notifier).fire(0);
    await settle(tester);
    expect(find.text(_l.uiArchiveDownloadAll), findsNothing);
  });

  for (final (width, scale) in [(360.0, 1.0), (360.0, 2.0), (390.0, 2.0)]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await _open(tester, dark: dark);
          await _tap(tester, find.textContaining('${_l.uiArchiveTags} ·'));
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 10; i++) {
            await tester.drag(scrollable, const Offset(0, -300));
            await tester.pump();
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
