// GoRouterAppNav: kabuk içi hedefler `go` (iç içe yığın, geri dal köküne); tam ekranlar itilir; uygulama
// menüsü (çekmece) modülleri gerçek rotalara bağlar, ekranı olmayanlar yer tutucu bildirimidir.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/tasks/application/tasks_list_controller.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/timeline.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../support/harness.dart';
import 'router_test_support.dart';

final _l = AppLocalizationsTr();

Future<(GoRouter, NzAppNav)> _scoped(WidgetTester tester) async {
  final phase = ValueNotifier(AppPhase.scoped);
  addTearDown(phase.dispose);
  final router = await pumpRouter(tester, phase, width: 400, height: 900);
  final nav = NzAppNavScope.of(tester.element(find.byType(NzAdaptiveShell)));
  return (router, nav);
}

void main() {
  setUpFonts();

  testWidgets('kabuk içi go (iç içe yığın), tam ekran itme', (tester) async {
    final (router, nav) = await _scoped(tester);
    nav.openHistory();
    await settle(tester);
    expect(locationOf(router), '/home/history');
    expect(router.canPop(), isTrue);

    // Başka modülün kaydı bulunulan konumun izine itilir (geri açıldığı sayfaya döner).
    nav.openTask('ALT-7');
    await settle(tester);
    expect(locationOf(router), '/home/history?trail=task%3AALT-7');

    // İtilen tam ekranlar konumda değil sayfa olarak görünür (go_router push yapılandırmayı
    // değiştirmez); geri açıldıkları sayfaya döner.
    nav.openTimeline(coordinatorship: 'ALT');
    await settle(tester);
    expect(
      tester.widget<TimelinePage>(find.byType(TimelinePage)).coordinatorship,
      'ALT',
    );
    router.pop();
    await settle(tester);
    expect(find.byType(TimelinePage), findsNothing);
    expect(locationOf(router), '/home/history?trail=task%3AALT-7');

    nav.openTasks(view: NzTaskView.late, people: const ['p1']);
    await settle(tester);
    expect(locationOf(router), '/tasks?view=late&people=p1');

    nav.openTasks(
      view: NzTaskView.late,
      people: const ['p1'],
      coordinatorship: 'ALT',
    );
    await settle(tester);
    expect(locationOf(router), '/tasks?view=late&people=p1&coord=ALT');
    expect(
      tester.widget<TasksPage>(find.byType(TasksPage)).coordinatorship,
      'ALT',
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TasksPage)),
    );
    final list = tasksListControllerProvider(TaskView.late, 'p1');
    expect(container.read(list).filter.coordinatorships, {'ALT'});
    container.read(list.notifier).toggleCoordinatorship('ALT');
    expect(container.read(list).filter.coordinatorships, isEmpty);
    nav.openCoordinatorships();
    await settle(tester);
    nav.openTasks(
      view: NzTaskView.late,
      people: const ['p1'],
      coordinatorship: 'ALT',
    );
    await settle(tester);
    expect(container.read(list).filter.coordinatorships, {'ALT'});

    nav.openArchive();
    await settle(tester);
    nav.openArchiveFolder('ALT');
    await settle(tester);
    expect(locationOf(router), '/archive/ALT');
    nav.openMessages();
    await settle(tester);
    nav.openChat('gen');
    await settle(tester);
    expect(tester.widget<ChatPage>(find.byType(ChatPage)).id, 'gen');
    router.pop();
    await settle(tester);
    nav.openProfile();
    await settle(tester);
    expect(find.byType(ProfilePage), findsOneWidget);
    router.pop();
    await settle(tester);
    nav.openHome();
    await settle(tester);
    expect(locationOf(router), '/home');
    nav.openCoordinatorships();
    await settle(tester);
    nav.openCoordinatorship('ALT');
    await settle(tester);
    expect(locationOf(router), '/coordinatorships/ALT');

    // Koordinatörlükten açılan görev izde; geri koordinatörlüğe döner, Görevler'e değil.
    nav.openTask('ALT-7');
    await settle(tester);
    expect(locationOf(router), '/coordinatorships/ALT?trail=task%3AALT-7');
    NzPaneScope.back(tester.element(find.byType(TaskDetailPage)));
    await settle(tester);
    expect(locationOf(router), '/coordinatorships/ALT');
  });

  testWidgets('menü: modüller rotalara gider; ekranı olmayan yer tutucu', (
    tester,
  ) async {
    final (router, _) = await _scoped(tester);
    Future<void> openMenu() async {
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);
    }

    await openMenu();
    await tester.tap(find.text(_l.uiHomeModuleCalendar));
    await settle(tester);
    expect(locationOf(router), '/calendar');
    router.go('/home');
    await settle(tester);
    await openMenu();
    await tester.tap(find.text(_l.uiHomeModuleMemory));
    await settle(tester);
    expect(
      find.text('${_l.uiHomeModuleMemory} ${_l.uiHomeSoonTail}'),
      findsOneWidget,
    );
    expect(locationOf(router), '/home');
    await openMenu();
    await tester.tap(find.text(_l.uiHomeModuleTasks));
    await settle(tester);
    expect(locationOf(router), '/tasks');
    router.go('/home');
    await settle(tester);
    await openMenu();
    await tester.drag(find.text(_l.uiHomeModuleTasks), const Offset(0, -400));
    await settle(tester);
    await tester.tap(find.text(_l.uiHomeCoordinatorships).last);
    await settle(tester);
    expect(locationOf(router), '/coordinatorships');
  });

  testWidgets('menü: görünüm seçici tema modunu kalıcı değiştirir', (
    tester,
  ) async {
    final h = Harness();
    addTearDown(h.dispose);
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 900);
    addTearDown(tester.view.reset);
    final router = createRouter(phase);
    addTearDown(router.dispose);
    await pumpRouterWidget(tester, router, harness: h);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await settle(tester);
    await tester.scrollUntilVisible(
      find.text(_l.uiHomeThemeLight),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(_l.uiHomeThemeLight));
    await settle(tester);
    expect(h.read(themeModeProvider), ThemeMode.light);
    expect(h.prefs.values[AppPreferences.themeModeKey], 'light');
  });
}
