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
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

/// Kabuk içi / feature / derin rotalar: yalnız `scoped` fazında açılırlar.
const _scopedOnly = [
  '/tasks',
  '/profile',
  '/home/history',
  '/tasks/ALT-7',
  '/coordinatorships',
  '/coordinatorships/ALT',
  '/archive',
  '/archive/ALT',
  '/messages',
  '/timeline',
  '/chat/gen',
];

/// Kabuk sekme simgeleri (sıra dal sırası; üçüncüsü varsayılan modül Koordinatörlükler).
const _tabIcons = [
  Icons.home_outlined,
  Icons.checklist_rounded,
  Icons.apartment_rounded,
];

/// Tablet rayındaki modül öğesi (etiketiyle).
Finder _railItem(String label) =>
    find.descendant(of: find.byType(NzTabletRail), matching: find.text(label));

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
    expect(const HistoryRoute().location, '/home/history');
    expect(const TaskDetailRoute(code: 'a b').location, '/tasks/a%20b');
    expect(
      const TasksRoute(view: 'late', people: ['p1']).location,
      '/tasks?view=late&people=p1',
    );
    expect(
      const CoordinatorshipRoute(code: 'ALT').location,
      '/coordinatorships/ALT',
    );
    expect(const ArchiveFolderRoute(code: 'ALT').location, '/archive/ALT');
    expect(const TimelineRoute(coord: 'ALT').location, '/timeline?coord=ALT');
    expect(const ChatRoute(id: 'gen').location, '/chat/gen');
  });

  test('gateRedirect: saf karar tablosu', () {
    expect(gateRedirect(AppPhase.scoped, '/home'), isNull);
    expect(gateRedirect(AppPhase.scoped, '/tasks'), isNull);
    expect(gateRedirect(AppPhase.scoped, '/yok'), isNull); // 404'e düşer
    expect(gateRedirect(AppPhase.scoped, '/login'), '/home');
    expect(gateRedirect(AppPhase.scoped, '/server'), '/home');
    expect(gateRedirect(AppPhase.unbound, '/tasks'), '/server');
    expect(gateRedirect(AppPhase.unbound, '/yok'), '/server');
    // Prototip modu (yalnız dev flavor): kabuk/feature rotaları açık; kapı rotaları normal kalır.
    expect(
      gateRedirect(AppPhase.unbound, '/tasks', devPrototype: true),
      isNull,
    );
    expect(gateRedirect(AppPhase.unbound, '/home', devPrototype: true), isNull);
    expect(
      gateRedirect(AppPhase.unbound, '/login', devPrototype: true),
      isNull,
    );
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
        // Zaman çizelgesi, sohbet ve profil kabuk dışıdır (alt menü yok).
        final fullScreen =
            path == '/timeline' ||
            path == '/profile' ||
            path.startsWith('/chat/');
        expect(
          find.byType(NzAdaptiveShell),
          fullScreen ? findsNothing : findsOneWidget,
          reason: path,
        );
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

    testWidgets('scoped: kaldırılan /dev/catalog tanımsız → 404', (
      tester,
    ) async {
      final router = await _scoped(tester);
      router.go('/dev/catalog');
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
        hasLength(_tabIcons.length),
      );
    });

    testWidgets(
      'compact: etkin sekmeye yeniden dokunma kısayol olayıdır (alt sayfada da)',
      (tester) async {
        final router = await _scoped(tester, width: 400);
        final container = ProviderScope.containerOf(_ctx(tester));
        expect(container.read(shellReselectEventsProvider), isNull);
        await tester.tap(find.byIcon(_tabIcons[0]));
        await settle(tester);
        expect(container.read(shellReselectEventsProvider)?.tab, 0);
        expect(locationOf(router), '/home');
        // Ana sayfa olayı dinleyip kısayol menüsünü açtı; dışarı dokunup kapat.
        await tester.tapAt(const Offset(390, 10));
        await settle(tester);
        const HistoryRoute().go(_ctx(tester));
        await settle(tester);
        await tester.tap(find.byIcon(_tabIcons[0]));
        await settle(tester);
        expect(container.read(shellReselectEventsProvider)?.seq, 2);
        expect(locationOf(router), '/home/history');
      },
    );

    testWidgets('üçüncü öğe son girilen modüldür', (tester) async {
      final router = await _scoped(tester, width: 400);
      router.go('/messages');
      await settle(tester);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
      router.go('/home');
      await settle(tester);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chat_bubble_outline_rounded));
      await settle(tester);
      expect(locationOf(router), '/messages');
    });

    testWidgets('zaman çizelgesi ve sohbet kabuk dışıdır (alt menü yok)', (
      tester,
    ) async {
      final router = await _scoped(tester, width: 400);
      for (final path in ['/timeline', '/chat/gen']) {
        router.go(path);
        await settle(tester);
        expect(find.byType(NzFloatingNav), findsNothing, reason: path);
      }
    });

    testWidgets('medium: tablet rayı (altı modül) + tek bölme, alt çubuk yok', (
      tester,
    ) async {
      await _scoped(tester, width: 700);
      expect(find.byType(NzFloatingNav), findsNothing);
      expect(
        tester.widget<NzTabletRail>(find.byType(NzTabletRail)).items,
        hasLength(6),
      );
      // Bölme rolü yok (sağ yığının yalnız geri bağlamı olabilir).
      expect(
        find.byWidgetPredicate((w) => w is NzPaneScope && w.role != null),
        findsNothing,
      );
    });

    testWidgets('expanded: tablet rayı + liste ve ayrıntı bölmesi', (
      tester,
    ) async {
      await _scoped(tester, width: 1100);
      expect(find.byType(NzFloatingNav), findsNothing);
      expect(find.byType(NzTabletRail), findsOneWidget);
      expect(
        tester.getSize(find.byType(NzTabletRail)).width,
        NzTabletMetrics.railWidth,
      );
      final roles = tester
          .widgetList<NzPaneScope>(find.byType(NzPaneScope))
          .map((p) => p.role);
      expect(roles, containsAll(NzPaneRole.values));
    });

    testWidgets('sekme sayısı dal sayısıyla aynıdır', (tester) async {
      final router = await _scoped(tester);
      final shell = router.configuration.routes
          .whereType<StatefulShellRoute>()
          .single;
      expect(shell.branches.length, _tabIcons.length);
    });

    testWidgets('sekme değiştirip dönünce iç rota korunur', (tester) async {
      final router = await _scoped(tester);
      const HistoryRoute().go(_ctx(tester));
      await settle(tester);
      expect(locationOf(router), '/home/history');

      await tester.tap(find.byIcon(_tabIcons[1]));
      await settle(tester);
      expect(locationOf(router), '/tasks');

      await tester.tap(find.byIcon(_tabIcons[0]));
      await settle(tester);
      expect(locationOf(router), '/home/history');
    });

    testWidgets(
      'expanded rayda modül değişimi modül varsayılanına döner (prototip tgo)',
      (tester) async {
        final router = await _scoped(tester, width: 1100);
        const TaskDetailRoute(code: '9').go(_ctx(tester));
        await settle(tester);
        await tester.tap(_railItem('Ana sayfa'));
        await settle(tester);
        expect(locationOf(router), '/home');
        await tester.tap(_railItem('Görevler'));
        await settle(tester);
        // Son açılan görev (prototip alt ekranı kalıcı), rotada kimlikle.
        expect(locationOf(router), '/tasks/9');
      },
    );
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

        // Eski sunucunun ekranları: başka sekmede iç rota + üstte itilmiş tam ekran.
        const TaskDetailRoute(code: 'ESKI-SEKME').go(_ctx(tester));
        await settle(tester);
        unawaited(const ChatRoute(id: 'ESKI-ITILMIS').push<void>(_ctx(tester)));
        await settle(tester);
        expect(find.byType(ChatPage), findsOneWidget);
        expect(router.canPop(), isTrue);

        notifier.value = away;
        await settle(tester);
        expect(locationOf(router), routeForPhase(away));
        expect(router.canPop(), isFalse);
        expect(find.byType(ChatPage), findsNothing);
        expect(find.byType(TaskDetailPage), findsNothing);
        expect(find.byType(NzAdaptiveShell), findsNothing);

        // Geri tuşu (sistem pop) eski ekranı getirmez.
        await tester.binding.handlePopRoute();
        await settle(tester);
        expect(locationOf(router), routeForPhase(away));
        expect(find.byType(ChatPage), findsNothing);

        // Yeni oturum: temiz /home, eski iç rota ve yığın yok.
        notifier.value = AppPhase.scoped;
        await settle(tester);
        expect(locationOf(router), '/home');
        expect(router.canPop(), isFalse);
        expect(find.byType(ChatPage), findsNothing);
        // 800 geniş: tablet rayı, tek bölme.
        await tester.tap(_railItem('Görevler'));
        await settle(tester);
        expect(locationOf(router), '/tasks');
        expect(find.byType(TaskDetailPage), findsNothing);
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

  testWidgets(
    'sayfa kabuğu hareketi azalt ayarından bağımsız olarak geçişsiz',
    (tester) async {
      await _scoped(tester);
      int fades(Type page) => find
          .ancestor(of: find.byType(page), matching: find.byType(Opacity))
          .evaluate()
          .length;

      const TaskDetailRoute(code: 'ANIM').go(_ctx(tester));
      await settle(tester);
      final withFade = fades(TaskDetailPage);

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      const CoordinatorshipRoute(code: 'DURAGAN').go(_ctx(tester));
      await settle(tester);
      expect(fades(CoordinatorshipPage), withFade);
    },
  );
}
