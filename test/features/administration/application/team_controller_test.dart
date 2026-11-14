import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/administration/application/team_controller.dart';
import 'package:nizamio/features/administration/domain/team_view.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/scope/scope.dart' show DepartmentRole;
import 'package:nizamio/features/tasks/tasks.dart';

class _Catalog extends TaskCatalogController {
  _Catalog(this.value);
  final TaskCatalog value;
  @override
  Future<TaskCatalog> build() => Future.value(value);
}

const _p = 'p1';

/// Hesap `me`: d1'de koordinatör, d2'de üye.
TaskAccess _access({bool admin = false}) => TaskAccess(
  accountId: 'me',
  companyAdmin: admin,
  seats: const [
    TeamSeat(
      programId: _p,
      departmentId: 'd1',
      departmentName: 'Altyapı',
      role: SeatRole.coordinator,
    ),
    TeamSeat(
      programId: _p,
      departmentId: 'd2',
      departmentName: 'Yazılım',
      role: SeatRole.member,
    ),
  ],
);

TaskCatalog _catalog(TaskAccess access) {
  final today = DateTime(2026, 11, 14);
  TaskItem task(
    String code,
    List<String> who, {
    int late = 0,
    bool done = false,
  }) => TaskItem(
    code: code,
    id: code,
    title: code,
    coordinatorship: 'd1',
    status: done ? TaskStatus.done : TaskStatus.inProgress,
    priority: TaskPriority.medium,
    start: today,
    due: today,
    assignees: who,
    overdueDays: late,
  );
  return TaskCatalog(
    today: today,
    me: 'me',
    access: access,
    tasks: [
      task('t1', ['u1'], late: 2),
      task('t2', ['u1']),
      task('t3', ['u1'], done: true),
    ],
    people: const [
      Person(id: 'me', name: 'Ben', role: PersonRole.coordinator),
      Person(id: 'u1', name: 'Ali', role: PersonRole.member),
    ],
    coordinatorships: const [
      CoordinatorshipRef(
        code: 'd1',
        name: 'Altyapı',
        leads: ['me'],
        members: ['u1'],
      ),
      CoordinatorshipRef(code: 'd2', name: 'Yazılım', leads: [], members: []),
    ],
  );
}

ProviderContainer _container(
  EffectiveRole role, {
  bool admin = false,
  ChatMembers? group,
  List<String>? groupReads,
}) {
  final access = _access(admin: admin);
  final c = ProviderContainer(
    overrides: [
      taskCatalogControllerProvider.overrideWith(
        () => _Catalog(_catalog(access)),
      ),
      effectiveAccessProvider.overrideWithValue(
        EffectiveAccess.of(access, ScopeSelection(programId: _p, role: role)),
      ),
      departmentGroupTeamProvider.overrideWith((ref, dept) async {
        groupReads?.add(dept);
        return group;
      }),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('yönetici görünümü: dizin, ekip listesi kurulmaz', () async {
    final c = _container(EffectiveRole.admin, admin: true);
    expect(c.read(teamSourceProvider), TeamSource.directory);
    expect(await c.read(teamRosterProvider.future), isNull);
  });

  test(
    'koordinatör görünümü: etkin koordinatörlüğün ekibi katalogdan',
    () async {
      final reads = <String>[];
      final c = _container(EffectiveRole.coordinator, groupReads: reads);
      expect(c.read(teamSourceProvider), TeamSource.departmentMembers);
      final roster = (await c.read(teamRosterProvider.future))!;
      expect(roster.departmentId, 'd1');
      expect(roster.available, isTrue);
      expect(
        [for (final p in roster.people) (p.accountId, p.lead)],
        [('me', true), ('u1', false)],
      );
      // Sohbet grubu okunmaz (koordinatörün `members` hakkı var).
      expect(reads, isEmpty);
    },
  );

  test('üye görünümü: koordinatörlük grubunun kaynaklı üyeleri', () async {
    final reads = <String>[];
    final c = _container(
      EffectiveRole.member,
      groupReads: reads,
      group: ChatMembers(
        items: const [
          ChatMember(
            accountId: 'k9',
            name: 'Koord',
            role: ChatMemberRole.admin,
            fromSource: true,
          ),
          ChatMember(
            accountId: 'me',
            name: 'Ben',
            role: ChatMemberRole.member,
            fromSource: true,
          ),
        ],
      ),
    );
    expect(c.read(teamSourceProvider), TeamSource.departmentGroup);
    final roster = (await c.read(teamRosterProvider.future))!;
    expect(reads, ['d2']);
    expect(roster.available, isTrue);
    expect(
      [for (final p in roster.people) (p.accountId, p.lead)],
      [('k9', true), ('me', false)],
    );
  });

  test('üye görünümü: grup yoksa liste yok (backend bekliyor)', () async {
    final c = _container(EffectiveRole.member);
    final roster = (await c.read(teamRosterProvider.future))!;
    expect(roster.available, isFalse);
    expect(roster.people, isEmpty);
  });

  test('ekip satırının kullanıcı ayrıntısı e-postasız ve rolüyle', () async {
    final c = _container(EffectiveRole.coordinator);
    final user = (await c.read(teamUserProfileProvider('u1').future))!;
    expect(user.fullName, 'Ali');
    expect(user.email, isEmpty);
    expect(user.teams.single.role, DepartmentRole.member);
    expect(user.teams.single.departmentId, 'd1');
    expect(await c.read(teamUserProfileProvider('yok').future), isNull);
  });

  test('kişi yükü: koordinatörlükteki açık ve geciken görevler', () {
    final load = teamLoadOf(_catalog(_access()), 'd1', 'u1');
    expect(load, (open: 2, late: 1));
  });
}
