// Koordinatörlük ayrıntısı karar mantığı: görev süzgeci, ilerleme dağılımı, ekip satırları,
// dosya türü.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_board.dart';
import 'package:nizamio/features/tasks/tasks.dart';

TaskItem _t(
  String code,
  TaskStatus status, {
  int overdue = 0,
  List<String> who = const [],
}) => TaskItem(
  code: code,
  title: code,
  coordinatorship: 'd1',
  status: status,
  priority: TaskPriority.medium,
  start: DateTime(2026, 10),
  due: DateTime(2026, 11),
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
      expect((p.total, p.open, p.ratio), (5, 4, .2));
      expect(CoordPulse.of(const []).ratio, 0);
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

  test('dosya türü içerik türünden', () {
    expect(CoordFile.kindOf('image/png'), CoordFileKind.image);
    expect(CoordFile.kindOf('application/pdf'), CoordFileKind.pdf);
    expect(CoordFile.kindOf('application/msword'), CoordFileKind.document);
  });
}
