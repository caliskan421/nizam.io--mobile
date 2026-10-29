import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/nz_motion.dart';

/// İçerik oluşturulunca ve korunan sayfa yeniden görünür olunca açılır.
/// Sıradan yeniden çizimler animasyonu başlatmaz; mesafe sabit mantıksal pikseldir.
/// Sekme paneline kimliğinden ValueKey vererek yeni giriş başlatılabilir.
class PageContentEntrance extends StatefulWidget {
  const PageContentEntrance({super.key, required this.child}) : _sliver = false;

  /// Sliver geometrisini ve tembel liste kurulumunu koruyan aynı hareket.
  const PageContentEntrance.sliver({super.key, required this.child})
    : _sliver = true;

  final Widget child;
  final bool _sliver;

  @override
  State<PageContentEntrance> createState() => _PageContentEntranceState();
}

class _PageContentEntranceState extends State<PageContentEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;
  bool? _coveredByParent;
  bool? _active;
  Animation<double>? _parentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: RpMotion.enterDuration,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: RpMotion.enterCurve,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // İlk panel zaten sayfa ile birlikte hareket eder: mesafe/opaklık ikiye katlanmaz.
    // Sonradan anahtarı değişen panel kendi girişini oynatır.
    _parentAnimation ??= context
        .getInheritedWidgetOfExactType<_EntranceScope>()
        ?.animation;
    _coveredByParent ??= _parentAnimation?.isCompleted == false;
    final active = TickerMode.valuesOf(context).enabled;
    final returning = _active == false && active;
    _active = active;
    if (NzMotion.reduced(context)) {
      _controller.duration = Duration.zero;
      _controller.value = 1;
      return;
    }
    if (!active) {
      _controller.stop();
      return;
    }
    if (returning) {
      // go_router korunan dalları TickerMode ile gizler. Yalnız dış içerik yeniden
      // oynar; alt paneller onun hareketine katılır ve mesafeyi ikiye katlamaz.
      // Üst hareket şu an oynuyorsa (tablet bölme geçişi) ona katılınır.
      _coveredByParent = _parentAnimation?.isAnimating ?? false;
      _controller.duration = RpMotion.enterDuration;
      if (!_coveredByParent!) _controller.forward(from: 0);
    }
    if (_coveredByParent!) {
      _controller.duration = Duration.zero;
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _EntranceScope(
    animation: _coveredByParent! ? _parentAnimation! : _animation,
    child: AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final t = _animation.value;
        final dy = RpMotion.enterOffset * (1 - t);
        if (widget._sliver) {
          return SliverOpacity(
            opacity: t,
            sliver: _SliverTranslate(dy: dy, child: child!),
          );
        }
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, dy), child: child),
        );
      },
    ),
  );
}

/// Tablet bölme geçişinin türü (prototip `A`): [fade] `rpFadeIn .3s ease` (modül değişimi,
/// aynı türde kayıt seçimi, aynı kaydı yeniden seçme), [push] `rpPush .38s` (36 px sağdan),
/// [pop] `rpPop .38s` (36 px soldan), eğri `cubic(.2,.8,.2,1)`.
enum NzPaneMotion { fade, push, pop }

/// Tablet bölmesine giren ekranın hareketi. Ağaç yapısı her zaman aynıdır (çocuğun State'i
/// korunur); [enabled] false iken (telefon, tek bölme) hareket yoktur ve içteki
/// [PageContentEntrance] kendi yükselişini oynatır. [enabled] iken oluşunca ve [play] her
/// değiştiğinde (null hariç) [motion] oynar; içteki [PageContentEntrance] bunu üst hareket
/// sayar (çift animasyon yok). Hareketi azalt → anlık.
class NzPaneTransition extends StatefulWidget {
  const NzPaneTransition({
    super.key,
    required this.motion,
    required this.child,
    this.enabled = true,
    this.play,
  });

  final NzPaneMotion motion;
  final bool enabled;

  /// Yeniden oynatma belirteci (ör. ekran yeniden en üste geldi).
  final Object? play;
  final Widget child;

  @override
  State<NzPaneTransition> createState() => _NzPaneTransitionState();
}

class _NzPaneTransitionState extends State<NzPaneTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  late NzPaneMotion _motion = widget.motion;
  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: RpMotion.enterCurve,
  );
  Object? _played;

  @override
  void initState() {
    super.initState();
    _played = widget.play;
    if (widget.enabled) {
      _start(widget.motion);
    } else {
      _controller.value = 1;
    }
  }

  void _start(NzPaneMotion motion) {
    _motion = motion;
    final fade = motion == NzPaneMotion.fade;
    _controller.duration = fade
        ? RpMotion.tabFadeDuration
        : RpMotion.pushDuration;
    _animation.curve = fade ? Curves.ease : RpMotion.enterCurve;
    _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(NzPaneTransition old) {
    super.didUpdateWidget(old);
    if (!widget.enabled) {
      _controller.value = 1;
      return;
    }
    if (widget.play != null && widget.play != _played) {
      _played = widget.play;
      _start(widget.motion);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (NzMotion.reduced(context)) _controller.value = 1;
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _EntranceScope(
    animation: _animation,
    child: FadeTransition(
      opacity: _animation,
      child: AnimatedBuilder(
        animation: _animation,
        child: widget.child,
        builder: (context, child) {
          final t = _controller.isCompleted ? 1.0 : _animation.value;
          final dx = switch (_motion) {
            NzPaneMotion.fade => 0.0,
            NzPaneMotion.push => RpMotion.pushOffset * (1 - t),
            NzPaneMotion.pop => -RpMotion.pushOffset * (1 - t),
          };
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
      ),
    ),
  );
}

class _EntranceScope extends InheritedWidget {
  const _EntranceScope({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_EntranceScope oldWidget) =>
      animation != oldWidget.animation;
}

/// Yalnız boyama dönüşür; scrollExtent, layoutExtent ve sabit başlık hesabı değişmez.
class _SliverTranslate extends SingleChildRenderObjectWidget {
  const _SliverTranslate({required this.dy, required super.child});

  final double dy;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverTranslate(dy);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliverTranslate renderObject,
  ) => renderObject.dy = dy;
}

class _RenderSliverTranslate extends RenderProxySliver {
  _RenderSliverTranslate(this._dy);

  double _dy;

  set dy(double value) {
    if (_dy == value) return;
    _dy = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child!, offset + Offset(0, _dy));
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    transform.translateByDouble(0, _dy, 0, 1);
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) => result.addWithAxisOffset(
    paintOffset: Offset(0, _dy),
    mainAxisOffset: _dy,
    crossAxisOffset: 0,
    mainAxisPosition: mainAxisPosition,
    crossAxisPosition: crossAxisPosition,
    hitTest: super.hitTestChildren,
  );
}
