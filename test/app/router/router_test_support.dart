// Router testlerinin ortak düzeneği (yalnız test): Riverpod kapsamı (bağlantı çevrimiçi),
// Türkçe yerelleştirme, geniş yüzey. Sayfalar kendi sağlayıcılarını ister (NzPage).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/app_nav.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../support/harness.dart';

/// Yönlendiriciyi kurar ve ilk kareyi çizer. [width] pencere sınıfını belirler.
Future<GoRouter> pumpRouter(
  WidgetTester tester,
  ValueNotifier<AppPhase> phase, {
  bool devCatalog = false,
  ValueNotifier<bool>? devPrototype,
  double width = 800,
  double height = 1200,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
  final router = createRouter(
    phase,
    devCatalog: devCatalog,
    devPrototype: devPrototype,
  );
  addTearDown(router.dispose);
  await pumpRouterWidget(tester, router);
  return router;
}

/// Hazır yönlendiriciyi uygulamaya bağlar (Riverpod kapsamı, TR yerelleştirme) ve ilk kareyi çizer.
Future<void> pumpRouterWidget(WidgetTester tester, GoRouter router) async {
  // Kapı rotaları gerçek feature sayfalarıdır (sunucu, giriş, kapsam…): sayfalar gerçek bileşim
  // kökünün portlarını okur. Sahte ağ her isteğe 404 verir; faz ValueNotifier'ı testin
  // elindedir (sayfalar kendi hata durumunu çizer, faz makinesine dokunmaz).
  final harness = Harness();
  addTearDown(harness.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: harness.container,
      child: ProviderScope(
        retry: (_, _) => null,
        overrides: [
          connectivityStateProvider.overrideWithValue(ConnectivityState.online),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            theme: theme(false),
            locale: const Locale('tr'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: testLocalizationDelegates,
            routerConfig: router,
            builder: (context, child) =>
                NzAppNavScope(nav: GoRouterAppNav(router, ref), child: child!),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Geçerli konum (yol + sorgu).
String locationOf(GoRouter r) =>
    r.routerDelegate.currentConfiguration.uri.toString();

/// Yönlendirme ve geçiş animasyonları sürelerinin oturması için birkaç kare.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}
