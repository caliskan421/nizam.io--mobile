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
  List<String> assignees = const [],
  String coordinatorship = 'd1',
}) => TaskItem(
  code: code,
  title: 'Görev $code',
  coordinatorship: coordinatorship,
  status: status,
  priority: TaskPriority.medium,
  start: start,
  due: due,
  assignees: assignees,
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
  test('koordinatörlük takvimi diğer koordinatörlüğün görev ve toplantılarını dışlar', () {
    final day = DateTime(2026, 11, 5);
    final index = CalendarIndex.build(
      [
        _meeting('shared', day, depts: ['Altyapı', 'Mekanik']),
        _meeting('other', day),
      ],
      _catalog([
        _task('mine', start: day, due: day),
        _task('other', start: day, due: day, coordinatorship: 'd0'),
      ]),
      coordinatorship: 'd1',
    );
    expect(index.on(day).whereType<MeetingEntry>().map((e) => e.id), [
      'shared',
    ]);
    expect(index.on(day).whereType<TaskEntry>().map((e) => e.code), [
      'mine',
      'mine',
    ]);
  });

  test('profil takvimi tamamlanan görevi korur ve aynı gün başlangıç/bitişi tek kayıt yapar', () {
    final day = DateTime(2026, 11, 5);
    final task = _task(
      'done',
      start: day,
      due: day,
      status: TaskStatus.done,
      assignees: ['person'],
    );
    final index = CalendarIndex.personTasks(_catalog([task]), 'person');
    final entry = index.on(day).single as TaskEntry;
    expect(entry.status, TaskStatus.done);
    expect(entry.edge, TaskEdge.end);
    expect(entry.late, isFalse);
  });

  test('kişi takvimi yalnız o kişiye atanmış görev tarihlerini içerir', () {
    final date = DateTime(2026, 11, 5);
    final index = CalendarIndex.build(
      const [],
      _catalog([
        _task('mine', start: date, due: date, assignees: ['person']),
        _task('other', start: date, due: date, assignees: ['someone']),
      ]),
      accountId: 'person',
    );
    expect(index.on(date).whereType<TaskEntry>().map((e) => e.code), [
      'mine',
      'mine',
    ]);
  });

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

  test(
    'dönem özeti: bitişi düşen (tamamlanan/geciken), başlayan, toplantı',
    () {
      final ix = CalendarIndex.build(
        [
          _meeting('m1', DateTime(2026, 10, 27, 10)),
          _meeting('m2', DateTime(2026, 11, 9, 10)),
        ],
        _catalog([
          _task(
            'done',
            start: DateTime(2026, 10, 1),
            due: DateTime(2026, 10, 28),
            status: TaskStatus.done,
          ),
          _task(
            'late',
            start: DateTime(2026, 10, 1),
            due: DateTime(2026, 10, 30),
          ),
          _task(
            'new',
            start: DateTime(2026, 10, 26),
            due: DateTime(2026, 12, 1),
          ),
        ]),
      );
      // _today 5 Kasım: geçen hafta 26 Eki – 1 Kas.
      final p = ix.period(DateTime(2026, 10, 26), DateTime(2026, 11, 1));
      expect((p.due, p.done, p.late, p.starts, p.meetings), (2, 1, 1, 1, 1));
      final none = ix.period(DateTime(2026, 11, 2), DateTime(2026, 11, 8));
      expect((none.due, none.starts, none.meetings), (0, 0, 0));
    },
  );

  test('hafta: pazartesi–pazar; uçlar, hafta boyu süren görevler, toplantılar saatle', () {
    expect(weekOf(DateTime(2026, 10, 21, 9)), [
      for (var d = 19; d <= 25; d++) DateTime(2026, 10, d),
    ]);
    expect(weekOf(DateTime(2026, 11, 1)).first, DateTime(2026, 10, 26));
    final ix = CalendarIndex.build(
      [
        _meeting('late', DateTime(2026, 11, 4, 15)),
        _meeting('early', DateTime(2026, 11, 4, 9)),
        _meeting('next', DateTime(2026, 11, 10, 9)),
      ],
      _catalog([
        _task('end', start: DateTime(2026, 10, 1), due: DateTime(2026, 11, 6)),
        _task(
          'start',
          start: DateTime(2026, 11, 3),
          due: DateTime(2026, 12, 1),
        ),
        _task('span', start: DateTime(2026, 10, 1), due: DateTime(2026, 12, 1)),
        _task(
          'done',
          start: DateTime(2026, 10, 1),
          due: DateTime(2026, 12, 1),
          status: TaskStatus.done,
        ),
      ]),
    );
    final w = ix.week(DateTime(2026, 11, 5));
    expect(w.ends.map((e) => e.code), ['end']);
    expect(w.starts.map((e) => e.code), ['start']);
    expect(w.ongoing.map((e) => (e.code, e.due)), [
      ('span', DateTime(2026, 12, 1)),
    ]);
    expect(w.meetings.map((m) => m.id), ['early', 'late']);
  });
}
