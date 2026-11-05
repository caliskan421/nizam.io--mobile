// Yatay çizelge yerleşim önbelleği: aynı girdi → aynı örnek; katalog ya da ekran durumu
// değişince yeniden; ömür kapsama bağlı (program değişimi ve çıkışta atılır, aynı kapsamda
// yenilemede kalır); dinleyici kapanınca bırakılır.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/horizontal_timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_geometry.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_layout_provider.dart';

final _today = DateTime(2026, 6, 15);

TaskCatalog _catalog() => TaskCatalog(
  today: _today,
  me: 'p1',
  people: const [],
  coordinatorships: const [
    CoordinatorshipRef(code: 'C0', name: 'Grup 0', leads: [], members: []),
    CoordinatorshipRef(code: 'C1', name: 'Grup 1', leads: [], members: []),
  ],
  tasks: [
    for (var i = 0; i < 6; i++)
      TaskItem(
        code: 'T$i',
        title: 'Görev $i',
        coordinatorship: 'C${i % 2}',
        status: i.isEven ? TaskStatus.done : TaskStatus.inProgress,
        priority: TaskPriority.medium,
        start: _today.add(Duration(days: i)),
        due: _today.add(Duration(days: i + 3)),
        assignees: const [],
      ),
  ],
);

/// Katalog sağlayıcısının yerine: gerçek denetleyici gibi kapsamı izler, sunucuya gitmeden
/// [load]'un verdiği kataloğu taşır.
class _Catalog extends TaskCatalogController {
  _Catalog(this.load);

  final Future<TaskCatalog> Function() load;

  @override
  Future<TaskCatalog> build() {
    ref.watch(scopeStateProvider);
    return load();
  }

  void put(TaskCatalog v) => state = AsyncData(v);
}

void main() {
  late ProviderContainer c;
  late ScopeController scope;
  late TaskCatalog first;
  late Future<TaskCatalog> Function() next;
  late ProviderSubscription<GanttLayout?> page;
  setUp(() async {
    first = _catalog();
    next = () => Future.value(first);
    scope = ScopeController()..selectProgram('p1');
    c = ProviderContainer(
      overrides: [
        scopeControllerProvider.overrideWithValue(scope),
        taskCatalogControllerProvider.overrideWith(
          () => _Catalog(() => next()),
        ),
      ],
    );
    await c.read(taskCatalogControllerProvider.future);
    // Açık sayfa: yerleşimi izler (autoDispose).
    page = c.listen(ganttLayoutProvider, (_, _) {});
  });
  tearDown(() => c.dispose());

  _Catalog catalog() =>
      c.read(taskCatalogControllerProvider.notifier) as _Catalog;
  HorizontalTimelineController ctrl() =>
      c.read(horizontalTimelineControllerProvider.notifier);
  GanttLayout layout() => c.read(ganttLayoutProvider)!;

  test('aynı girdi → aynı örnek', () {
    final a = layout();
    expect(layout(), same(a));
    // Eşit durum yeniden yazılır (aynı ölçek) ya da katalog aynı örnekle yenilenir.
    ctrl().setZoom(GanttZoom.month);
    expect(layout(), same(a));
    catalog().put(first);
    expect(layout(), same(a));
  });

  test('süzgeç, arama, ölçek, grup ve seçim değişince yeniden', () {
    var prev = layout();
    void changed(void Function() f) {
      f();
      final next = layout();
      expect(next, isNot(same(prev)));
      prev = next;
    }

    changed(() => ctrl().setFilter(GanttFilter.open));
    expect(prev.view.visible, 3);
    changed(() => ctrl().setQuery('Görev 1'));
    changed(() => ctrl().setZoom(GanttZoom.week));
    expect(prev.ppd, GanttGeometry.ppd(GanttZoom.week));
    changed(() => ctrl().toggleGroup('C1'));
    changed(() => ctrl().pick('T1'));
  });

  test('yeni katalog örneği → yeniden', () {
    final a = layout();
    final next = _catalog();
    catalog().put(next);
    final b = layout();
    expect(b, isNot(same(a)));
    expect(b.view.rows.length, a.view.rows.length);
  });

  test(
    'aynı kapsamda yenileme: önceki yerleşim kalır, yeni katalogla yeniden',
    () async {
      final a = layout();
      final pending = Completer<TaskCatalog>();
      next = () => pending.future;
      c.invalidate(taskCatalogControllerProvider);
      expect(c.read(taskCatalogControllerProvider).isRefreshing, isTrue);
      expect(layout(), same(a));
      pending.complete(_catalog());
      await c.read(taskCatalogControllerProvider.future);
      expect(layout(), isNot(same(a)));
    },
  );

  test(
    'program değişince atılır; yeni programın kataloğu gelene kadar yok',
    () async {
      final a = layout();
      final pending = Completer<TaskCatalog>();
      next = () => pending.future;
      scope.selectProgram('p2');
      expect(c.read(taskCatalogControllerProvider).isReloading, isTrue);
      expect(c.read(ganttLayoutProvider), isNull);
      pending.complete(_catalog());
      await c.read(taskCatalogControllerProvider.future);
      expect(layout(), isNot(same(a)));
    },
  );

  test(
    'çıkış: kapsam temizlenince atılır (katalog önceki değeri taşısa da)',
    () async {
      layout();
      next = () => Future.error(StateError('kapsam yok'));
      scope.clear();
      await expectLater(
        c.read(taskCatalogControllerProvider.future),
        throwsStateError,
      );
      expect(c.read(taskCatalogControllerProvider).value, same(first));
      expect(c.read(ganttLayoutProvider), isNull);
    },
  );

  test('sayfa kapanınca bırakılır; yeniden açılışta yeniden kurulur', () async {
    final a = page.read()!;
    page.close();
    await Future<void>.delayed(Duration.zero);
    final again = c.listen(ganttLayoutProvider, (_, _) {});
    expect(again.read(), isNot(same(a)));
    again.close();
  });

  test('katalog yokken null', () {
    final loading = ProviderContainer(
      overrides: [
        scopeControllerProvider.overrideWithValue(
          ScopeController()..selectProgram('p1'),
        ),
        taskCatalogControllerProvider.overrideWith(
          () => _Catalog(() => Completer<TaskCatalog>().future),
        ),
      ],
    );
    addTearDown(loading.dispose);
    expect(loading.read(ganttLayoutProvider), isNull);
  });
}
