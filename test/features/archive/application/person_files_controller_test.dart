import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
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
