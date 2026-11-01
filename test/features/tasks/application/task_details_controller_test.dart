// taskDetails: ayrıntı kaynaktan okunur ve katalogdaki göreve eklenir; kaynak null dönerse
// (örnek kapsam) katalog değişmez; görev yoksa kaynağa gidilmez. Kaynak seçiciler
// (TaskCatalogSource / TaskDetailsSource) kapsama göre sunucu ya da örnek seçer.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/application/task_sources.dart';
import 'package:nizamio/features/tasks/application/tasks_providers.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';

final _task = TaskItem(
  code: 'w1',
  title: 'Hidrofor',
  coordinatorship: 'd1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 7, 2),
  due: DateTime(2026, 9, 20),
  assignees: const [],
  overdueDays: 42,
);

class _Catalog implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    today: DateTime(2026, 11),
    me: 'me',
    tasks: [_task],
    people: const [],
    coordinatorships: const [],
    access: _access,
  );
}

final _access = TaskAccess(
  accountId: 'me',
  companyAdmin: false,
  seats: const [],
);

class _Details implements TaskDetailsRepository {
  _Details(this.result);

  final TaskDetails? result;
  final asked = <String>[];
  final accesses = <TaskAccess?>[];

  @override
  Future<TaskDetails?> load(TaskItem task, {TaskAccess? access}) async {
    asked.add(task.code);
    accesses.add(access);
    return result;
  }

  @override
  Future<TaskItem?> loadItem(TaskItem task) async => null;
}

final _details = TaskDetails(
  subtasks: const [Subtask(id: 's1', title: 'Pompa', done: true)],
  notes: [TaskNote(by: 'u1', at: DateTime(2026, 7, 5), text: 'Not')],
  files: const [
    TaskFile(
      id: 'f1',
      kind: TaskFileKind.pdf,
      name: 'Tutanak.pdf',
      tag: EvidenceTag.output,
      by: 'u1',
      sizeKb: 2,
    ),
  ],
  dateRequest: DateChangeRequest(
    oldDue: DateTime(2026, 9, 20),
    start: DateTime(2026, 7, 2),
    due: DateTime(2026, 11, 10),
  ),
);

ProviderContainer _container(_Details details) {
  final c = ProviderContainer(
    overrides: [
      taskCatalogRepositoryProvider.overrideWithValue(_Catalog()),
      taskDetailsRepositoryProvider.overrideWithValue(details),
      scopeStateProvider.overrideWith(
        (ref) => const ScopeSelection(programId: 'p1'),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  test(
    'ayrıntı katalogdaki göreve eklenir; gecikme korunur; rol katalogdan',
    () async {
      final details = _Details(_details);
      final c = _container(details);
      c.listen(taskDetailsProvider('w1'), (_, _) {});
      await c.read(taskDetailsProvider('w1').future);
      expect(details.asked, ['w1']);
      expect(details.accesses.single, same(_access));
      final t = c.read(taskCatalogControllerProvider).value!.task('w1')!;
      expect(t.subtasks.single.title, 'Pompa');
      expect(t.noteEntries.single.text, 'Not');
      expect(t.notes, 1);
      expect(t.fileEntries.single.name, 'Tutanak.pdf');
      expect(t.files, 1);
      expect(t.dateRequest!.due, DateTime(2026, 11, 10));
      expect(t.overdueDays, 42);
    },
  );

  test('katalog yeniden kurulunca ayrıntı yeniden okunur ve yeni kataloğa eklenir (döngü yok)', () async {
    final details = _Details(_details);
    final c = _container(details);
    c.listen(taskDetailsProvider('w1'), (_, _) {});
    await c.read(taskDetailsProvider('w1').future);
    expect(details.asked, ['w1']);

    c.invalidate(taskCatalogControllerProvider);
    await c.read(taskCatalogControllerProvider.future);
    await c.read(taskDetailsProvider('w1').future);
    final t = c.read(taskCatalogControllerProvider).value!.task('w1')!;
    expect(t.subtasks.single.title, 'Pompa', reason: 'ayrıntı kaybolmaz');
    expect(t.fileEntries, hasLength(1));
    expect(details.asked, ['w1', 'w1']);

    // applyDetails yükleme üretmez: kendiliğinden ek okuma yok.
    await Future<void>.delayed(Duration.zero);
    await c.read(taskDetailsProvider('w1').future);
    expect(details.asked, ['w1', 'w1']);
  });

  test('kaynak null dönerse katalog değişmez', () async {
    final c = _container(_Details(null));
    c.listen(taskDetailsProvider('w1'), (_, _) {});
    await c.read(taskDetailsProvider('w1').future);
    final t = c.read(taskCatalogControllerProvider).value!.task('w1')!;
    expect(t.subtasks, isEmpty);
    expect(t.dateRequest, isNull);
  });

  test('görev katalogda yoksa kaynağa gidilmez', () async {
    final details = _Details(_details);
    final c = _container(details);
    c.listen(taskDetailsProvider('yok'), (_, _) {});
    await c.read(taskDetailsProvider('yok').future);
    expect(details.asked, isEmpty);
  });

  group('kaynak seçiciler', () {
    late ScopeController scope;
    var bound = true;
    final server = _Details(_details);
    setUp(() {
      scope = ScopeController();
      bound = true;
      server.asked.clear();
    });

    test(
      'katalog: sunucu programında sunucu, örnek/boş kapsamda örnek',
      () async {
        final sample = TaskCatalog(
          today: DateTime(2026),
          me: 'örnek',
          tasks: const [],
          people: const [],
          coordinatorships: const [],
        );
        final source = TaskCatalogSource(
          scope: scope,
          server: () => bound ? _Catalog() : null,
          sample: _Fixed(sample),
        );
        expect((await source.load()).me, 'örnek');
        scope.selectSample();
        expect((await source.load()).me, 'örnek');
        scope.selectProgram('p1');
        expect((await source.load()).me, 'me');
        bound = false;
        await expectLater(source.load(), _notVerified);
      },
    );

    test('ayrıntı: örnek kapsamda null, sunucu programında sunucu', () async {
      final source = TaskDetailsSource(
        scope: scope,
        server: () => bound ? server : null,
      );
      scope.selectSample();
      expect(await source.load(_task), isNull);
      expect(server.asked, isEmpty);
      scope.selectProgram('p1');
      expect(await source.load(_task), same(_details));
      bound = false;
      await expectLater(source.load(_task), _notVerified);
    });
  });
}

final _notVerified = throwsA(
  isA<ApiError>().having(
    (e) => e.code,
    'code',
    ClientErrorCode.serverNotVerified,
  ),
);

class _Fixed implements TaskCatalogRepository {
  _Fixed(this.catalog);

  final TaskCatalog catalog;

  @override
  Future<TaskCatalog> load() async => catalog;
}
