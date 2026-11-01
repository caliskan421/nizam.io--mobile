// Görevler ekranının departman süzgeci (sunucu süzgeci `department_id`, istemci akışları §2):
// paylaşılan katalog HER ZAMAN süzgeçsiz kalır (ana sayfa, zaman çizelgesi); süzgeç yalnız
// görevler görünümünü süzer, süzgeç yokken ek istek yoktur, süzgeçli okuma yalnız görev
// sayfalarını çeker. Geç gelen eski yanıtlar (ters sırada tamamlanan Completer'lar) süzgeç
// durumunu bozmaz; 404 / seçenek dışı süzgeç temizlenir. Yeni görev seçenekleri ve varsayılanı
// görev açılabilen departmanlardır.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/scope/application/home_dashboard_controller.dart';
import 'package:nizamio/features/scope/application/scope_providers.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard_repository.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/application/task_list_filter.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/timeline_controller.dart';

TaskItem _task(String id, String dept) => TaskItem(
  code: id,
  id: id,
  title: 'Görev $id',
  coordinatorship: dept,
  departmentId: dept,
  programId: 'p1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 11),
  due: DateTime(2026, 11, 20),
  assignees: const [],
  lateness: const TaskLateness(),
);

TeamSeat _seat(String dept, SeatRole role, {String program = 'p1'}) => TeamSeat(
  programId: program,
  departmentId: dept,
  departmentName: 'Ad $dept',
  role: role,
);

final _admin = TaskAccess(accountId: 'me', companyAdmin: true, seats: const []);

/// Mixed: d1 üye, d2 koordinatör.
final _mixed = TaskAccess(
  accountId: 'me',
  companyAdmin: false,
  seats: [_seat('d1', SeatRole.member), _seat('d2', SeatRole.coordinator)],
);

/// Paylaşılan katalog kaynağı (süzgeçsiz): w1 (d1), w2 (d2), w3 (d3).
class _Catalog implements TaskCatalogRepository {
  _Catalog(this.access);

  final TaskAccess access;
  int loads = 0;

  @override
  Future<TaskCatalog> load() async {
    loads++;
    return TaskCatalog(
      today: DateTime(2026, 11),
      me: 'me',
      tasks: [_task('w1', 'd1'), _task('w2', 'd2'), _task('w3', 'd3')],
      people: const [Person(id: 'me', name: 'Ayşe', role: PersonRole.member)],
      coordinatorships: const [
        CoordinatorshipRef(code: 'd1', name: 'Ad d1', leads: [], members: []),
        CoordinatorshipRef(code: 'd2', name: 'Ad d2', leads: [], members: []),
        CoordinatorshipRef(code: 'd3', name: 'Ad d3', leads: [], members: []),
      ],
      access: access,
      departments: const [
        TaskDepartment(id: 'd1', name: 'Ad d1'),
        TaskDepartment(id: 'd2', name: 'Ad d2'),
        TaskDepartment(id: 'd3', name: 'Ad d3'),
      ],
    );
  }
}

/// Süzgeçli okuma: her çağrı bir Completer açar (testi sırayı kendisi tamamlar).
class _Pages implements TaskListRepository {
  final List<(String, Completer<TaskListPage>)> calls = [];
  List<String> get asked => [for (final (d, _) in calls) d];

  @override
  Future<TaskListPage> loadTasks(
    String departmentId, {
    bool Function()? isCurrent,
  }) {
    final c = Completer<TaskListPage>();
    calls.add((departmentId, c));
    return c.future;
  }

  void ok(int i, List<TaskItem> tasks) =>
      calls[i].$2.complete(TaskListPage(tasks: tasks));

  void invalid(int i) =>
      calls[i].$2.completeError(ApiError('work.program_scope_invalid'));
}

class _Home implements HomeDashboardRepository {
  @override
  Future<HomeDashboard> load() => throw UnimplementedError('yönetici yolu');

  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) async => const TeamDashboardExtras(unreadMessages: 0);
}

