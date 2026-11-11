import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_filter_choice.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_group_filter_chip.dart';
import 'package:nizamio/features/tasks/application/tasks_list_controller.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/presentation/tasks/tasks_list_parts.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

void main() {
  setUpFonts();
  testWidgets('araç satırı dar ekranda filtre ve sıralamayı gösterir', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.reset);
    final setup = await tester.runAsync(() async {
      final h = await pilotHarness(CoordBackend(), signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final catalog = await h.container.read(
        taskCatalogControllerProvider.future,
      );
      return (h.container, catalog);
    });
    final (container, catalog) = setup!;
    final scoped = catalog.filtered(
      codes: [for (final task in catalog.tasks) task.code],
      truncated: true,
    );
    final provider = tasksListControllerProvider(TaskView.all, '');
    final controller = container.read(provider.notifier);
    controller
      ..toggleCoordinatorship(dAlt)
      ..togglePerson(pAli)
      ..togglePerson(pKadir)
      ..togglePriority(TaskPriority.low)
      ..togglePriority(TaskPriority.high);
    TaskFilterGroup? opened;
    final state = container.read(provider);
    final result = queryTasks(
      scoped,
      view: state.view,
      sort: state.sort,
      descending: state.descending,
      filter: state.filter,
    );
    await tester.pumpWidget(
      testApp(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(2),
          ),
          child: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: tasksListChildren(
                  context,
                  catalog: scoped,
                  state: state,
                  result: result,
                  ctl: controller,
                  onClearAll: () {},
                  onFilter: (group) => opened = group,
                  onOpen: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('TÜM GÖREVLER · ≥${result.tasks.length}'), findsNothing);
    expect(find.byType(NzGroupFilterChip), findsNWidgets(3));
    expect(find.text('2 kişi'), findsOneWidget);
    expect(find.text('Yüksek, Düşük'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Kişi filtresi: 2 kişi · düzenle'));
    expect(opened, TaskFilterGroup.people);
    await tester.tap(find.bySemanticsLabel('Kişi filtresini kaldır'));
    expect(container.read(provider).filter.people, isEmpty);
    expect(container.read(provider).filter.priorities.length, 2);
    await tester.tap(
      find.bySemanticsLabel('Sıralama ölçütünü değiştir: Bitiş tarihine göre'),
    );
    await tester.pumpAndSettle();
    expect(container.read(provider).sort, TaskSort.start);
    final beforeDirection = container.read(provider).descending;
    await tester.tap(
      find.bySemanticsLabel('Sırayı ters çevir: küçükten büyüğe'),
    );
    expect(container.read(provider).descending, isNot(beforeDirection));
    tester.view.physicalSize = const Size(700, 1000);
    await tester.pumpWidget(
      testApp(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(700, 1000),
            textScaler: TextScaler.linear(2),
          ),
          child: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: tasksListChildren(
                  context,
                  catalog: scoped,
                  state: state,
                  result: result,
                  ctl: controller,
                  onClearAll: () {},
                  onFilter: (_) {},
                  onOpen: (_) {},
                ),
              ),
            ),
          ),
        ),
        dark: true,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('TÜM GÖREVLER · ≥${result.tasks.length}'), findsNothing);
  });
  testWidgets('öncelik çipi diğer gruplar kapalıyken segmenti gösterir', (
    tester,
  ) async {
    final catalog = (await tester.runAsync(() async {
      final h = await pilotHarness(CoordBackend(), signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      return h.container.read(taskCatalogControllerProvider.future);
    }))!;
    final options = filterOptions(catalog);
    await tester.pumpWidget(
      ProviderScope(
        child: testApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSharedTasksFilterSheet(
                context,
                initialGroup: TaskFilterGroup.priority,
                data: (_) => TasksFilterSheetData(
                  filter: const TaskFilter(),
                  options: options,
                  count: 0,
                  truncated: false,
                  onClear: () {},
                  onPerson: (_) {},
                  onCoordinatorship: (_) {},
                  onPriority: (_) {},
                ),
              ),
              child: const Text('Aç'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Aç'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskSegmented), findsOneWidget);
    expect(find.byType(NzFilterChoice), findsNothing);
  });
}
