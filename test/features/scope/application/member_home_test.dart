// Üye ana sayfası türetmesi: odak görevi seçimi (başlamadı/devam, geciken önce, bitiş), en
// yakın iade, sayılar, açık satır sırası ve 7 günlük yaklaşanlar (toplantı + bitiş).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/scope/application/member_home.dart';
import 'package:nizamio/features/scope/application/team_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/tasks/tasks.dart';

TaskItem _t(
  String id, {
  TaskStatus status = TaskStatus.inProgress,
  int due = 20,
  bool late = false,
  String dept = 'd1',
  String who = 'me',
}) => TaskItem(
  code: id,
  title: id,
  coordinatorship: dept,
  departmentId: dept,
  programId: 'p1',
  status: status,
  priority: TaskPriority.medium,
  start: DateTime(2026, 11),
  due: DateTime(2026, 11, due),
  assignees: [who],
  lateness: TaskLateness(isOverdue: late, daysOverdue: late ? 2 : 0),
);

Meeting _m(String id, DateTime at) => Meeting(
  id: id,
  programId: 'p1',
  ownerDepartmentId: 'd1',
  title: id,
  meetingDate: at,
  membersIncluded: true,
  createdByAccountId: 'k',
  createdByRole: MeetingRole.admin,
  createdAt: at,
  updatedAt: at,
  departments: const [],
);

void main() {
  group('memberHome', () {
    test('odak: başlamadı/devam; geciken önce, sonra bitişi yakın', () {
      final h = memberHome([
        _t('review', status: TaskStatus.review, due: 15),
        _t('soon', status: TaskStatus.todo, due: 16),
        _t('late-old', due: 10, late: true),
        _t('late-new', status: TaskStatus.todo, due: 12, late: true),
        _t('done', status: TaskStatus.done, due: 1),
      ]);
      expect(h.focus?.code, 'late-old');
      expect(
        [for (final t in h.open) t.code],
        ['late-old', 'late-new', 'review', 'soon'],
      );
    });

    test('odak onayda ve iade görevlerini seçmez; yoksa null', () {
      final h = memberHome([
        _t('r', status: TaskStatus.review),
        _t('x', status: TaskStatus.returned),
        _t('d', status: TaskStatus.done),
      ]);
      expect(h.focus, isNull);
      expect(h.open.map((t) => t.code), ['r', 'x']);
    });

    test('iade: bitişi en yakın iade görevi', () {
      final h = memberHome([
        _t('a', status: TaskStatus.returned, due: 25),
        _t('b', status: TaskStatus.returned, due: 18),
        _t('c', due: 10),
      ]);
      expect(h.returned?.code, 'b');
      expect(memberHome([_t('c')]).returned, isNull);
    });

    test('sayılar: toplam, geciken, onayda, biten', () {
      final h = memberHome([
        _t('a', late: true),
        _t('b', status: TaskStatus.review),
        _t('c', status: TaskStatus.done),
        _t('d', status: TaskStatus.done),
      ], truncated: true);
      expect(h.stats.total, 4);
      expect(h.stats.late, 1);
      expect(h.stats.review, 1);
      expect(h.stats.done, 2);
      expect(h.truncated, isTrue);
    });
  });

  group('memberUpcoming', () {
    final today = DateTime(2026, 11, 14);
    final now = DateTime(2026, 11, 14, 12);

    test('7 gün içindeki toplantılar ve açık bitişler zaman sırasıyla', () {
      final items = memberUpcoming(
        [
          _t('t-today', due: 14),
          _t('t-17', due: 17),
          _t('t-done', status: TaskStatus.done, due: 15),
          _t('t-late', due: 10, late: true),
          _t('t-far', due: 21),
        ],
        [
          _m('m-past', DateTime(2026, 11, 14, 9)),
          _m('m-15', DateTime(2026, 11, 15, 10)),
          _m('m-far', DateTime(2026, 11, 22, 10)),
        ],
        today: today,
        now: now,
        limit: 10,
      );
      expect(
        [for (final x in items) x.task?.code ?? x.meeting?.id],
        ['t-today', 'm-15', 't-17'],
      );
    });

    test('canlı toplantı başlamış olsa da kalır; en çok limit kadar', () {
      final live = _m('live', DateTime(2026, 11, 14, 11));
      final items = memberUpcoming(
        [for (var d = 14; d < 20; d++) _t('t$d', due: d)],
        [live],
        today: today,
        now: now,
        live: (m) => m.id == 'live',
      );
      expect(items, hasLength(4));
      expect(items.map((x) => x.meeting?.id ?? x.task?.code), [
        't14',
        'live',
        't15',
        't16',
      ]);
    });
  });

  test('teamDashboard: üye sayımı etkin koordinatörlükte kendine atananlardan (F3)', () {
    TaskCatalog catalog(List<TaskItem> tasks) => TaskCatalog(
      today: DateTime(2026, 11, 14),
      me: 'me',
      tasks: tasks,
      people: const [],
      coordinatorships: const [],
    );
    final tasks = [
      _t('a'),
      _t('b', status: TaskStatus.review),
      _t('other-dept', dept: 'd2'),
      _t('other-person', who: 'x'),
    ];
    const extras = TeamDashboardExtras(unreadMessages: 0);
    final member = teamDashboard(
      catalog(tasks),
      extras,
      coordinator: false,
      departmentId: 'd1',
    );
    expect(member.tasks.total, 2);
    expect(member.tasks.awaitingApproval, 1);
    final coordinator = teamDashboard(
      catalog(tasks),
      extras,
      coordinator: true,
      departmentId: 'd1',
    );
    expect(coordinator.tasks.total, 4, reason: 'koordinatör davranışı aynı');
  });
}
