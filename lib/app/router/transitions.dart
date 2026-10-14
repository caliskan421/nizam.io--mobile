import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Rota geçişleri TEK yerde (A5): bütün sayfalar [nzTransitionPage] ile kurulur. Geçiş solmadır;
/// sistem "animasyonları azalt" dediğinde geçişsiz açılır.
const _transitionDuration = Duration(milliseconds: 200);

Page<T> nzTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  name: state.name ?? state.path,
  transitionDuration: _transitionDuration,
  reverseTransitionDuration: _transitionDuration,
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      MediaQuery.disableAnimationsOf(context)
      ? child
      : FadeTransition(
          opacity: CurveTween(curve: Curves.easeOut).animate(animation),
          child: child,
        ),
);

/// Bütün tipli rotaların tabanı: sayfayı [nzTransitionPage] ile kurar. Alt sınıf yalnız
/// [build] yazar; geçiş seçimi rota dosyalarına dağılmaz.
abstract class NzRouteData extends GoRouteData {
  const NzRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      nzTransitionPage<void>(state: state, child: build(context, state));
}
