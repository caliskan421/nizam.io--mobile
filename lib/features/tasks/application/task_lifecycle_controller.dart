import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import '../domain/work_item.dart';
import '../domain/work_item_repository.dart';
import 'task_catalog_controller.dart';
import 'task_details_controller.dart';

final deletedTasksRepositoryProvider = Provider<DeletedWorkItemRepository>(
  (ref) => throw UnimplementedError(),
);
final taskDependencyRepositoryProvider =
    Provider.family<WorkItemDependencyRepository, TaskItem>(
      (ref, task) => throw UnimplementedError(),
    );
final deletedTasksProvider =
    AsyncNotifierProvider.autoDispose<
      DeletedTasksController,
      PageSlice<DeletedTask>
    >(DeletedTasksController.new);
final taskDependenciesProvider = FutureProvider.autoDispose
    .family<TaskDependencies, String>((ref, code) async {
      ref.watch(sessionGenerationProvider);
      ref.watch(scopeStateProvider);
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      final task = catalog.task(code);
      if (task == null) throw ApiError('work.item_not_found');
      return ref.watch(taskDependencyRepositoryProvider(task)).list(task.id);
    });

class DeletedTasksController extends AsyncNotifier<PageSlice<DeletedTask>> {
  bool _busy = false;
  @override
  Future<PageSlice<DeletedTask>> build() async {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    final catalog = await ref.watch(taskCatalogControllerProvider.future);
    if (catalog.access?.companyAdmin != true) {
      throw ApiError('work.not_authorized');
    }
    return ref.watch(deletedTasksRepositoryProvider).list();
  }

  Future<void> loadMore() async {
    final old = state.value;
    if (_busy || old?.nextCursor == null) return;
    _busy = true;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    try {
      final page = await ref
          .read(deletedTasksRepositoryProvider)
          .list(PageRequest(cursor: old!.nextCursor));
      if (!ref.mounted ||
          session != ref.read(sessionGenerationProvider) ||
          scope != ref.read(scopeStateProvider)) {
        return;
      }
      state = AsyncData(
        PageSlice(
          items: [...old.items, ...page.items],
          nextCursor: page.nextCursor,
        ),
      );
    } finally {
      _busy = false;
    }
  }

  Future<void> restore(DeletedTask task) async {
    if (_busy) return;
    _busy = true;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    try {
      await ref.read(deletedTasksRepositoryProvider).restore(task.id);
      if (!ref.mounted ||
          session != ref.read(sessionGenerationProvider) ||
          scope != ref.read(scopeStateProvider)) {
        return;
      }
      ref.invalidateSelf();
      await ref.read(taskCatalogControllerProvider.notifier).reload();
    } finally {
      _busy = false;
    }
  }
}

final taskDependencyCommandProvider =
    NotifierProvider.autoDispose<TaskDependencyCommandController, bool>(
      TaskDependencyCommandController.new,
    );

class TaskDependencyCommandController extends Notifier<bool> {
  @override
  bool build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return false;
  }

  Future<void> change(
    String code, {
    String? addTaskId,
    String? removeEdgeId,
  }) async {
    if (state) return;
    final catalog = ref.read(taskCatalogControllerProvider).value;
    final task = catalog?.task(code);
    // WORK-K34: şirket yöneticisi tek başına bağımlılık değiştiremez.
    if (task == null ||
        !TaskPermissions.of(catalog?.access, task).coordinator) {
      throw ApiError('work.not_authorized');
    }
    state = true;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    try {
      final repository = ref.read(taskDependencyRepositoryProvider(task));
      if (addTaskId != null) {
        await repository.add(task.id, addTaskId);
      }
      if (removeEdgeId != null) {
        await repository.remove(task.id, removeEdgeId);
      }
    } finally {
      if (ref.mounted &&
          session == ref.read(sessionGenerationProvider) &&
          scope == ref.read(scopeStateProvider)) {
        state = false;
        ref.invalidate(taskDependenciesProvider(code));
        ref.invalidate(taskDetailsProvider(code));
        await ref.read(taskCatalogControllerProvider.notifier).reload();
      }
    }
  }
}
