// TaskCatalogController: bileşim kökündeki örnek kaynaktan katalog; arama yardımcıları.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_list_filter.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';
import 'package:nizamio/features/tasks/tasks.dart';

void main() {
  test('oturum değişince başarısız okuma önceki kataloğu taşımaz', () async {
    final h = _OwnershipHarness();
    addTearDown(h.container.dispose);
    final first = await _Server().load();
    h.server.requests.single.complete(first);
    await h.container.read(taskCatalogControllerProvider.future);

    h.changeSession();
    expect(h.state.isLoading, isTrue);
    expect(h.state.hasValue, isFalse);
    expect(
      h.states.last.hasValue,
      isFalse,
      reason: 'dinleyiciler de temiz durumu görür',
    );
    final pending = h.container.read(taskCatalogControllerProvider.future);
    final check = expectLater(pending, throwsStateError);
    h.server.requests.last.completeError(StateError('yeni oturum'));
    await check;
    expect(h.state, isA<AsyncError<TaskCatalog>>());
    expect(h.state.hasError, isTrue);
    expect(h.state.isLoading, isFalse);
    expect(h.state.hasValue, isFalse);
    expect(h.state.value, isNull);
  });

  test('program değişince okuma sürerken önceki katalog görünmez', () async {
    final h = _OwnershipHarness();
    addTearDown(h.container.dispose);
    h.server.requests.single.complete(await _Server().load());
    await h.container.read(taskCatalogControllerProvider.future);

    h.program = 'p2';
    h.container.invalidate(scopeStateProvider);
    expect(h.state, isA<AsyncLoading<TaskCatalog>>());
    expect(h.states.last, isA<AsyncLoading<TaskCatalog>>());
    expect(h.states.last.hasValue, isFalse);
    expect(h.state.isLoading, isTrue);
    expect(h.state.hasValue, isFalse);
    expect(h.state.value, isNull);
    final next = await _Counting(() {}, () => 'd2').load();
    h.server.requests.last.complete(next);
    expect(
      await h.container.read(taskCatalogControllerProvider.future),
      same(next),
    );
  });

  for (final oldFirst in [true, false]) {
    test(
      'geç eski yanıt yeni sahibine yazılmaz (eski önce: $oldFirst)',
      () async {
        final h = _OwnershipHarness();
        addTearDown(h.container.dispose);
        final oldRequest = h.server.requests.single;
        h.changeSession();
        expect(h.state.hasValue, isFalse);
        expect(h.server.requests, hasLength(2));
        final old = await _Server().load();
        if (oldFirst) {
          oldRequest.complete(old);
          await h.container.pump();
          expect(h.state.isLoading, isTrue);
          expect(h.state.hasValue, isFalse);
        }
        final next = await _Counting(() {}, () => 'd2').load();
        h.server.requests.last.complete(next);
        await h.container.read(taskCatalogControllerProvider.future);
        if (!oldFirst) {
          oldRequest.complete(old);
          await h.container.pump();
        }
        expect(h.state.value, same(next));
      },
    );
  }

  test('applyDetails: tekil okuma kalemin yerine geçer (yalnız o kalem), adlar dizine katılır', () async {
    final c = ProviderContainer(
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => 1),
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

  test('paylaşılan katalog süzgeçsiz: görevler ekranının departman süzgeci ve kapsam '
      'departmanı kataloğu yeniden okutmaz', () async {
    final scope = ScopeController()..selectProgram('p1');
    var loads = 0;
    final c = ProviderContainer(
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => 1),
        scopeControllerProvider.overrideWithValue(scope),
        taskCatalogRepositoryProvider.overrideWithValue(
          _Counting(() => loads++, () => null),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    c.read(taskListFilterProvider.notifier).select('d2');
    await Future<void>.delayed(Duration.zero);
    await c.read(taskCatalogControllerProvider.future);
    expect(loads, 1);
  });

  test('refresh: eski katalog yenilenirken ve hatada durumda kalır; hata fırlatılır, reload yutar', () async {
    var loads = 0;
    var fail = false;
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => 1),
        scopeStateProvider.overrideWith(
          (ref) => const ScopeSelection(programId: 'p1'),
        ),
        taskCatalogRepositoryProvider.overrideWithValue(
          _Counting(() {
            loads++;
            if (fail) throw StateError('ağ');
          }, () => null),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    final first = await c.read(taskCatalogControllerProvider.future);
    final ctl = c.read(taskCatalogControllerProvider.notifier);

    final pending = ctl.refresh();
    expect(c.read(taskCatalogControllerProvider).isRefreshing, isTrue);
    expect(c.read(taskCatalogControllerProvider).value, same(first));
    await pending;
    expect(loads, 2);

    fail = true;
    await expectLater(ctl.refresh(), throwsA(isA<StateError>()));
    final failed = c.read(taskCatalogControllerProvider);
    expect(failed.hasError, isTrue);
    expect(failed.hasValue, isTrue, reason: 'görünür veri silinmez');
    await ctl.reload(); // hata yutulur
    expect(loads, 4);

    // Hata sonrası otomatik yol (yeniden ziyaret) okumaz; yeniden deneme kullanıcıdan.
    fail = false;
    await ctl.refreshIfStale(maxAge: Duration.zero);
    expect(loads, 4);
    await ctl.refresh();
    expect(loads, 5);
    // Yeniden ziyaret: taze değilse (maxAge 0) okur; zaten taze ise okumaz.
    await ctl.refreshIfStale(maxAge: Duration.zero);
    expect(loads, 6);
    await ctl.refreshIfStale();
    expect(loads, 6);
    c.invalidate(taskCatalogControllerProvider);
    await c.read(taskCatalogControllerProvider.future);
    expect(loads, 7, reason: 'dışarıdan yeniden dene asıl okumayı yeniler');
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

class _OwnershipHarness {
  _OwnershipHarness() {
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => session),
        scopeStateProvider.overrideWith(
          (ref) => ScopeSelection(programId: program),
        ),
        taskCatalogRepositoryProvider.overrideWithValue(server),
      ],
    );
    container.listen(
      taskCatalogControllerProvider,
      (_, next) => states.add(next),
    );
  }

  final states = <AsyncValue<TaskCatalog>>[];
  var session = 1;
  var program = 'p1';
  final server = _PendingServer();
  late final ProviderContainer container;

  AsyncValue<TaskCatalog> get state =>
      container.read(taskCatalogControllerProvider);

  void changeSession() {
    session++;
    container.invalidate(sessionGenerationProvider);
  }
}

class _PendingServer implements TaskCatalogRepository {
  final requests = <Completer<TaskCatalog>>[];

  @override
  Future<TaskCatalog> load() {
    final request = Completer<TaskCatalog>();
    requests.add(request);
    return request.future;
  }
}
