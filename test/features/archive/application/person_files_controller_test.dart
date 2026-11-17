import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/archive/application/archive_controller.dart';
import 'package:nizamio/features/archive/application/archive_providers.dart';
import 'package:nizamio/features/archive/application/person_files_controller.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';

import '../archive_fixture.dart';

ProviderContainer _container(FakeArchiveRepository repo) {
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      sessionGenerationProvider.overrideWithValue(1),
      scopeStateProvider.overrideWithValue(
        const ScopeSelection(programId: 'p1'),
      ),
      archiveViewFilterProvider.overrideWith((ref) async => null),
      archiveScopeProvider.overrideWith(
        (ref) async => const ArchiveScope(department: 'd1', admin: true),
      ),
      archiveRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(c.dispose);
  c.listen(personFilesControllerProvider('acc-9'), (_, _) {});
  return c;
}

class _DelayedRepository extends FakeArchiveRepository {
  final more = Completer<PageSlice<RecordFile>>();
  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  }) => page.cursor == 'c2'
      ? more.future
      : super.archiveAttachments(
          department: department,
          filter: filter,
          page: page,
        );
}

void main() {
  test(
    'dosyalar seçili arşiv departmanı ve yükleyen süzgeciyle imleçli okunur',
    () async {
      final repo = FakeArchiveRepository()
        ..pages = {
          null: PageSlice(
            items: [archiveFile('f1', uploader: 'acc-9')],
            nextCursor: 'c2',
          ),
          'c2': PageSlice(items: [archiveFile('f2', uploader: 'acc-9')]),
        };
      final c = _container(repo);
      final p = personFilesControllerProvider('acc-9');
      await c.read(p.future);
      await c.read(p.notifier).loadMore();
      expect(c.read(p).value!.files.items.map((f) => f.id), ['f1', 'f2']);
      expect(repo.calls, [('files', 'd1', null), ('files', 'd1', 'c2')]);
      expect(repo.filters.every((f) => f.uploaderId == 'acc-9'), isTrue);
      expect(c.read(p).value!.files.hasMore, isFalse);
    },
  );

  test('arşivde çoklu etiket OR; eşleşmeyen sayfa atlanır, değişiklik imleci sıfırlar', () async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(
          items: [archiveFile('no', tag: RecordTag.girdi)],
          nextCursor: 'c2',
        ),
        'c2': PageSlice(items: [archiveFile('yes', tag: RecordTag.plan)]),
      };
    final c = _container(repo);
    c.read(archiveControllerProvider.notifier).setTags({
      RecordTag.plan,
      RecordTag.sonuc,
    });
    final p = personFilesControllerProvider('acc-9', filterArchive: true);
    c.listen(p, (_, _) {});
    final result = await c.read(p.future);
    expect(result.files.items.map((f) => f.id), ['yes']);
    expect(repo.filters.last.uploaderId, 'acc-9');
    c.read(archiveControllerProvider.notifier).setTags({RecordTag.girdi});
    final changed = await c.read(p.future);
    expect(changed.files.items.map((f) => f.id), ['no']);
    expect(repo.calls.last, ('files', 'd1', null));
    expect(repo.filters.last.tag, RecordTag.girdi);
    c.read(archiveControllerProvider.notifier).setQuery('rapor');
    await c.read(p.future);
    expect(repo.filters.last.search, 'rapor');
    // Profildeki liste arşiv süzgecinden etkilenmez.
    c.invalidate(personFilesControllerProvider('acc-9'));
    await c.read(personFilesControllerProvider('acc-9').future);
    expect(repo.filters.last.tag, isNull);
    expect(repo.filters.last.search, isNull);
  });

  test(
    'çoklu etiket taraması sınırlıdır; kalan imleçle sonraki eşleşme yüklenir',
    () async {
      final repo = FakeArchiveRepository()
        ..pages = {
          for (var i = 0; i < 6; i++)
            i == 0 ? null : 'c$i': PageSlice(
              items: [
                archiveFile(
                  'f$i',
                  tag: i == 5 ? RecordTag.sonuc : RecordTag.girdi,
                ),
              ],
              nextCursor: i == 5 ? null : 'c${i + 1}',
            ),
        };
      final c = _container(repo);
      await c.read(personFilesControllerProvider('acc-9').future);
      repo.calls.clear();
      c.read(archiveControllerProvider.notifier).setTags({
        RecordTag.plan,
        RecordTag.sonuc,
      });
      final p = personFilesControllerProvider('acc-9', filterArchive: true);
      c.listen(p, (_, _) {});
      final result = await c.read(p.future);
      expect(result.files.items, isEmpty);
      expect(result.files.nextCursor, 'c5');
      expect(repo.calls.length, 5);
      await c.read(p.notifier).loadMore();
      expect(c.read(p).value!.files.items.single.id, 'f5');
      expect(c.read(p).value!.files.hasMore, isFalse);
    },
  );

  test('devam hatası dosyaları ve tekrar denenebilir imleci korur', () async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
      };
    final c = _container(repo);
    final p = personFilesControllerProvider('acc-9');
    await c.read(p.future);
    repo.error = ApiError('records.invalid_cursor');
    await c.read(p.notifier).loadMore();
    expect(c.read(p).value!.files.items.single.id, 'f1');
    expect(c.read(p).value!.files.nextCursor, 'c2');
    expect(c.read(p).value!.error?.code, 'records.invalid_cursor');
  });

  test('yeniden okuma uçuşta kalan eski devam sayfasını uygulamaz', () async {
    final repo = _DelayedRepository()
      ..pages = {
        null: PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
      };
    final c = _container(repo);
    final p = personFilesControllerProvider('acc-9');
    await c.read(p.future);
    final pending = c.read(p.notifier).loadMore();
    c.invalidate(p);
    await c.read(p.future);
    repo.more.complete(PageSlice(items: [archiveFile('old')]));
    await pending;
    expect(c.read(p).value!.files.items.single.id, 'f1');
  });
}
