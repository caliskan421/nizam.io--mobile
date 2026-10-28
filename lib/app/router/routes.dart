import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/page/nz_app_nav.dart';
import '../../features/activity/activity.dart';
import '../../features/archive/archive.dart';
import '../../features/coordinatorships/coordinatorships.dart';
import '../../features/identity/identity.dart';
import '../../features/messages/messages.dart';
import '../../features/scope/scope.dart';
import '../../features/server/server.dart';
import '../../features/tasks/tasks.dart';
import '../../features/timeline/timeline.dart';
import 'shell.dart';
import 'transitions.dart';

part 'routes.g.dart';

// Tipli rotalar (go_router_builder, A5). Kurallar:
//  - Rota NESNE değil KİMLİK taşır: yol/sorgu parametresi; `extra` ile nesne taşıma ve dize yolla
//    `go()` yasaktır (derin bağlantıda ve yeniden başlatmada kaybolur). Gezinme
//    `TaskDetailRoute(code: x).push(context)` ile yapılır; veri controller'dan yüklenir.
//  - Faz kapısı `router.dart` içindeki [gateRedirect]'tedir; rotalar kapıyı bilmez.
//  - Feature rota kaydı: her feature açık yüzünden `List<RouteBase> get <f>Routes` verir;
//    [registeredFeatureRoutes] bunları birleştirir (app → feature facade, B2/B3).
//  - Geçiş [NzRouteData] tabanındadır (transitions.dart).

// ---- Kapı rotaları (faz makinesinin hedefleri) ----

@TypedGoRoute<ServerRoute>(path: '/server')
class ServerRoute extends NzRouteData with $ServerRoute {
  const ServerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ServerPage();
}

@TypedGoRoute<UpdateRequiredRoute>(path: '/update-required')
class UpdateRequiredRoute extends NzRouteData with $UpdateRequiredRoute {
  const UpdateRequiredRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UpdateRequiredPage();
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends NzRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@TypedGoRoute<PasswordRoute>(path: '/password')
class PasswordRoute extends NzRouteData with $PasswordRoute {
  const PasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PasswordChangePage();
}

@TypedGoRoute<ScopeRoute>(path: '/scope')
class ScopeRoute extends NzRouteData with $ScopeRoute {
  const ScopeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ScopePage();
}

// ---- Kabuk (yalnız `scoped` fazı): prototip gezinmesi ----
//
// Alt menü üç öğedir (README "Gezinme"): Ana sayfa, Görevler ve son girilen modül
// (Koordinatörlükler, Arşiv, Mesajlar — üçü aynı dalda, dal yığını son konumu korur). Dal
// kökleri sekme geçişiyle ([NzTabRouteData]), alt sayfalar itme geçişiyle açılır. Zaman
// çizelgesi ve sohbet kabuk dışındadır: alt menü gizlenir.

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: '/home',
          routes: [TypedGoRoute<HistoryRoute>(path: 'history')],
        ),
      ],
    ),
    TypedStatefulShellBranch<TasksBranch>(
      routes: [
        TypedGoRoute<TasksRoute>(
          path: '/tasks',
          routes: [TypedGoRoute<TaskDetailRoute>(path: ':code')],
        ),
      ],
    ),
    TypedStatefulShellBranch<ModulesBranch>(
      routes: [
        TypedGoRoute<CoordinatorshipsRoute>(
          path: '/coordinatorships',
          routes: [TypedGoRoute<CoordinatorshipRoute>(path: ':code')],
        ),
        TypedGoRoute<ArchiveRoute>(
          path: '/archive',
          routes: [TypedGoRoute<ArchiveFolderRoute>(path: ':code')],
        ),
        TypedGoRoute<MessagesRoute>(path: '/messages'),
      ],
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
  ) => NzAdaptiveShell(
    navigationShell: navigationShell,
    location: state.uri.path,
  );
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class TasksBranch extends StatefulShellBranchData {
  const TasksBranch();
}

class ModulesBranch extends StatefulShellBranchData {
  const ModulesBranch();
}

class HomeRoute extends NzTabRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class HistoryRoute extends NzRouteData with $HistoryRoute {
  const HistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivityPage();
}

class TasksRoute extends NzTabRouteData with $TasksRoute {
  const TasksRoute({this.view, this.people = const []});

  /// Başlangıç görünümü (`NzTaskView.name`); yalnız ad taşınır.
  final String? view;

  /// Başlangıç kişi süzgeci (kişi kimlikleri).
  final List<String> people;

  @override
  Widget build(BuildContext context, GoRouterState state) => TasksPage(
    view: NzTaskView.values.where((v) => v.name == view).firstOrNull,
    people: people,
  );
}

class TaskDetailRoute extends NzRouteData with $TaskDetailRoute {
  const TaskDetailRoute({required this.code});

  /// Görev kodu (`ALT-7`); veri controller'dan yüklenir.
  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TaskDetailPage(code: code);
}

class CoordinatorshipsRoute extends NzTabRouteData with $CoordinatorshipsRoute {
  const CoordinatorshipsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CoordinatorshipsPage();
}

class CoordinatorshipRoute extends NzRouteData with $CoordinatorshipRoute {
  const CoordinatorshipRoute({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CoordinatorshipPage(code: code);
}

class ArchiveRoute extends NzTabRouteData with $ArchiveRoute {
  const ArchiveRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ArchivePage();
}

class ArchiveFolderRoute extends NzRouteData with $ArchiveFolderRoute {
  const ArchiveFolderRoute({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ArchiveFolderPage(code: code);
}

class MessagesRoute extends NzTabRouteData with $MessagesRoute {
  const MessagesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MessagesPage();
}

// ---- Kabuk dışı (alt menü gizli) ----

@TypedGoRoute<TimelineRoute>(path: '/timeline')
class TimelineRoute extends NzRouteData with $TimelineRoute {
  const TimelineRoute({this.coord});

  /// Başlangıçta seçili koordinatörlük kodu.
  final String? coord;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TimelinePage(coordinatorship: coord);
}

@TypedGoRoute<ChatRoute>(path: '/chat/:id')
class ChatRoute extends NzRouteData with $ChatRoute {
  const ChatRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) => ChatPage(id: id);
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends NzRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
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
