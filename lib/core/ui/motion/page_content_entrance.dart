import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/nz_motion.dart';

/// İçerik oluşturulunca ve korunan sayfa yeniden görünür olunca açılır.
/// Sıradan yeniden çizimler animasyonu başlatmaz; mesafe sabit mantıksal pikseldir.
/// Sekme paneline kimliğinden ValueKey vererek yeni giriş başlatılabilir; liste/ızgara
/// öğeleri için hazır sarmalayıcı [NzEntrance]'tır.
///
/// Alt ağacında cam (`NzGlass` / `BackdropFilter`) olan girişe [fade] false verilir: hareket
/// yalnız ötelemedir. Saydamlık katmanı altındaki bulanıklık her karede saveLayer ve yeniden
/// bulanıklaştırma ister. İçteki camsız giriş, üst hareketin solmasını kendi katmanında yapar
/// (kapsayan hareketle aynı eğri; mesafe ikiye katlanmaz).
class PageContentEntrance extends StatefulWidget {
  const PageContentEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.enabled = true,
    this.fade = true,
    this.onRevisit,
  }) : _sliver = false;

  /// Sliver geometrisini ve tembel liste kurulumunu koruyan aynı hareket.
  const PageContentEntrance.sliver({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.enabled = true,
    this.fade = true,
    this.onRevisit,
  }) : _sliver = true;

  final Widget child;
  final bool enabled;

  /// false → opaklık animasyonu yok, yalnız öteleme (alt ağaçta cam var; bkz. sınıf belgesi).
  final bool fade;

  /// İlk etkin görünüşte ve gizli içerik yeniden görünür olunca (`TickerMode` kapalı → açık)
  /// giriş hareketi BİTİNCE bir kez çağrılır: bu girişin ya da katıldığı üst hareketin
  /// (tablet bölme geçişi), her durumda kare sonunda. Hareket yoksa (hareketi azalt,
  /// [enabled] false) ilk etkin karenin sonunda.
  /// Bayat veri tazelemesi içindir (ör. `refreshIfStale`): istek ve yeniden kurulum hareketle
  /// aynı karelere düşmez. Hareket bitmeden yeniden gizlenirse çağrılmaz.
  final VoidCallback? onRevisit;

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

  /// [PageContentEntrance.onRevisit] için bitişi beklenen hareket.
  Animation<double>? _revisitAfter;
  int _revisitEpoch = 0;

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
    final entering = _active != true && active;
    final returning = _active == false && active;
    _active = active;
    if (!active) _cancelRevisit();
    if (NzMotion.reduced(context) || !widget.enabled) {
      _controller.duration = Duration.zero;
      _controller.value = 1;
    } else if (!active) {
      _controller.stop();
      return;
    } else if (returning) {
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
    if (entering) _scheduleRevisit();
  }

  void _scheduleRevisit() {
    if (widget.onRevisit == null) return;
    final motion = _coveredByParent! ? _parentAnimation! : _controller;
    if (motion.isAnimating) {
      _revisitAfter = motion..addStatusListener(_onMotionStatus);
    } else {
      _queueRevisit(motion);
    }
  }

  /// Yalnız tamamlanma sayılır: hareket `forward(from: 0)` ile baştan başlarsa (dismissed)
  /// ya da durdurulursa bekleme sürer; yeniden gizlenme [_cancelRevisit] ile bırakır.
  void _onMotionStatus(AnimationStatus status) {
    if (!status.isCompleted) return;
    final motion = _revisitAfter!;
    motion.removeStatusListener(_onMotionStatus);
    _revisitAfter = null;
    _queueRevisit(motion);
  }

  void _queueRevisit(Animation<double> motion) {
    final epoch = _revisitEpoch;
    // Hareket dinleyicisi de kare içinde çalışır: sağlayıcı yazımı her zaman kare sonuna.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _active != true || epoch != _revisitEpoch) return;
      // Üst hareket tamamlandıktan sonra aynı karede yeniden başlamış olabilir.
      if (motion.isAnimating) {
        _revisitAfter = motion..addStatusListener(_onMotionStatus);
        return;
      }
      _revisitEpoch++;
      widget.onRevisit?.call();
    });
  }

  void _cancelRevisit() {
    _revisitEpoch++;
    _revisitAfter?.removeStatusListener(_onMotionStatus);
    _revisitAfter = null;
  }

  @override
  void dispose() {
    _cancelRevisit();
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final covered = _coveredByParent!;
    // Üst hareket solmuyorsa (cam taşıyan kapsayıcı) bu katman onun solmasını üstlenir.
    final parentFaded =
        covered &&
        (context.getInheritedWidgetOfExactType<_EntranceScope>()?.faded ??
            false);
    final Animation<double> opacity = !widget.fade || parentFaded
        ? kAlwaysCompleteAnimation
        : covered
        ? _parentAnimation!
        : _animation;
    return _EntranceScope(
      animation: covered ? _parentAnimation! : _animation,
      faded: widget.fade || parentFaded,
      // Kare başına build yok: öteleme ve opaklık animasyonu render nesnesinde dinlenir.
      // Öteleme dışta, opaklık içte: opaklık katmanı yeniden boyanmadan kaydırılır.
      // Ağaç yapısı [fade]'den bağımsızdır (değişince alt ağacın State'i korunur).
      child: widget._sliver
          ? _SliverTranslate(
              animation: _animation,
              dy: RpMotion.enterOffset,
              child: SliverFadeTransition(
                opacity: opacity,
                sliver: widget.child,
              ),
            )
          : _Translate(
              animation: _animation,
              from: const Offset(0, RpMotion.enterOffset),
              child: FadeTransition(opacity: opacity, child: widget.child),
            ),
    );
  }
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

