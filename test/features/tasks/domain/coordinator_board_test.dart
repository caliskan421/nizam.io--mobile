// Koordinatör görünümünün karar mantığı: etkin görünüme göre görev kümesi, onay kuyruğu ve
// atanmamış türetme, ekip yükü hesabı, doğrudan süre uzatma sınırı (7 gün), görünüm/sıralama
// kümeleri, durum gruplu liste ve karar/uzatma yetenek dalları.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/features/tasks/domain/coordinator_board.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_permissions.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/domain/work_item.dart';

TaskItem _t(
  String id, {
  TaskStatus status = TaskStatus.inProgress,
  List<String> assignees = const ['a'],
  String dept = 'd1',
  int due = 10,
  bool late = false,
}) => TaskItem(
  code: id,
  title: id,
  coordinatorship: dept,
  departmentId: dept,
  programId: 'p1',
  status: status,
  priority: TaskPriority.medium,
  start: DateTime(2026, 10),
  due: DateTime(2026, 10, due),
  assignees: assignees,
  lateness: TaskLateness(isOverdue: late, daysOverdue: late ? 2 : 0),
);

TaskAccess _access({bool admin = false, SeatRole? role}) => TaskAccess(
  accountId: 'me',
  companyAdmin: admin,
  seats: [
    if (role != null)
      TeamSeat(
        programId: 'p1',
        departmentId: 'd1',
        departmentName: 'Altyapı',
        role: role,
      ),
  ],
);

