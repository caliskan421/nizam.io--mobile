// Tablet yatay çizelgenin açılış karesi bölünür: ilk karede iskelet (üst çubuk, araç satırı),
// Gantt gövdesi bir sonraki karede kurulur.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/domain/gantt_schedule.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline_view_builder.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_chart.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_controls.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_geometry.dart';
import 'package:nizamio/features/timeline/presentation/horizontal_timeline_page.dart';

final _today = DateTime(2026, 6, 15);

TaskCatalog _catalog() => TaskCatalog(
  today: _today,
  me: 'p1',
  people: const [],
  coordinatorships: const [
    CoordinatorshipRef(code: 'C0', name: 'Grup 0', leads: [], members: []),
  ],
  tasks: [
    for (var i = 0; i < 4; i++)
      TaskItem(
        code: 'T$i',
        title: 'Görev $i',
        coordinatorship: 'C0',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        start: _today.add(Duration(days: i)),
        due: _today.add(Duration(days: i + 3)),
        assignees: const [],
      ),
  ],
);

class _Catalog extends TaskCatalogController {
  _Catalog(this.value);

  final TaskCatalog value;

  @override
  Future<TaskCatalog> build() => Future.value(value);
}

void main() {
  test('kişi, koordinatörlük ve öncelik filtreleri birlikte uygulanır', () {
    final catalog = _catalog();
    final tasks = [
      catalog.tasks[0].copyWith(assignees: ['p1'], priority: TaskPriority.high),
      catalog.tasks[1].copyWith(assignees: ['p2'], priority: TaskPriority.high),
      catalog.tasks[2].copyWith(assignees: ['p1'], priority: TaskPriority.low),
    ];
    final updated = catalog.withTasks(tasks);
    final state = const GanttState()
        .toggleCoord('C0')
        .togglePerson('p1')
        .togglePriority(TaskPriority.high);
    expect(buildGanttView(updated, state).visible, 1);
    expect(buildGanttView(updated, state.clearFilters()).visible, 3);
    expect(buildGanttView(updated, state.toggleCoord('başka')).visible, 1);
  });

  test('açık alt görevler aynı hizadaki satırlara eklenir', () {
    final catalog = _catalog();
    final task = catalog.tasks.first.copyWith(
      subtasks: [const Subtask(id: 'sub', title: 'Alt görev', done: true)],
    );
    final updated = catalog.withTasks([task, ...catalog.tasks.skip(1)]);
    final view = buildGanttView(updated, const GanttState());
    final closed = GanttLayout.of(view);
    final open = GanttLayout.of(
      view,
      labelWidth: 150,
      expandedTasks: {task.code},
    );
    expect(open.rows.length, closed.rows.length + 1);
    expect(open.rows.where((row) => row.row is GanttSubtaskRow), hasLength(1));
    expect(open.rowsHeight, closed.rowsHeight + GanttGeometry.row);
    expect(open.labelWidth, 150);
  });

  test('sütun genişliği ve görünüm genişliği gün ölçeğini belirler', () {
    final view = buildGanttView(_catalog(), const GanttState());
    final wide = GanttLayout.of(view, labelWidth: 300, viewportWidth: 5000);
    final narrow = GanttLayout.of(view, labelWidth: 150, viewportWidth: 5000);
    expect(narrow.ppd, greaterThan(wide.ppd));
    expect(narrow.totalWidth, closeTo(5000, .001));
    final small = GanttLayout.of(view, labelWidth: 150, viewportWidth: 800);
    expect(small.ppd, GanttGeometry.ppd(view.state.zoom));
  });

  test('tablet ve telefon sezon şeritleri aynı görevleri sayar', () {
    final catalog = _catalog();
    final phone = buildTimelineView(
      catalog,
      const TimelineState(startAll: true),
    );
    final tablet = buildGanttView(catalog, const GanttState(closed: {'C0'}));
    expect(
      tablet.weeks.map((w) => (w.count, w.late)).toList(),
      phone.weeks.map((w) => (w.count, w.late)).toList(),
    );
    expect(tablet.weeks.any((w) => w.count > 0), isTrue);
  });

  testWidgets('ilk karede iskelet var, Gantt gövdesi yok; sonraki karede var', (
    t,
  ) async {
    t.view.physicalSize = const Size(1376, 1032);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final c = ProviderContainer(
      overrides: [
        timelineCatalogProvider.overrideWith(
          (ref) => ref.watch(taskCatalogControllerProvider),
        ),
        ganttScheduleProvider.overrideWith(
          (ref) async => GanttSchedule(tasks: const [], links: const []),
        ),
        scopeStateProvider.overrideWithValue(
          const ScopeSelection(programId: 'p1'),
        ),
        taskCatalogControllerProvider.overrideWith(() => _Catalog(_catalog())),
        canCreateTaskProvider.overrideWithValue(false),
        connectivityStateProvider.overrideWithValue(ConnectivityState.online),
      ],
    );
    addTearDown(c.dispose);
    // Katalog hazır (yeniden açılış: veri önbellekte).
    await c.read(taskCatalogControllerProvider.future);

    await t.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HorizontalTimelinePage(onBack: () {}, onOpenTask: (_) {}),
        ),
      ),
    );

    expect(find.byType(GanttTopBar), findsOneWidget);
    expect(find.byType(GanttToolbar), findsOneWidget);
    expect(find.byKey(HorizontalTimelinePage.chartKey), findsNothing);

    await t.pump();
    expect(find.byKey(HorizontalTimelinePage.chartKey), findsOneWidget);
    await t.pumpAndSettle();
    expect(t.getSize(find.byKey(GanttChart.labelsKey)).width, 300);
    await t.tap(find.byTooltip('Yalnız kodları göster'));
    await t.pump();
    expect(t.getSize(find.byKey(GanttChart.labelsKey)).width, 150);
    expect(find.text('KOD'), findsOneWidget);
    await t.tap(find.byTooltip('Görev adlarını göster'));
    await t.pump();
    expect(t.getSize(find.byKey(GanttChart.labelsKey)).width, 300);
    await t.tap(find.text('Aylık'));
    await t.pumpAndSettle();
    final monthly = t
        .widget<GanttChart>(find.byKey(HorizontalTimelinePage.chartKey))
        .layout;
    expect(monthly.view.state.zoom, GanttZoom.monthly);
    expect(monthly.ticks, hasLength(12));
    expect(
      monthly.gridLines.toList(),
      monthly.months.map((month) => month.x).toList(),
    );
    await t.tap(find.text('Haftalık'));
    await t.pumpAndSettle();
    final strip = find.byKey(const ValueKey('gantt-season-strip'));
    expect(strip, findsOneWidget);
    final scroll = t
        .widget<SingleChildScrollView>(find.byKey(GanttChart.horizontalKey))
        .controller!;
    final before = scroll.offset;
    await t.tapAt(t.getTopRight(strip) + const Offset(-2, 10));
    await t.pump();
    expect(scroll.offset, greaterThan(before));
    await t.tapAt(t.getTopLeft(strip) + const Offset(2, 10));
    await t.pump();
    expect(scroll.offset, lessThan(before));
    expect(t.takeException(), isNull);
  });
}
