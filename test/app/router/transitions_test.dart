import 'package:flutter/material.dart';
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
    expect(route.transitionDuration, Duration.zero);
    expect(route.reverseTransitionDuration, Duration.zero);
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
}
