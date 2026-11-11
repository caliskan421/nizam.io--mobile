// TasksListController + tasksListResult: başlangıç süzgeci (görünüm, kişiler), sıralama döngüsü
// ve yön, arama (kapanınca sorgu silinir), süzgeç geçişleri, sayfa sınırı, oturum boyunca
// korunan tercihler (TasksListPrefsStore) ve sunucu biçimli katalogdan (CoordBackend) sonuç.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/tasks_list_controller.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

Future<ProviderContainer> _container() async {
  final backend = CoordBackend();
  final h = await pilotHarness(backend, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  addTearDown(() => expect(backend.unhandled, isEmpty));
  return h.container;
}

/// Durumsuz denetleyici testi için düz kapsayıcı (katalog gerekmez).
ProviderContainer _bare() {
  final c = ProviderContainer();
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('başlangıç süzgeci: görünüm ve virgüllü kişi listesi', () {
    final c = _bare();
    final s = c.read(tasksListControllerProvider(TaskView.late, 'a,,b'));
    expect(s.view, TaskView.late);
    expect(s.filter.people, {'a', 'b'});
    expect(s.sort, TaskSort.due);
    expect(s.descending, isFalse);
    expect(s.limit, TasksListState.pageSize);
  });

  test('sıralama: döngü varsayılan yönle; seçili tarihli ölçüt yönü çevirir, '
      'koordinatörlük yönsüz', () {
    final c = _bare();
    final p = tasksListControllerProvider(TaskView.all, '');
    final ctl = c.read(p.notifier);
    ctl.cycleSort();
    expect(c.read(p).sort, TaskSort.start);
    ctl.selectSort(TaskSort.created);
    expect((c.read(p).sort, c.read(p).descending), (TaskSort.created, true));
    ctl.flipDirection();
    expect(c.read(p).descending, isFalse);
    ctl.selectSort(TaskSort.coordinatorship);
    final before = c.read(p);
    ctl.flipDirection();
    expect(c.read(p), same(before), reason: 'koordinatörlük sıralaması yönsüz');
    ctl.cycleSort();
    expect(c.read(p).sort, TaskSort.created, reason: 'döngü başa sarar');
  });

  test('arama kapanınca sorgu silinir; süzgeçler ve sayfa sınırı', () {
    final c = _bare();
    final p = tasksListControllerProvider(TaskView.all, '');
    final ctl = c.read(p.notifier);
    ctl
      ..toggleSearch()
      ..setQuery('hidrofor')
      ..togglePerson(pKadir)
      ..toggleCoordinatorship(dAlt)
      ..togglePriority(TaskPriority.medium);
    var s = c.read(p);
    expect(s.searchOpen, isTrue);
    expect(s.filter.query, 'hidrofor');
    expect(s.filter.people, {pKadir});
    expect(s.filter.coordinatorships, {dAlt});
    expect(s.filter.priorities, {TaskPriority.medium});

    ctl.showMore();
    expect(c.read(p).limit, 2 * TasksListState.pageSize);
    ctl.togglePerson(pKadir);
    expect(c.read(p).filter.people, isEmpty, reason: 'ikinci dokunuş çıkarır');
    expect(
      c.read(p).limit,
      TasksListState.pageSize,
      reason: 'süzgeç sayfayı sıfırlar',
    );

    ctl.clearExtra();
    s = c.read(p);
    expect(s.filter.query, 'hidrofor', reason: 'arama kalır');
    expect(s.filter.coordinatorships, isEmpty);
    expect(s.filter.priorities, isEmpty);

    ctl.toggleSearch();
    expect(c.read(p).searchOpen, isFalse);
    expect(c.read(p).filter.query, isEmpty);

    ctl
      ..selectView(TaskView.done)
      ..togglePerson(pAli)
      ..clearAll();
    s = c.read(p);
    expect(s.view, TaskView.all);
    expect(s.filter.people, isEmpty);
  });

  test('tercihler (sıralama, yön, gruplar) yeni denetleyiciye taşınır; süzgeç taşınmaz', () {
    final c = _bare();
    final a = tasksListControllerProvider(TaskView.all, '');
    c.read(a.notifier)
      ..selectSort(TaskSort.start)
      ..flipDirection()
      ..toggleGroup(dEle)
      ..toggleFilterGroup(TaskFilterGroup.priority)
      ..setQuery('x');
    final b = c.read(tasksListControllerProvider(TaskView.late, pAli));
    expect(b.sort, TaskSort.start);
    expect(b.descending, isTrue);
    expect(b.flippedGroups, {dEle});
    expect(b.openFilterGroups, {
      TaskFilterGroup.people,
      TaskFilterGroup.priority,
    });
    expect(b.filter.query, isEmpty);
    expect(b.isGroupOpen(dEle), isTrue);
    expect(b.isGroupOpen(dAlt), isFalse);
  });

  test(
    'koordinatörlük sıralaması seçildiğinde bütün gruplar kapalı başlar',
    () {
      final c = _bare();
      final p = tasksListControllerProvider(TaskView.all, '');
      final ctl = c.read(p.notifier);
      ctl.selectSort(TaskSort.coordinatorship);
      expect(c.read(p).isGroupOpen(dEle), isFalse);
      expect(c.read(p).isGroupOpen(dAlt), isFalse);
      ctl.toggleGroup(dEle);
      expect(c.read(p).isGroupOpen(dEle), isTrue);
      ctl.selectSort(TaskSort.due);
      ctl.selectSort(TaskSort.coordinatorship);
      expect(c.read(p).isGroupOpen(dEle), isFalse);
    },
  );

  test('sonuç sunucu kataloğundan: görünüm, arama ve kişi süzgeci', () async {
    final c = await _container();
    final p = tasksListControllerProvider(TaskView.all, '');
    final r = tasksListResultOf(p);
    c.listen(r, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    var res = c.read(r)!;
    expect(res.tasks, hasLength(9));
    expect(res.counts[TaskView.late], 3);

    c.read(p.notifier).selectView(TaskView.late);
    res = c.read(r)!;
    expect(res.tasks.map((t) => t.code).toSet(), {
      'wi-alt-1',
      'wi-alt-2',
      'wi-egi-1',
    });

    c.read(p.notifier)
      ..selectView(TaskView.all)
      ..setQuery('hidrofor');
    expect(c.read(r)!.tasks.map((t) => t.code), ['wi-alt-2']);

    // Kişi süzgeciyle açılan liste (ana sayfa ekip kutusu): yalnız o kişinin görevleri.
    final kadir = tasksListResultOf(
      tasksListControllerProvider(TaskView.all, pKadir),
    );
    c.listen(kadir, (_, _) {});
    expect(c.read(kadir)!.tasks.map((t) => t.code).toSet(), {
      'wi-alt-1',
      'wi-alt-4',
    });
  });
}
