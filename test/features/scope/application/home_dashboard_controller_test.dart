// HomeDashboardController: özet bileşim kökündeki kaynaktan okunur; kapsam değişince yeniden
// okunur. Rol → kaynak: yönetici pano yolu (load); koordinatör/üye yönetici yolunu ÇAĞIRMAZ,
// özet görev kataloğundan sayılır + loadTeamExtras (koordinatör bayrağı, departman).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
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
        // Rol bilgisi taşımayan katalog → pano yolu.
        taskCatalogRepositoryProvider.overrideWithValue(
          _Fixed(
            TaskCatalog(
              today: DateTime(2026, 11),
              me: 'me',
              tasks: const [],
              people: const [],
              coordinatorships: const [],
            ),
          ),
        ),
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

    TaskCatalog catalogOf({
      bool admin = false,
      SeatRole role = SeatRole.member,
      String? department = 'd1',
      bool truncated = false,
    }) => TaskCatalog(
      today: DateTime(2026, 11),
      me: 'me',
      departmentId: department,
      truncated: truncated,
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
        CoordinatorshipRef(code: 'd1', name: 'Altyapı', leads: [], members: []),
      ],
    );

    ProviderContainer containerOf(
      _Counting repo,
      TaskCatalogRepository catalogs,
    ) {
      final c = ProviderContainer(
        // Uygulamadaki gibi otomatik yeniden deneme yok (composition.dart).
        retry: (_, _) => null,
        overrides: [
          homeDashboardRepositoryProvider.overrideWithValue(repo),
          taskCatalogRepositoryProvider.overrideWithValue(catalogs),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(homeDashboardControllerProvider, (_, _) {});
      return c;
    }

    Future<(HomeDashboard, _Counting)> run({
      bool admin = false,
      SeatRole role = SeatRole.member,
      bool truncated = false,
    }) async {
      final repo = _Counting();
      final c = containerOf(
        repo,
        _Fixed(catalogOf(admin: admin, role: role, truncated: truncated)),
      );
      return (await c.read(homeDashboardControllerProvider.future), repo);
    }

    test('katalog okunamazsa yönetici rapor uçlarına düşülmez; katalog hatası gösterilir', () async {
      final repo = _Counting();
      final c = containerOf(repo, _Failing());
      await expectLater(
        c.read(homeDashboardControllerProvider.future),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.networkError,
          ),
        ),
      );
      expect(repo.loads, 0, reason: 'rapor uçlarına istek 0');
      expect(repo.extras, isEmpty);
    });

    test(
      'yönetici dışı + departman yok: scope_missing, rapor/ekip isteği yok',
      () async {
        final repo = _Counting();
        final c = containerOf(repo, _Fixed(catalogOf(department: null)));
        await expectLater(
          c.read(homeDashboardControllerProvider.future),
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              ClientErrorCode.scopeMissing,
            ),
          ),
        );
        expect(repo.loads, 0);
        expect(repo.extras, isEmpty);
      },
    );

    test('kesik katalog: özet uyarı bayrağını taşır', () async {
      final (d, _) = await run(truncated: true);
      expect(d.truncated, isTrue);
      expect(d.tasks.inProgressOnTime, isNull);
    });

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
      // Tek kaynak: KPI ile kısayol rozeti aynı sayı.
      expect(d.counts.tasksAwaitingApproval, d.tasks.awaitingApproval);
      expect(d.truncated, isFalse);
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

class _Failing implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async =>
      throw ApiError(ClientErrorCode.networkError);
}

class _Fixed implements TaskCatalogRepository {
  _Fixed(this.catalog);

  final TaskCatalog catalog;

  @override
  Future<TaskCatalog> load() async => catalog;
}
