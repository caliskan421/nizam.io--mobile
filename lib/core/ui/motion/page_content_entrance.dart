import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/nz_motion.dart';

/// İçerik oluşturulunca ve korunan sayfa yeniden görünür olunca açılır.
/// Sıradan yeniden çizimler animasyonu başlatmaz; mesafe sabit mantıksal pikseldir.
/// Sekme paneline kimliğinden ValueKey vererek yeni giriş başlatılabilir; liste/ızgara
/// öğeleri için hazır sarmalayıcı [NzEntrance]'tır.
class PageContentEntrance extends StatefulWidget {
  const PageContentEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.enabled = true,
  }) : _sliver = false;

  /// Sliver geometrisini ve tembel liste kurulumunu koruyan aynı hareket.
  const PageContentEntrance.sliver({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.enabled = true,
  }) : _sliver = true;

  final Widget child;
  final bool enabled;

  /// Hareketin başlamadan önce beklediği süre (kademeli giriş; bkz. [RpMotion.stagger]).
  /// Yalnız ilk kurulumda okunur; süre boyunca içerik saydam ve aşağıda bekler.
  final Duration delay;
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

  /// Gecikme + giriş; gecikme eğrinin başındaki düz [Interval] bölümüdür (zamanlayıcı yok).
  Duration get _total => RpMotion.enterDuration + widget.delay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _total)..forward();
    final start = widget.delay.inMicroseconds / _total.inMicroseconds;
    _animation = CurvedAnimation(
      parent: _controller,
      curve: start == 0
          ? RpMotion.enterCurve
          : Interval(start, 1, curve: RpMotion.enterCurve),
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
      _controller.duration = _total;
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
  Widget build(BuildContext context) => !widget.enabled
      ? widget.child
      : _EntranceScope(
          animation: _coveredByParent! ? _parentAnimation! : _animation,
          // Kare başına build yok: öteleme ve opaklık animasyonu render nesnesinde dinlenir.
          // Öteleme dışta, opaklık içte: opaklık katmanı yeniden boyanmadan kaydırılır.
          child: widget._sliver
              ? _SliverTranslate(
                  animation: _animation,
                  dy: RpMotion.enterOffset,
                  child: SliverFadeTransition(
                    opacity: _animation,
                    sliver: widget.child,
                  ),
                )
              : _Translate(
                  animation: _animation,
                  from: const Offset(0, RpMotion.enterOffset),
                  child: FadeTransition(
                    opacity: _animation,
                    child: widget.child,
                  ),
                ),
        );
}

/// Değişen içeriğin girişi (görev ayrıntısı sekme paneliyle aynı hareket: opaklık 0 → 1,
/// [RpMotion.enterOffset] aşağıdan yükseliş). [replay] değişince giriş yeniden oynar
/// (ör. süzgeç/sıralama değişti); aynı kalırsa sıradan yeniden çizim hareket başlatmaz.
/// [index] verilirse kademeli başlar ([RpMotion.stagger]; üst sınırlı, uzun listede gecikme
/// birikmez). Sayfa girişi sürerken ilk kurulumda sayfa hareketine katılır (çift hareket yok);
/// hareketi azalt → anlık.
///
/// Izgara/liste için öneri: [replay] olarak süzgeç durumu + öğe kimliği verilir; böylece
/// süzgeç değişince tüm öğeler, "tümünü göster" ile yalnız yeni gelen öğeler girer.
class NzEntrance extends StatelessWidget {
  const NzEntrance({
    super.key,
    required this.replay,
    required this.child,
    this.index = 0,
  }) : _sliver = false;

  /// Sliver biçimi (geometri değişmez; bkz. [PageContentEntrance.sliver]).
  const NzEntrance.sliver({
    super.key,
    required this.replay,
    required Widget sliver,
    this.index = 0,
  }) : child = sliver,
       _sliver = true;

  /// Değişince giriş yeniden oynar (eşitlik `==` ile).
  final Object? replay;

  /// Kademeli giriş sırası (0 → gecikmesiz).
  final int index;
  final Widget child;
  final bool _sliver;

