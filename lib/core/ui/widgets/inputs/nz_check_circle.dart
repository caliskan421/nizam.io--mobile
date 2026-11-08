import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

/// Yuvarlak işaret (prototip gündem `.ag-chk` / `.ag-box`): 22 px daire, boşken 1,5 px soluk
/// kenar, işaretliyken vurgu ile soluk mürekkebin karışımı (zeytin ton) + onay. Dokunma alanı
/// 36 × [NizamioSize.tap]; basılınca kutu küçülür. Okuyucuda onay kutusudur ([label]); [onChanged] null →
/// salt okunur: kutu soluk çizilir, dokunuş varsa [onBlocked]'u çağırır (ör. nedenini bildiren
/// toast; sessiz kalan devre dışı kutu işaretlenemiyor sanılır).
class NzCheckCircle extends StatefulWidget {
  const NzCheckCircle({
    super.key,
    required this.value,
    required this.label,
    this.onChanged,
    this.onBlocked,
  });

  final bool value;
  final String label;
  final VoidCallback? onChanged;

  /// Salt okunurken dokunuş (yalnız [onChanged] null iken).
  final VoidCallback? onBlocked;

  @override
  State<NzCheckCircle> createState() => _NzCheckCircleState();
}

class _NzCheckCircleState extends State<NzCheckCircle> {
  var _down = false;

  void _press(bool v) {
    if (widget.onChanged != null && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = widget.value;
    final locked = widget.onChanged == null;
    return Semantics(
      checked: done,
      enabled: widget.onChanged != null,
      label: widget.label,
      onTap: widget.onChanged,
      excludeSemantics: true,
      child: InkResponse(
        onTap: widget.onChanged ?? widget.onBlocked,
        onTapDown: (_) => _press(true),
        onTapUp: (_) => _press(false),
        onTapCancel: () => _press(false),
        radius: 22,
        child: SizedBox(
          width: 36,
          height: NizamioSize.tap,
          child: Center(
            child: Opacity(
              opacity: locked ? .4 : 1,
              child: AnimatedScale(
                scale: _down ? .86 : 1,
                duration: NzMotion.of(context, NizamioMotion.durPress),
                curve: const Cubic(.34, 1.56, .64, 1),
                child: AnimatedContainer(
                  duration: NzMotion.of(
                    context,
                    const Duration(milliseconds: 250),
                  ),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? Color.lerp(c.primary, c.textFaint, .28)
                        : null,
                    border: done
                        ? null
                        : Border.all(color: c.textFaint, width: 1.5),
                  ),
                  child: done
                      ? NzIcon(NzIcons.check, size: 13, color: c.onPrimary)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
