// Bayat katalog: katalogda olmayan görev kimliği (ör. tablo referansından açılan, katalog
// yüklendikten sonra oluşturulmuş görev) için katalog BİR KEZ yeniden okunur; görev gelince
// ayrıntısı yüklenir. Görev yine yoksa (erişim yok/silinmiş) döngü olmaz.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/application/tasks_providers.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';

TaskItem _item(String code) => TaskItem(
  code: code,
  title: 'Görev $code',
  coordinatorship: 'd1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 11),
  due: DateTime(2026, 12),
  assignees: const [],
);

/// İlk okumada yalnız w1; sonraki okumalarda [later] kodları da gelir.
class _Catalog implements TaskCatalogRepository {
  _Catalog(this.later);
  final List<String> later;
  var loads = 0;

  @override
  Future<TaskCatalog> load() async {
    loads++;
    return TaskCatalog(
      today: DateTime(2026, 11),
      me: 'me',
      tasks: [_item('w1'), if (loads > 1) ...later.map(_item)],
      people: const [],
      coordinatorships: const [],
      access: TaskAccess(accountId: 'me', companyAdmin: false, seats: const []),
    );
  }
}

class _Details implements TaskDetailsRepository {
  final asked = <String>[];

  @override
  Future<TaskDetails> load(TaskItem task, {TaskAccess? access}) async {
    asked.add(task.code);
    return TaskDetails(subtasks: const [], notes: const [], files: const []);
  }

  @override
  Future<TaskItem> loadItem(TaskItem task) async => task;
}

(ProviderContainer, _Catalog, _Details) _open(List<String> later) {
  final catalog = _Catalog(later);
  final details = _Details();
  final c = ProviderContainer(
    overrides: [
      sessionGenerationProvider.overrideWith((ref) => 1),
      taskCatalogRepositoryProvider.overrideWithValue(catalog),
      taskDetailsRepositoryProvider.overrideWithValue(details),
      scopeStateProvider.overrideWith(
        (ref) => const ScopeSelection(programId: 'p1'),
      ),
    ],
  );
  addTearDown(c.dispose);
  return (c, catalog, details);
}

Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await pumpEventQueue();
  }
}

void main() {
  test(
    'katalogda olmayan yeni görev: katalog bir kez yenilenir, ayrıntı yüklenir',
    () async {
      final (c, catalog, details) = _open(['w9']);
      c.listen(taskCatalogControllerProvider, (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      c.listen(taskDetailsProvider('w9'), (_, _) {});
      await _settle();
      expect(catalog.loads, 2);
      expect(
        c.read(taskCatalogControllerProvider).value!.task('w9'),
        isNotNull,
      );
      expect(details.asked, contains('w9'));
    },
  );

  test('görev yenilemeden sonra da yoksa döngü yok (tek ek okuma)', () async {
    final (c, catalog, details) = _open(const []);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    c.listen(taskDetailsProvider('yok'), (_, _) {});
    await _settle();
    expect(catalog.loads, 2);
    expect(details.asked, isEmpty);
  });
}
