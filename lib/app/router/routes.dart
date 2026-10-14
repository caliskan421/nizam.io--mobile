import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages.dart';
import 'shell.dart';
import 'transitions.dart';

part 'routes.g.dart';

// Tipli rotalar (go_router_builder, A5). Kurallar:
//  - Rota NESNE değil KİMLİK taşır: yol/sorgu parametresi; `extra` ile nesne taşıma ve dize yolla
//    `go()` yasaktır (derin bağlantıda ve yeniden başlatmada kaybolur). Gezinme
//    `const HomeDetailRoute(id: x).go(context)` ile yapılır; veri controller'dan yüklenir.
//  - Faz kapısı `router.dart` içindeki [gateRedirect]'tedir; rotalar kapıyı bilmez.
//  - Feature rota kaydı: her feature açık yüzünden `List<RouteBase> get <f>Routes` verir;
//    [registeredFeatureRoutes] bunları birleştirir (app → feature facade, B2/B3).
//  - Geçiş [NzRouteData] tabanındadır (transitions.dart).

// ---- Kapı rotaları (faz makinesinin hedefleri) ----

@TypedGoRoute<ServerRoute>(path: '/server')
class ServerRoute extends NzRouteData with $ServerRoute {
  const ServerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPageServer);
}

@TypedGoRoute<UpdateRequiredRoute>(path: '/update-required')
class UpdateRequiredRoute extends NzRouteData with $UpdateRequiredRoute {
  const UpdateRequiredRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPageUpdateRequired);
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends NzRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPageLogin);
}

@TypedGoRoute<PasswordRoute>(path: '/password')
class PasswordRoute extends NzRouteData with $PasswordRoute {
  const PasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPagePassword);
}

@TypedGoRoute<ScopeRoute>(path: '/scope')
class ScopeRoute extends NzRouteData with $ScopeRoute {
  const ScopeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPageScope);
}

// ---- Kabuk (yalnız `scoped` fazı): üç yer tutucu sekme ----

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: '/home',
          routes: [TypedGoRoute<HomeDetailRoute>(path: 'detail/:id')],
        ),
      ],
    ),
    TypedStatefulShellBranch<WorkBranch>(
      routes: [
        TypedGoRoute<WorkRoute>(
          path: '/work',
          routes: [TypedGoRoute<WorkDetailRoute>(path: 'detail/:id')],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [TypedGoRoute<ProfileRoute>(path: '/profile')],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => NzAdaptiveShell(navigationShell: navigationShell);
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class WorkBranch extends StatefulShellBranchData {
  const WorkBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class HomeRoute extends NzRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterTabHome);
}

class HomeDetailRoute extends NzRouteData with $HomeDetailRoute {
  const HomeDetailRoute({required this.id});

  /// Yalnız kimlik; veri controller'dan yüklenir.
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPageDetail, detailId: id);
}

class WorkRoute extends NzRouteData with $WorkRoute {
  const WorkRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterTabWork);
}

class WorkDetailRoute extends NzRouteData with $WorkDetailRoute {
  const WorkDetailRoute({required this.id});

  /// Yalnız kimlik; veri controller'dan yüklenir.
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterPageDetail, detailId: id);
}

class ProfileRoute extends NzRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouterPlaceholderPage(title: (l) => l.uiRouterTabProfile);
}

// ---- Birleştirme ----

/// Feature rota kaydı sözleşmesi: feature açık yüzü (`features/<f>/<f>.dart`)
/// `List<RouteBase> get <f>Routes` verir ve burada yayılır (`...identityRoutes`).
/// Henüz rota sunan feature yoktur. Bu rotalar da faz kapısının arkasındadır.
List<RouteBase> get registeredFeatureRoutes => const [];

/// Bütün rota ağacı: tipli rotalar + feature rotaları. Katalog rotası ayrıca eklenir
/// (`router.dart`, yalnız dev).
List<RouteBase> buildAppRoutes({List<RouteBase> featureRoutes = const []}) => [
  ...$appRoutes,
  ...featureRoutes,
];
