// GoRouterAppNav: kabuk içi hedefler `go` (iç içe yığın, geri dal köküne); tam ekranlar itilir; uygulama
// menüsü (çekmece) modülleri gerçek rotalara bağlar, ekranı olmayanlar yer tutucu bildirimidir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/timeline/timeline.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
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

    nav.openTask('ALT-7');
    await settle(tester);
    expect(locationOf(router), '/tasks/ALT-7');

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
    expect(locationOf(router), '/tasks/ALT-7');

    nav.openTasks(view: NzTaskView.late, people: const ['p1']);
    await settle(tester);
    expect(locationOf(router), '/tasks?view=late&people=p1');

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
    expect(
      find.text('${_l.uiHomeModuleCalendar} ${_l.uiHomeSoonTail}'),
      findsOneWidget,
    );
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
}
