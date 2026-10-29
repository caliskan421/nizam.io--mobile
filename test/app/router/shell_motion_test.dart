import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/motion/page_content_entrance.dart';
import 'package:nizamio/core/ui/theme/nz_motion.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_top_bar.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('korunan dallarda sayfa kabuğu ve alt menü animasyonsuzdur', (
    tester,
  ) async {
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    await pumpRouter(tester, phase, width: 400);
    await settle(tester);
    final nav = find.byType(NzFloatingNav);
    final navRect = tester.getRect(nav);
    final context = tester.element(find.byType(NzAdaptiveShell));
    const TasksRoute().go(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    final fades = find.ancestor(
      of: find.byType(TasksPage),
      matching: find.byType(Opacity),
    );
    expect(fades, findsNothing);
    final entrance = find
        .descendant(
          of: find.byType(TasksPage),
          matching: find.byType(PageContentEntrance),
        )
        .first;
    final opacity = find
        .descendant(of: entrance, matching: find.byType(SliverOpacity))
        .first;
    expect(
      tester.widget<SliverOpacity>(opacity).opacity,
      closeTo(RpMotion.enterCurve.transform(150 / 320), 0.001),
    );
    final appbar = find.descendant(
      of: find.byType(TasksPage),
      matching: find.byType(NzTopBar),
    );
    expect(
      find.ancestor(of: appbar, matching: find.byType(PageContentEntrance)),
      findsNothing,
    );
    expect(tester.getRect(nav), navRect);
    await settle(tester);
    const HomeRoute().go(tester.element(find.byType(NzAdaptiveShell)));
    await settle(tester);
    const TasksRoute().go(tester.element(find.byType(NzAdaptiveShell)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(fades, findsNothing);
    expect(
      tester.widget<SliverOpacity>(opacity).opacity,
      closeTo(RpMotion.enterCurve.transform(150 / 320), 0.001),
    );
    await settle(tester);
  });
}
