// Faz kapısı davranışı (A5): her AppPhase için hedef rota ve yönlendirme. Bu dosya taşımadan
// ÖNCE yazıldı ve taşımadan sonra değişmeden geçer: kapı davranışı birebir korunur.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/core/app_phase.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

/// Kapı rotaları: faz makinesinin hedef yolları.
final _gatePaths = {for (final p in AppPhase.values) routeForPhase(p)};

/// Taşımadan önceki sözleşme: faz → hedef yol (tablo elle yazılı; koddan türetilmez).
const _expected = <AppPhase, String>{
  AppPhase.unbound: '/server',
  AppPhase.bindingFailed: '/server',
  AppPhase.verifying: '/server',
  AppPhase.updateRequired: '/update-required',
  AppPhase.serverVerified: '/login',
  AppPhase.reauthRequired: '/login',
  AppPhase.passwordChangeRequired: '/password',
  AppPhase.sessionOpen: '/scope',
  AppPhase.scoped: '/home',
};

void main() {
  setUpFonts();

  test('routeForPhase: her faz için sabit hedef (tablo tam)', () {
    expect(_expected.keys.toSet(), AppPhase.values.toSet());
    for (final MapEntry(key: phase, value: path) in _expected.entries) {
      expect(routeForPhase(phase), path, reason: '$phase');
    }
    expect(_gatePaths, {
      '/server',
      '/update-required',
      '/login',
      '/password',
      '/scope',
      '/home',
    });
  });

  for (final phase in AppPhase.values) {
    testWidgets('$phase: açılış konumu faz hedefidir', (tester) async {
      final notifier = ValueNotifier(phase);
      addTearDown(notifier.dispose);
      final router = await pumpRouter(tester, notifier);
      expect(locationOf(router), _expected[phase]);
    });

    testWidgets(
      '$phase: faz dışı her kapı rotasına derin bağlantı faz hedefine döner',
      (tester) async {
        final notifier = ValueNotifier(phase);
        addTearDown(notifier.dispose);
        final router = await pumpRouter(tester, notifier);
        for (final path in _gatePaths) {
          router.go(path);
          await settle(tester);
          expect(
            locationOf(router),
            _expected[phase],
            reason: '$phase ← $path',
          );
        }
      },
    );

    testWidgets(
      '$phase: platform derin bağlantısı (rota bilgisi) kapıyı aşamaz',
      (tester) async {
        final notifier = ValueNotifier(phase);
        addTearDown(notifier.dispose);
        final router = await pumpRouter(tester, notifier);
        for (final path in _gatePaths) {
          await tester.binding.handlePushRoute(path);
          await settle(tester);
          expect(
            locationOf(router),
            _expected[phase],
            reason: '$phase ← derin bağlantı $path',
          );
        }
      },
    );
  }

  // 404 de kapıyı aşamaz: scoped olmayan her fazda bilinmeyen yol faz hedefine gider.
  for (final phase in AppPhase.values.where((p) => p != AppPhase.scoped)) {
    testWidgets('$phase: bilinmeyen yol faz hedefine gider', (tester) async {
      final notifier = ValueNotifier(phase);
      addTearDown(notifier.dispose);
      final router = await pumpRouter(tester, notifier);
      for (final path in ['/yok', '/yok/bilinmiyor/5', '/server/x']) {
        router.go(path);
        await settle(tester);
        expect(locationOf(router), _expected[phase], reason: '$phase ← $path');
      }
    });
  }

  testWidgets('refreshListenable: faz değişince yönlendirme (tüm geçişler)', (
    tester,
  ) async {
    final notifier = ValueNotifier(AppPhase.unbound);
    addTearDown(notifier.dispose);
    final router = await pumpRouter(tester, notifier);
    for (final from in AppPhase.values) {
      for (final to in AppPhase.values) {
        notifier.value = from;
        await settle(tester);
        expect(locationOf(router), _expected[from], reason: '→ $from');
        notifier.value = to;
        await settle(tester);
        expect(locationOf(router), _expected[to], reason: '$from → $to');
      }
    }
  });

  testWidgets(
    'platform derin bağlantısı yönlendiriciye ulaşır (kanıt: katalog muaf)',
    (tester) async {
      // Derin bağlantı testlerinin boş geçmediğinin kanıtı: muaf rota bağlantıyla açılır.
      final notifier = ValueNotifier(AppPhase.unbound);
      addTearDown(notifier.dispose);
      final router = await pumpRouter(tester, notifier, devCatalog: true);
      await tester.binding.handlePushRoute(catalogPath);
      await settle(tester);
      expect(locationOf(router), catalogPath);
    },
  );
}
