// A5 yeni davranışlar: kabuk (yalnız scoped), sekme yığını, 404, yığın temizleme, feature kaydı.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/pages.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

/// Kabuk içi / feature / derin rotalar: yalnız `scoped` fazında açılırlar.
const _scopedOnly = ['/work', '/profile', '/home/detail/5', '/work/detail/7'];

BuildContext _ctx(WidgetTester tester) =>
    tester.element(find.byType(NzAdaptiveShell));

Future<GoRouter> _scoped(WidgetTester tester, {double width = 400}) async {
  final phase = ValueNotifier(AppPhase.scoped);
  addTearDown(phase.dispose);
  return pumpRouter(tester, phase, width: width);
}

void main() {
  setUpFonts();

  test('tipli rota yolları faz hedefleriyle aynıdır', () {
    expect(const ServerRoute().location, '/server');
    expect(const UpdateRequiredRoute().location, '/update-required');
    expect(const LoginRoute().location, '/login');
    expect(const PasswordRoute().location, '/password');
    expect(const ScopeRoute().location, '/scope');
    expect(const HomeRoute().location, '/home');
    expect(const HomeDetailRoute(id: 'a b').location, '/home/detail/a%20b');
    expect(const WorkDetailRoute(id: '7').location, '/work/detail/7');
  });

  test('gateRedirect: saf karar tablosu', () {
    expect(gateRedirect(AppPhase.scoped, '/home'), isNull);
    expect(gateRedirect(AppPhase.scoped, '/work'), isNull);
    expect(gateRedirect(AppPhase.scoped, '/yok'), isNull); // 404'e düşer
    expect(gateRedirect(AppPhase.scoped, '/login'), '/home');
    expect(gateRedirect(AppPhase.scoped, '/server'), '/home');
    expect(gateRedirect(AppPhase.unbound, '/work'), '/server');
    expect(gateRedirect(AppPhase.unbound, '/yok'), '/server');
    expect(gateRedirect(AppPhase.unbound, '/dev/catalog'), '/server');
    expect(
      gateRedirect(AppPhase.unbound, '/dev/catalog', devCatalog: true),
      isNull,
    );
    expect(gateRedirect(AppPhase.scoped, '/dev/catalog'), isNull);
  });

  group('faz × korunan rota matrisi (kabuk ve derin rotalar)', () {
    for (final phase in AppPhase.values.where((p) => p != AppPhase.scoped)) {
      testWidgets('$phase: kabuk rotaları faz hedefine döner, kabuk kurulmaz', (
        tester,
      ) async {
        final notifier = ValueNotifier(phase);
        addTearDown(notifier.dispose);
        final router = await pumpRouter(tester, notifier);
        for (final path in [..._scopedOnly, '/home']) {
          router.go(path);
          await settle(tester);
          expect(locationOf(router), routeForPhase(phase), reason: path);
          expect(find.byType(NzAdaptiveShell), findsNothing, reason: path);
        }
        for (final path in _scopedOnly) {
          await tester.binding.handlePushRoute(path);
          await settle(tester);
          expect(locationOf(router), routeForPhase(phase), reason: path);
        }
      });
    }

    testWidgets('scoped: kapı rotaları /home\'a döner', (tester) async {
      final router = await _scoped(tester);
      for (final path in [
        '/server',
        '/update-required',
        '/login',
        '/password',
        '/scope',
      ]) {
        router.go(path);
        await settle(tester);
        expect(locationOf(router), '/home', reason: path);
      }
    });

    testWidgets('scoped: kabuk ve derin rotalar açılır', (tester) async {
      final router = await _scoped(tester);
      for (final path in _scopedOnly) {
        router.go(path);
        await settle(tester);
        expect(locationOf(router), path);
        expect(find.byType(NzAdaptiveShell), findsOneWidget);
      }
    });
  });

  group('404', () {
    testWidgets(
      'scoped: bilinmeyen yol 404 sayfasıdır; düğme /home\'a götürür',
      (tester) async {
        final router = await _scoped(tester);
        router.go('/yok/bilinmiyor');
        await settle(tester);
        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.text('Sayfa bulunamadı'), findsWidgets);

        await tester.tap(find.text('Ana sayfaya dön'));
        await settle(tester);
        expect(locationOf(router), '/home');
        expect(find.byType(NotFoundPage), findsNothing);
      },
    );

    testWidgets('scoped, prod: /dev/catalog tanımsız → 404', (tester) async {
      final router = await _scoped(tester);
      router.go(catalogPath);
      await settle(tester);
      expect(find.byType(NotFoundPage), findsOneWidget);
    });

    testWidgets('scoped değilken 404 sayfası hiç görünmez', (tester) async {
      final notifier = ValueNotifier(AppPhase.serverVerified);
      addTearDown(notifier.dispose);
      final router = await pumpRouter(tester, notifier);
      router.go('/yok');
      await settle(tester);
      expect(find.byType(NotFoundPage), findsNothing);
      expect(locationOf(router), '/login');
    });
  });

  group('kabuk', () {
    testWidgets('compact: yüzen cam alt menü, ray yok', (tester) async {
      await _scoped(tester, width: 400);
      expect(find.byType(NzFloatingNav), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(
        tester.widget<NzFloatingNav>(find.byType(NzFloatingNav)).items,
        hasLength(shellTabs.length),
      );
    });

    testWidgets(
      'compact: kökte etkin sekmeye yeniden dokunma kısayol olayıdır',
      (tester) async {
        final router = await _scoped(tester, width: 400);
        final container = ProviderScope.containerOf(_ctx(tester));
        expect(container.read(shellReselectEventsProvider), isNull);
        await tester.tap(find.byIcon(shellTabs[0].icon));
        await settle(tester);
        expect(container.read(shellReselectEventsProvider)?.tab, 0);
        expect(locationOf(router), '/home');
      },
    );

    testWidgets('medium: NavigationRail (daralmış), alt çubuk yok', (
      tester,
    ) async {
      await _scoped(tester, width: 700);
      expect(find.byType(NzFloatingNav), findsNothing);
      expect(
        tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse,
      );
    });

    testWidgets('expanded: genişletilmiş ray', (tester) async {
      await _scoped(tester, width: 1100);
      expect(find.byType(NzFloatingNav), findsNothing);
      expect(
        tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue,
      );
    });

    testWidgets('sekme sayısı dal sayısıyla aynıdır', (tester) async {
      final router = await _scoped(tester);
      final shell = router.configuration.routes
          .whereType<StatefulShellRoute>()
          .single;
      expect(shell.branches.length, shellTabs.length);
    });

    testWidgets('sekme değiştirip dönünce iç rota korunur', (tester) async {
      final router = await _scoped(tester);
      const HomeDetailRoute(id: '5').go(_ctx(tester));
      await settle(tester);
      expect(locationOf(router), '/home/detail/5');

      await tester.tap(find.byIcon(shellTabs[1].icon));
      await settle(tester);
      expect(locationOf(router), '/work');

      await tester.tap(find.byIcon(shellTabs[0].icon));
      await settle(tester);
      expect(locationOf(router), '/home/detail/5');
      expect(find.textContaining('5'), findsWidgets);

      // Seçili sekmeye (kökte değilken) yeniden dokunma kök konuma döner.
      await tester.tap(find.byIcon(shellTabs[0].icon));
      await settle(tester);
      expect(locationOf(router), '/home');
    });

    testWidgets('expanded rayda da sekme yığını korunur', (tester) async {
      final router = await _scoped(tester, width: 1100);
      const WorkDetailRoute(id: '9').go(_ctx(tester));
      await settle(tester);
      await tester.tap(find.text('Profil'));
      await settle(tester);
      expect(locationOf(router), '/profile');
      await tester.tap(find.text('Görevler'));
      await settle(tester);
      expect(locationOf(router), '/work/detail/9');
    });
  });

  group('yeniden bağlanma: gezinme yığını temizlenir', () {
    for (final away in [
      AppPhase.unbound,
      AppPhase.verifying,
      AppPhase.bindingFailed,
      AppPhase.sessionOpen,
    ]) {
      testWidgets('scoped → $away → scoped: eski ekran geri tuşuyla görünmez', (
        tester,
      ) async {
        final notifier = ValueNotifier(AppPhase.scoped);
        addTearDown(notifier.dispose);
        final router = await pumpRouter(tester, notifier);

        // Eski sunucunun ekranları: başka sekmede iç rota + üstte itilmiş ayrıntı.
        const WorkDetailRoute(id: 'ESKI-SEKME').go(_ctx(tester));
        await settle(tester);
        unawaited(
          const HomeDetailRoute(id: 'ESKI-ITILMIS').push<void>(_ctx(tester)),
        );
        await settle(tester);
        expect(find.textContaining('ESKI-ITILMIS'), findsOneWidget);
        expect(router.canPop(), isTrue);

        notifier.value = away;
        await settle(tester);
        expect(locationOf(router), routeForPhase(away));
        expect(router.canPop(), isFalse);
        expect(find.textContaining('ESKI'), findsNothing);
        expect(find.byType(NzAdaptiveShell), findsNothing);

        // Geri tuşu (sistem pop) eski ekranı getirmez.
        await tester.binding.handlePopRoute();
        await settle(tester);
        expect(locationOf(router), routeForPhase(away));
        expect(find.textContaining('ESKI'), findsNothing);

        // Yeni oturum: temiz /home, eski iç rota ve yığın yok.
        notifier.value = AppPhase.scoped;
        await settle(tester);
        expect(locationOf(router), '/home');
        expect(router.canPop(), isFalse);
        expect(find.textContaining('ESKI'), findsNothing);
        await tester.tap(find.byIcon(shellTabs[1].icon));
        await settle(tester);
        expect(locationOf(router), '/work');
        expect(find.textContaining('ESKI'), findsNothing);
      });
    }
  });

  group('feature rota kaydı', () {
    final featureRoute = GoRoute(
      path: '/feat',
      builder: (context, state) => const Text('FEATURE'),
    );

    Future<(GoRouter, ValueNotifier<AppPhase>)> pumpWith(
      WidgetTester tester,
      AppPhase phase,
    ) async {
      final notifier = ValueNotifier(phase);
      addTearDown(notifier.dispose);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.reset);
      final router = createRouter(notifier, featureRoutes: [featureRoute]);
      addTearDown(router.dispose);
      await pumpRouterWidget(tester, router);
      return (router, notifier);
    }

    testWidgets('scoped: feature rotası açılır', (tester) async {
      final (router, _) = await pumpWith(tester, AppPhase.scoped);
      router.go('/feat');
      await settle(tester);
      expect(locationOf(router), '/feat');
      expect(find.text('FEATURE'), findsOneWidget);
    });

    for (final phase in AppPhase.values.where((p) => p != AppPhase.scoped)) {
      testWidgets('$phase: feature rotası faz kapısını aşamaz', (tester) async {
        final (router, _) = await pumpWith(tester, phase);
        router.go('/feat');
        await settle(tester);
        expect(locationOf(router), routeForPhase(phase));
        expect(find.text('FEATURE'), findsNothing);
      });
    }
  });

  testWidgets('geçiş: tek yerde solma; animasyonlar azaltılınca geçişsiz', (
    tester,
  ) async {
    await _scoped(tester);
    int fades(String id) => find
        .ancestor(
          of: find.textContaining(id),
          matching: find.byType(FadeTransition),
        )
        .evaluate()
        .length;

    const HomeDetailRoute(id: 'ANIM').go(_ctx(tester));
    await settle(tester);
    final withFade = fades('ANIM');

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    const WorkDetailRoute(id: 'DURAGAN').go(_ctx(tester));
    await settle(tester);
    expect(fades('DURAGAN'), withFade - 1);
  });
}
