import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_lifecycle_controller.dart';
import 'package:nizamio/features/tasks/domain/work_item_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

class _Deleted implements DeletedWorkItemRepository {
  final more = Completer<PageSlice<DeletedTask>>();
  @override
  Future<PageSlice<DeletedTask>> list([
    PageRequest page = const PageRequest(),
  ]) async {
    if (page.cursor != null) {
      return more.future;
    }
    return PageSlice(items: [], nextCursor: 'cursor');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

DeletedTask _deleted(String id) => DeletedTask(
  id: id,
  title: id,
  departmentId: 'd',
  status: TaskStatus.todo,
  deletedAt: DateTime(2026),
  fileCount: 0,
);

class _Purgeable implements DeletedWorkItemRepository {
  final purged = <String>[];
  @override
  Future<PageSlice<DeletedTask>> list([
    PageRequest page = const PageRequest(),
  ]) async => PageSlice(items: [_deleted('a'), _deleted('b')]);

  @override
  Future<int> purge(String id) async {
    purged.add(id);
    return 3;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'geç gelen silinen görev sayfası başka programın listesine eklenmez',
    () async {
      final repository = _Deleted();
      final container = moduleContainer(
        overrides: [
          deletedTasksRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.listen(deletedTasksProvider, (_, _) {});
      await container.read(deletedTasksProvider.future);
      final loading = container.read(deletedTasksProvider.notifier).loadMore();
      container.read(scopeControllerProvider).selectProgram('other');
      await container.pump();
      repository.more.complete(
        PageSlice(
          items: [
            DeletedTask(
              id: 'old',
              title: 'Eski',
              departmentId: 'd',
              status: TaskStatus.todo,
              deletedAt: DateTime(2026),
              fileCount: 0,
            ),
          ],
        ),
      );
      await loading;
      final page = await container.read(deletedTasksProvider.future);
      expect(page.items, isEmpty);
    },
  );
  test('yönetici tek başına bağımlılık değiştiremez', () async {
    final container = moduleContainer();
    addTearDown(container.dispose);
    await container.read(taskCatalogControllerProvider.future);
    await expectLater(
      container
          .read(taskDependencyCommandProvider.notifier)
          .change('task', addTaskId: 'other'),
      throwsA(isA<ApiError>()),
    );
  });
  test(
    'kalıcı silinen görev listeden düşer, silinen dosya sayısı döner',
    () async {
      final repository = _Purgeable();
      final container = moduleContainer(
        overrides: [
          deletedTasksRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.listen(deletedTasksProvider, (_, _) {});
      final page = await container.read(deletedTasksProvider.future);
      final files = await container
          .read(deletedTasksProvider.notifier)
          .purge(page.items.first);
      expect(files, 3);
      expect(repository.purged, ['a']);
      final after = await container.read(deletedTasksProvider.future);
      expect(after.items.map((t) => t.id), ['b']);
    },
  );
}
