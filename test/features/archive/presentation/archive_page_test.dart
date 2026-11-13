// ArchivePage (sunucu verisi, sahte depo): özet ve klasörler, arama, klasör → ayrıntı, yükleme
// görev seçimi, kısayol menüsü (tam arşiv yalnız yöneticide), hata görünümü, dar ekran / 2.0 / koyu.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/feedback/feedback.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/presentation/archive/archive_folder_card.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../archive_fixture.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav, RecordingSink)> _open(
  WidgetTester tester, {
  FakeArchiveRepository? repo,
  bool admin = false,
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(archiveBackend(admin: admin), signedIn: true),
  );
  final sink = RecordingSink();
  useArchiveFakes(h, repo ?? FakeArchiveRepository(), sink: sink);
  h.read(scopeControllerProvider).selectProgram('prog-1');
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const ArchivePage(), nav: nav, dark: dark);
  await settle(tester);
  return (h, nav, sink);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('özet ve klasörler sunucudan; klasör açılır', (tester) async {
    final repo = FakeArchiveRepository();
    final (_, nav, _) = await _open(tester, repo: repo);
    expect(find.text(_l.uiArchiveTitle), findsOneWidget);
    expect(find.text(_l.uiArchiveSummaryFiles), findsOneWidget);
    expect(find.text('2 ${_l.uiArchiveFoldersLc}'), findsOneWidget);
    expect(find.text('${_l.uiArchiveFoldersTitle} · 2'), findsOneWidget);
    // Kartta yalnız klasör adı ve dosya sayısı (örnek veri yok); aynı metin özetteki boyut
    // kutucuğunun alt yazısında da var (toplam 3 dosya).
    expect(find.text('3 dosya'), findsNWidgets(2));
    expect(find.text(_l.uiArchiveNoFiles), findsOneWidget);
    expect(find.bySemanticsLabel('Altyapı, 3 dosya'), findsOneWidget);
    expect(find.text('grup'), findsNothing);
    // Koordinatör satırının departmanı başlık olarak gider.
    expect(repo.calls.first, ('folders', 'd1', null));
    await _tap(tester, find.text('Bilişim'));
    expect(nav.calls, ['folder:d2']);
  });

  for (final (size, columns) in [
    (const Size(320, 900), 1),
    (const Size(390, 900), 2),
    (const Size(1024, 1000), 4),
  ]) {
    testWidgets('klasör kartları görünür alana uyum sağlar: $size', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      if (size.width >= 1024) {
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      }
      final repo = FakeArchiveRepository()
        ..folders = [
          for (var i = 0; i < 7; i++)
            ArchiveFolder(
              code: 'd$i',
              name: i == 0
                  ? 'Altyapı ve tesisat'
                  : i == 1
                  ? 'Klasör $i uzun koordinatörlük ismi'
                  : 'Klasör $i',
              files: i,
            ),
        ];
      await _open(tester, repo: repo);
      final heading = find.text('${_l.uiArchiveFoldersTitle} · 7');
      final cards = find.byType(ArchiveFolderCard);
      final headingRect = tester.getRect(heading);
      final first = tester.getRect(cards.first);
      for (var i = 0; i < 7; i++) {
        final card = cards.at(i);
        final rect = tester.getRect(card);
        final folder = tester.widget<ArchiveFolderCard>(card).folder;
        final title = find.descendant(
          of: card,
          matching: find.text(folder.name),
        );
        final meta = find.descendant(
          of: card,
          matching: find.text(
            folder.files > 0 ? '${folder.files} dosya' : _l.uiArchiveNoFiles,
          ),
        );
        expect(rect.height, closeTo(first.height, .1));
        expect(
          tester.getTopLeft(meta).dy - tester.getRect(title).bottom,
          inInclusiveRange(0, 3),
        );
      }
      expect(first.left, closeTo(headingRect.left, .1));
      expect(first.top - headingRect.bottom, greaterThanOrEqualTo(23));
      expect(
        tester.getTopLeft(cards.at(columns - 1)).dy,
        closeTo(first.top, .1),
      );
      expect(tester.getTopLeft(cards.at(columns)).dy, greaterThan(first.top));
    });
  }

  testWidgets('arama süzer; eşleşme yoksa boş metni; geri dönüşte korunur', (
    tester,
  ) async {
    final (h, _, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(TextField).first, 'bili');
    await settle(tester);
    expect(find.text('${_l.uiArchiveFoldersTitle} · 1'), findsOneWidget);
    await pumpScreen(tester, h, const SizedBox.shrink());
    await settle(tester);
    await pumpScreen(tester, h, const ArchivePage());
    await settle(tester);
    expect(find.text('bili'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'yok böyle');
    await settle(tester);
    expect(find.text(_l.uiArchiveEmptySearch), findsOneWidget);
  });

  testWidgets('yüklenecek görev yoksa bilgi; kısayollar (koordinatör)', (
    tester,
  ) async {
    final (h, nav, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.arrow_upward_rounded));
    // Pilot kataloğunda görev yok: görev seçici açılmaz, bilgi verilir.
    expect(find.text(_l.uiArchiveUploadNoTask), findsOneWidget);
    h.read(shellReselectEventsProvider.notifier).fire(ArchivePage.shellTab);
    await settle(tester);
    expect(find.text(_l.uiArchiveGoCoordinatorships), findsOneWidget);
    // Tam arşiv yalnız şirket yöneticisine.
    expect(find.text(_l.uiArchiveDownloadAll), findsNothing);
    await tester.tap(find.text(_l.uiArchiveGoCoordinatorships));
    await settle(tester);
    expect(nav.calls, ['coordinatorships']);
  });

  testWidgets('yönetici: tam arşiv indirilir ve kaydedilir', (tester) async {
    final repo = FakeArchiveRepository();
    final (h, _, sink) = await _open(tester, repo: repo, admin: true);
    h.read(shellReselectEventsProvider.notifier).fire(ArchivePage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiArchiveDownloadAll));
    await settle(tester);
    expect(repo.calls.last, ('periodZip', 'd1', null));
    expect(sink.saved.keys, ['${_l.uiArchiveTitle}.zip']);
    expect(find.text(_l.uiArchiveSaved), findsOneWidget);
  });

  testWidgets('sunucu hatası: hata görünümü', (tester) async {
    final repo = FakeArchiveRepository()
      ..error = ApiError('records.not_authorized');
    await _open(tester, repo: repo);
    expect(find.byType(NzErrorState), findsOneWidget);
  });

  for (final (width, scale) in [
    (320.0, 2.0),
    (360.0, 1.0),
    (360.0, 2.0),
    (390.0, 2.0),
    (1024.0, 2.0),
  ]) {
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
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 4; i++) {
            await tester.drag(scrollable, const Offset(0, -300));
            await tester.pump();
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
