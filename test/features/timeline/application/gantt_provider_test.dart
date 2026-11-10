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
  Future<GanttSchedule> coordinator() => admin();

  @override
  Future<GanttSchedule> member() => admin();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final flags in [(true, false), (false, true)]) {
    test('iki koltuğun kesilmesi OR ile birleşir: $flags', () async {
      final original = moduleCatalog();
      final catalog = TaskCatalog(
        today: original.today,
        me: original.me,
        tasks: original.tasks,
        people: original.people,
        coordinatorships: original.coordinatorships,
        access: TaskAccess(
          accountId: 'me',
          companyAdmin: false,
          seats: const [
            TeamSeat(
              programId: 'program',
              departmentId: 'one',
              departmentName: 'Bir',
              role: SeatRole.coordinator,
            ),
            TeamSeat(
              programId: 'program',
              departmentId: 'two',
              departmentName: 'İki',
              role: SeatRole.member,
            ),
          ],
        ),
      );
      final first = _Gantt(
        GanttSchedule(tasks: const [], links: const [], truncated: flags.$1),
      );
      final second = _Gantt(
        GanttSchedule(tasks: const [], links: const [], truncated: flags.$2),
      );
      final container = moduleContainer(
        catalog: catalog,
        overrides: [
          ganttRepositoryProvider.overrideWith(
            (ref, scope) => scope.department == 'one' ? first : second,
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = await container.read(ganttScheduleProvider.future);
      expect(result.truncated, isTrue);
      expect(first.calls, 1);
      expect(second.calls, 1);
    });
  }
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
        truncated: true,
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
    expect(catalog.truncated, isTrue);
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
