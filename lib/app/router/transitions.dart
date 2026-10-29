import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum NzTransition { push, tab }

/// Sayfa kabuğu anında değişir; hareket yalnız NzPage içindeki içerikte uygulanır.
class RpPushRoute<T> extends PageRouteBuilder<T> {
  RpPushRoute({
    required Widget child,
    required BuildContext context,
    super.settings,
    NzTransition kind = NzTransition.push,
  }) : super(
         transitionDuration: Duration.zero,
         reverseTransitionDuration: Duration.zero,
         pageBuilder: (context, animation, secondaryAnimation) => Builder(
           builder: (context) {
             final page = ModalRoute.of(context)!.settings;
             return page is _RpPage<T> ? page.child : child;
           },
         ),
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             child,
       );
}

class _RpPage<T> extends Page<T> {
  const _RpPage({
    super.key,
    super.name,
    required this.child,
    required this.kind,
  });

  final Widget child;
  final NzTransition kind;

  @override
  Route<T> createRoute(BuildContext context) => RpPushRoute<T>(
    context: context,
    settings: this,
    child: child,
    kind: kind,
  );
}

/// go_router sayfaları da aynı PageRouteBuilder üzerinden açılır.
Page<T> nzTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
  NzTransition kind = NzTransition.push,
}) => _RpPage<T>(
  key: state.pageKey,
  name: state.name ?? state.path,
  child: child,
  kind: kind,
);

abstract class NzRouteData extends GoRouteData {
  const NzRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      nzTransitionPage<void>(state: state, child: build(context, state));
}

abstract class NzTabRouteData extends GoRouteData {
  const NzTabRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      nzTransitionPage<void>(
        state: state,
        child: build(context, state),
        kind: NzTransition.tab,
      );
}
