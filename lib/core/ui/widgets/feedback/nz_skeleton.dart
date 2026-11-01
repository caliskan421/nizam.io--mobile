import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';

/// Parıltı (shimmer) kapsamı: altındaki iskelet şekillerinin üstünden soldan sağa açık bir
/// bant geçer. Bir sayfa iskeletinin bütün şekilleri tek kapsamda aynı bantla parlar (her
/// şekil kendi animasyonunu kurmaz). "Hareketi azalt" açıkken durağandır (yalnız taban rengi).
///
/// Şekiller taban renginde ([NzShimmer.baseOf]) çizilir; bant yalnız şekillerin üstüne düşer
/// (`BlendMode.srcATop`). Animasyonun ilk karesinde bant görünür alanın dışındadır.
/// Ekran okuyucuya tek "yükleniyor" etiketi verir; alt ağacın anlamı dışlanır.
class NzShimmer extends StatefulWidget {
  const NzShimmer({super.key, required this.child, this.semanticLabel});

  final Widget child;

  /// null → `ui.feedback.loading`.
  final String? semanticLabel;

  /// Bandın bir geçişi.
  static const period = Duration(milliseconds: 1500);

  /// İskelet şekillerinin taban rengi (kenarlık rolü).
  static Color baseOf(BuildContext context) => context.colors.border;

  /// Bandın rengi: açık temada yüzey (beyaza yakın), koyuda güçlü kenarlık (tabandan açık).
  static Color highlightOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? context.colors.borderStrong
      : context.colors.surface;

  /// [context] bir parıltı kapsamının içinde mi (iç içe kapsam kurulmaz).
  static bool isActive(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_ShimmerScope>() != null;

  @override
  State<NzShimmer> createState() => _NzShimmerState();
}

class _NzShimmerState extends State<NzShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: NzShimmer.period,
  );

  bool _reduced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = NzMotion.reduced(context);
    if (_reduced) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _ShimmerScope(child: widget.child);
    final Widget painted;
    if (_reduced) {
      painted = child;
    } else {
      final base = NzShimmer.baseOf(context);
      final highlight = NzShimmer.highlightOf(context);
      painted = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            colors: [base, highlight, base],
            stops: const [0.35, 0.5, 0.65],
            transform: _SweepTransform(_controller.value),
          ).createShader(bounds),
          child: child,
        ),
        child: child,
      );
    }
    return Semantics(
      label: widget.semanticLabel ?? context.l10n.uiFeedbackLoading,
      excludeSemantics: true,
      child: painted,
    );
  }
}

/// Bandı yatayda kaydırır: t = 0'da bant solda dışarıda, t = 1'de sağda dışarıda.
class _SweepTransform extends GradientTransform {
  const _SweepTransform(this.t);

  final double t;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (2 * t - 1), 0, 0);
}

class _ShimmerScope extends InheritedWidget {
  const _ShimmerScope({required super.child});

  @override
  bool updateShouldNotify(_ShimmerScope old) => false;
}

enum _SkeletonKind { text, block, circle, list, page }

/// İçerik yer tutucusu (iskelet). Bir [NzShimmer] içindeyse yalnız şekli çizer (kapsamın
/// bandıyla parlar); değilse kendi kapsamını kurar. Ekrana özgü iskeletler bu şekillerden
/// tek bir [NzShimmer] altında kurulur (ör. ana sayfa: karşılama, 2×2 özet, kartlar).
class NzSkeleton extends StatelessWidget {
  /// [lines] metin satırı; son satır kısa.
  const NzSkeleton.text({super.key, this.lines = 1})
    : height = null,
      width = null,
      radius = null,
      count = 0,
      _kind = _SkeletonKind.text;

  /// Sabit yükseklikte blok (kart/görsel yeri). Genişlik [width] ya da üst kısıttan;
  /// köşe [radius] ya da `radius-tile`.
  const NzSkeleton.block({
    super.key,
    required this.height,
    this.width,
    this.radius,
  }) : lines = 0,
       count = 0,
       _kind = _SkeletonKind.block;

  /// [size] çaplı daire (avatar/simge yeri).
  const NzSkeleton.circle({super.key, required double size})
    : height = size,
      width = size,
      lines = 0,
      radius = null,
      count = 0,
      _kind = _SkeletonKind.circle;

  /// [count] adet liste satırı (avatar + iki satır).
  const NzSkeleton.list({super.key, this.count = 3})
    : lines = 0,
      height = null,
      width = null,
      radius = null,
      _kind = _SkeletonKind.list;

  /// Genel sayfa iskeleti (ekrana özgü iskelet verilmediğinde `NzAsyncView` varsayılanı):
  /// başlık satırı, kart bloğu, liste satırları.
  const NzSkeleton.page({super.key})
    : lines = 0,
      height = null,
      width = null,
      radius = null,
      count = 0,
      _kind = _SkeletonKind.page;

  final int lines;
  final double? height;
  final double? width;
  final double? radius;
  final int count;
  final _SkeletonKind _kind;

  static const _lineHeight = NizamioSpacing.space3;
  static const _shortFactor = 0.6;
  static const _pageCardHeight = NizamioSpacing.space12 * 2;

  @override
  Widget build(BuildContext context) {
    final color = NzShimmer.baseOf(context);
    final shape = switch (_kind) {
      _SkeletonKind.text => _lines(color, lines),
      _SkeletonKind.block => _bar(
        color,
        height: height!,
        width: width,
        radius: radius ?? NizamioRadius.tile,
      ),
      _SkeletonKind.circle => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      _SkeletonKind.list => _list(color, count),
      _SkeletonKind.page => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FractionallySizedBox(
            widthFactor: _shortFactor,
            child: _bar(
              color,
              height: NizamioSpacing.space6,
              radius: NizamioRadius.pill,
            ),
          ),
          const Gap(NizamioSpacing.gapXl),
          _bar(color, height: _pageCardHeight, radius: NizamioRadius.card),
          const Gap(NizamioSpacing.gapXl),
          _list(color, 4),
        ],
      ),
    };
    if (NzShimmer.isActive(context)) return shape;
    return NzShimmer(child: shape);
  }

  static Widget _list(Color color, int n) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < n; i++) ...[
        if (i > 0) const Gap(NizamioSpacing.space4),
        Row(
          children: [
            Container(
              width: NizamioSpacing.space10,
              height: NizamioSpacing.space10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const Gap(NizamioSpacing.space3),
            Expanded(child: _lines(color, 2)),
          ],
        ),
      ],
    ],
  );

  static Widget _lines(Color color, int n) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < n; i++) ...[
        if (i > 0) const Gap(NizamioSpacing.space2),
        if (n > 1 && i == n - 1)
          FractionallySizedBox(
            widthFactor: _shortFactor,
            child: _bar(color, height: _lineHeight, radius: NizamioRadius.pill),
          )
        else
          _bar(color, height: _lineHeight, radius: NizamioRadius.pill),
      ],
    ],
  );

  static Widget _bar(
    Color color, {
    required double height,
    required double radius,
    double? width,
  }) => Container(
    width: width ?? double.infinity,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
