import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';
import 'nz_avatar.dart';

/// Üst üste avatar yığını (prototip `.rp-avstack`): her avatar bir öncekinin üstüne 8 px biner,
/// çevresinde 2 px yüzey halkası ([ring], varsayılan `bg-surface`; kart üstünde ayırır). [max]'tan
/// fazlası "+N" nötr dairesiyle özetlenir. Okuyucuda tek düğüm: [semanticLabel] ya da adlar.
/// [colored] → kişi başına kararlı avatar rengi (`NzAvatar.toneOf`), değilse nötr.
class NzAvatarStack extends StatelessWidget {
  const NzAvatarStack({
    super.key,
    required this.names,
    this.max = 3,
    this.extent = NzAvatarSize.sm,
    this.colored = false,
    this.ring,
    this.semanticLabel,
  }) : assert(max >= 1, 'max >= 1');

  final List<String> names;
  final int max;
  final NzAvatarSize extent;
  final bool colored;
  final Color? ring;
  final String? semanticLabel;

  // Prototip: `margin-left: -8px`, `box-shadow: 0 0 0 2px var(--bg-surface)`.
  static const overlap = 8.0;
  static const ringWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final ringColor = ring ?? context.colors.surface;
    final shown = names.length > max ? max - 1 : names.length;
    final extra = names.length - shown;
    final d = extent.diameter;
    final items = <Widget>[
      for (var i = 0; i < shown; i++)
        NzAvatar.initials(
          name: names[i],
          extent: extent,
          tone: colored ? NzAvatar.toneOf(names[i]) : NzAvatar.neutralTone,
        ),
      if (extra > 0) _More(count: extra, extent: extent),
    ];
    final step = d - overlap;
    final width = items.isEmpty ? 0.0 : d + step * (items.length - 1);
    return Semantics(
      container: true,
      label: semanticLabel ?? names.join(', '),
      excludeSemantics: true,
      child: SizedBox(
        width: width + 2 * ringWidth,
        height: d + 2 * ringWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < items.length; i++)
              PositionedDirectional(
                start: i * step,
                top: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ringColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(ringWidth),
                    child: items[i],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _More extends StatelessWidget {
  const _More({required this.count, required this.extent});

  final int count;
  final NzAvatarSize extent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox.square(
      dimension: extent.diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceOverlay,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '+$count',
              maxLines: 1,
              style: context.text.monoSm.copyWith(color: c.text),
            ),
          ),
        ),
      ),
    );
  }
}
