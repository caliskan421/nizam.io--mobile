// Prototip modu (yalnız dev flavor): login ekranında açılır; kapı rotaları normal kalır.
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

  testWidgets('oturum kapanınca (çıkış) kabuktan girişe zorunlu dönülür', (
    tester,
  ) async {
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    final router = await pumpRouter(tester, phase);
    await tester.pump(const Duration(seconds: 1));
    router.go('/tasks');
    await tester.pump();
    await tester.pump();
    expect(locationOf(router), '/tasks');
    phase.value = AppPhase.serverVerified;
    await tester.pump();
    await tester.pump();
    expect(locationOf(router), '/login');
    router.go('/tasks');
    await tester.pump();
    await tester.pump();
    expect(locationOf(router), '/login');
    await tester.pump(const Duration(seconds: 1));
  });
}
