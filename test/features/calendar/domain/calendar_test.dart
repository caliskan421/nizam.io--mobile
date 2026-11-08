// Takvim kuralları: ay ızgarası, hafta sırası; gün dizini (toplantı + görev + bekleyen tarih
// talebi), toplantının yerel güne eşlenmesi, bölüm ve tür sırası.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/tasks/tasks.dart';

final _today = DateTime(2026, 11, 5, 14);

Meeting _meeting(
  String id,
  DateTime at, {
  List<String> depts = const ['Altyapı'],
}) => Meeting(
  id: id,
  programId: 'p',
  ownerDepartmentId: 'd0',
  title: 'Toplantı $id',
  meetingDate: at,
  membersIncluded: false,
  createdByAccountId: 'a',
  createdByRole: MeetingRole.admin,
  createdAt: at,
  updatedAt: at,
  departments: [
    for (final (i, n) in depts.indexed) MeetingDepartment(id: 'd$i', name: n),
  ],
);

TaskItem _task(
  String code, {
  required DateTime start,
  required DateTime due,
  TaskStatus status = TaskStatus.inProgress,
  DateChangeRequest? request,
}) => TaskItem(
  code: code,
  title: 'Görev $code',
  coordinatorship: 'd1',
  status: status,
  priority: TaskPriority.medium,
  start: start,
  due: due,
  assignees: const [],
  dateRequest: request,
);

TaskCatalog _catalog(List<TaskItem> tasks) => TaskCatalog(
  today: _today,
  me: 'me',
  tasks: tasks,
  people: const [],
  coordinatorships: const [],
);

void main() {
  test('Ekim 2026 ızgarası 28 Eylül – 1 Kasım, 5 satır, pazartesi başlar', () {
    final w = monthWeeks(DateTime(2026, 10));
    expect(w, hasLength(5));
    expect(w.first.first, DateTime(2026, 9, 28));
    expect(w.last.last, DateTime(2026, 11));
    expect(w.every((r) => r.first.weekday == DateTime.monday), isTrue);
    // Şubat 2027 pazartesi başlar, 28 gün → 4 satır; Ağustos 2026 → 6 satır.
    expect(monthWeeks(DateTime(2027, 2)), hasLength(4));
    expect(monthWeeks(DateTime(2026, 8)), hasLength(6));
  });

  test('hafta sırası ve gün farkı', () {
    final m = DateTime(2026, 10);
    expect(weekIndexOf(DateTime(2026, 10, 21), m), 3);
    expect(weekIndexOf(DateTime(2026, 10), m), 0);
    expect(weekIndexOf(DateTime(2026, 10, 31), m), 4);
    expect(calendarDiff(DateTime(2026, 10, 29), DateTime(2026, 10, 21)), 8);
    expect(calendarDiff(DateTime(2026, 10, 19), DateTime(2026, 10, 21)), -2);
  });

  test(
    'toplantı UTC anından yerel gün ve saate, departman adlarıyla eşlenir',
    () {
      final at = DateTime.utc(2026, 11, 6, 7, 30);
      final e = MeetingEntry.of(
        _meeting('m1', at, depts: ['Altyapı', 'Mekanik']),
      );
      final local = at.toLocal();
      expect(e.id, 'm1');
      expect(e.title, 'Toplantı m1');
      expect(e.date, DateTime(local.year, local.month, local.day));
      expect((e.hour, e.minute), (local.hour, local.minute));
      expect(e.departments, ['Altyapı', 'Mekanik']);
    },
  );

  test('gün dizini: toplantılar saate göre, görevde bitiş önce, talep yeni bitişte', () {
    final day = DateTime(2026, 11, 10);
    final ix = CalendarIndex.build(
      [
        _meeting('late', DateTime(2026, 11, 10, 16)),
        _meeting('early', DateTime(2026, 11, 10, 9)),
      ],
      _catalog([
        _task('w1', start: day, due: DateTime(2026, 11, 20)),
        _task('w2', start: DateTime(2026, 11, 2), due: day),
        _task(
          'w3',
          start: DateTime(2026, 11, 3),
          due: DateTime(2026, 11, 4),
          request: DateChangeRequest(
            id: 'r1',
            oldDue: DateTime(2026, 11, 4),
            start: DateTime(2026, 11, 3),
            due: day,
          ),
        ),
      ]),
    );
    final groups = ix.groups(day);
    expect(groups.map((g) => g.kind), [
      CalendarKind.meeting,
      CalendarKind.task,
      CalendarKind.request,
    ]);
    expect(groups[0].entries.cast<MeetingEntry>().map((m) => m.id), [
      'early',
      'late',
    ]);
    expect(groups[1].entries.cast<TaskEntry>().map((t) => (t.code, t.edge)), [
      ('w2', TaskEdge.end),
      ('w1', TaskEdge.start),
    ]);
    final r = groups[2].entries.single as RequestEntry;
    expect(
      (r.code, r.title, r.start),
      ('w3', 'Görev w3', DateTime(2026, 11, 3)),
    );
    expect(ix.kinds(day), CalendarKind.values);
    expect(ix.count(day), 5);
    expect(ix.today, DateTime(2026, 11, 5));
  });

  test('görev başlangıcı eşiksiz düşer; biten görev ve sonuçlanmış talep düşmez; gecikme', () {
    final ix = CalendarIndex.build(
      const [],
      _catalog([
        // Çok önce başlamış, bitişi geçmiş: başlangıç da takvimde, bitiş "gecikti".
        _task('old', start: DateTime(2025, 1, 6), due: DateTime(2026, 11, 2)),
        _task(
          'done',
          start: DateTime(2026, 11, 3),
          due: DateTime(2026, 11, 4),
          status: TaskStatus.done,
        ),
        _task(
          'rej',
          start: DateTime(2026, 11, 3),
          due: DateTime(2026, 11, 9),
          request: DateChangeRequest(
            oldDue: DateTime(2026, 11, 9),
            start: DateTime(2026, 11, 3),
            due: DateTime(2026, 11, 12),
            state: DateRequestState.rejected,
          ),
        ),
      ]),
    );
    expect(ix.on(DateTime(2025, 1, 6)).single, isA<TaskEntry>());
    final end = ix.on(DateTime(2026, 11, 2)).single as TaskEntry;
    expect((end.edge, end.late), (TaskEdge.end, true));
    expect(ix.on(DateTime(2026, 11, 4)), isEmpty);
    expect(ix.on(DateTime(2026, 11, 12)), isEmpty);
    expect(ix.groups(DateTime(2026, 10, 6)), isEmpty);
  });
}
