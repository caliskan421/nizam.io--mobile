import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_button.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

/// Karar bloğu (prototip görev ayrıntısı `kd`): onay bekleyen kaydın üstünde başlık, özet
/// satırı, isteğe bağlı uyarı ([warning]), **İade et** / **Onayla** ve alt not. Uyarı tonlu
/// çerçeveli kart; düğmeler eşit genişlikte.
class NzDecisionBlock extends StatelessWidget {
  const NzDecisionBlock({
    super.key,
    required this.title,
    required this.returnLabel,
    required this.approveLabel,
    this.summary,
    this.warning,
    this.footnote,
    this.onReturn,
    this.onApprove,
  });

  final String title;
  final String? summary;

  /// Kırmızı uyarı satırı (ör. "Kanıt dosyası yüklenmemiş").
  final String? warning;
  final String? footnote;
  final String returnLabel;
  final String approveLabel;

  /// null → düğme pasif.
  final VoidCallback? onReturn;
  final VoidCallback? onApprove;

  static const _tint = 0.08;
  static const _edge = 0.4;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final summary = this.summary;
    final warning = this.warning;
    final footnote = this.footnote;
    return Semantics(
      container: true,
      label: title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.warning.withValues(alpha: _tint),
          borderRadius: BorderRadius.circular(NizamioRadius.card),
          border: Border.all(
            color: c.warning.withValues(alpha: _edge),
            width: NizamioSize.borderWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(NizamioSpacing.rowPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  NzIcon(
                    NzIcons.clock,
                    size: NizamioSize.iconSizeSm,
                    color: c.warning,
                  ),
                  const Gap(NizamioSpacing.space2),
                  Expanded(
                    child: Text(
                      title,
                      style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              if (summary != null) ...[
                const Gap(NizamioSpacing.space1),
                Text(summary, style: t.caption.copyWith(color: c.textMuted)),
              ],
              if (warning != null) ...[
                const Gap(NizamioSpacing.space2),
                Text(warning, style: t.caption.copyWith(color: c.danger)),
              ],
              const Gap(NizamioSpacing.space3),
              Row(
                spacing: NizamioSpacing.space2,
                children: [
                  Expanded(
                    child: NzButton.secondary(
                      label: returnLabel,
                      expand: true,
                      onPressed: onReturn,
                    ),
                  ),
                  Expanded(
                    child: NzButton.primary(
                      label: approveLabel,
                      expand: true,
                      onPressed: onApprove,
                    ),
                  ),
                ],
              ),
              if (footnote != null) ...[
                const Gap(NizamioSpacing.space2),
                Text(footnote, style: t.caption.copyWith(color: c.textMuted)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
