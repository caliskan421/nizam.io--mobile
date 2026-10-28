import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';

/// Sağdan açılan çekmece (README "Gezinme": tüm modüller): `bg-surface`, sol kenarda 1 px
/// `border-strong`, sol köşeler `m-r-sheet`, gölge `m-sh-drawer`, arkada `scrim`. Açılış
/// `easeSheet` / `durSheet`, kapanış `easeExit` / `durExit`; dışarı dokunma ve geri kapatır.
/// Uygulamanın kök Navigator'ında açılır (PrivacyMask altında kalır).
abstract final class NzSideSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String semanticLabel,
    required WidgetBuilder builder,
  }) {
    final c = context.colors;
    return Navigator.of(context, rootNavigator: true).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierDismissible: true,
        barrierLabel: context.l10n.uiCommonClose,
        barrierColor: c.scrim,
        transitionDuration: NzMotion.of(context, NizamioMotion.durSheet),
        reverseTransitionDuration: NzMotion.of(context, NizamioMotion.durExit),
        pageBuilder: (routeContext, _, _) =>
            _Panel(semanticLabel: semanticLabel, builder: builder),
        transitionsBuilder: (_, animation, _, child) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animation,
              curve: NizamioMotion.easeSheet,
              reverseCurve: NizamioMotion.easeExit,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.semanticLabel, required this.builder});

  final String semanticLabel;
  final WidgetBuilder builder;

  // Dar ekranda çekmece ekranın en çok bu kadarını kaplar (arkadaki örtüye dokunulabilsin).
  static const _maxFraction = 0.86;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final width = math.min(
      NizamioSize.drawerWidth,
      MediaQuery.sizeOf(context).width * _maxFraction,
    );
    const radius = BorderRadius.horizontal(
      left: Radius.circular(NizamioRadius.sheet),
    );
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: semanticLabel,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: radius,
              // Üst/alt/sağ kenar ekran dışında kalır; tek tip kenar köşe yarıçapıyla çizilir.
              border: Border.all(
                color: c.borderStrong,
                width: NizamioSize.borderWidth,
              ),
              boxShadow: context.shadows.drawer,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Material(
                type: MaterialType.transparency,
                child: SafeArea(left: false, child: Builder(builder: builder)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
