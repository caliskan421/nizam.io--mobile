// Yalnız katalog rotası (W21): `devCatalog` kapalıyken tanımsız, açıkken faz yönlendirmesinden muaf.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/dev/catalog_page.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/core/app_phase.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

Future<GoRouter> _pump(
  WidgetTester tester,
  ValueNotifier<AppPhase> phase, {
  required bool devCatalog,
}) => pumpRouter(tester, phase, devCatalog: devCatalog);

String _location(GoRouter r) => locationOf(r);

bool _hasCatalogRoute(GoRouter r) =>
    r.configuration.routes.any((x) => x is GoRoute && x.path == catalogPath);

void main() {
  setUpFonts();

  testWidgets(
    'devCatalog kapalı (varsayılan): rota tanımlı değil, faz rotasına düşer',
    (tester) async {
      final phase = ValueNotifier(AppPhase.unbound);
      addTearDown(phase.dispose);
      final router = await _pump(tester, phase, devCatalog: false);
      expect(_hasCatalogRoute(router), isFalse);

      router.go(catalogPath);
      await tester.pump();
      await tester.pump();
      expect(_location(router), '/server');
      expect(find.byType(CatalogPage), findsNothing);
    },
  );

  testWidgets('devCatalog açık: /dev/catalog faz makinesinden muaf', (
    tester,
  ) async {
    final phase = ValueNotifier(AppPhase.unbound);
    addTearDown(phase.dispose);
    final router = await _pump(tester, phase, devCatalog: true);
    expect(_hasCatalogRoute(router), isTrue);

    router.go(catalogPath);
    await tester.pump();
    await tester.pump();
    expect(_location(router), catalogPath);
    expect(find.byType(CatalogPage), findsOneWidget);

    // Faz değişse de katalogda kalınır.
    phase.value = AppPhase.sessionOpen;
    await tester.pump();
    await tester.pump();
    expect(_location(router), catalogPath);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('devCatalog açık: diğer rotalar faz makinesine bağlı kalır', (
    tester,
  ) async {
    final phase = ValueNotifier(AppPhase.unbound);
    addTearDown(phase.dispose);
    final router = await _pump(tester, phase, devCatalog: true);
    expect(_location(router), '/server');

    router.go('/home');
    await tester.pump();
    await tester.pump();
    expect(_location(router), '/server');

    phase.value = AppPhase.scoped;
    await tester.pump();
    await tester.pump();
    expect(_location(router), '/home');
  });

  testWidgets('prototip modu: katalogdan açılır, oturumsuz kabuğa girer', (
    tester,
  ) async {
    final phase = ValueNotifier(AppPhase.unbound);
    final prototype = ValueNotifier(false);
    addTearDown(phase.dispose);
    addTearDown(prototype.dispose);
    final router = await pumpRouter(
      tester,
      phase,
      devCatalog: true,
      devPrototype: prototype,
    );
    router.go('/tasks');
    await tester.pump();
    await tester.pump();
    expect(_location(router), '/server');
    router.go(catalogPath);
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Prototype'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(prototype.value, isTrue);
    expect(_location(router), '/home');
    router.go('/tasks');
    await tester.pump();
    await tester.pump();
    expect(_location(router), '/tasks');
    await tester.pump(const Duration(seconds: 1));
  });
}
