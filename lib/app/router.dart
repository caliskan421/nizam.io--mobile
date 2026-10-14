import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/app_phase.dart';
import 'dev/catalog_page.dart';

/// Durum makinesinden türetilen rota (platform §6: "router bu makineden türetilir").
/// Ekran yoktur (D-0174): her rota boş yer tutucudur; ekran çalışması bu yolları doldurur.
String routeForPhase(AppPhase phase) => switch (phase) {
  AppPhase.unbound || AppPhase.bindingFailed || AppPhase.verifying => '/server',
  AppPhase.updateRequired => '/update-required',
  AppPhase.serverVerified || AppPhase.reauthRequired => '/login',
  AppPhase.passwordChangeRequired => '/password',
  AppPhase.sessionOpen => '/scope',
  AppPhase.scoped => '/home',
};

/// Bileşen kataloğu rotası (yalnız dev flavor; [createRouter] `devCatalog: true`).
const catalogPath = '/dev/catalog';

GoRouter createRouter(
  ValueNotifier<AppPhase> phase, {
  bool devCatalog = false,
}) => GoRouter(
  initialLocation: routeForPhase(phase.value),
  refreshListenable: phase,
  redirect: (context, state) {
    // Katalog faz makinesinden muaftır; yalnız devCatalog açıkken tanımlıdır.
    if (devCatalog && state.matchedLocation == catalogPath) return null;
    final target = routeForPhase(phase.value);
    return state.matchedLocation == target ? null : target;
  },
  routes: [
    for (final path in {for (final p in AppPhase.values) routeForPhase(p)})
      GoRoute(path: path, builder: (context, state) => const SizedBox.shrink()),
    if (devCatalog)
      GoRoute(
        path: catalogPath,
        builder: (context, state) => const CatalogPage(),
      ),
  ],
);
