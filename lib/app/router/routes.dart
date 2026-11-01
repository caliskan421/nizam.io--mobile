import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/page/nz_app_nav.dart';
import '../../core/ui/widgets/feedback/nz_pick_record.dart';
import '../../features/activity/activity.dart';
import '../../features/archive/archive.dart';
import '../../features/calendar/calendar.dart';
import '../../features/coordinatorships/coordinatorships.dart';
import '../../features/identity/identity.dart';
import '../../features/messages/messages.dart';
import '../../features/scope/scope.dart';
import '../../features/server/server.dart';
import '../../features/tasks/tasks.dart';
import '../../features/timeline/timeline.dart';
import 'shell.dart';
import 'split.dart';
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
//
// Tablet (split.dart): aynı ağaç; dal kökü çift bölmede sağ bölmenin tabanını kurar, liste
// sayfası sol bölmededir. Kabuk rotaları modüller arası sağ yığını yalnız kimlik taşıyan
// `trail` sorgusuyla taşır (`/coordinatorships/ALT?trail=folder:ALT`); her genişlikte en
// üstteki kayıt çizilir, geri izi kısaltır ([PaneStack]). Sohbet tablette Mesajlar dalında
// açılır (`/messages/:id`); telefonda kabuk dışı `/chat/:id` kalır. Takvim modül dalındadır.

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
        TypedGoRoute<MessagesRoute>(
          path: '/messages',
          routes: [TypedGoRoute<MessagesChatRoute>(path: ':id')],
        ),
        TypedGoRoute<CalendarRoute>(path: '/calendar'),
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
    query: state.uri.queryParametersAll,
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
  const HomeRoute({this.trail = const []});

  /// Sağ yığın izi (yalnız kimlik; split.dart).
  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    // Çift bölmede işlem geçmişi varsayılan açık değildir: kart/kısayol `/home/history`
    // tabanını açar, kapatınca buraya ("Bir kayıt seç") dönülür.
    base: SplitRoot(
      master: (_) => homeMaster(),
      detail: (c) => NzPickRecord(
        title: c.l10n.uiRouterPickTitle,
        message: c.l10n.uiRouterPickBody,
      ),
    ),
  );
}

class HistoryRoute extends NzRouteData with $HistoryRoute {
  const HistoryRoute({this.trail = const []});

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PaneStack(trail: trail, base: const ActivityPage());
}

class TasksRoute extends NzTabRouteData with $TasksRoute {
  const TasksRoute({this.view, this.people = const [], this.trail = const []});

  /// Başlangıç görünümü (`NzTaskView.name`); yalnız ad taşınır.
  final String? view;

  /// Başlangıç kişi süzgeci (kişi kimlikleri).
  final List<String> people;

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    base: SplitRoot(
      master: (_) => tasksMaster(view: initialView, people: people),
      detail: (c) => _splitBase(c, PaneKind.task, _keyedTaskDetailPage),
    ),
  );

  NzTaskView? get initialView =>
      NzTaskView.values.where((v) => v.name == view).firstOrNull;
}

class TaskDetailRoute extends NzRouteData with $TaskDetailRoute {
  const TaskDetailRoute({required this.code, this.trail = const []});

  /// Görev kodu (`ALT-7`); veri controller'dan yüklenir.
  final String code;

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    // Kimlik değişince yeni ekran (prototip `load(id)`); aynı kimlikte State kalır.
    base: TaskDetailPage(key: ValueKey(code), code: code),
  );
}

class CalendarRoute extends NzTabRouteData with $CalendarRoute {
  const CalendarRoute({this.trail = const []});

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    base: SplitRoot(
      master: (c) => calendarMaster((day) => showMeetingSheet(c, date: day)),
      detail: (_) => const CalendarEmptyDetail(),
    ),
  );
}

class CoordinatorshipsRoute extends NzTabRouteData with $CoordinatorshipsRoute {
  const CoordinatorshipsRoute({this.trail = const []});

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    base: SplitRoot(
      master: (_) => coordinatorshipsMaster(),
      detail: (c) => _splitBase(c, PaneKind.coord, _keyedCoordinatorshipPage),
    ),
  );
}

