import 'package:flutter/widgets.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../theme/nz_motion.dart';

/// Yerinde açılan içerik (prototip `grid-template-rows: 0fr → 1fr`, bundle.css `.m-acc` /
/// `.m-reveal`): [open] değişince yükseklik `easeSheet` / `durSheet` ile açılır; kapanış
/// aynı süre ve eğrinin aynasıdır (hızlı başlar, yavaşça oturur — açılışla simetrik; düz
/// ters eğri kapanışı ağır başlatıp "yavaş" gösteriyordu). İçerik kırpılır. Kapalıyken
/// [child] ağaçta yoktur (odak/okuyucu gizli içeriğe gitmez). Hareketi azalt → anlık.
class NzReveal extends StatefulWidget {
  const NzReveal({
    super.key,
    required this.open,
    required this.child,
    this.onOpened,
  });

  final bool open;
  final Widget child;

  /// Açılış hareketi tamamlanınca bir kez (ör. arama alanına odak: klavye ilk karede değil,
  /// alan yerine oturunca açılır). Açılış yarıda kapatılırsa çağrılmaz.
  final VoidCallback? onOpened;

  @override
  State<NzReveal> createState() => _NzRevealState();
}

class _NzRevealState extends State<NzReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    value: widget.open ? 1 : 0,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _c,
    curve: NizamioMotion.easeSheet,
    reverseCurve: NizamioMotion.easeSheet.flipped,
  );

  @override
  void didUpdateWidget(NzReveal old) {
    super.didUpdateWidget(old);
    if (old.open == widget.open) return;
    _c.duration = NzMotion.of(context, NizamioMotion.durSheet);
    if (widget.open) {
      _c.forward().then((_) {
        if (mounted && widget.open) widget.onOpened?.call();
      });
    } else {
      _c.reverse();
    }
  }

  @override
  void dispose() {
    _curve.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _curve,
    builder: (context, child) {
      if (_c.isDismissed) return const SizedBox.shrink();
      return ClipRect(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          heightFactor: _curve.value,
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}
