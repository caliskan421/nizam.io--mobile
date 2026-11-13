// ArchiveFolderPage (sunucu verisi, sahte depo): başlık, sekmeler, görev klasörü → dosya süzgeci,
// ZIP, önizleme (indir, yükleyen adı, silme yalnız yükleyene), yükleme akışı, bilinmeyen klasör,
// kısayol menüsü, taşma.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';
import 'package:nizamio/features/archive/presentation/archive/archive_folder_parts.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../archive_fixture.dart';

final _l = AppLocalizationsTr();

class _ImageArchiveRepository extends FakeArchiveRepository {
  @override
  Future<Stream<List<int>>> downloadFile(
    String fileId, {
    required String department,
  }) async {
    calls.add(('file', department, fileId));
    return Stream.value(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+a6b0AAAAASUVORK5CYII=',
      ),
    );
  }
}

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

  testWidgets(
    'doğrudan açılış sonraki sayfadaki dosyanın önizlemesini gösterir',
    (tester) async {
      final h = await real(
        tester,
        () => pilotHarness(archiveBackend(), signedIn: true),
      );
      final repo = FakeArchiveRepository()
        ..pages = {
          null: PageSlice(
            items: [archiveFile('f1', type: 'application/octet-stream')],
            nextCursor: 'next',
          ),
          'next': PageSlice(
            items: [archiveFile('f2', type: 'application/octet-stream')],
          ),
        };
      useArchiveFakes(h, repo, sink: RecordingSink(), picker: FakePicker());
      h.read(scopeControllerProvider).selectProgram('prog-1');
      await pumpScreen(
        tester,
        h,
        Consumer(
          builder: (context, ref, _) => Scaffold(
            body: TextButton(
              onPressed: () => openArchiveFile(
                context,
                folderCode: 'd1',
                workItemId: 'w1',
                fileId: 'f2',
                taskTitle: (_) => 'Saha keşfi',
              ),
              child: const Text('Dosyayı aç'),
            ),
          ),
        ),
      );
      await settle(tester);
      await real(
        tester,
        () => h.container.read(taskCatalogControllerProvider.future),
      );
      await _tap(tester, find.text('Dosyayı aç'));
      expect(find.text('f2.pdf'), findsOneWidget);
      expect(find.text(_l.uiArchiveDownload), findsOneWidget);
      expect(repo.filters.any((filter) => filter.workItemId == 'w1'), isTrue);
    },
  );

  testWidgets('başlık ve görev klasörleri; görev → dosyalar süzülür', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    await _open(tester, repo: repo);
    expect(find.text('Altyapı'), findsOneWidget);
    expect(find.text('Saha keşfi'), findsOneWidget);
    expect(find.text('2 dosya'), findsOneWidget);
    expect(find.byType(ArchiveTaskFolderCard), findsNWidgets(2));
    expect(find.bySemanticsLabel('Saha keşfi, 2 dosya'), findsOneWidget);
    expect(find.text('2,5 MB'), findsNothing);
    await _tap(tester, find.text('Saha keşfi'));
    expect(find.text('f1.pdf'), findsOneWidget);
    expect(repo.filters.last.workItemId, 'w1');
    expect(find.bySemanticsLabel(_l.uiArchiveCoordinatorship), findsNothing);
    expect(find.bySemanticsLabel(_l.uiTasksFilters), findsOneWidget);
  });

  testWidgets(
    'arama görevleri süzer, dosya sorgusunu sunucuya taşır ve Escape temizler',
    (tester) async {
      final repo = FakeArchiveRepository();
      await _open(tester, repo: repo);
      await _tap(tester, find.bySemanticsLabel(_l.uiArchiveSearch));
      await tester.enterText(find.byType(TextField), 'SAHA');
      await settle(tester);
      expect(find.text('Saha keşfi'), findsOneWidget);
      expect(find.text('Rapor'), findsNothing);
      await _tap(tester, find.byTooltip(_l.uiInputsSearchClear));
      expect(find.text('Rapor'), findsOneWidget);
      await _tap(tester, find.text(_l.uiArchiveTabFiles));
      await _tap(tester, find.bySemanticsLabel(_l.uiArchiveSearch));
      await tester.enterText(find.byType(TextField), 'dosya');
      await settle(tester);
      expect(repo.filters.last.search, 'dosya');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(tester);
      expect(find.byType(TextField), findsNothing);
      expect(repo.filters.last.search, isNull);
    },
  );

  testWidgets('etiket süzgeci ve ZIP (süzgeçliyken görünen dosyalar)', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    final sink = RecordingSink();
    await _open(tester, repo: repo, sink: sink);
    await _tap(tester, find.text(_l.uiArchiveTabFiles));
    expect(find.text('f3.pdf'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(_l.uiTasksFilters));
    await _tap(tester, find.text(_l.uiArchiveTagFilter));
    await _tap(tester, find.text(_l.uiArchiveTagSonuc).first);
    await _tap(tester, find.textContaining(_l.uiArchiveShowFilesTail));
    expect(repo.filters.last.tag, RecordTag.sonuc);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveZipSelection));
    expect(repo.calls.where((c) => c.$1 == 'selectionZip'), hasLength(1));
    expect(sink.saved.keys, ['Altyapı.zip']);
  });

  testWidgets('dosya filtreleri arama ve görev seçimini korur', (tester) async {
    final repo = FakeArchiveRepository();
    await _open(tester, repo: repo);
    await _tap(tester, find.text('Saha keşfi'));
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveSearch));
    await tester.enterText(find.byType(TextField), 'rapor');
    await settle(tester);
    await _tap(tester, find.bySemanticsLabel(_l.uiTasksFilters));
    await _tap(tester, find.text(_l.uiArchiveFilterType));
    await _tap(tester, find.text(_l.uiArchiveMimeSpreadsheet));
    expect(repo.filters.last.mimeCategory, ArchiveMimeCategory.tablo);
    expect(repo.filters.last.workItemId, 'w1');
    expect(repo.filters.last.search, 'rapor');
    await _tap(tester, find.text(_l.uiTasksClearAll));
    expect(repo.filters.last.mimeCategory, isNull);
    expect(repo.filters.last.workItemId, 'w1');
    expect(repo.filters.last.search, 'rapor');
  });

  testWidgets('görsel önizlemesi yetkili dosya akışını gösterir', (
    tester,
  ) async {
    final repo = _ImageArchiveRepository();
    await _open(tester, repo: repo);
    await _tap(tester, find.text(_l.uiArchiveTabFiles));
    await _tap(tester, find.text('f3.pdf'));
    expect(find.byType(Image), findsOneWidget);
    expect(repo.calls.where((call) => call.$1 == 'file').single, (
      'file',
      'd1',
      'f3',
    ));
    expect(tester.takeException(), isNull);
  });

  testWidgets('büyük görsel indirilmeden önizleme sınırı gösterilir', (
    tester,
  ) async {
    final repo = _ImageArchiveRepository()
      ..pages = {
        null: PageSlice(
          items: [
            archiveFile('big', type: 'image/png', size: 11 * 1024 * 1024),
          ],
        ),
      };
    await _open(tester, repo: repo);
    await _tap(tester, find.text(_l.uiArchiveTabFiles));
    await _tap(tester, find.text('big.pdf'));
    expect(find.text(_l.uiArchiveImageTooLarge), findsOneWidget);
    expect(find.text(_l.uiArchiveDownload), findsOneWidget);
    expect(repo.calls.where((call) => call.$1 == 'file'), isEmpty);
  });

  testWidgets('büyük PDF indirilmeden önizleme sınırı gösterilir', (
    tester,
  ) async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(items: [archiveFile('big', size: 11 * 1024 * 1024)]),
      };
    await _open(tester, repo: repo);
    await _tap(tester, find.text(_l.uiArchiveTabFiles));
    await _tap(tester, find.text('big.pdf'));
    expect(find.text(_l.uiArchivePdfTooLarge), findsOneWidget);
    expect(find.text(_l.uiArchiveDownload), findsOneWidget);
    expect(repo.calls.where((call) => call.$1 == 'file'), isEmpty);
  });

  testWidgets('önizleme: indir; yükleyenin kendi dosyasında sil', (
    tester,
  ) async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(
          items: [
            archiveFile('f1', type: 'application/octet-stream'),
            archiveFile(
              'f2',
              type: 'application/octet-stream',
              tag: RecordTag.sonuc,
              uploader: 'acc-9',
            ),
          ],
        ),
      };
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
      const UploadSource(path: '/tmp/r.pdf', name: 'r.pdf', sizeBytes: 9),
    );
    await _open(tester, repo: repo, picker: picker);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveUploadShort));
    await _tap(tester, find.text('Rapor').last);
    await _tap(tester, find.text(_l.uiArchiveTagPlan).last);
    await _tap(tester, find.text(_l.uiTasksPickPhotos));
    expect(picker.origins, [UploadOrigin.photos]);
    final attach = repo.calls.where((c) => c.$1 == 'attach').single;
    expect(attach, ('attach', 'd1', ('w2', RecordTag.plan, 'r.pdf')));
    expect(find.text(_l.uiArchiveUploaded), findsOneWidget);
  });

  testWidgets('yükle: kaynak sayfasında Kamera seçimi kameraya geçer', (
    tester,
  ) async {
    final repo = FakeArchiveRepository();
    final picker = FakePicker(
      const UploadSource(
        path: '/tmp/c.jpg',
        name: 'IMG_20260307_090504.jpg',
        sizeBytes: 9,
      ),
    );
    await _open(tester, repo: repo, picker: picker);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveUploadShort));
    await _tap(tester, find.text('Rapor').last);
    await _tap(tester, find.text(_l.uiArchiveTagPlan).last);
    await _tap(tester, find.text(_l.uiTasksPickCamera));
    expect(picker.origins, [UploadOrigin.camera]);
    final attach = repo.calls.where((c) => c.$1 == 'attach').single;
    expect(attach.$3, ('w2', RecordTag.plan, 'IMG_20260307_090504.jpg'));
  });

  testWidgets('sanal klasörde koordinatörlük eylemi görünmez', (tester) async {
    final repo = FakeArchiveRepository()
      ..folders = const [
        ArchiveFolder(
          code: 'my-tasks',
          name: 'Görevlerim',
          files: 1,
          isVirtual: true,
        ),
      ];
    await _open(tester, code: 'my-tasks', repo: repo);
    expect(find.bySemanticsLabel(_l.uiArchiveCoordinatorship), findsNothing);
    expect(find.bySemanticsLabel(_l.uiArchiveSearch), findsOneWidget);
    expect(find.bySemanticsLabel(_l.uiArchiveUploadShort), findsOneWidget);
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

  for (final width in [320.0, 360.0, 1024.0]) {
    for (final dark in [false, true]) {
      testWidgets('taşma yok: $width geniş, 2.0x, ${dark ? 'koyu' : 'açık'}', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await _open(tester, dark: dark);
        expect(find.byType(ArchiveTaskFolderCard), findsNWidgets(2));
        await _tap(tester, find.bySemanticsLabel(_l.uiArchiveSearch));
        expect(find.byType(TextField), findsOneWidget);
        await _tap(tester, find.text(_l.uiArchiveTabFiles));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
