// Koordinatörlük ayrıntısı karar mantığı: görev süzgeci, ilerleme dağılımı, ekip satırları,
// akış, iş yükü, dosya türü.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_board.dart';
import 'package:nizamio/features/tasks/tasks.dart';

TaskItem _t(
  String code,
  TaskStatus status, {
  int overdue = 0,
  List<String> who = const [],
  DateTime? due,
}) => TaskItem(
  code: code,
  title: code,
  coordinatorship: 'd1',
  status: status,
  priority: TaskPriority.medium,
  start: DateTime(2026, 10),
  due: due ?? DateTime(2026, 11),
  assignees: who,
  overdueDays: overdue,
);

void main() {
  final tasks = [
    _t('a', TaskStatus.done, who: ['p1']),
    _t('b', TaskStatus.inProgress, overdue: 3, who: ['p1']),
    _t('c', TaskStatus.inProgress, who: ['p2']),
    _t('d', TaskStatus.todo),
    _t('e', TaskStatus.review, who: ['p1']),
  ];

  test('süzgeç: açık, geciken, onay, başlamadı, biten, tümü', () {
    List<String> of(CoordTaskFilter f) => [
      for (final t in tasks)
        if (f.matches(t)) t.code,
    ];
    expect(of(CoordTaskFilter.open), ['b', 'c', 'd', 'e']);
    expect(of(CoordTaskFilter.late), ['b']);
    expect(of(CoordTaskFilter.review), ['e']);
    expect(of(CoordTaskFilter.notStarted), ['d']);
    expect(of(CoordTaskFilter.done), ['a']);
    expect(of(CoordTaskFilter.all), hasLength(5));
  });

  test(
    'ilerleme: geciken ayrı sayılır, süren gecikmesiz başlamış görevdir',
    () {
      final p = CoordPulse.of(tasks);
      expect((p.done, p.doing, p.late, p.todo), (1, 2, 1, 1));
      expect((p.total, p.open), (5, 4));
    },
  );

  test('ekip: koordinatör önce, açık/geciken atamalar, tekrar yok', () {
    const p1 = Person(id: 'p1', name: 'Bir', role: PersonRole.coordinator);
    const p2 = Person(id: 'p2', name: 'İki', role: PersonRole.member);
    const p3 = Person(id: 'p3', name: 'Üç', role: PersonRole.member);
    final rows = coordPeople([p1], [p3, p2, p1], tasks);
    expect(rows.map((r) => r.id), ['p1', 'p2', 'p3']);
    expect((rows[0].lead, rows[0].open, rows[0].late), (true, 2, 1));
    expect((rows[1].open, rows[1].late), (1, 0));
    expect(rows[2].open, 0);
  });

  test('akış: son üç geciken eskiden yeniye; yaklaşan en çok üç toplantı, ilk dört öğe', () {
    final now = DateTime(2026, 10, 21, 12);
    CoordMeeting m(String id, DateTime at) =>
        CoordMeeting(id: id, title: id, at: at, owner: true, departments: 1);
    final flow = coordFlow(
      [
        for (final (i, d) in [5, 9, 2, 7].indexed)
          _t(
            'l$i',
            TaskStatus.inProgress,
            overdue: d,
            due: DateTime(2026, 10, 20 - d),
          ),
        _t('done', TaskStatus.done, due: DateTime(2026, 10, 25)),
        _t('soon', TaskStatus.todo, due: DateTime(2026, 10, 23)),
        _t('far', TaskStatus.inProgress, due: DateTime(2026, 12)),
      ],
      [
        m('past', DateTime(2026, 10, 20)),
        m('m1', DateTime(2026, 10, 22)),
        m('m2', DateTime(2026, 10, 24)),
        m('m3', DateTime(2026, 10, 26)),
        m('m4', DateTime(2026, 10, 27)),
      ],
      now,
    );
    expect(flow.late.map((t) => t.code), ['l3', 'l0', 'l2']);
    expect(
      flow.upcoming.map(
        (e) => switch (e) {
          CoordFlowTask(:final task) => task.code,
          CoordFlowMeeting(:final meeting) => meeting.id,
        },
      ),
      ['m1', 'soon', 'm2', 'm3'],
    );
  });

  test('iş yükü: önce geciken, sonra açık, sonra toplam; atanmamış yok', () {
    final rows = coordLoad([
      ...tasks,
      _t('f', TaskStatus.done, who: ['p2', 'p3']),
    ]);
    expect(rows.map((r) => r.id), ['p1', 'p2', 'p3']);
    expect((rows[0].late, rows[0].open, rows[0].done), (1, 1, 1));
    expect((rows[1].late, rows[1].open, rows[1].done), (0, 1, 1));
    expect(rows[2].total, 1);
  });

  test('dosya türü içerik türünden', () {
    expect(CoordFile.kindOf('image/png'), CoordFileKind.image);
    expect(CoordFile.kindOf('application/pdf'), CoordFileKind.pdf);
    expect(CoordFile.kindOf('application/msword'), CoordFileKind.document);
  });
}
