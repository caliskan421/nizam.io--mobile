// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $serverRoute,
  $updateRequiredRoute,
  $loginRoute,
  $passwordRoute,
  $scopeRoute,
  $appShellRoute,
];

RouteBase get $serverRoute => GoRouteData.$route(
  path: '/server',
  hasOverriddenOnExit: false,
  factory: $ServerRoute._fromState,
);

mixin $ServerRoute on GoRouteData {
  static ServerRoute _fromState(GoRouterState state) => const ServerRoute();

  @override
  String get location => GoRouteData.$location('/server');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $updateRequiredRoute => GoRouteData.$route(
  path: '/update-required',
  hasOverriddenOnExit: false,
  factory: $UpdateRequiredRoute._fromState,
);

mixin $UpdateRequiredRoute on GoRouteData {
  static UpdateRequiredRoute _fromState(GoRouterState state) =>
      const UpdateRequiredRoute();

  @override
  String get location => GoRouteData.$location('/update-required');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $passwordRoute => GoRouteData.$route(
  path: '/password',
  hasOverriddenOnExit: false,
  factory: $PasswordRoute._fromState,
);

mixin $PasswordRoute on GoRouteData {
  static PasswordRoute _fromState(GoRouterState state) => const PasswordRoute();

  @override
  String get location => GoRouteData.$location('/password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $scopeRoute => GoRouteData.$route(
  path: '/scope',
  hasOverriddenOnExit: false,
  factory: $ScopeRoute._fromState,
);

mixin $ScopeRoute on GoRouteData {
  static ScopeRoute _fromState(GoRouterState state) => const ScopeRoute();

  @override
  String get location => GoRouteData.$location('/scope');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $appShellRoute => StatefulShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'detail/:id',
              hasOverriddenOnExit: false,
              factory: $HomeDetailRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/work',
          hasOverriddenOnExit: false,
          factory: $WorkRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'detail/:id',
              hasOverriddenOnExit: false,
              factory: $WorkDetailRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          hasOverriddenOnExit: false,
          factory: $ProfileRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HomeDetailRoute on GoRouteData {
  static HomeDetailRoute _fromState(GoRouterState state) =>
      HomeDetailRoute(id: state.pathParameters['id']!);

  HomeDetailRoute get _self => this as HomeDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/home/detail/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $WorkRoute on GoRouteData {
  static WorkRoute _fromState(GoRouterState state) => const WorkRoute();

  @override
  String get location => GoRouteData.$location('/work');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $WorkDetailRoute on GoRouteData {
  static WorkDetailRoute _fromState(GoRouterState state) =>
      WorkDetailRoute(id: state.pathParameters['id']!);

  WorkDetailRoute get _self => this as WorkDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/work/detail/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
