import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
import 'nz_count_pill.dart';

/// Akış bölümü başlığı (prototip ana sayfa "Onay bekleyenler 3 · Tümü ›"): kalın başlık,
/// isteğe bağlı gri sayı kapsülü ([count]) ve sağda "Tümü ›" bağlantısı ([onAll] verilirse).
/// [NzKicker] küçük mono etikettir; bu, bölüm başlığıdır.
class NzSectionHeader extends StatelessWidget {
  const NzSectionHeader(
    this.title, {
    super.key,
    this.count,
    this.onAll,
    this.allLabel,
  }) : assert(onAll == null || allLabel != null, 'onAll için allLabel gerekir');

  final String title;
  final int? count;
  final VoidCallback? onAll;
  final String? allLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final count = this.count;
    final onAll = this.onAll;
    return Row(
      children: [
        // Başlık + sayı kalan genişliği alır; "Tümü ›" doğal genişliğinde (başlık yarıda
        // kesilmez).
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleSm.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              if (count != null) ...[
                const Gap(NizamioSpacing.space2),
                NzCountPill.neutral(count),
              ],
            ],
          ),
        ),
        if (onAll != null)
          Semantics(
            button: true,
            label: allLabel,
            excludeSemantics: true,
            onTap: onAll,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onAll,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: NizamioSize.controlMd,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      allLabel!,
                      style: t.bodySm.copyWith(color: c.textMuted),
                    ),
                    NzIcon(
                      NzIcons.chevronRight,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
