// Bayat katalog: katalogda olmayan görev kimliği (ör. tablo referansından açılan, katalog
// yüklendikten sonra oluşturulmuş görev) için katalog BİR KEZ yeniden okunur; görev gelince
// ayrıntısı yüklenir. Görev yine yoksa (erişim yok/silinmiş) döngü olmaz.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/application/tasks_providers.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';

TaskItem _item(String code, {String? department}) => TaskItem(
  code: code,
  departmentId: department,
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
  _Catalog(this.later, {this.truncated = false});
  final List<String> later;
  final bool truncated;
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
      access: TaskAccess(
        accountId: 'me',
        companyAdmin: false,
        seats: const [
          TeamSeat(
            programId: 'p1',
            departmentId: 'd1',
            departmentName: 'D1',
            role: SeatRole.member,
          ),
          TeamSeat(
            programId: 'p1',
            departmentId: 'd2',
            departmentName: 'D2',
            role: SeatRole.member,
          ),
        ],
      ),
      truncated: truncated,
    );
  }
}

class _Details implements TaskDetailsRepository {
  final asked = <String>[];
  final probed = <String>[];

  /// Görev [found] kimliği yalnız [foundIn] departmanında okunur; diğerinde 404.
  String? found;
  String? foundIn;

  @override
  Future<TaskDetails> load(TaskItem task, {TaskAccess? access}) async {
    asked.add(task.code);
    return TaskDetails(subtasks: const [], notes: const [], files: const []);
  }

  @override
  Future<TaskItem> loadItem(TaskItem task) async {
    probed.add('${task.code}@${task.departmentId}');
    if (task.code == found && task.departmentId == foundIn) {
      return _item(task.code, department: foundIn);
    }
    throw ApiError('work.item_not_found', status: 404);
  }
}

(ProviderContainer, _Catalog, _Details) _open(
  List<String> later, {
  bool truncated = false,
}) {
  final catalog = _Catalog(later, truncated: truncated);
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

  test('N2: kesik katalog: görev görünür departmanlarda kimlikle aranır, bulununca açılır', () async {
    final (c, catalog, details) = _open(const [], truncated: true);
    details
      ..found = 'w9'
      ..foundIn = 'd2';
    c.listen(taskCatalogControllerProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    c.listen(taskDetailsProvider('w9'), (_, _) {});
    await _settle();
    expect(details.probed, ['w9@d1', 'w9@d2']);
    expect(c.read(taskCatalogControllerProvider).value!.task('w9'), isNotNull);
    expect(details.asked, contains('w9'));
    expect(catalog.loads, 1, reason: 'kesik katalog yeniden okunmaz');
  });
}