  @override
  Widget build(BuildContext context) {
    final key = ValueKey(replay);
    final delay = RpMotion.stagger(index);
    return _sliver
        ? PageContentEntrance.sliver(key: key, delay: delay, child: child)
        : PageContentEntrance(key: key, delay: delay, child: child);
  }
}

/// Tablet bölme geçişinin türü: [rise] telefondaki sayfa girişinin birebir aynısı
/// ([PageContentEntrance]: opaklık 0 → 1, [RpMotion.enterOffset] aşağıdan yükseliş,
/// [RpMotion.enterDuration], [RpMotion.enterCurve]; modül değişimi, aynı türde kayıt seçimi,
/// aynı kaydı yeniden seçme), [push] `rpPush .38s` (36 px sağdan), [pop] `rpPop .38s` (36 px
/// soldan), eğri `cubic(.2,.8,.2,1)`.
enum NzPaneMotion { rise, push, pop }

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
    _controller.duration = motion == NzPaneMotion.rise
        ? RpMotion.enterDuration
        : RpMotion.pushDuration;
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
    child: _Translate(
      animation: _animation,
      from: switch (_motion) {
        NzPaneMotion.rise => const Offset(0, RpMotion.enterOffset),
        NzPaneMotion.push => const Offset(RpMotion.pushOffset, 0),
        NzPaneMotion.pop => const Offset(-RpMotion.pushOffset, 0),
      },
      child: FadeTransition(opacity: _animation, child: widget.child),
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

/// [animation] değerine göre çocuğu boyamada öteler: t = 0 → [from], t = 1 → yerinde.
/// Yerleşim değişmez; değer değişince yalnız boyama geçersizlenir (build yok).
class _Translate extends SingleChildRenderObjectWidget {
  const _Translate({
    required this.animation,
    required this.from,
    required super.child,
  });

  final Animation<double> animation;
  final Offset from;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTranslate(animation, from);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTranslate renderObject,
  ) => renderObject
    ..animation = animation
    ..from = from;
}

class _RenderTranslate extends RenderProxyBox {
  _RenderTranslate(this._animation, this._from);

  Animation<double> _animation;
  Offset _from;
  Offset _offset = Offset.zero;

  set animation(Animation<double> value) {
    if (_animation == value) return;
    if (attached) _animation.removeListener(_update);
    _animation = value;
    if (attached) _animation.addListener(_update);
    _update();
  }

  set from(Offset value) {
    if (_from == value) return;
    _from = value;
    _update();
  }

  void _update() {
    final next = _from * (1 - _animation.value);
    if (next == _offset) return;
    _offset = next;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation.addListener(_update);
    _update();
  }

  @override
  void detach() {
    _animation.removeListener(_update);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child!, offset + _offset);
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translateByDouble(_offset.dx, _offset.dy, 0, 1);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      result.addWithPaintOffset(
        offset: _offset,
        position: position,
        hitTest: (result, position) =>
            super.hitTestChildren(result, position: position),
      );
}

/// Sliver öteleme ([_Translate] gibi animasyonu dinler): yalnız boyama dönüşür;
/// scrollExtent, layoutExtent ve sabit başlık hesabı değişmez. t = 0 → [dy] aşağıda.
class _SliverTranslate extends SingleChildRenderObjectWidget {
  const _SliverTranslate({
    required this.animation,
    required this.dy,
    required super.child,
  });

  final Animation<double> animation;
  final double dy;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverTranslate(animation, dy);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliverTranslate renderObject,
  ) => renderObject
    ..animation = animation
    ..dy = dy;
}

class _RenderSliverTranslate extends RenderProxySliver {
  _RenderSliverTranslate(this._animation, this._from);

  Animation<double> _animation;
  double _from;
  double _dy = 0;

  set animation(Animation<double> value) {
    if (_animation == value) return;
    if (attached) _animation.removeListener(_update);
    _animation = value;
    if (attached) _animation.addListener(_update);
    _update();
  }

  set dy(double value) {
    if (_from == value) return;
    _from = value;
    _update();
  }

  void _update() {
    final next = _from * (1 - _animation.value);
    if (next == _dy) return;
    _dy = next;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation.addListener(_update);
    _update();
  }

  @override
  void detach() {
    _animation.removeListener(_update);
    super.detach();
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
