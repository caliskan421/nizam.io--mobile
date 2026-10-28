// TasksListController + queryTasks: görünüm sayıları (prototip 76/15/20/3/3/14/39), başlangıç
// süzgeci, sıralama ve yön, arama, filtre grupları, sayfalama, koordinatörlük grupları.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/application/tasks_list_controller.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

Future<(ProviderContainer, TaskCatalog)> _setup() async {
  final h = await pilotHarness(PilotBackend());
  h.container.listen(taskCatalogControllerProvider, (_, _) {});
  final c = await h.container.read(taskCatalogControllerProvider.future);
  return (h.container, c);
}

TaskQueryResult _q(TaskCatalog c, TasksListState s) => queryTasks(
  c,
  view: s.view,
  sort: s.sort,
  descending: s.descending,
  filter: s.filter,
);

void main() {
  test('görünüm sayıları prototiple aynı', () async {
    final (_, c) = await _setup();
    final r = _q(c, const TasksListState());
    expect(r.counts, {
      TaskView.all: 76,
      TaskView.late: 15,
      TaskView.inProgress: 20,
      TaskView.review: 3,
      TaskView.dateRequest: 3,
      TaskView.notStarted: 14,
      TaskView.done: 39,
    });
    // Bitiş tarihine göre: bitenler sonda, ilk kart en eski bitişli açık görev (ALT-5).
    expect(r.tasks.first.code, 'ALT-5');
    expect(r.tasks.last.isDone, isTrue);
  });

  test('başlangıç süzgeci, sıralama yönü, arama ve filtreler', () async {
    final (container, c) = await _setup();
    final p = tasksListControllerProvider(TaskView.late, 'ko');
    container.listen(p, (_, _) {});
    final ctl = container.read(p.notifier);
    var s = container.read(p);
    expect(s.view, TaskView.late);
    expect(s.filter.people, {'ko'});
    expect(_q(c, s).tasks.every((t) => t.assignees.contains('ko')), isTrue);

    ctl.clearAll();
    ctl.selectSort(TaskSort.created);
    s = container.read(p);
    expect((s.sort, s.descending), (TaskSort.created, true));
    ctl.selectSort(TaskSort.created);
    expect(container.read(p).descending, isFalse);
    ctl.selectSort(TaskSort.coordinatorship);
    ctl.selectSort(TaskSort.coordinatorship);
    s = container.read(p);
    expect((s.sort, s.descending), (TaskSort.coordinatorship, false));
    final r = _q(c, s);
    expect(r.groups, hasLength(11));
    expect(r.groups.first.coordinatorship, 'ALT');
    expect(s.isGroupOpen('ALT', first: true), isTrue);
    ctl.toggleGroup('ALT');
    expect(container.read(p).isGroupOpen('ALT', first: true), isFalse);

    ctl.toggleSearch();
    ctl.setQuery('hidrofor');
    expect(_q(c, container.read(p)).tasks.map((t) => t.code), ['ALT-7']);
    ctl.setQuery('kerem özdal');
    expect(_q(c, container.read(p)).tasks, isNotEmpty);
    ctl.toggleSearch();
    expect(container.read(p).filter.query, '');

    ctl
      ..toggleCoordinatorship('ALT')
      ..togglePriority(TaskPriority.high);
    final f = _q(c, container.read(p)).tasks;
    expect(
      f.every(
        (t) => t.coordinatorship == 'ALT' && t.priority == TaskPriority.high,
      ),
      isTrue,
    );
    ctl.clearExtra();
    expect(container.read(p).filter.hasExtra, isFalse);

    ctl.showMore();
    expect(container.read(p).limit, 16);
    ctl.selectView(TaskView.done);
    expect(container.read(p).limit, 8);
    ctl.toggleFilterGroup(TaskFilterGroup.priority);
    expect(container.read(p).openFilterGroups, {
      TaskFilterGroup.people,
      TaskFilterGroup.priority,
    });
  });

  test('Türkçe sıralama ve küçük harf', () {
    expect(trCompare('İdari işler', 'Fuar'), greaterThan(0));
    expect(trCompare('Çevre', 'Cami'), greaterThan(0));
    expect(trLower('IŞIK İzmir'), 'ışık izmir');
  });
}
