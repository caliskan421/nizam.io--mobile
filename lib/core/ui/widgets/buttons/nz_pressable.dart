import 'package:flutter/widgets.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../theme/nz_motion.dart';

/// Basma geri bildirimi (README "Hareket · Basma"): parmak değdiği sürece [scale]'e küçülür,
/// bırakınca döner; süre/eğri `NizamioMotion`. Yalnız görseldir — dokunma, odak ve anlam
/// sarılan widget'tadır ([Listener] jest yarışına girmez). Hareketi azalt açıkken anlık.
class NzPressable extends StatefulWidget {
  const NzPressable({
    super.key,
    required this.child,
    this.enabled = true,
    this.scale = NizamioMotion.pressButton,
  });

  /// Kart ölçeği (`.985`).
  const NzPressable.card({super.key, required this.child, this.enabled = true})
    : scale = NizamioMotion.pressCard;

  final Widget child;
  final bool enabled;
  final double scale;

  @override
  State<NzPressable> createState() => _NzPressableState();
}

class _NzPressableState extends State<NzPressable> {
  var _down = false;

  void _set(bool down) {
    if (_down != down && mounted) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: widget.enabled ? (_) => _set(true) : null,
    onPointerUp: (_) => _set(false),
    onPointerCancel: (_) => _set(false),
    child: AnimatedScale(
      scale: _down && widget.enabled ? widget.scale : 1,
      duration: NzMotion.of(context, NizamioMotion.durPress),
      curve: NizamioMotion.easeOut,
      child: widget.child,
    ),
  );
}
