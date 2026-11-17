import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/archive/application/archive_actions_controller.dart';
import 'package:nizamio/features/archive/application/archive_files_controller.dart';
import 'package:nizamio/features/archive/application/archive_folder_sources.dart';
import 'package:nizamio/features/archive/application/archive_folders_controller.dart';
import 'package:nizamio/features/archive/application/archive_summary_provider.dart';
import 'package:nizamio/features/archive/application/person_files_controller.dart';
import 'package:nizamio/features/archive/domain/records.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../archive_fixture.dart';

TaskCatalog _catalog({bool partial = false}) => archiveCatalog(
  admin: true,
  truncated: partial,
  seats: {'d1': true, 'd2': false},
  tasks: {'w1': 'd1', 'w2': 'd1', 'w3': 'd2', 'w4': 'd2', 'w5': 'd2'},
  assignees: {
    'w3': ['acc-1'],
    'w4': ['acc-1'],
  },
);

FakeArchiveRepository _repo() => FakeArchiveRepository()
  ..tasks = const [
    ArchiveTaskSummary(workItemId: 'w1', title: 'Ekip işi', fileCount: 1),
    ArchiveTaskSummary(workItemId: 'w2', title: 'Başka ekip işi', fileCount: 1),
    ArchiveTaskSummary(workItemId: 'w3', title: 'Benim işim', fileCount: 1),
    ArchiveTaskSummary(workItemId: 'w4', title: 'Diğer işim', fileCount: 1),
    ArchiveTaskSummary(workItemId: 'w5', title: 'Atanmadığım iş', fileCount: 1),
  ]
  ..pages = {
    null: PageSlice(
      items: [
        archiveFile('f1'),
        archiveFile('f3', task: 'w3'),
      ],
      nextCursor: 'c2',
    ),
    'c2': PageSlice(
      items: [
        archiveFile('f2', task: 'w2'),
        archiveFile('f4', task: 'w4'),
        archiveFile('f5', task: 'w5'),
      ],
    ),
  };

Future<ArchiveFilesState> _files(ProviderContainer c, String code) {
  c.listen(archiveFilesControllerProvider(code), (_, _) {});
  return c.read(archiveFilesControllerProvider(code).future);
}

