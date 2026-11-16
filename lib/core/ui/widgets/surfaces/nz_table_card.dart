import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import 'nz_card.dart';

/// Tablo kartı (prototip ana sayfa "Görev | Bitiş"): isteğe bağlı başlık şeridi (sol ve sağ
/// sütun adı, gri zemin) ve aralarında ince ayraçlı satırlar. Satırlar kendi dolgusunu taşır
/// (ör. `NzQueueRow(flat: true)`).
class NzTableCard extends StatelessWidget {
  const NzTableCard({
    super.key,
    required this.children,
    this.leading,
    this.trailing,
  });

  final List<Widget> children;

  /// Başlık şeridinin sol / sağ sütun adı; ikisi de null → şerit yok.
  final String? leading;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final hasHead = leading != null || trailing != null;
    final divider = Divider(
      height: NizamioSize.borderWidth,
      thickness: NizamioSize.borderWidth,
      color: c.border,
    );
    return NzCard.outlined(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NizamioRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasHead)
              ExcludeSemantics(
                child: ColoredBox(
                  color: c.surfaceOverlay,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NizamioSpacing.space4,
                      vertical: NizamioSpacing.space3,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            leading ?? '',
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                        ),
                        Text(
                          trailing ?? '',
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            for (final (i, w) in children.indexed) ...[if (i > 0) divider, w],
          ],
        ),
      ),
    );
  }
}
