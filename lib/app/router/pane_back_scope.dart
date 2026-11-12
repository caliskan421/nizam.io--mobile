import 'dart:math' as math;

import 'package:flutter/material.dart';

/// URL sorgusunda tutulan bölme izinin geri kapısı. İz varken dış route pop edilmez;
/// sistem geri ve iOS'un yalnız bölme kenarında başlayan hareketi aynı adımı ister.
/// Gerçek route yığınında iz yoksa platformun kendi geri hareketi devrededir.
class PaneBackScope extends StatefulWidget {
  const PaneBackScope({
    super.key,
    required this.hasTrail,
    required this.owner,
    required this.onBack,
    required this.child,
  });

  final bool hasTrail;

  /// Yol ve tüm sorgu parametreleri: hareket sürerken konum değişirse hareket iptal olur.
  final String owner;
  final VoidCallback onBack;
  final Widget child;

  @override
  State<PaneBackScope> createState() => _PaneBackScopeState();
}

class _PaneBackScopeState extends State<PaneBackScope>
    implements PopEntry<Object?> {
  ModalRoute<dynamic>? _route;
  bool _checking = false;
  bool _committed = false;
  String? _dragOwner;
  double _distance = 0;
  double _direction = 1;

  @override
  late final ValueNotifier<bool> canPopNotifier = ValueNotifier(
    !widget.hasTrail,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = ModalRoute.of(context);
    if (!identical(_route, next)) {
      _route?.unregisterPopEntry(this);
      _route = next;
      _route?.registerPopEntry(this);
      _dragOwner = null;
    }
  }

  @override
  void didUpdateWidget(PaneBackScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    canPopNotifier.value = !widget.hasTrail;
    if (oldWidget.owner != widget.owner ||
        oldWidget.hasTrail != widget.hasTrail) {
      _committed = false;
      _dragOwner = null;
    }
  }

  @override
  void dispose() {
    _route?.unregisterPopEntry(this);
    canPopNotifier.dispose();
    super.dispose();
  }

  /// StatefulShellRoute'un gizli dalı veya kök navigator'daki modal da geri adımını
  /// durdurur. İç navigator'ın isCurrent değeri tek başına dış modalı göstermez.
  bool get _foreground {
    if (!mounted || !TickerMode.valuesOf(context).enabled) return false;
    final seen = <ModalRoute<dynamic>>{};
    var route = _route;
    while (route != null) {
      if (!seen.add(route) || !route.isCurrent) return false;
      final navigator = route.navigator;
      if (navigator == null) return false;
      route = ModalRoute.of(navigator.context);
    }
    return seen.isNotEmpty;
  }

  /// Kendi virtual-stack vetomuzu eşzamanlı olarak dışarıda bırakarak route'un diğer
  /// PopScope vetolarını sorarız. await yoktur; notifier ve reentrancy kapısı istisna
  /// halinde de eski hâline döner. SDK'nın kayıt koleksiyonu değiştirilmez.
  bool _otherGuardsAllow() {
    final route = _route;
    if (route == null || _checking) return false;
    final previous = canPopNotifier.value;
    _checking = true;
    try {
      canPopNotifier.value = true;
      return route.popDisposition != RoutePopDisposition.doNotPop &&
          !route.willHandlePopInternally;
    } finally {
      canPopNotifier.value = previous;
      _checking = false;
    }
  }

  void _back(String owner) {
    if (!mounted ||
        !widget.hasTrail ||
        widget.owner != owner ||
        _committed ||
        !_foreground ||
        !_otherGuardsAllow()) {
      return;
    }
    // Bildirim dinleyicileri eşzamanlı çalışabilir: komuttan önce sahibini tekrar doğrula.
    if (!mounted || !widget.hasTrail || widget.owner != owner || !_foreground) {
      return;
    }
    _committed = true;
    widget.onBack();
  }

  @override
  void onPopInvoked(bool didPop) {}

  @override
  void onPopInvokedWithResult(bool didPop, Object? result) {
    if (!didPop && !_checking) _back(widget.owner);
  }

  void _start(DragStartDetails details) {
    _distance = 0;
    _direction = Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    _dragOwner = widget.hasTrail && !_committed && _foreground
        ? widget.owner
        : null;
  }

  void _update(DragUpdateDetails details) {
    if (_dragOwner != null) {
      _distance += (details.primaryDelta ?? 0) * _direction;
    }
  }

  void _end(DragEndDetails details, double width) {
    final owner = _dragOwner;
    _dragOwner = null;
    if (owner == null) return;
    final velocity = (details.primaryVelocity ?? 0) * _direction;
    if (velocity < 0) return;
    final threshold = math.min(160.0, math.max(64.0, width * .28));
    if (_distance >= threshold || (_distance >= 32 && velocity >= 800)) {
      _back(owner);
    }
  }

  @override
  Widget build(BuildContext context) {
    final edge =
        widget.hasTrail && Theme.of(context).platform == TargetPlatform.iOS;
    return LayoutBuilder(
      builder: (context, box) => Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (edge)
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              width: 24,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                excludeFromSemantics: true,
                onHorizontalDragStart: _start,
                onHorizontalDragUpdate: _update,
                onHorizontalDragEnd: (details) => _end(details, box.maxWidth),
                onHorizontalDragCancel: () => _dragOwner = null,
                child: const SizedBox.expand(),
              ),
            ),
        ],
      ),
    );
  }
}
