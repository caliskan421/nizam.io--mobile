// ArchiveFolderPage (sunucu verisi, sahte depo): başlık, sekmeler, görev klasörü → dosya süzgeci,
// ZIP, önizleme (indir, yükleyen adı, silme yalnız yükleyene), yükleme akışı, bilinmeyen klasör,
// kısayol menüsü, taşma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../archive_fixture.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  String code = 'd1',
  FakeArchiveRepository? repo,
  RecordingSink? sink,
  FakePicker? picker,
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(archiveBackend(), signedIn: true),
  );
  useArchiveFakes(
    h,
    repo ?? FakeArchiveRepository(),
    sink: sink ?? RecordingSink(),
    picker: picker ?? FakePicker(),
  );
  h.read(scopeControllerProvider).selectProgram('prog-1');
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    ArchiveFolderPage(code: code),
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

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('başlık ve görev klasörleri; görev → dosyalar süzülür', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    final (_, nav) = await _open(tester, repo: repo);
    expect(find.text('Altyapı'), findsOneWidget);
    expect(find.text('Saha keşfi'), findsOneWidget);
    expect(find.text('2 dosya'), findsOneWidget);
    await _tap(tester, find.text('Saha keşfi'));
    expect(find.text('f1.pdf'), findsOneWidget);
    expect(repo.filters.last.workItemId, 'w1');
    await _tap(tester, find.text(_l.uiArchiveCoordinatorship));
    expect(nav.calls, ['coord:d1']);
  });

  testWidgets('etiket süzgeci ve ZIP (süzgeçliyken görünen dosyalar)', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    final sink = RecordingSink();
    await _open(tester, repo: repo, sink: sink);
    await _tap(tester, find.text(_l.uiArchiveTabFiles));
    expect(find.text('f3.pdf'), findsOneWidget);
    await _tap(tester, find.text(_l.uiArchiveTagSonuc).first);
    expect(repo.filters.last.tag, RecordTag.sonuc);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveZipSelection));
    expect(repo.calls.where((c) => c.$1 == 'selectionZip'), hasLength(1));
    expect(sink.saved.keys, ['Altyapı.zip']);
  });

  testWidgets('önizleme: indir; yükleyenin kendi dosyasında sil', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    final sink = RecordingSink();
    await _open(tester, repo: repo, sink: sink);
    await _tap(tester, find.text(_l.uiArchiveTabFiles));
    await _tap(tester, find.text('f2.pdf'));
    // f2'yi başkası yükledi: silme düğmesi yok.
    expect(find.bySemanticsLabel(_l.uiArchiveDelete), findsNothing);
    await _tap(tester, find.text(_l.uiArchiveDownload));
    expect(sink.saved.keys, ['f2.pdf']);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchivePrev));
    expect(find.text('f1.pdf'), findsWidgets);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveDelete));
    await _tap(tester, find.text(_l.uiArchiveDeleteOk));
    expect(repo.calls.where((c) => c.$1 == 'delete').single.$3, 'f1');
    expect(find.text(_l.uiArchiveDeleted), findsOneWidget);
  });

  testWidgets('yükle: görev → etiket → kaynak → seçici → göreve yüklenir', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    final picker = FakePicker(
      const UploadSource(
        path: '/tmp/r.pdf',
        name: 'r.pdf',
        sizeBytes: 9,
        digest: 'd',
      ),
    );
    await _open(tester, repo: repo, picker: picker);
    await _tap(tester, find.text(_l.uiArchiveUploadShort));
    await _tap(tester, find.text('Rapor').last);
    await _tap(tester, find.text(_l.uiArchiveTagPlan).last);
    await _tap(tester, find.text(_l.uiTasksPickPhotos));
    expect(picker.origins, [UploadOrigin.photos]);
    final attach = repo.calls.where((c) => c.$1 == 'attach').single;
    expect(attach, ('attach', 'd1', ('w2', RecordTag.plan, 'r.pdf')));
    expect(find.text(_l.uiArchiveUploaded), findsOneWidget);
  });

  testWidgets('listede olmayan klasör: bulunamadı', (tester) async {
    await _open(tester, code: 'yok');
    expect(find.text(_l.uiArchiveFolderMissing), findsOneWidget);
  });

  testWidgets('kısayol menüsü: diğer klasör ve tüm arşiv', (tester) async {
    final (h, nav) = await _open(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(ArchiveFolderPage.shellTab);
    await settle(tester);
    await tester.tap(find.text('Bilişim'));
    await settle(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(ArchiveFolderPage.shellTab);
    await settle(tester);
    await _tap(tester, find.text(_l.uiArchiveAllArchive));
    expect(nav.calls, ['folder:d2', 'archive']);
  });

  for (final dark in [false, true]) {
    testWidgets('taşma yok: 360 geniş, 2.0x, ${dark ? 'koyu' : 'açık'}', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 844);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _open(tester, dark: dark);
      await _tap(tester, find.text(_l.uiArchiveTabFiles));
      expect(tester.takeException(), isNull);
    });
  }
}
