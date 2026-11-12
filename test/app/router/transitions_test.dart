import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/transitions.dart';
import 'package:nizamio/core/ui/motion/page_content_entrance.dart';
import 'package:nizamio/core/ui/theme/nz_motion.dart';

void main() {
  testWidgets('AppBar sabit, yalnız içerik giriş animasyonu oynar', (
    tester,
  ) async {
    late BuildContext routeContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            routeContext = context;
            return const SizedBox();
          },
        ),
      ),
    );
    const header = ValueKey('header');
    const content = ValueKey('content');
    final route = RpPushRoute<void>(
      context: routeContext,
      child: const Column(
        children: [
          SizedBox(key: header, width: 100, height: 64),
          PageContentEntrance(
            child: SizedBox(key: content, width: 100, height: 100),
          ),
        ],
      ),
    );
    Navigator.of(routeContext).push(route);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 160));
    expect(tester.getRect(find.byKey(header)).top, 0);
    expect(
      tester.getRect(find.byKey(content)).top - 64,
      closeTo(10 * (1 - RpMotion.enterCurve.transform(0.5)), 0.001),
    );
    expect(route.animation!.isCompleted, isTrue);
    await tester.pump(RpMotion.enterDuration);
    expect(tester.getRect(find.byKey(content)).top, 64);
    Navigator.of(routeContext).pop();
    await tester.pumpAndSettle();
  });

  testWidgets('aynı sayfa kimliğinde güncellenen child güncel kalır', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => nzTransitionPage<void>(
            state: state,
            child: Text(state.uri.queryParameters['q'] ?? 'ilk'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    expect(find.text('ilk'), findsOneWidget);
    router.go('/?q=yeni');
    await tester.pumpAndSettle();
    expect(find.text('yeni'), findsOneWidget);
    expect(find.text('ilk'), findsNothing);
  });
  testWidgets('iOS: sol kenar commit ve iptal; iptal taslağı korur', (t) async {
    final (nav, context) = await _host(t, TargetPlatform.iOS);
    final text = TextEditingController();
    addTearDown(text.dispose);
    final route = RpPushRoute<void>(
      context: context,
      child: Material(
        child: Column(
          children: [
            const Text('detail'),
            TextField(controller: text),
          ],
        ),
      ),
    );
    nav.push(route);
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), 'korunan taslak');
    FocusManager.instance.primaryFocus?.unfocus();
    await t.pumpAndSettle();
    await _edge(t, finish: false);
    expect(route.isCurrent, isTrue);
    expect(route.animation!.isCompleted, isTrue);
    expect(text.text, 'korunan taslak');
    expect(nav.userGestureInProgress, isFalse);
    await _edge(t, finish: true);
    expect(find.text('detail'), findsNothing);
    expect(find.text('root'), findsOneWidget);
    expect(nav.canPop(), isFalse);
    await _edge(t, finish: true);
    expect(find.text('root'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('iOS: PopScope ve modal alttaki route hareketini engeller', (
    t,
  ) async {
    final (nav, context) = await _host(t, TargetPlatform.iOS);
    var attempts = 0;
    final guard = RpPushRoute<void>(
      context: context,
      child: PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (_, _) => attempts++,
        child: const Material(child: Text('guard')),
      ),
    );
    nav.push(guard);
    await t.pumpAndSettle();
    expect(guard.popGestureEnabled, isFalse);
    await _edge(t, finish: true);
    expect(attempts, 0);
    expect(guard.isCurrent, isTrue);
    nav.pop();
    await t.pumpAndSettle();
    final route = RpPushRoute<void>(
      context: context,
      child: const Material(child: Text('detail')),
    );
    nav.push(route);
    await t.pumpAndSettle();
    unawaited(
      showDialog<void>(
        context: route.subtreeContext!,
        builder: (_) => const AlertDialog(content: Text('overlay')),
      ),
    );
    await t.pumpAndSettle();
    expect(route.popGestureEnabled, isFalse);
    await _edge(t, finish: true);
    expect(find.text('overlay'), findsOneWidget);
    nav.pop();
    await t.pumpAndSettle();
    expect(find.text('detail'), findsOneWidget);
    expect(route.popGestureEnabled, isTrue);
    expect(t.takeException(), isNull);
  });

  testWidgets('orta yatay kaydırma ve Android edge-pan route pop yapmaz', (
    t,
  ) async {
    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      final (nav, context) = await _host(t, platform);
      final scroll = ScrollController();
      final route = RpPushRoute<void>(
        context: context,
        child: Material(
          child: SingleChildScrollView(
            controller: scroll,
            scrollDirection: Axis.horizontal,
            child: const SizedBox(
              width: 2400,
              child: Center(child: Text('wide')),
            ),
          ),
        ),
      );
      nav.push(route);
      await t.pumpAndSettle();
      await t.dragFrom(const Offset(400, 300), const Offset(-180, 0));
      await t.pumpAndSettle();
      expect(scroll.offset, greaterThan(0));
      expect(route.isCurrent, isTrue);
      if (platform == TargetPlatform.android) {
        await _edge(t, finish: true);
        expect(route.isCurrent, isTrue);
      }
      nav.pop();
      await t.pumpAndSettle();
      scroll.dispose();
    }
  });

  testWidgets(
    'tab edge engellenir; push ve tab düğme geri ilk karede tamamlanır',
    (t) async {
      for (final kind in NzTransition.values) {
        final (nav, context) = await _host(t, TargetPlatform.iOS);
        final route = RpPushRoute<void>(
          context: context,
          kind: kind,
          child: Material(
            child: TextButton(
              onPressed: nav.pop,
              child: const Text('button back'),
            ),
          ),
        );
        nav.push(route);
        await t.pumpAndSettle();
        if (kind == NzTransition.tab) {
          expect(route.popGestureEnabled, isFalse);
          await _edge(t, finish: true);
          expect(route.isCurrent, isTrue);
        }
        await t.tap(find.text('button back'));
        await t.pump();
        expect(find.text('root'), findsOneWidget);
        expect(find.text('button back'), findsNothing);
        expect(nav.canPop(), isFalse);
      }
    },
  );

  testWidgets(
    'Android gizli nested branch ve root modalı alttaki gestureı engeller',
    (t) async {
      final visible = ValueNotifier(false);
      addTearDown(visible.dispose);
      final nested = GlobalKey<NavigatorState>();
      final (root, context) = await _host(
        t,
        TargetPlatform.android,
        home: ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (_, enabled, child) => TickerMode(
            enabled: enabled,
            child: Offstage(offstage: !enabled, child: child),
          ),
          child: Navigator(
            key: nested,
            onGenerateRoute: (_) => RpPushRoute<void>(
              context: nested.currentContext!,
              child: const Material(child: Text('nested root')),
            ),
          ),
        ),
      );
      final route = RpPushRoute<void>(
        context: nested.currentContext!,
        child: const Material(child: Text('nested detail')),
      );
      nested.currentState!.push(route);
      await t.pumpAndSettle();
      expect(route.popGestureEnabled, isFalse);
      await _systemBack(t, 'startBackGesture', progress: 0);
      expect(nested.currentState!.userGestureInProgress, isFalse);
      await _systemBack(t, 'cancelBackGesture');
      visible.value = true;
      await t.pumpAndSettle();
      expect(route.popGestureEnabled, isTrue);
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => const AlertDialog(content: Text('root modal')),
        ),
      );
      await t.pumpAndSettle();
      expect(route.popGestureEnabled, isFalse);
      await _systemBack(t, 'startBackGesture', progress: 0);
      expect(nested.currentState!.userGestureInProgress, isFalse);
      await _systemBack(t, 'cancelBackGesture');
      expect(find.text('root modal'), findsOneWidget);
      root.pop();
      await t.pumpAndSettle();
      expect(find.text('nested detail'), findsOneWidget);
      expect(route.popGestureEnabled, isTrue);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('Android sistem predictive back iptal ve commit', (t) async {
    final (nav, context) = await _host(t, TargetPlatform.android);
    final route = RpPushRoute<void>(
      context: context,
      child: const Material(child: Text('detail')),
    );
    nav.push(route);
    await t.pumpAndSettle();
    await _systemBack(t, 'startBackGesture', progress: 0);
    await _systemBack(t, 'updateBackGestureProgress', progress: .35);
    expect(nav.userGestureInProgress, isTrue);
    await _systemBack(t, 'cancelBackGesture');
    await t.pumpAndSettle();
    expect(route.isCurrent, isTrue);
    expect(route.animation!.isCompleted, isTrue);
    expect(nav.userGestureInProgress, isFalse);
    await _systemBack(t, 'startBackGesture', progress: 0);
    await _systemBack(t, 'updateBackGestureProgress', progress: .7);
    await _systemBack(t, 'commitBackGesture');
    await t.pumpAndSettle();
    expect(find.text('detail'), findsNothing);
    expect(nav.canPop(), isFalse);
    expect(t.takeException(), isNull);
  });
}