void main() {
  group('etkin görünüm kümesi', () {
    final tasks = [
      _t('a1', assignees: ['me']),
      _t('a2', assignees: ['x']),
      _t('b1', dept: 'd2', assignees: ['me']),
    ];
    test('yönetici her şeyi, koordinatör yalnız koordinatörlüğünü görür', () {
      List<String> ids(EffectiveRole r, String? d) => [
        for (final t in scopedTasks(tasks, role: r, departmentId: d, me: 'me'))
          t.id,
      ];
      expect(ids(EffectiveRole.admin, 'd1'), ['a1', 'a2', 'b1']);
      expect(ids(EffectiveRole.coordinator, 'd1'), ['a1', 'a2']);
      expect(ids(EffectiveRole.member, 'd1'), ['a1']);
      expect(ids(EffectiveRole.coordinator, null), ['a1', 'a2', 'b1']);
    });
  });

  group('onay kuyruğu ve atanmamış', () {
    final tasks = [
      _t('r2', status: TaskStatus.review, due: 20),
      _t('r1', status: TaskStatus.review, due: 5),
      _t('u1', status: TaskStatus.todo, assignees: const [], due: 8),
      _t('u2', status: TaskStatus.done, assignees: const []),
      _t('u3', status: TaskStatus.unknown, assignees: const []),
      _t('u4', status: TaskStatus.review, assignees: const [], due: 1),
      _t('d1', status: TaskStatus.done),
    ];
    test('kuyruk yalnız onaya sunulanlar, bitişi yakın önce', () {
      expect([for (final t in approvalQueue(tasks)) t.id], ['u4', 'r1', 'r2']);
    });
    test('atanmamış: açık ve atamasız; biten ve tanımsız durum düşer', () {
      expect([for (final t in unassignedTasks(tasks)) t.id], ['u4', 'u1']);
      expect(TaskView.unassigned.matches(tasks[2]), isTrue);
      expect(TaskView.unassigned.matches(tasks[3]), isFalse);
    });
    test('özet sayıları', () {
      final s = summarizeTasks(tasks);
      expect(s.total, 7);
      expect(s.done, 2);
      expect(s.review, 3);
      expect(s.unassigned, 2);
      expect(s.todo, 1);
    });
  });

  group('ekip yükü', () {
    test('kişi başına bitmemiş görevler; ekipte görevsiz kişi 0 ile kalır', () {
      final load = teamLoad(
        [
          _t('1', assignees: ['ali', 'can']),
          _t('2', status: TaskStatus.review, assignees: ['ali']),
          _t('3', status: TaskStatus.returned, assignees: ['ali'], late: true),
          _t('4', status: TaskStatus.done, assignees: ['can']),
          _t('5', status: TaskStatus.todo, assignees: ['dış']),
        ],
        team: ['bos', 'can', 'ali'],
      );
      expect([for (final p in load) p.personId], ['ali', 'can', 'dış', 'bos']);
      final ali = load.first;
      expect(
        (ali.open, ali.inProgress, ali.review, ali.returned, ali.late),
        (3, 1, 1, 1, 1),
      );
      expect(load[1].open, 1, reason: 'biten görev yüke girmez');
      expect(load.last.open, 0);
    });
    test('eşit açıkta geciken çok olan önce, sonra giriş sırası', () {
      final load = teamLoad([
        _t('1', assignees: ['x']),
        _t('2', assignees: ['y'], late: true),
      ]);
      expect([for (final p in load) p.personId], ['y', 'x']);
    });
  });

  group('süre uzatma sınırı', () {
    test('1–7 gün doğrudan; 0 ve 8 geçersiz; seçenekler sınır içinde', () {
      expect(isValidExtendDays(0), isFalse);
      expect(isValidExtendDays(1), isTrue);
      expect(isValidExtendDays(maxDirectExtendDays), isTrue);
      expect(isValidExtendDays(8), isFalse);
      expect(extendDayOptions.every(isValidExtendDays), isTrue);
    });
    test('karar sebebi boş olamaz ve 1000 karakteri aşamaz', () {
      expect(isValidDecisionReason('   '), isFalse);
      expect(isValidDecisionReason(' eksik kanıt '), isTrue);
      expect(isValidDecisionReason('a' * decisionReasonMaxLength), isTrue);
      expect(
        isValidDecisionReason('a' * (decisionReasonMaxLength + 1)),
        isFalse,
      );
    });
  });

  group('görünüm ve sıralama kümeleri', () {
    test(
      'koordinatörde Atanmamış var, Tarih talebi yok; diğerlerinde tersi',
      () {
        final k = taskViewsFor(coordinator: true);
        final o = taskViewsFor(coordinator: false);
        expect(k, contains(TaskView.unassigned));
        expect(k, isNot(contains(TaskView.dateRequest)));
        expect(o, contains(TaskView.dateRequest));
        expect(o, isNot(contains(TaskView.unassigned)));
        expect(k.first, TaskView.all);
      },
    );
    test('koordinatör varsayılanı duruma göre; seçilen ölçüt korunur', () {
      expect(
        resolveTaskSort(TaskSort.due, picked: false, coordinator: true),
        TaskSort.status,
      );
      expect(
        resolveTaskSort(TaskSort.due, picked: false, coordinator: false),
        TaskSort.due,
      );
      expect(
        resolveTaskSort(TaskSort.start, picked: true, coordinator: true),
        TaskSort.start,
      );
      // Koordinatörlüğe göre koordinatörde yok → rolün ilk seçeneği.
      expect(
        resolveTaskSort(
          TaskSort.coordinatorship,
          picked: true,
          coordinator: true,
        ),
        TaskSort.status,
      );
      expect(
        resolveTaskSort(TaskSort.status, picked: true, coordinator: false),
        TaskSort.created,
      );
    });
    test('duruma göre gruplu liste koordinatör sırasıyla', () {
      final catalog = TaskCatalog(
        today: DateTime(2026, 10, 21),
        me: 'me',
        people: const [],
        coordinatorships: const [],
        tasks: [
          _t('done', status: TaskStatus.done),
          _t('todo', status: TaskStatus.todo),
          _t('free', status: TaskStatus.todo, assignees: const []),
          _t('back', status: TaskStatus.returned),
          _t('rev', status: TaskStatus.review),
        ],
      );
      final r = queryTasks(
        catalog,
        view: TaskView.all,
        sort: TaskSort.status,
        descending: false,
        filter: const TaskFilter(),
      );
      expect(
        [for (final g in r.groups) TaskStatusGroup.fromKey(g.coordinatorship)],
        [
          TaskStatusGroup.review,
          TaskStatusGroup.unassigned,
          TaskStatusGroup.returned,
          TaskStatusGroup.todo,
          TaskStatusGroup.done,
        ],
      );
      expect(r.counts[TaskView.unassigned], 1);
      expect(TaskStatusGroup.fromKey('d1'), isNull);
    });
  });

  group('bağımlılık kilidi', () {
    test('katalogda görünen bitmemiş ön görevler kilitler', () {
      final byId = {
        'open': _t('open'),
        'done': _t('done', status: TaskStatus.done),
      };
      TaskDependency dep(String on) =>
          TaskDependency(id: 'e-$on', workItemId: 'w', dependsOnId: on);
      final links = TaskDependencies(
        dependencies: [dep('open'), dep('done'), dep('hidden')],
        dependents: const [],
      );
      expect(
        [for (final t in blockingPrerequisites(links, byId.get)) t.id],
        ['open'],
      );
    });
  });

  group('karar ve uzatma yetenek dalları', () {
    final review = _t('w', status: TaskStatus.review, assignees: ['x']);
    test('kapsam koordinatörü onaydaki görevde karar verir ve uzatır', () {
      final p = TaskPermissions.of(_access(role: SeatRole.coordinator), review);
      expect(p.canDecide(review), isTrue);
      expect(p.canExtend(review), isTrue);
      expect(p.canDecide(_t('w')), isFalse, reason: 'onayda değil');
      final done = _t('w', status: TaskStatus.done);
      expect(p.canExtend(done), isFalse, reason: 'biten uzatılmaz');
    });
    test('atanmış üye karar veremez ve uzatamaz', () {
      final mine = _t('w', status: TaskStatus.review, assignees: ['me']);
      final p = TaskPermissions.of(_access(role: SeatRole.member), mine);
      expect(p.canDecide(mine), isFalse);
      expect(p.canExtend(mine), isFalse);
    });
    test('Üye görünümündeki koordinatör karar düğmesi görmez', () {
      final view = _access(role: SeatRole.coordinator)
          .viewAs('p1', EffectiveRole.member);
      expect(TaskPermissions.of(view, review).canDecide(review), isFalse);
    });
    test('şirket yöneticisi (ADR-0041) karar verir; yetkisiz hesap hayır', () {
      expect(
        TaskPermissions.of(_access(admin: true), review).canDecide(review),
        isTrue,
      );
      expect(const TaskPermissions.none().canDecide(review), isFalse);
    });
  });
}

extension on Map<String, TaskItem> {
  TaskItem? get(String id) => this[id];
}
