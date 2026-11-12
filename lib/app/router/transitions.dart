import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum NzTransition { push, tab }

/// Normal gezinmede kabuk anında değişir; geri hareketini platformun route
/// controller'ı yönetir. İçerik girişi NzPage'de kalır.
class RpPushRoute<T> extends PageRouteBuilder<T> {
  RpPushRoute({
    required Widget child,
    required BuildContext context,
    super.settings,
    NzTransition kind = NzTransition.push,
  }) : _kind = kind,
       super(
         transitionDuration: kind == NzTransition.tab
             ? Duration.zero
             : CupertinoRouteTransitionMixin.kTransitionDuration,
         reverseTransitionDuration: kind == NzTransition.tab
             ? Duration.zero
             : CupertinoRouteTransitionMixin.kTransitionDuration,
         pageBuilder: (context, animation, secondaryAnimation) => Builder(
           builder: (context) {
             final page = ModalRoute.of(context)!.settings;
             return page is _RpPage<T> ? page.child : child;
           },
         ),
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             child,
       );

  final NzTransition _kind;

  @override
  bool get popGestureEnabled =>
      _kind != NzTransition.tab &&
      isCurrent &&
      _visibleNavigatorChain &&
      !popGestureInProgress &&
      secondaryAnimation!.isDismissed &&
      super.popGestureEnabled;

  // Inactive shell branches retain a current leaf in their nested Navigator.
  // Root overlays must also block that leaf's system-back observer.
  bool get _visibleNavigatorChain {
    var current = navigator;
    while (current != null) {
      if (!TickerMode.getValuesNotifier(current.context).value.enabled) {
        return false;
      }
      final outer = ModalRoute.of(current.context);
      if (outer == null) return true;
      if (!outer.isCurrent) return false;
      final parent = outer.navigator;
      if (identical(parent, current)) return true;
      current = parent;
    }
    return true;
  }

  @override
  TickerFuture didPush() {
    controller!.duration = Duration.zero;
    final pushed = super.didPush();
    controller!.duration = transitionDuration;
    return pushed;
  }

  @override
  bool didPop(T? result) {
    final previousDuration = controller!.reverseDuration;
    if (!popGestureInProgress) controller!.reverseDuration = Duration.zero;
    final popped = super.didPop(result);
    if (!popped) controller!.reverseDuration = previousDuration;
    return popped;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final platform = Theme.of(context).platform;
    if (_kind == NzTransition.tab ||
        (platform != TargetPlatform.iOS &&
            platform != TargetPlatform.android)) {
      return child;
    }
    return ValueListenableBuilder<bool>(
      valueListenable: navigator!.userGestureInProgressNotifier,
      child: child,
      builder: (context, interactive, child) {
        // Sabit animasyon normal açılışta ikinci bir sayfa hareketini önler.
        // Algılayıcı idle durumda da ağaçtadır; sürükleme ve settle SDK'ya aittir.
        final primary = interactive ? animation : kAlwaysCompleteAnimation;
        final secondary = interactive
            ? secondaryAnimation
            : kAlwaysDismissedAnimation;
        return platform == TargetPlatform.iOS
            ? CupertinoRouteTransitionMixin.buildPageTransitions<T>(
                this,
                context,
                primary,
                secondary,
                child!,
              )
            : const PredictiveBackPageTransitionsBuilder().buildTransitions<T>(
                this,
                context,
                primary,
                secondary,
                child!,
              );
      },
    );
  }
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