class CoordinatorshipRoute extends NzRouteData with $CoordinatorshipRoute {
  const CoordinatorshipRoute({required this.code, this.trail = const []});

  final String code;

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    // Kimlik değişince yeni ekran (prototip `load(id)`); aynı kimlikte State kalır.
    base: CoordinatorshipPage(key: ValueKey(code), code: code),
  );
}

class ArchiveRoute extends NzTabRouteData with $ArchiveRoute {
  const ArchiveRoute({this.trail = const []});

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    base: SplitRoot(
      master: (_) => archiveMaster(),
      detail: (c) => _splitBase(c, PaneKind.folder, _keyedArchiveFolderPage),
    ),
  );
}

class ArchiveFolderRoute extends NzRouteData with $ArchiveFolderRoute {
  const ArchiveFolderRoute({required this.code, this.trail = const []});

  final String code;

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    // Kimlik değişince yeni ekran (prototip `load(id)`); aynı kimlikte State kalır.
    base: ArchiveFolderPage(key: ValueKey(code), code: code),
  );
}

class MessagesRoute extends NzTabRouteData with $MessagesRoute {
  const MessagesRoute({this.trail = const []});

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    base: SplitRoot(
      master: (_) => messagesMaster(),
      detail: (c) => _splitBase(c, PaneKind.chat, _keyedChatPage),
    ),
  );
}

/// Tablet sağ bölmesinde sohbet (prototip `messages` / `chat`). Telefonda sohbet kabuk dışı
/// [ChatRoute] ile açılır; bu yola yalnız tabletten daralınca düşülür (alt menü gizli).
class MessagesChatRoute extends NzRouteData with $MessagesChatRoute {
  const MessagesChatRoute({required this.id, this.trail = const []});

  final String id;

  final List<String> trail;

  @override
  Widget build(BuildContext context, GoRouterState state) => PaneStack(
    trail: trail,
    // Kimlik değişince yeni ekran (prototip `load(id)`); aynı kimlikte State kalır.
    base: ChatPage(key: ValueKey(id), id: id),
  );
}

// ---- Kabuk dışı (alt menü gizli) ----

/// Zaman çizelgesi. Telefonda dikey çizelge (kabuk dışı tam ekran); ray genişliğinde yatay
/// çizelge ray yanında tam genişlik (prototip `full='gantt'`: ray kalır, liste ve ayrıntı
/// gizli). Geri tam ekranı kapatır (önceki modül ve sağ yığın döner); çizelgeden görev →
/// Görevler modülü + görev ayrıntısı (geri çizelgeye dönmez).
@TypedGoRoute<TimelineRoute>(path: '/timeline')
class TimelineRoute extends NzTabRouteData with $TimelineRoute {
  const TimelineRoute({this.coord});

  /// Başlangıçta seçili koordinatörlük kodu.
  final String? coord;

  @override
  Widget build(BuildContext context, GoRouterState state) => TimelineHost(
    phone: (_) => TimelinePage(coordinatorship: coord),
    tablet: (c) => HorizontalTimelinePage(
      coordinatorship: coord,
      onBack: () => closeTimeline(c),
      onOpenTask: (code) =>
          GoRouter.of(c).go(TaskDetailRoute(code: code).location),
    ),
  );
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

/// Çift bölmede modül kökünün sağ bölmesi: son açılan kayıt, yoksa "Bir kayıt seç".
Widget _splitBase(
  BuildContext context,
  PaneKind kind,
  Widget Function(String id) page,
) => switch (splitBaseId(context, kind)) {
  final id? => page(id),
  null => NzPickRecord(
    title: context.l10n.uiRouterPickTitle,
    message: context.l10n.uiRouterPickBody,
  ),
};

// Kök varsayılan ayrıntıları kimlikle anahtarlı (son açılan kimlik değişince yeni ekran).
Widget _keyedTaskDetailPage(String code) =>
    TaskDetailPage(key: ValueKey(code), code: code);
Widget _keyedCoordinatorshipPage(String code) =>
    CoordinatorshipPage(key: ValueKey(code), code: code);
Widget _keyedArchiveFolderPage(String code) =>
    ArchiveFolderPage(key: ValueKey(code), code: code);
Widget _keyedChatPage(String id) => ChatPage(key: ValueKey(id), id: id);
