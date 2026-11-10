import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/session/session_controller.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/tasks/tasks.dart';

TaskCatalog moduleCatalog({bool admin = true, bool coordinator = false}) =>
    TaskCatalog(
      today: DateTime(2026, 11, 9),
      me: 'me',
      access: TaskAccess(
        accountId: 'me',
        companyAdmin: admin,
        seats: [
          TeamSeat(
            programId: 'program',
            departmentId: 'department',
            departmentName: 'Ekip',
            role: coordinator ? SeatRole.coordinator : SeatRole.member,
          ),
        ],
      ),
      tasks: [
        TaskItem(
          code: 'task',
          title: 'Görev',
          coordinatorship: 'department',
          departmentId: 'department',
          programId: 'program',
          status: TaskStatus.todo,
          priority: TaskPriority.medium,
          start: DateTime(2026, 11, 1),
          due: DateTime(2026, 11, 20),
          assignees: const ['me'],
          editRevision: 3,
          datesRevision: 7,
        ),
      ],
      people: const [],
      coordinatorships: const [
        CoordinatorshipRef(
          code: 'department',
          name: 'Ekip',
          leads: [],
          members: [],
        ),
      ],
    );

class TestCatalog extends TaskCatalogController {
  TestCatalog(this.catalog);
  final TaskCatalog catalog;
  @override
  Future<TaskCatalog> build() async {
    ref.watch(scopeStateProvider);
    return catalog;
  }
}

ProviderContainer moduleContainer({
  List<Override> overrides = const [],
  TaskCatalog? catalog,
}) {
  final scope = ScopeController()..selectProgram('program');
  return ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      scopeControllerProvider.overrideWithValue(scope),
      sessionGenerationProvider.overrideWithValue(1),
      sessionControllerProvider.overrideWithValue(
        SessionController(
          TokenStore(MemorySecureStore()),
          (_, _) async => throw StateError('unexpected refresh'),
        ),
      ),
      taskCatalogControllerProvider.overrideWith(
        () => TestCatalog(catalog ?? moduleCatalog()),
      ),
      ...overrides,
    ],
  );
}
