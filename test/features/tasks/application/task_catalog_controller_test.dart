// TaskCatalogController: bileşim kökündeki örnek kaynaktan katalog; arama yardımcıları.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
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
      reason: 'geçici due (bugün) ile 0 hesaplanmaz',
    );
    expect(after.task('ornek')!.overdueDays, 7);
    expect(ctl, isNotNull);
  });
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
