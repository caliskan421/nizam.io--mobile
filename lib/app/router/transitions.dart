import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/generated/tokens.gen.dart';

/// Rota geçişinin türü (README "Hareket · Ekran geçişi"): ileri `m-push` (36 px sağdan), geri
/// `m-pop` (aynı yolun tersi), sekme değişimi `m-tab` (10 px aşağıdan). Eğri `easeOut`.
enum NzTransition { push, tab }

// Prototip ekran geçişi .38 s (`--m-ease-out`); en yakın hareket token'ı `durSheet` (.42 s).
const _duration = NizamioMotion.durSheet;
const _pushOffset = 36.0;
const _tabOffset = 10.0;

/// Rota geçişleri TEK yerde (A5): bütün sayfalar [nzTransitionPage] ile kurulur. Sistem
/// "animasyonları azalt" dediğinde geçişsiz açılır.
Page<T> nzTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
  NzTransition kind = NzTransition.push,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  name: state.name ?? state.path,
  transitionDuration: _duration,
  reverseTransitionDuration: NizamioMotion.durExit,
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: NizamioMotion.easeOut,
      reverseCurve: NizamioMotion.easeExit,
    );
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final begin = switch (kind) {
      NzTransition.push => Offset(width == 0 ? 0 : _pushOffset / width, 0),
      NzTransition.tab => Offset(0, height == 0 ? 0 : _tabOffset / height),
    };
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: begin, end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  },
);

/// Bütün tipli rotaların tabanı: sayfayı [nzTransitionPage] (itme) ile kurar. Alt sınıf yalnız
/// [build] yazar; geçiş seçimi rota dosyalarına dağılmaz.
abstract class NzRouteData extends GoRouteData {
  const NzRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      nzTransitionPage<void>(state: state, child: build(context, state));
}

/// Kabuk dal kökleri: sekme geçişi.
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
