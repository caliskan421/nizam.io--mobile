import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

enum _PillTone { neutral, warning, danger }

/// Sayaç kapsülü (çekmece ve menü satırı rozeti): dolu kapsül içinde mono sayı. [NzBadge]
/// durum etiketidir (çerçeveli, ton dolgulu); bu yalnız sayı taşır. Tonlar isimli yapıcıdır:
/// [NzCountPill.neutral] (okunmamış), [NzCountPill.warning] (onayda), [NzCountPill.danger]
/// (geciken). Dokunulamaz; okuyucuya sayı ve varsa [semanticLabel] okunur.
class NzCountPill extends StatelessWidget {
  const NzCountPill.neutral(this.count, {super.key, this.semanticLabel})
    : _tone = _PillTone.neutral;
  const NzCountPill.warning(this.count, {super.key, this.semanticLabel})
    : _tone = _PillTone.warning;
  const NzCountPill.danger(this.count, {super.key, this.semanticLabel})
    : _tone = _PillTone.danger;

  final int count;
  final String? semanticLabel;
  final _PillTone _tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, ink) = switch (_tone) {
      _PillTone.neutral => (c.surfaceOverlay, c.text),
      _PillTone.warning => (c.surfaceOverlay, c.warning),
      _PillTone.danger => (c.danger, c.onDanger),
    };
    return Semantics(
      container: true,
      label: [?semanticLabel, '$count'].join(' '),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(NizamioRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space2,
            vertical: NizamioSpacing.space1 / 2,
          ),
          child: Text(
            '$count',
            style: context.text.monoSm.copyWith(
              color: ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
