import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/domain/gantt_schedule.dart';

import '../../connected_module_support.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

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
    test(
      'yalnız etkin koordinatörlüğün Gantt\'ı okunur (GAP-053): $flags',
      () async {
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
        // Varsayılan görünüm koordinatör rolü + ilk koordinatör satırı ('one'); üye satırı
        // ('two') ayrı görünümdür, birleşik okuma yok.
        expect(result.truncated, flags.$1);
        expect(first.calls, 1);
        expect(second.calls, 0);
      },
    );
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
  test(
    'ayrıntı eklemek çizelgeyi yeniden okutmaz; tarih değişikliği okutur',
    () async {
      final backend = CoordBackend();
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final container = h.container;
      container.listen(timelineCatalogProvider, (_, _) {});
      await container.read(taskCatalogControllerProvider.future);
      await container.read(ganttScheduleProvider.future);
      final task = container
          .read(taskCatalogControllerProvider)
          .requireValue
          .task(tAltLate30)!;
      final before = h.backend.count('GET', '/v1/work-items/gantt/admin');
      final controller = container.read(taskCatalogControllerProvider.notifier);
      controller.applyDetails(
        task.code,
        TaskDetails(
          subtasks: const [
            Subtask(id: 's', title: 'Kanıt kontrolü', done: false),
          ],
          notes: const [],
          files: const [],
        ),
      );
      await container.pump();
      expect(h.backend.count('GET', '/v1/work-items/gantt/admin'), before);
      expect(container.read(ganttScheduleProvider).isLoading, isFalse);
      expect(
        container
            .read(timelineCatalogProvider)
            .requireValue
            .task(task.code)!
            .subtasks,
        hasLength(1),
      );

      final changed = task.copyWith(
        due: task.due.add(const Duration(days: 2)),
        datesRevision: 8,
      );
      final wire = backend.workItems.firstWhere(
        (w) => w['work_item_id'] == task.code,
      );
      wire['end_on'] = changed.due.toIso8601String().substring(0, 10);
      wire['dates_revision'] = 8;
      controller.applyDetails(
        task.code,
        TaskDetails(
          item: changed,
          subtasks: const [],
          notes: const [],
          files: const [],
        ),
      );
      await container.read(ganttScheduleProvider.future);
      expect(h.backend.count('GET', '/v1/work-items/gantt/admin'), before + 1);
      expect(
        container
            .read(timelineCatalogProvider)
            .requireValue
            .task(task.code)!
            .due,
        changed.due,
      );
    },
  );

  test('aynı sahipte Gantt yenilemesi çizelgeyi korur; program değişince eski veri silinir', () async {
    final backend = CoordBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    final c = h.container;
    c.listen(timelineCatalogProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    await c.read(ganttScheduleProvider.future);
    final shown = c.read(timelineCatalogProvider).requireValue;
    final release = Completer<void>();
    h.backend.handler = (request) async {
      if (request.path.contains('/gantt')) await release.future;
      return backend.handle(request);
    };
    try {
      await c.read(taskCatalogControllerProvider.notifier).reload();
      final refreshing = c.read(timelineCatalogProvider);
      expect(c.read(ganttScheduleProvider).isLoading, isTrue);
      expect(refreshing.hasValue, isTrue);
      expect(refreshing.requireValue, same(shown));
      h.read(scopeControllerProvider).selectProgram('prog-2');
      expect(c.read(timelineCatalogProvider).value, isNull);
      await expectLater(
        c.read(taskCatalogControllerProvider.future),
        throwsA(isA<ApiError>()),
      );
      expect(c.read(timelineCatalogProvider).value, isNull);
    } finally {
      release.complete();
    }
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
