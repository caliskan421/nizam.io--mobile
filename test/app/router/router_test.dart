// Prototip modu (yalnız dev flavor): oturumsuz ana sayfada açılır; kapı rotaları normal kalır.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

void main() {
  setUpFonts();

  testWidgets(
    'prototip modu kapalı (varsayılan): kabuk rotaları faz hedefine döner',
    (tester) async {
      final phase = ValueNotifier(AppPhase.unbound);
      addTearDown(phase.dispose);
      final router = await pumpRouter(tester, phase);
      expect(locationOf(router), '/server');
      router.go('/tasks');
      await tester.pump();
      await tester.pump();
      expect(locationOf(router), '/server');
      phase.value = AppPhase.scoped;
      await tester.pump();
      await tester.pump();
      expect(locationOf(router), '/home');
      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets('prototip modu: oturumsuz ana sayfada açılır, kabuğa girer', (
    tester,
  ) async {
    final phase = ValueNotifier(AppPhase.unbound);
    addTearDown(phase.dispose);
    final router = await pumpRouter(tester, phase, devPrototype: true);
    await tester.pump(const Duration(seconds: 1));
    expect(locationOf(router), '/home');
    router.go('/tasks');
    await tester.pump();
    await tester.pump();
    expect(locationOf(router), '/tasks');
    router.go('/login');
    await tester.pump();
    await tester.pump();
    expect(locationOf(router), '/server');
    await tester.pump(const Duration(seconds: 1));
  });
}
