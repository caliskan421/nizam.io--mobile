import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/domain/gantt_schedule.dart';

import '../../connected_module_support.dart';

class _Gantt implements GanttRepository {
  _Gantt(this.schedule);
  final GanttSchedule schedule;
  int calls = 0;
  bool fail = false;
  @override
  Future<GanttSchedule> admin({bool overdueOnly = false}) async {
    calls++;
    if (fail) {
      throw ApiError('client.network_error');
    }
    return schedule;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('görünür küme Gantt yanıtıdır; eşleşen görev sürümleri ve bağlantılar korunur', () async {
    final original = moduleCatalog();
    final extra = TaskItem(
      code: 'extra',
      id: 'extra',
      title: 'Ek görev',
      coordinatorship: 'department',
      departmentId: 'department',
      programId: 'program',
      status: TaskStatus.todo,
      priority: TaskPriority.medium,
      start: DateTime(2026, 11, 1),
      due: DateTime(2026, 11, 20),
      assignees: const [],
    );
    final repository = _Gantt(
      GanttSchedule(
        tasks: [
          original.tasks.single.copyWith(start: DateTime(2026, 11, 2)),
          extra,
        ],
        links: const [
          TaskDependency(id: 'edge', workItemId: 'extra', dependsOnId: 'task'),
        ],
      ),
    );
    final container = moduleContainer(
      overrides: [
        ganttRepositoryProvider.overrideWith((ref, scope) => repository),
      ],
    );
    addTearDown(container.dispose);
    container.listen(timelineCatalogProvider, (_, _) {});
    await container.read(ganttScheduleProvider.future);
    final catalog = container.read(timelineCatalogProvider).requireValue;
    expect(catalog.tasks.map((t) => t.code), ['task', 'extra']);
    expect(catalog.task('task')!.datesRevision, 7);
    expect(catalog.task('task')!.start, DateTime(2026, 11, 2));
    expect(container.read(ganttScheduleProvider).requireValue.dependentIds, {
      'extra',
    });
  });
  test('Gantt hatası görünüm hatasıdır; katalog retry sunucu Gantt okumasını da tekrarlar', () async {
    final repository = _Gantt(GanttSchedule(tasks: const [], links: const []))
      ..fail = true;
    final container = moduleContainer(
      overrides: [
        ganttRepositoryProvider.overrideWith((ref, scope) => repository),
      ],
    );
    addTearDown(container.dispose);
    container.listen(timelineCatalogProvider, (_, _) {});
    await expectLater(
      container.read(ganttScheduleProvider.future),
      throwsA(isA<ApiError>()),
    );
    expect(container.read(timelineCatalogProvider).hasError, isTrue);
    repository.fail = false;
    container.invalidate(taskCatalogControllerProvider);
    await container.read(taskCatalogControllerProvider.future);
    await container.read(ganttScheduleProvider.future);
    expect(container.read(timelineCatalogProvider).requireValue.tasks, isEmpty);
    expect(repository.calls, 2);
  });
}