/// Tablet bölme geçişinin türü: [rise] telefondaki sayfa girişinin yükselişi
/// ([PageContentEntrance]: [RpMotion.enterOffset] aşağıdan yükseliş,
/// [RpMotion.enterDuration], [RpMotion.enterCurve]; modül değişimi, aynı türde kayıt seçimi,
/// aynı kaydı yeniden seçme), [push] `rpPush .38s` (36 px sağdan), [pop] `rpPop .38s` (36 px
/// soldan), eğri `cubic(.2,.8,.2,1)`.
enum NzPaneMotion { rise, push, pop }

/// Tablet bölmesine giren ekranın hareketi. Ağaç yapısı her zaman aynıdır (çocuğun State'i
/// korunur); [enabled] false iken (telefon, tek bölme) hareket yoktur ve içteki
/// [PageContentEntrance] kendi yükselişini oynatır. [enabled] iken oluşunca ve [play] her
/// değiştiğinde (null hariç) [motion] oynar; içteki [PageContentEntrance] bunu üst hareket
/// sayar (çift animasyon yok). Hareketi azalt → anlık.
///
/// Yalnız ötelemedir: bölmedeki ekranlar cam taşır (üst çubuk, yapışkan şerit, sohbet hapı,
/// çizelge sütunu); opaklık 0 → 1 içteki camsız [PageContentEntrance] katmanında bu hareketin
/// eğrisiyle oynar.
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
    faded: false,
    child: _Translate(
      animation: _animation,
      from: switch (_motion) {
        NzPaneMotion.rise => const Offset(0, RpMotion.enterOffset),
        NzPaneMotion.push => const Offset(RpMotion.pushOffset, 0),
        NzPaneMotion.pop => const Offset(-RpMotion.pushOffset, 0),
      },
      child: widget.child,
    ),
  );
}

class _EntranceScope extends InheritedWidget {
  const _EntranceScope({
    required this.animation,
    required this.faded,
    required super.child,
  });

  final Animation<double> animation;

  /// Bu kapsamın içeriği zaten soluyor mu (içteki giriş opaklığı ikiye katlamaz).
  final bool faded;

  @override
  bool updateShouldNotify(_EntranceScope oldWidget) =>
      animation != oldWidget.animation || faded != oldWidget.faded;
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