void main() {
  test('yönetici hesabı üye görünümünde: görev, dosya, sayaç ve ZIP aynı iki görev', () async {
    final repo = _repo();
    final c = archiveContainer(
      repo,
      catalog: _catalog(),
      scope: const ScopeSelection(
        programId: 'p1',
        role: EffectiveRole.member,
        departmentId: 'd2',
      ),
    );
    final folders = await c.read(archiveFoldersControllerProvider.future);
    expect(folders.map((f) => (f.code, f.files, f.isVirtual)), [
      ('my-tasks', 2, true),
    ]);
    c.listen(archiveFolderTasksProvider('my-tasks'), (_, _) {});
    expect(
      (await c.read(archiveFolderTasksProvider('my-tasks').future))
          .map((t) => t.workItemId),
      ['w3', 'w4'],
    );
    final first = await _files(c, 'my-tasks');
    expect(first.items.map((f) => f.id), ['f3']);
    expect(first.nextCursor, 'c2');
    await c
        .read(archiveFilesControllerProvider('my-tasks').notifier)
        .loadMore();
    expect(
      c
          .read(archiveFilesControllerProvider('my-tasks'))
          .value!
          .items
          .map((f) => f.id),
      ['f3', 'f4'],
    );
    final stats = await c.read(archiveStatsProvider.future);
    expect((stats.files, stats.tasks, stats.partial), (2, 2, false));
    final person = personFilesControllerProvider('acc-1', filterArchive: true);
    c.listen(person, (_, _) {});
    await c.read(person.future);
    await c.read(person.notifier).loadMore();
    expect(c.read(person).value!.files.items.map((f) => f.id), ['f3', 'f4']);
    final action = archiveActionsControllerProvider('my-tasks');
    c.listen(action, (_, _) {});
    expect((await c.read(action.notifier).downloadZip('benim.zip')).ok, isTrue);
    expect(repo.calls.where((x) => x.$1 == 'folderZip'), isEmpty);
    expect(repo.calls.lastWhere((x) => x.$1 == 'selectionZip').$3, [
      'f3',
      'f4',
    ]);
  });

  test(
    'yönetici hesabı koordinatör görünümünde: yalnız seçili koordinatörlük',
    () async {
      final repo = _repo();
      final c = archiveContainer(
        repo,
        catalog: _catalog(),
        scope: const ScopeSelection(
          programId: 'p1',
          role: EffectiveRole.coordinator,
          departmentId: 'd1',
        ),
      );
      final folders = await c.read(archiveFoldersControllerProvider.future);
      expect(folders.map((f) => (f.code, f.files, f.isVirtual)), [
        ('d1', 2, false),
      ]);
      await _files(c, 'd1');
      await c.read(archiveFilesControllerProvider('d1').notifier).loadMore();
      expect(
        c
            .read(archiveFilesControllerProvider('d1'))
            .value!
            .items
            .map((f) => f.id),
        ['f1', 'f2'],
      );
      expect((await c.read(archiveStatsProvider.future)).files, 2);
      expect((await c.read(archiveFolderContextProvider('d2').future)), isNull);
    },
  );

  test('yönetici görünümünde tüm klasörler ve toplam korunur', () async {
    final c = archiveContainer(_repo(), catalog: _catalog());
    expect(
      (await c.read(archiveFoldersControllerProvider.future))
          .map((f) => f.code),
      ['d1', 'd2'],
    );
    expect((await c.read(archiveStatsProvider.future)).files, 5);
  });

  for (final partial in [true, false]) {
    test(
      'daraltılmış ZIP: kesik katalog=$partial, geniş ZIP yerine sınır hatası',
      () async {
        final repo = _repo();
        if (!partial) {
          repo.pages = {
            null: PageSlice(
              items: [
                for (var i = 0; i < 101; i++) archiveFile('f$i', task: 'w3'),
              ],
            ),
          };
        }
        final c = archiveContainer(
          repo,
          catalog: _catalog(partial: partial),
          scope: const ScopeSelection(
            programId: 'p1',
            role: EffectiveRole.member,
            departmentId: 'd2',
          ),
        );
        final action = archiveActionsControllerProvider('my-tasks');
        c.listen(action, (_, _) {});
        final result = await c.read(action.notifier).downloadZip('arsiv.zip');
        expect(result.error?.code, 'records.too_many_files');
        expect(repo.calls.where((x) => x.$1.endsWith('Zip')), isEmpty);
      },
    );
  }

  test(
    'rol değişince aynı imleçli eski sayfa yeni görünüme eklenmez',
    () async {
      final scope = ValueNotifier(const ScopeSelection(programId: 'p1'));
      addTearDown(scope.dispose);
      final repo = _DelayedPage();
      final c = archiveContainer(
        repo,
        catalog: _catalog(),
        scopeChanges: scope,
      );
      await _files(c, 'd1');
      final pending = c
          .read(archiveFilesControllerProvider('d1').notifier)
          .loadMore();
      await repo.started.future;
      scope.value = const ScopeSelection(
        programId: 'p1',
        role: EffectiveRole.coordinator,
        departmentId: 'd1',
      );
      await c.read(archiveFilesControllerProvider('d1').future);
      repo.page.complete(PageSlice(items: [archiveFile('eski-rol')]));
      await pending;
      expect(
        c
            .read(archiveFilesControllerProvider('d1'))
            .value!
            .items
            .map((f) => f.id),
        ['f1'],
      );
    },
  );
}

class _DelayedPage extends FakeArchiveRepository {
  final started = Completer<void>();
  final page = Completer<PageSlice<RecordFile>>();
  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  }) {
    if (page.cursor != null) {
      started.complete();
      return this.page.future;
    }
    return Future.value(
      PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
    );
  }
}
