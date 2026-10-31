// HomeDashboardController: özet bileşim kökündeki kaynaktan okunur; kapsam değişince yeniden
// okunur. Rol → kaynak: yönetici pano yolu (load); koordinatör/üye yönetici yolunu ÇAĞIRMAZ,
// özet görev kataloğundan sayılır + loadTeamExtras (koordinatör bayrağı, departman).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/scope/application/home_dashboard_controller.dart';
import 'package:nizamio/features/scope/application/scope_providers.dart';
import 'package:nizamio/features/scope/data/sample/sample_home_dashboard_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

class _Counting implements HomeDashboardRepository {
  var loads = 0;
  final extras = <(String?, bool)>[];
  final _inner = SampleHomeDashboardRepository();

  @override
  Future<HomeDashboard> load() {
    loads++;
    return _inner.load();
  }

  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) async {
    extras.add((departmentId, coordinator));
    return TeamDashboardExtras(
      unreadMessages: 4,
      pendingDateRequests: [
        if (coordinator)
          PendingDateRequest(
            workItemId: 'w2',
            oldEnd: DateTime(2026, 11, 10),
            newEnd: DateTime(2026, 11, 13),
          ),
      ],
    );
  }
}

void main() {
  test('bileşim kökündeki örnek kaynak bağlı; ağ isteği yok', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    final before = h.backend.requests.length;
    h.container.listen(homeDashboardControllerProvider, (_, _) {});
    final d = await h.container.read(homeDashboardControllerProvider.future);
    expect(d.coordinatorships, hasLength(11));
    expect(h.backend.requests.length, before);
  });

  test('kapsam değişince yeniden okunur', () async {
    final repo = _Counting();
    var program = 0;
    final c = ProviderContainer(
      overrides: [
        homeDashboardRepositoryProvider.overrideWithValue(repo),
        scopeStateProvider.overrideWith(
          (ref) => ScopeSelection(programId: 'p${program++}'),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(homeDashboardControllerProvider, (_, _) {});
    await c.read(homeDashboardControllerProvider.future);
    expect(repo.loads, 1);
    c.invalidate(scopeStateProvider);
    await c.read(homeDashboardControllerProvider.future);
    expect(repo.loads, 2);
  });

  group('rol → kaynak', () {
    TaskItem task(String id, TaskStatus status, {bool late = false}) =>
        TaskItem(
          code: id,
          title: 'Görev $id',
          coordinatorship: 'd1',
          departmentId: 'd1',
          status: status,
          priority: TaskPriority.medium,
          start: DateTime(2026, 11),
          due: DateTime(2026, 11),
          assignees: const [],
          lateness: TaskLateness(isOverdue: late, daysOverdue: late ? 3 : 0),
          overdueDays: late ? 3 : 0,
        );

    Future<(HomeDashboard, _Counting)> run({
      bool admin = false,
      SeatRole role = SeatRole.member,
    }) async {
      final repo = _Counting();
      final catalog = TaskCatalog(
        today: DateTime(2026, 11),
        me: 'me',
        departmentId: 'd1',
        access: TaskAccess(
          accountId: 'me',
          companyAdmin: admin,
          seats: [
            TeamSeat(
              programId: 'p1',
              departmentId: 'd1',
              departmentName: 'Altyapı',
              role: role,
            ),
          ],
        ),
        tasks: [
          task('w1', TaskStatus.inProgress),
          task('w2', TaskStatus.inProgress, late: true),
          task('w3', TaskStatus.review),
          task('w4', TaskStatus.done),
          task('w5', TaskStatus.todo),
        ],
        people: const [Person(id: 'me', name: 'Ayşe', role: PersonRole.member)],
        coordinatorships: const [
          CoordinatorshipRef(
            code: 'd1',
            name: 'Altyapı',
            leads: [],
            members: [],
          ),
        ],
      );
      final c = ProviderContainer(
        overrides: [
          homeDashboardRepositoryProvider.overrideWithValue(repo),
          taskCatalogRepositoryProvider.overrideWithValue(_Fixed(catalog)),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(homeDashboardControllerProvider, (_, _) {});
      return (await c.read(homeDashboardControllerProvider.future), repo);
    }

    test('yönetici: pano yolu; ekip yolu yok', () async {
      final (_, repo) = await run(admin: true, role: SeatRole.coordinator);
      expect(repo.loads, 1);
      expect(repo.extras, isEmpty);
    });

    test('üye: yönetici yolu çağrılmaz; sayılar katalogdan, ekip kutusu yok, bekleyen yok', () async {
      final (d, repo) = await run();
      expect(repo.loads, 0, reason: 'yönetici rapor uçlarına istek 0');
      expect(repo.extras, [('d1', false)]);
      expect(d.team, isNull);
      expect(d.greetingRole, TeamRole.member);
      expect(d.greetingName, 'Ayşe');
      expect(
        (d.tasks.total, d.tasks.done, d.tasks.inProgress, d.tasks.late),
        (5, 1, 2, 1),
      );
      expect(d.tasks.inProgressOnTime, 1);
      expect(d.tasks.awaitingApproval, 1);
      expect(d.pending, isEmpty);
      expect(d.counts.unreadMessages, 4);
      expect(d.counts.tasksAwaitingApproval, 0);
      final dept = d.coordinatorships.single;
      expect(
        (dept.code, dept.todo, dept.inProgress, dept.inReview, dept.done),
        ('d1', 1, 2, 1, 1),
      );
    });

    test(
      'koordinatör: onaya sunulanlar ve kendi bekleyen tarih talepleri',
      () async {
        final (d, repo) = await run(role: SeatRole.coordinator);
        expect(repo.loads, 0);
        expect(repo.extras, [('d1', true)]);
        expect(d.greetingRole, TeamRole.coordinator);
        expect(d.pending.map((p) => (p.taskCode, p.kind)), [
          ('w2', PendingKind.dateChange),
          ('w3', PendingKind.approval),
        ]);
        expect(d.pending.first.requestedShiftDays, 3);
        expect(d.counts.pendingRequests, 1);
        expect(d.counts.tasksAwaitingApproval, 1);
      },
    );
  });
}

class _Fixed implements TaskCatalogRepository {
  _Fixed(this.catalog);

  final TaskCatalog catalog;

  @override
  Future<TaskCatalog> load() async => catalog;
}
