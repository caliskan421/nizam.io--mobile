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
  $timelineRoute,
  $chatRoute,
  $profileRoute,
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
              path: 'history',
              hasOverriddenOnExit: false,
              factory: $HistoryRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/tasks',
          hasOverriddenOnExit: false,
          factory: $TasksRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':code',
              hasOverriddenOnExit: false,
              factory: $TaskDetailRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/coordinatorships',
          hasOverriddenOnExit: false,
          factory: $CoordinatorshipsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':code',
              hasOverriddenOnExit: false,
              factory: $CoordinatorshipRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/archive',
          hasOverriddenOnExit: false,
          factory: $ArchiveRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':code',
              hasOverriddenOnExit: false,
              factory: $ArchiveFolderRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/messages',
          hasOverriddenOnExit: false,
          factory: $MessagesRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',
              hasOverriddenOnExit: false,
              factory: $MessagesChatRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/calendar',
          hasOverriddenOnExit: false,
          factory: $CalendarRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute(
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  HomeRoute get _self => this as HomeRoute;

  @override
  String get location => GoRouteData.$location(
    '/home',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $HistoryRoute on GoRouteData {
  static HistoryRoute _fromState(GoRouterState state) => HistoryRoute(
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  HistoryRoute get _self => this as HistoryRoute;

  @override
  String get location => GoRouteData.$location(
    '/home/history',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $TasksRoute on GoRouteData {
  static TasksRoute _fromState(GoRouterState state) => TasksRoute(
    view: state.uri.queryParameters['view'],
    people:
        state.uri.queryParametersAll['people']?.map((e) => e).toList() ??
        const [],
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  TasksRoute get _self => this as TasksRoute;

  @override
  String get location => GoRouteData.$location(
    '/tasks',
    queryParams: {
      if (_self.view != null) 'view': _self.view,
      if (!_$iterablesEqual(_self.people, const []))
        'people': _self.people.map((e) => e).toList(),
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $TaskDetailRoute on GoRouteData {
  static TaskDetailRoute _fromState(GoRouterState state) => TaskDetailRoute(
    code: state.pathParameters['code']!,
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  TaskDetailRoute get _self => this as TaskDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/tasks/${Uri.encodeComponent(_self.code)}',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $CoordinatorshipsRoute on GoRouteData {
  static CoordinatorshipsRoute _fromState(GoRouterState state) =>
      CoordinatorshipsRoute(
        trail:
            state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
            const [],
      );

  CoordinatorshipsRoute get _self => this as CoordinatorshipsRoute;

  @override
  String get location => GoRouteData.$location(
    '/coordinatorships',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $CoordinatorshipRoute on GoRouteData {
  static CoordinatorshipRoute _fromState(GoRouterState state) =>
      CoordinatorshipRoute(
        code: state.pathParameters['code']!,
        trail:
            state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
            const [],
      );

  CoordinatorshipRoute get _self => this as CoordinatorshipRoute;

  @override
  String get location => GoRouteData.$location(
    '/coordinatorships/${Uri.encodeComponent(_self.code)}',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $ArchiveRoute on GoRouteData {
  static ArchiveRoute _fromState(GoRouterState state) => ArchiveRoute(
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  ArchiveRoute get _self => this as ArchiveRoute;

  @override
  String get location => GoRouteData.$location(
    '/archive',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $ArchiveFolderRoute on GoRouteData {
  static ArchiveFolderRoute _fromState(GoRouterState state) =>
      ArchiveFolderRoute(
        code: state.pathParameters['code']!,
        trail:
            state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
            const [],
      );

  ArchiveFolderRoute get _self => this as ArchiveFolderRoute;

  @override
  String get location => GoRouteData.$location(
    '/archive/${Uri.encodeComponent(_self.code)}',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $MessagesRoute on GoRouteData {
  static MessagesRoute _fromState(GoRouterState state) => MessagesRoute(
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  MessagesRoute get _self => this as MessagesRoute;

  @override
  String get location => GoRouteData.$location(
    '/messages',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $MessagesChatRoute on GoRouteData {
  static MessagesChatRoute _fromState(GoRouterState state) => MessagesChatRoute(
    id: state.pathParameters['id']!,
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  MessagesChatRoute get _self => this as MessagesChatRoute;

  @override
  String get location => GoRouteData.$location(
    '/messages/${Uri.encodeComponent(_self.id)}',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

mixin $CalendarRoute on GoRouteData {
  static CalendarRoute _fromState(GoRouterState state) => CalendarRoute(
    trail:
        state.uri.queryParametersAll['trail']?.map((e) => e).toList() ??
        const [],
  );

  CalendarRoute get _self => this as CalendarRoute;

  @override
  String get location => GoRouteData.$location(
    '/calendar',
    queryParams: {
      if (!_$iterablesEqual(_self.trail, const []))
        'trail': _self.trail.map((e) => e).toList(),
    },
  );

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

bool _$iterablesEqual<T>(Iterable<T>? iterable1, Iterable<T>? iterable2) {
  if (identical(iterable1, iterable2)) return true;
  if (iterable1 == null || iterable2 == null) return false;
  final iterator1 = iterable1.iterator;
  final iterator2 = iterable2.iterator;
  while (true) {
    final hasNext1 = iterator1.moveNext();
    final hasNext2 = iterator2.moveNext();
    if (hasNext1 != hasNext2) return false;
    if (!hasNext1) return true;
    if (iterator1.current != iterator2.current) return false;
  }
}

RouteBase get $timelineRoute => GoRouteData.$route(
  path: '/timeline',
  hasOverriddenOnExit: false,
  factory: $TimelineRoute._fromState,
);

mixin $TimelineRoute on GoRouteData {
  static TimelineRoute _fromState(GoRouterState state) =>
      TimelineRoute(coord: state.uri.queryParameters['coord']);

  TimelineRoute get _self => this as TimelineRoute;

  @override
  String get location => GoRouteData.$location(
    '/timeline',
    queryParams: {if (_self.coord != null) 'coord': _self.coord},
  );

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

RouteBase get $chatRoute => GoRouteData.$route(
  path: '/chat/:id',
  hasOverriddenOnExit: false,
  factory: $ChatRoute._fromState,
);

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) =>
      ChatRoute(id: state.pathParameters['id']!);

  ChatRoute get _self => this as ChatRoute;

  @override
  String get location =>
      GoRouteData.$location('/chat/${Uri.encodeComponent(_self.id)}');

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

RouteBase get $profileRoute => GoRouteData.$route(
  path: '/profile',
  hasOverriddenOnExit: false,
  factory: $ProfileRoute._fromState,
);

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
