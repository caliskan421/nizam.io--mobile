// TaskCatalogController: bileşim kökündeki örnek kaynaktan katalog; arama yardımcıları.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

void main() {
  test(
    'örnek katalog: 76 görev, 11 koordinatörlük, prototip kişileri',
    () async {
      final h = await pilotHarness(PilotBackend());
      h.container.listen(taskCatalogControllerProvider, (_, _) {});
      final c = await h.container.read(taskCatalogControllerProvider.future);
      expect(c.tasks, hasLength(76));
      expect(c.coordinatorships, hasLength(11));
      expect(c.person(c.me)?.name, 'Muhammet Ali Çalışkan');
      expect(c.task('ALT-7')?.coordinatorship, 'ALT');
      expect(c.coordinatorship('ALT')?.leads, ['aa', 'av']);
      expect(c.tasksOf('ALT'), hasLength(13));
      expect(c.tasks.where((t) => t.isOverdue), isNotEmpty);
      expect(c.task('YOK'), isNull);
    },
  );

  test('replace: sunucu görevinde gecikme sunucu değeri korunur; örnekte yeniden hesaplanır', () async {
    final c = ProviderContainer(
      overrides: [
        taskCatalogRepositoryProvider.overrideWithValue(_Server()),
        scopeStateProvider.overrideWith(
          (ref) => const ScopeSelection(programId: 'p1'),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    final catalog = await c.read(taskCatalogControllerProvider.future);
    final ctl = c.read(taskCatalogControllerProvider.notifier)
      ..replace(catalog.task('w1')!.copyWith(title: 'Yeni ad'))
      ..replace(catalog.task('ornek')!.copyWith(due: DateTime(2026, 10, 25)));
    final after = c.read(taskCatalogControllerProvider).value!;
    expect(after.task('w1')!.title, 'Yeni ad');
    expect(
      after.task('w1')!.overdueDays,
      9,
      reason: 'sunucu gecikmesi tarihten yeniden hesaplanmaz',
    );
    expect(after.task('ornek')!.overdueDays, 7);
    expect(ctl, isNotNull);
  });

  test('applyDetails: tekil okuma kalemin yerine geçer (yalnız o kalem), adlar dizine katılır', () async {
    final c = ProviderContainer(
      overrides: [
        taskCatalogRepositoryProvider.overrideWithValue(_Server()),
        scopeStateProvider.overrideWith(
          (ref) => const ScopeSelection(programId: 'p1'),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    final before = await c.read(taskCatalogControllerProvider.future);
    c
        .read(taskCatalogControllerProvider.notifier)
        .applyDetails(
          'w1',
          TaskDetails(
            subtasks: const [],
            notes: const [],
            files: const [],
            item: TaskItem(
              code: 'w1',
              title: 'Sunucu (güncel)',
              coordinatorship: 'd1',
              status: TaskStatus.review,
              priority: TaskPriority.high,
              start: DateTime(2026, 10, 3),
              due: DateTime(2026, 10, 22),
              assignees: const ['u2'],
              description: 'Açıklama',
              lateness: const TaskLateness(isOverdue: true, daysOverdue: 10),
              overdueDays: 10,
            ),
            names: const [PersonName('u2', 'Ali Veli')],
          ),
        );
    final after = c.read(taskCatalogControllerProvider).value!;
    final w1 = after.task('w1')!;
    expect(w1.title, 'Sunucu (güncel)');
    expect(w1.status, TaskStatus.review);
    expect(w1.start, DateTime(2026, 10, 3));
    expect(w1.due, DateTime(2026, 10, 22));
    expect(w1.description, 'Açıklama');
    expect(w1.overdueDays, 10, reason: 'sunucu gecikmesi');
    expect(after.nameOf('u2'), 'Ali Veli');
    expect(after.nameOf('u9'), isNull, reason: 'bilinmeyen → nötr etiket');
    expect(
      identical(after.task('ornek'), before.task('ornek')),
      isTrue,
      reason: 'diğer kalemler değişmez',
    );
  });

  test('selectDepartment: kapsamı değiştirir, katalog yeniden okunur; aynı departman no-op', () async {
    final scope = ScopeController()..selectProgram('p1');
    var loads = 0;
    final c = ProviderContainer(
      overrides: [
        scopeControllerProvider.overrideWithValue(scope),
        taskCatalogRepositoryProvider.overrideWithValue(
          _Counting(() => loads++, () => scope.current.departmentId),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    expect(loads, 1);
    c.read(taskCatalogControllerProvider.notifier).selectDepartment('d1');
    expect(scope.current.departmentId, isNull, reason: 'zaten seçili: no-op');
    c.read(taskCatalogControllerProvider.notifier).selectDepartment('d2');
    expect(scope.current.departmentId, 'd2');
    expect(scope.current.programId, 'p1');
    final next = await c.read(taskCatalogControllerProvider.future);
    expect(loads, 2);
    expect(next.departmentId, 'd2');
  });
}

class _Counting implements TaskCatalogRepository {
  _Counting(this.onLoad, this.department);

  final void Function() onLoad;
  final String? Function() department;

  @override
  Future<TaskCatalog> load() async {
    onLoad();
    return TaskCatalog(
      today: DateTime(2026, 11),
      me: 'me',
      tasks: const [],
      people: const [],
      coordinatorships: const [],
      access: TaskAccess(accountId: 'me', companyAdmin: true, seats: const []),
      departmentId: department() ?? 'd1',
      departments: const [
        TaskDepartment(id: 'd1', name: 'Altyapı', code: 'ALT'),
        TaskDepartment(id: 'd2', name: 'Bilişim'),
      ],
    );
  }
}

class _Server implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    today: DateTime(2026, 11),
    me: 'me',
    tasks: [
      TaskItem(
        code: 'w1',
        title: 'Sunucu',
        coordinatorship: 'd1',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        start: DateTime(2026, 11),
        due: DateTime(2026, 11),
        assignees: const [],
        lateness: const TaskLateness(isOverdue: true, daysOverdue: 9),
        overdueDays: 9,
      ),
      TaskItem(
        code: 'ornek',
        title: 'Örnek',
        coordinatorship: 'd1',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        start: DateTime(2026, 10),
        due: DateTime(2026, 10, 20),
        assignees: const [],
      ),
    ],
    people: const [],
    coordinatorships: const [],
  );
}
