import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_phase.dart';
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

/// Faz kapısı: [location] için yönlendirme hedefi; null → konumda kalınır.
///
/// - Prototip modu (yalnız dev flavor, [devPrototype] true): oturum/kapsam olmadan
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
  bool devPrototype = false,
}) {
  if (devPrototype &&
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
/// [devPrototype]: yalnız dev flavor'da true verilir; uygulama ana sayfada, örnek veriyle açılır.
GoRouter createRouter(
  ValueNotifier<AppPhase> phase, {
  bool devPrototype = false,
  List<RouteBase>? featureRoutes,
}) => GoRouter(
  initialLocation: devPrototype
      ? routeForPhase(AppPhase.scoped)
      : routeForPhase(phase.value),
  refreshListenable: phase,
  redirect: (context, state) => gateRedirect(
    phase.value,
    state.matchedLocation,
    devPrototype: devPrototype,
  ),
  errorPageBuilder: (context, state) =>
      nzTransitionPage<void>(state: state, child: const NotFoundPage()),
  routes: [
    ...buildAppRoutes(featureRoutes: featureRoutes ?? registeredFeatureRoutes),
  ],
);
