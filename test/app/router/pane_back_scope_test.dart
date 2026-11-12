import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/pane_back_scope.dart';
import 'package:nizamio/app/router/split.dart';

const _initial = '/page?filter=a&filter=b&trail=coord%3AALT&trail=folder%3AX';

class _Harness {
  final guard = ValueNotifier(true);
  final horizontal = ScrollController();
  late GoRouter router;
  int backs = 0;

  Future<void> pump(
    WidgetTester tester, {
    String location = _initial,
    TargetPlatform platform = TargetPlatform.iOS,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(
          path: '/page',
          builder: (context, state) => PaneBackScope(
            hasTrail: parseTrail(state.uri.queryParametersAll['trail'] ?? [])
                .isNotEmpty,
            owner: state.uri.toString(),
            onBack: () {
              final previous = splitBack(GoRouterState.of(context).uri);
              if (previous != null) {
                backs++;
                router.go(previous);
              }
            },
            child: ValueListenableBuilder(
              valueListenable: guard,
              builder: (context, value, _) => PopScope(
                canPop: value,
                child: Scaffold(
                  body: Column(
                    children: [
                      const SizedBox(height: 100),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          controller: horizontal,
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: (_, i) =>
                              SizedBox(width: 100, child: Text('item $i')),
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) => TextButton(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) =>
                                  const AlertDialog(content: Text('modal')),
                            ),
                            child: const Text('modal aç'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    addTearDown(guard.dispose);
    addTearDown(horizontal.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: ThemeData(platform: platform),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  Uri get uri => router.routerDelegate.currentConfiguration.uri;
}

Future<void> _swipe(
  WidgetTester tester, {
  Offset from = const Offset(10, 400),
  double delta = 240,
}) async {
  await tester.timedDragFrom(
    from,
    Offset(delta, 0),
    const Duration(milliseconds: 500),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'iOS kenar hareketi yalnız bir trail düşürür; yol ve tekrarlı sorgular korunur',
    (tester) async {
      final h = _Harness();
      await h.pump(tester);
      await _swipe(tester, delta: 350);
      expect(h.backs, 1);
      expect(h.uri.path, '/page');
      expect(h.uri.queryParametersAll, {
        'filter': ['a', 'b'],
        'trail': ['coord:ALT'],
      });
      await _swipe(tester);
      expect(h.backs, 2);
      expect(h.uri.queryParametersAll, {
        'filter': ['a', 'b'],
      });
    },
  );

  testWidgets('kısa, geriye çevrilen ve sağdan başlayan hareket geri almaz', (
    tester,
  ) async {
    final h = _Harness();
    await h.pump(tester);
    await _swipe(tester, delta: 28);
    final gesture = await tester.startGesture(const Offset(10, 400));
    await gesture.moveBy(const Offset(220, 0));
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.moveBy(const Offset(-180, 0));
    await gesture.up();
    await tester.pumpAndSettle();
    await _swipe(tester, from: const Offset(380, 400), delta: -240);
    expect(h.backs, 0);
    expect(h.uri.toString(), _initial);
  });

  testWidgets('orta yatay liste kayar; geri hareketine dönüşmez', (
    tester,
  ) async {
    final h = _Harness();
    await h.pump(tester);
    await _swipe(tester, from: const Offset(250, 150), delta: -180);
    expect(h.horizontal.offset, greaterThan(0));
    expect(h.backs, 0);
  });

  testWidgets(
    'başka PopScope vetosu hem kenar hem sistem gerisini durdurur ve restore edilir',
    (tester) async {
      final h = _Harness();
      await h.pump(tester);
      h.guard.value = false;
      await tester.pump();
      await _swipe(tester);
      final context = tester.element(find.byType(PaneBackScope));
      await Navigator.of(context).maybePop();
      await tester.pumpAndSettle();
      expect(h.backs, 0);
      h.guard.value = true;
      await tester.pump();
      await _swipe(tester);
      expect(h.backs, 1);
      expect(
        ModalRoute.of(tester.element(find.byType(PaneBackScope)))!
            .popDisposition,
        RoutePopDisposition.doNotPop,
      );
    },
  );

  testWidgets(
    'hareket sırasında URL değişirse eski hareket yeni izi düşürmez',
    (tester) async {
      final h = _Harness();
      await h.pump(tester);
      final gesture = await tester.startGesture(const Offset(10, 400));
      await gesture.moveBy(const Offset(200, 0));
      h.router.go('/page?filter=new&trail=task%3AY');
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(h.backs, 0);
      expect(h.uri.queryParametersAll, {
        'filter': ['new'],
        'trail': ['task:Y'],
      });
    },
  );

  testWidgets('izsiz kökte kenar hareketi geçmiş uydurmaz', (tester) async {
    final h = _Harness();
    await h.pump(tester, location: '/page?filter=root');
    await _swipe(tester);
    expect(h.backs, 0);
    expect(h.uri.toString(), '/page?filter=root');
  });

  testWidgets(
    'Android sistem geri sanal izi kısaltır; el ile kenar alanı kurulmaz',
    (tester) async {
      final h = _Harness();
      await h.pump(tester, platform: TargetPlatform.android);
      await _swipe(tester);
      expect(h.backs, 0);
      final context = tester.element(find.byType(PaneBackScope));
      await Navigator.of(context).maybePop();
      await tester.pumpAndSettle();
      expect(h.backs, 1);
      expect(h.uri.queryParametersAll['trail'], ['coord:ALT']);
    },
  );

  testWidgets('kök modal üstteyken iç navigator izi pop edilmez', (
    tester,
  ) async {
    final local = GlobalKey<NavigatorState>();
    var backs = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: Scaffold(
          body: Navigator(
            key: local,
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (context) => PaneBackScope(
                hasTrail: true,
                owner: 'trail:one',
                onBack: () => backs++,
                child: Center(
                  child: TextButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      useRootNavigator: true,
                      builder: (_) =>
                          const AlertDialog(content: Text('root modal')),
                    ),
                    child: const Text('aç'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    await local.currentState!.maybePop();
    await tester.pumpAndSettle();
    expect(backs, 0);
    expect(find.text('root modal'), findsOneWidget);
    Navigator.of(tester.element(find.text('root modal'))).pop();
    await tester.pumpAndSettle();
    await local.currentState!.maybePop();
    await tester.pumpAndSettle();
    expect(backs, 1);
  });
}
