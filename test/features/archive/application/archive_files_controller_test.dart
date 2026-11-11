// ArchiveFilesController + klasör kaynakları: süzgeç ve departman başlığı isteğe, imleçli devam,
// süzgeç değişince baştan yükleme, sonraki sayfa hatası; yöneticide görev ve satırlar klasöre
// göre süzülür; sanal klasör kapsamın departmanıyla gider.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/archive/application/archive_files_controller.dart';
import 'package:nizamio/features/archive/application/archive_folder_controller.dart';
import 'package:nizamio/features/archive/application/archive_folder_sources.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';

import '../archive_fixture.dart';

Future<ArchiveFilesState> _files(ProviderContainer c, String code) {
  c.listen(archiveFilesControllerProvider(code), (_, _) {});
  return c.read(archiveFilesControllerProvider(code).future);
}

class _DelayedPage extends FakeArchiveRepository {
  final delayed = Completer<PageSlice<RecordFile>>();
  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  }) {
    if (page.cursor == 'c2') return delayed.future;
    return Future.value(
      PageSlice(items: [archiveFile(filter.search ?? 'old')], nextCursor: 'c2'),
    );
  }
}

void main() {
  test('ilk sayfa: klasörün departmanı, süzgeçsiz, sayfa boyu', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo);
    final s = await _files(c, 'd1');
    expect(s.items.map((f) => f.id), ['f1', 'f2', 'f3']);
    expect(s.hasMore, isFalse);
    final call = repo.calls.lastWhere((x) => x.$1 == 'files');
    expect(call, ('files', 'd1', null));
    expect(repo.filters.last, const ArchiveAttachmentFilter());
  });

  test(
    'süzgeç değişince liste baştan (imleçsiz) ve yeni süzgeçle yüklenir',
    () async {
      final repo = FakeArchiveRepository()
        ..pages = {
          null: PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
          'c2': PageSlice(items: [archiveFile('f9')]),
        };
      final c = archiveContainer(repo);
      await _files(c, 'd1');
      c.read(archiveFolderControllerProvider('d1').notifier)
        ..openTask('w1')
        ..setTag(RecordTag.sonuc)
        ..setUploader('acc-9')
        ..cycleSort();
      final s = await c.read(archiveFilesControllerProvider('d1').future);
      expect(s.items.single.id, 'f1');
      expect(
        repo.filters.last,
        const ArchiveAttachmentFilter(
          tag: RecordTag.sonuc,
          workItemId: 'w1',
          uploaderId: 'acc-9',
          sort: ArchiveSort.name,
        ),
      );
      expect(repo.calls.last.$3, isNull, reason: 'imleç sıfırlanır');
    },
  );

  test(
    'eski sorgunun geciken sayfası aynı imleçli yeni sorguya eklenmez',
    () async {
      final repo = _DelayedPage();
      final c = archiveContainer(repo);
      await _files(c, 'd1');
      final pending = c
          .read(archiveFilesControllerProvider('d1').notifier)
          .loadMore();
      await Future<void>.delayed(Duration.zero);
      c.read(archiveFolderControllerProvider('d1').notifier).setQuery('yeni');
      await c.read(archiveFilesControllerProvider('d1').future);
      repo.delayed.complete(PageSlice(items: [archiveFile('stale')]));
      await pending;
      expect(
        c
            .read(archiveFilesControllerProvider('d1'))
            .value!
            .items
            .map((f) => f.id),
        ['yeni'],
      );
    },
  );

  test('daha fazla: imleçle devam eder ve ekler; son sayfada durur', () async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
        'c2': PageSlice(items: [archiveFile('f2')]),
      };
    final c = archiveContainer(repo);
    await _files(c, 'd1');
    final ctrl = c.read(archiveFilesControllerProvider('d1').notifier);
    await ctrl.loadMore();
    final s = c.read(archiveFilesControllerProvider('d1')).value!;
    expect(s.items.map((f) => f.id), ['f1', 'f2']);
    expect(s.hasMore, isFalse);
    expect(repo.calls.last, ('files', 'd1', 'c2'));
    final n = repo.calls.length;
    await ctrl.loadMore();
    expect(repo.calls, hasLength(n));
  });

  test(
    'sonraki sayfa hatası satırları korur, yeniden deneme dokunuşla',
    () async {
      final repo = FakeArchiveRepository()
        ..pages = {
          null: PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
        };
      final c = archiveContainer(repo);
      await _files(c, 'd1');
      repo.error = ApiError('records.invalid_cursor');
      await c.read(archiveFilesControllerProvider('d1').notifier).loadMore();
      final s = c.read(archiveFilesControllerProvider('d1')).value!;
      expect(s.items.single.id, 'f1');
      expect(s.moreError?.code, 'records.invalid_cursor');
      expect(s.loadingMore, isFalse);
      expect(s.hasMore, isTrue);
    },
  );

  test(
    'yönetici: görevler ve dosyalar klasörün departmanına süzülür',
    () async {
      final repo = FakeArchiveRepository()
        ..pages = {
          null: PageSlice(
            items: [
              archiveFile('f1'),
              archiveFile('f3', task: 'w2'),
            ],
            nextCursor: 'c2',
          ),
        };
      final c = archiveContainer(
        repo,
        catalog: archiveCatalog(
          admin: true,
          seats: {},
          tasks: {'w1': 'd1', 'w2': 'd2'},
        ),
      );
      c.listen(archiveFolderTasksProvider('d1'), (_, _) {});
      final tasks = await c.read(archiveFolderTasksProvider('d1').future);
      expect(tasks.map((t) => t.workItemId), ['w1']);
      final s = await _files(c, 'd1');
      expect(s.items.map((f) => f.id), ['f1']);
      // Süzülen sayfa kısa kalsa da imleç sürer.
      expect(s.hasMore, isTrue);
    },
  );

  test('koordinatör: görevler sunucuda daraltılmış, olduğu gibi', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo);
    c.listen(archiveFolderTasksProvider('d1'), (_, _) {});
    final tasks = await c.read(archiveFolderTasksProvider('d1').future);
    expect(tasks, hasLength(2));
    c.listen(archiveFolderUploadersProvider('d1'), (_, _) {});
    expect(await c.read(archiveFolderUploadersProvider('d1').future), [
      'acc-1',
      'acc-9',
    ]);
    expect(repo.calls.map((x) => x.$2).toSet(), {'d1'});
  });

  test('sanal klasör kapsamın departmanıyla; bilinmeyen klasör boş', () async {
    final repo = FakeArchiveRepository()
      ..folders = const [
        ArchiveFolder(
          code: 'my-tasks',
          name: 'Görevlerim',
          files: 1,
          isVirtual: true,
        ),
      ];
    final c = archiveContainer(
      repo,
      catalog: archiveCatalog(seats: {'d4': false}),
    );
    await _files(c, 'my-tasks');
    expect(repo.calls.last, ('files', 'd4', null));
    final none = await _files(c, 'yok');
    expect(none.items, isEmpty);
    c.listen(archiveFolderContextProvider('yok'), (_, _) {});
    expect(await c.read(archiveFolderContextProvider('yok').future), isNull);
  });
}
