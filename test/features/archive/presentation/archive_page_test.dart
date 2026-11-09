// ArchivePage (sunucu verisi, sahte depo): özet ve klasörler, arama, klasör → ayrıntı, yükleme
// tostu, kısayol menüsü (tam arşiv yalnız yöneticide), hata görünümü, dar ekran / 2.0 / koyu.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/feedback/feedback.dart';
import 'package:nizamio/features/archive/archive.dart';

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
    expect(find.text('3 dosya · 2 klasör'), findsOneWidget);
    expect(find.text('${_l.uiArchiveFoldersTitle} · 2'), findsOneWidget);
    expect(find.text('3 dosya'), findsOneWidget);
    expect(find.text(_l.uiArchiveNoFiles), findsOneWidget);
    // Koordinatör satırının departmanı başlık olarak gider.
    expect(repo.calls.single, ('folders', 'd1', null));
    await _tap(tester, find.text('Bilişim'));
    expect(nav.calls, ['folder:d2']);
  });

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

  testWidgets('yükleme görev bağlamı yok → yakında; kısayollar (koordinatör)', (
    tester,
  ) async {
    final (h, nav, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.arrow_upward_rounded));
    expect(find.text(_l.uiArchiveUploadSoon), findsOneWidget);
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
