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
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_controls.dart';
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
  testWidgets('ilk karede iskelet var, Gantt gövdesi yok; sonraki karede var', (
    t,
  ) async {
    t.view.physicalSize = const Size(1376, 1032);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final c = ProviderContainer(
      overrides: [
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
    expect(t.takeException(), isNull);
  });
}
