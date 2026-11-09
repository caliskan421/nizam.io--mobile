// Gerçek tablet yönlendirmesi ve gerçek veri depoları; yalnız yaş eşiği testten yönetilir.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/app_nav.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/scope/application/home_dashboard_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/meetings/meetings_server.dart';
import '../../features/pilot_support.dart' as pilot;
import 'router_test_support.dart' show settle;

class _Age {
  Duration maxAge = const Duration(days: 365);
}

class _Home extends HomeDashboardController {
  _Home(this.age);
  final _Age age;
  @override
  Future<void> refreshIfStale({Duration? maxAge}) =>
      super.refreshIfStale(maxAge: age.maxAge);
}

class _Meetings extends MeetingsBoardController {
  _Meetings(this.age);
  final _Age age;
  @override
  Future<void> refreshIfStale({Duration? maxAge}) =>
      super.refreshIfStale(maxAge: age.maxAge);
}

class _Tasks extends TaskCatalogController {
  _Tasks(this.age);
  final _Age age;
  @override
  Future<void> refreshIfStale({Duration? maxAge}) =>
      super.refreshIfStale(maxAge: age.maxAge);
}

void main() {
  setUpFonts();
  testWidgets('tablet modül yeniden kurulumu: taze istek yok, bayat tek okuma; '
      'takvim iki kaynağı yeniler', (tester) async {
    final (h, _) = await pilot.real(
      tester,
      () => openMeetings(MeetingsServer()),
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.reset);
    final phase = ValueNotifier(AppPhase.scoped);
    final router = createRouter(phase);
    addTearDown(phase.dispose);
    addTearDown(router.dispose);
    final age = _Age();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: h.container,
        child: ProviderScope(
          retry: (_, _) => null,
          overrides: [
            homeDashboardControllerProvider.overrideWith(() => _Home(age)),
            meetingsBoardControllerProvider.overrideWith(() => _Meetings(age)),
            taskCatalogControllerProvider.overrideWith(() => _Tasks(age)),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp.router(
              theme: theme(false),
              locale: const Locale('tr'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: testLocalizationDelegates,
              routerConfig: router,
              builder: (context, child) => NzAppNavScope(
                nav: GoRouterAppNav(router, ref),
                child: child!,
              ),
            ),
          ),
        ),
      ),
    );
    Future<void> go(String path) async {
      router.go(path);
      await settle(tester);
      await pilot.settle(tester);
      expect(tester.takeException(), isNull);
    }

    int count(String path) => h.backend.requests
        .where((r) => r.method == 'GET' && r.path == path)
        .length;

    for (final (route, endpoint) in [
      ('/home', '/v1/reports/dashboard'),
      ('/tasks', '/v1/program/work-items'),
      ('/meetings', '/v1/meetings'),
    ]) {
      age.maxAge = const Duration(days: 365);
      await go(route);
      await go('/archive');
      h.backend.requests.clear();
      await go(route);
      expect(count(endpoint), 0, reason: '$route taze');
      await go('/archive');
      h.backend.requests.clear();
      age.maxAge = Duration.zero;
      await go(route);
      expect(count(endpoint), 1, reason: '$route bayat: tek ziyaret/okuma');
    }
    age.maxAge = const Duration(days: 365);
    await go('/calendar');
    await go('/archive');
    h.backend.requests.clear();
    await go('/calendar');
    expect(count('/v1/meetings'), 0);
    expect(count('/v1/program/work-items'), 0);
    await go('/archive');
    h.backend.requests.clear();
    age.maxAge = Duration.zero;
    await go('/calendar');
    expect(count('/v1/meetings'), 1);
    expect(count('/v1/program/work-items'), 1);
  });
}