Future<void> _settle() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late ScopeController scope;
  late _Catalog catalog;
  late _Pages pages;

  ProviderContainer harness(TaskAccess access) {
    scope = ScopeController()..selectProgram('p1');
    catalog = _Catalog(access);
    pages = _Pages();
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        scopeControllerProvider.overrideWithValue(scope),
        taskCatalogRepositoryProvider.overrideWithValue(catalog),
        taskListRepositoryProvider.overrideWithValue(pages),
        homeDashboardRepositoryProvider.overrideWithValue(_Home()),
      ],
    );
    addTearDown(c.dispose);
    c
      ..listen(taskCatalogControllerProvider, (_, _) {})
      ..listen(taskListCatalogProvider, (_, _) {});
    return c;
  }

  TaskCatalog view(ProviderContainer c) =>
      c.read(taskListCatalogProvider).value!;
  TaskListFilter filter(ProviderContainer c) =>
      c.read(taskListFilterProvider.notifier);

  test('süzgeç yokken görünüm paylaşılan katalogdur, ek istek yok', () async {
    final c = harness(_admin);
    await c.read(taskCatalogControllerProvider.future);
    await _settle();
    expect(view(c).tasks.map((t) => t.id), ['w1', 'w2', 'w3']);
    expect(view(c).departmentId, isNull);
    expect(pages.asked, isEmpty);
  });

  test(
    'süzgeç: yalnız görev sayfaları okunur (katalog/kimlik yeniden okunmaz); paylaşılan '
    'katalog, ana sayfa toplamı/rol varyantı ve zaman çizelgesi değişmez',
    () async {
      final c = harness(_mixed);
      c
        ..listen(homeDashboardControllerProvider, (_, _) {})
        ..listen(timelineViewProvider(null), (_, _) {});
      final shared = await c.read(taskCatalogControllerProvider.future);
      final homeBefore = await c.read(homeDashboardControllerProvider.future);
      final timelineBefore = c.read(timelineViewProvider(null)).value!;
      expect(homeBefore.tasks.total, 3);
      expect(homeBefore.greetingRole, TeamRole.coordinator);

      filter(c).select('d1');
      await _settle();
      expect(pages.asked, ['d1']);
      expect(c.read(taskListCatalogProvider).isLoading, isTrue);
      pages.ok(0, [_task('w1', 'd1')]);
      await _settle();

      expect(view(c).tasks.map((t) => t.id), ['w1']);
      expect(view(c).departmentId, 'd1');
      expect(
        catalog.loads,
        1,
        reason: '/v1/me, ekip satırları, seçenekler yeniden yok',
      );
      final sharedAfter = c.read(taskCatalogControllerProvider).value!;
      expect(identical(sharedAfter, shared), isTrue);
      expect(sharedAfter.tasks, hasLength(3));
      final homeAfter = await c.read(homeDashboardControllerProvider.future);
      expect(homeAfter.tasks.total, 3);
      expect(homeAfter.greetingRole, TeamRole.coordinator);
      expect(homeAfter.coordinatorships.single.code, 'd2');
      final timelineAfter = c.read(timelineViewProvider(null)).value!;
      expect(timelineAfter.statusCounts, timelineBefore.statusCounts);
    },
  );

  test('katalog yeniden okununca (yazma sonrası reload) süzgeçli liste de yenilenir', () async {
    final c = harness(_admin);
    await c.read(taskCatalogControllerProvider.future);
    filter(c).select('d2');
    await _settle();
    pages.ok(0, [_task('w2', 'd2')]);
    await _settle();
    final reload = c.read(taskCatalogControllerProvider.notifier).reload();
    await _settle();
    expect(pages.asked, ['d2', 'd2']);
    pages.ok(1, [_task('w2', 'd2'), _task('w9', 'd2')]);
    await reload;
    await _settle();
    expect(view(c).tasks.map((t) => t.id), ['w2', 'w9']);
  });

  test('404 work.program_scope_invalid → süzgeç temizlenir, bilgi bayrağı; sonraki '
      'okumada süzgeçli istek yok', () async {
    final c = harness(_admin);
    await c.read(taskCatalogControllerProvider.future);
    filter(c).select('d3');
    await _settle();
    pages.invalid(0);
    await _settle();
    expect(c.read(taskListFilterProvider).departmentId, isNull);
    expect(view(c).departmentFilterCleared, isTrue);
    expect(view(c).tasks, hasLength(3));
    await c.read(taskCatalogControllerProvider.notifier).reload();
    await _settle();
    expect(pages.asked, ['d3']);
  });

  test('seçenekler arasında olmayan süzgeç gönderilmez, temizlenir', () async {
    final c = harness(_admin);
    await c.read(taskCatalogControllerProvider.future);
    filter(c).select('silinmis');
    await _settle();
    expect(pages.asked, isEmpty);
    expect(c.read(taskListFilterProvider).departmentId, isNull);
    expect(view(c).departmentFilterCleared, isTrue);
  });

  test('yarış (a): d1 uçuşta → "tümü" → d1 sonra (404 ya da başarı) biter: süzgeç null '
      'kalır, temizlendi bilgisi yok, sonraki okuma süzgeçsiz', () async {
    for (final late404 in [true, false]) {
      final c = harness(_admin);
      await c.read(taskCatalogControllerProvider.future);
      filter(c).select('d1');
      await _settle();
      filter(c).select(null);
      await _settle();
      expect(view(c).tasks, hasLength(3), reason: 'süzgeçsiz görünüm önce');
      late404 ? pages.invalid(0) : pages.ok(0, [_task('w1', 'd1')]);
      await _settle();
      final st = c.read(taskListFilterProvider);
      expect(st.departmentId, isNull);
      expect(st.cleared, isFalse, reason: 'eski 404 yeni seçimi bozmaz');
      expect(view(c).tasks, hasLength(3), reason: 'eski sayfa görünüme girmez');
      expect(view(c).departmentId, isNull);
      await c.read(taskCatalogControllerProvider.notifier).reload();
      await _settle();
      expect(pages.asked, ['d1'], reason: 'sonraki okuma süzgeçsiz');
    }
  });

  test(
    'yarış (b): P1/d1 uçuşta → P2 seçilir → eski yanıt P2 süzgecini kirletmez',
    () async {
      final c = harness(_admin);
      await c.read(taskCatalogControllerProvider.future);
      filter(c).select('d1');
      await _settle();
      scope.selectProgram('p2');
      await c.read(taskCatalogControllerProvider.future);
      await _settle();
      expect(c.read(taskListFilterProvider).program, 'p2');
      pages.invalid(0);
      await _settle();
      final st = c.read(taskListFilterProvider);
      expect(st.departmentId, isNull);
      expect(st.cleared, isFalse);
      expect(st.program, 'p2');

      // P2'de d2 seçiliyken P1'in geç gelen d2 yanıtı da etkisiz.
      filter(c).select('d2');
      await _settle();
      expect(pages.asked, ['d1', 'd2']);
      pages.ok(1, [_task('w2', 'd2')]);
      await _settle();
      expect(c.read(taskListFilterProvider).departmentId, 'd2');
    },
  );

  test('canCreateTask: yönetici ya da programda bir koordinatörlük; yalnız üye hayır', () async {
    final c = harness(_mixed)..listen(canCreateTaskProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    expect(c.read(canCreateTaskProvider), isTrue);
    filter(c).select('d1');
    await _settle();
    expect(c.read(canCreateTaskProvider), isTrue, reason: 'süzgeçten bağımsız');

    final m = harness(
      TaskAccess(
        accountId: 'me',
        companyAdmin: false,
        seats: [_seat('d1', SeatRole.member)],
      ),
    )..listen(canCreateTaskProvider, (_, _) {});
    await m.read(taskCatalogControllerProvider.future);
    expect(m.read(canCreateTaskProvider), isFalse);
  });

  test('yeni görev: seçenekler yalnız açılabilen departmanlar; hedefsiz sıfırlamada '
      'varsayılan hesaplanan açılabilir departman', () async {
    final c = harness(_mixed)..listen(newTaskFormControllerProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    expect(c.read(newTaskCoordinatorshipsProvider).map((d) => d.code), [
      'd2',
    ], reason: 'karma rol: yalnız koordinatörlük (d1 üyelik listelenmez)');
    c.read(newTaskFormControllerProvider.notifier).prepare();
    expect(c.read(newTaskFormControllerProvider).coordinatorship, 'd2');

    final a = harness(_admin)..listen(newTaskFormControllerProvider, (_, _) {});
    await a.read(taskCatalogControllerProvider.future);
    expect(a.read(newTaskCoordinatorshipsProvider).map((d) => d.code), [
      'd1',
      'd2',
      'd3',
    ], reason: 'yönetici: programın departmanları');
    a.read(newTaskFormControllerProvider.notifier).prepare();
    expect(a.read(newTaskFormControllerProvider).coordinatorship, 'd1');
  });
}