Future<(NavigatorState, BuildContext)> _host(
  WidgetTester t,
  TargetPlatform platform, {
  Widget? home,
}) async {
  late BuildContext root;
  await t.pumpWidget(
    MaterialApp(
      theme: ThemeData(platform: platform),
      home: Builder(
        builder: (context) {
          root = context;
          return Material(child: home ?? const Center(child: Text('root')));
        },
      ),
    ),
  );
  await t.pumpAndSettle();
  return (Navigator.of(root), root);
}

Future<void> _edge(WidgetTester t, {required bool finish}) async {
  final size = t.view.physicalSize / t.view.devicePixelRatio;
  final gesture = await t.startGesture(Offset(2, size.height / 2));
  await gesture.moveBy(Offset(size.width * (finish ? .8 : .15), 0));
  await t.pump(const Duration(milliseconds: 100));
  // Durağan bırakma hızdan bağımsız commit/cancel eşiğini sınar.
  await t.pump(const Duration(milliseconds: 500));
  await gesture.up();
  await t.pumpAndSettle();
}

Future<void> _systemBack(
  WidgetTester t,
  String method, {
  double? progress,
}) async {
  final message = const StandardMethodCodec().encodeMethodCall(
    MethodCall(
      method,
      progress == null
          ? null
          : <String, Object>{
              'touchOffset': <double>[5, 300],
              'progress': progress,
              'swipeEdge': 0,
            },
    ),
  );
  await t.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    message,
    (_) {},
  );
  await t.pump();
}
