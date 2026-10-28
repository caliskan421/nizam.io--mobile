import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

enum _SkeletonKind { text, block, list }

/// İçerik yer tutucusu (iskelet). Soluklaşma animasyonu; "hareketi azalt" açıksa durağan.
class NzSkeleton extends StatefulWidget {
  /// [lines] metin satırı; son satır kısa.
  const NzSkeleton.text({super.key, this.lines = 1})
    : height = null,
      count = 0,
      _kind = _SkeletonKind.text;

  /// Sabit yükseklikte blok (kart/görsel yeri). Genişlik üst kısıttan.
  const NzSkeleton.block({super.key, required this.height})
    : lines = 0,
      count = 0,
      _kind = _SkeletonKind.block;

  /// [count] adet liste satırı (avatar + iki satır).
  const NzSkeleton.list({super.key, this.count = 3})
    : lines = 0,
      height = null,
      _kind = _SkeletonKind.list;

  final int lines;
  final double? height;
  final int count;
  final _SkeletonKind _kind;

  @override
  State<NzSkeleton> createState() => _NzSkeletonState();
}

class _NzSkeletonState extends State<NzSkeleton>
    with SingleTickerProviderStateMixin {
  static const _period = Duration(milliseconds: 1200);
  static const _minOpacity = 0.5;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period,
  );
  late final Animation<double> _opacity = Tween<double>(
    begin: 1,
    end: _minOpacity,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.border;
    final shape = switch (widget._kind) {
      _SkeletonKind.text => _lines(color, widget.lines),
      _SkeletonKind.block => _bar(
        color,
        height: widget.height!,
        radius: NizamioRadius.tile,
      ),
      _SkeletonKind.list => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.count; i++) ...[
            if (i > 0) const Gap(NizamioSpacing.space4),
            Row(
              children: [
                Container(
                  width: NizamioSpacing.space10,
                  height: NizamioSpacing.space10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(child: _lines(color, 2)),
              ],
            ),
          ],
        ],
      ),
    };
    return Semantics(
      label: context.l10n.uiFeedbackLoading,
      excludeSemantics: true,
      child: FadeTransition(opacity: _opacity, child: shape),
    );
  }

  static const _lineHeight = NizamioSpacing.space3;
  static const _shortFactor = 0.6;

  Widget _lines(Color color, int n) => Column(
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

  Widget _bar(Color color, {required double height, required double radius}) =>
      Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
