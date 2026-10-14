// Router testlerinin ortak düzeneği (yalnız test): Riverpod kapsamı (bağlantı çevrimiçi),
// Türkçe yerelleştirme, geniş yüzey. Sayfalar kendi sağlayıcılarını ister (NzPage).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';

/// Yönlendiriciyi kurar ve ilk kareyi çizer. [width] pencere sınıfını belirler.
Future<GoRouter> pumpRouter(
  WidgetTester tester,
  ValueNotifier<AppPhase> phase, {
  bool devCatalog = false,
  double width = 800,
  double height = 1200,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
  final router = createRouter(phase, devCatalog: devCatalog);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        connectivityStateProvider.overrideWithValue(ConnectivityState.online),
      ],
      child: MaterialApp.router(
        theme: theme(false),
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: testLocalizationDelegates,
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
  return router;
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
