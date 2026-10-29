import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

/// Küçük harfli mono bölüm etiketi (`m-kicker`, ör. `tüm görevler · 76`) + isteğe bağlı sağ
/// açıklama ([trailing], caption) ya da sağ eylem ([action], ör. sıralama düğmesi). Etiket
/// okuyucuya başlık olarak bildirilir. [emphasis] etiketi `ink` yapar (liste başlığı).
class NzKicker extends StatelessWidget {
  const NzKicker(
    this.label, {
    super.key,
    this.trailing,
    this.action,
    this.emphasis = false,
  }) : assert(
         trailing == null || action == null,
         'trailing ve action birlikte verilmez',
       );

  final String label;
  final String? trailing;
  final Widget? action;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final trailing = this.trailing;
    final action = this.action;
    final kicker = Semantics(
      header: true,
      child: Text(
        label,
        style: context.text.kicker.copyWith(
          color: emphasis ? c.text : c.textMuted,
        ),
      ),
    );
    if (action != null) {
      return Row(
        children: [
          Expanded(child: kicker),
          const Gap(NizamioSpacing.space3),
          action,
        ],
      );
    }
    // İki gevşek esnek öğe + spaceBetween: açıklama sağ kenara yaslanır, ikisi de uzunsa yarı
    // yarıya sarılır (Flexible + Expanded boşluğu yarıya bölüp açıklamayı ortada bırakıyordu).
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(child: kicker),
        if (trailing != null) ...[
          const Gap(NizamioSpacing.space3),
          Flexible(
            child: Text(
              trailing,
              textAlign: TextAlign.end,
              style: context.text.caption.copyWith(color: c.textMuted),
            ),
          ),
        ],
      ],
    );
  }
}
