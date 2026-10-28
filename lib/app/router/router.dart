import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_phase.dart';
import '../dev/catalog_page.dart';
import 'pages.dart';
import 'routes.dart';
import 'transitions.dart';

export 'routes.dart';

/// Durum makinesinden türetilen rota (platform §6: "router bu makineden türetilir").
/// Yol dizeleri tipli rotalardan gelir; kapı kararı yine bu işlevdedir.
String routeForPhase(AppPhase phase) => switch (phase) {
  AppPhase.unbound ||
  AppPhase.bindingFailed ||
  AppPhase.verifying => const ServerRoute().location,
  AppPhase.updateRequired => const UpdateRequiredRoute().location,
  AppPhase.serverVerified ||
  AppPhase.reauthRequired => const LoginRoute().location,
  AppPhase.passwordChangeRequired => const PasswordRoute().location,
  AppPhase.sessionOpen => const ScopeRoute().location,
  AppPhase.scoped => const HomeRoute().location,
};

/// Bileşen kataloğu rotası (yalnız dev flavor; [createRouter] `devCatalog: true`).
const catalogPath = '/dev/catalog';

/// Faz kapısı: [location] için yönlendirme hedefi; null → konumda kalınır.
///
/// - Katalog (yalnız `devCatalog` açıkken) fazdan muaftır.
/// - Prototip modu (yalnız `devCatalog` açıkken ve [devPrototype] true): oturum/kapsam olmadan
///   kabuk ve feature rotaları açılır (ekranlar geliştirme örnek verisiyle çalışır; backend
///   isteği atan ekranlar hata görünümüne düşer). Kapı rotaları normal kalır. Prod'da yoktur.
/// - `scoped` dışındaki her fazda yalnız faz hedefi açıktır: başka her yol (kabuk rotaları,
///   feature rotaları, bilinmeyen yol) faz hedefine gider. 404 kapıyı aşamaz.
/// - `scoped` fazında kapı rotaları (hedef hariç) `/home`'a gider; kabuk/feature rotaları açıktır;
///   bilinmeyen yol 404 sayfasına düşer.
@visibleForTesting
String? gateRedirect(
  AppPhase phase,
  String location, {
  bool devCatalog = false,
  bool devPrototype = false,
}) {
  if (devCatalog && location == catalogPath) return null;
  if (devCatalog &&
      devPrototype &&
      (location == routeForPhase(AppPhase.scoped) ||
          !_gatePaths.contains(location))) {
    return null;
  }
  final target = routeForPhase(phase);
  if (location == target) return null;
  if (phase == AppPhase.scoped && !_gatePaths.contains(location)) return null;
  return target;
}

/// Faz hedeflerinin kümesi (kapı rotaları).
final Set<String> _gatePaths = {
  for (final p in AppPhase.values) routeForPhase(p),
};

/// Yönlendirici. [phase] değişince kapı yeniden değerlendirilir (`refreshListenable`); faz
/// `scoped`'tan çıkınca kabuk ağaçtan kalkar ve gezinme yığını (sekme yığınları dâhil) yeni
/// konumdan yeniden başlar: eski sunucunun ekranı geri tuşuyla görünmez.
///
/// Router hiçbir servisi çağırmaz; yalnız [phase]'i okur. [featureRoutes] feature rota
/// kaydıdır (varsayılan: [registeredFeatureRoutes]).
///
/// [devPrototype]: yalnız dev flavor'da verilir (katalogdaki "Prototype" düğmesi açar).
GoRouter createRouter(
  ValueNotifier<AppPhase> phase, {
  bool devCatalog = false,
  ValueNotifier<bool>? devPrototype,
  List<RouteBase>? featureRoutes,
}) => GoRouter(
  initialLocation: routeForPhase(phase.value),
  refreshListenable: devPrototype == null
      ? phase
      : Listenable.merge([phase, devPrototype]),
  redirect: (context, state) => gateRedirect(
    phase.value,
    state.matchedLocation,
    devCatalog: devCatalog,
    devPrototype: devPrototype?.value ?? false,
  ),
  errorPageBuilder: (context, state) =>
      nzTransitionPage<void>(state: state, child: const NotFoundPage()),
  routes: [
    ...buildAppRoutes(featureRoutes: featureRoutes ?? registeredFeatureRoutes),
    if (devCatalog)
      GoRoute(
        path: catalogPath,
        builder: (context, state) => CatalogPage(
          onOpenPrototype: devPrototype == null
              ? null
              : () {
                  devPrototype.value = true;
                  context.go(const HomeRoute().location);
                },
        ),
      ),
  ],
);
