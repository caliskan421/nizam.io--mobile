import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_button.dart';
import '../nz_size.dart';
import '../surfaces/nz_card.dart';

/// Onay kuyruğu satırı (prototip ana sayfa "Onay bekleyenler" ve `revq`): başlık, alt bilgi,
/// sağda bitiş/gecikme metni; altta **İade et** ve **Onayla**. Satıra dokunma ayrıntıyı açar.
/// Telefonda ve tabletin liste/ayrıntı bölmesinde aynı bileşen.
class NzQueueRow extends StatelessWidget {
  const NzQueueRow({
    super.key,
    required this.title,
    required this.returnLabel,
    required this.approveLabel,
    this.meta,
    this.dueText,
    this.dueDanger = false,
    this.onTap,
    this.onReturn,
    this.onApprove,
  });

  final String title;

  /// Alt satır (koordinatörlük, alt görev ilerlemesi vb.).
  final String? meta;

  /// Sağdaki bitiş metni ("3 gün geç", "bugün").
  final String? dueText;

  /// Bitiş metni gecikme rengiyle.
  final bool dueDanger;
  final String returnLabel;
  final String approveLabel;
  final VoidCallback? onTap;

  /// null → düğme pasif (uçuşta ya da yetki yok).
  final VoidCallback? onReturn;
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) => _ActionRow(
    title: title,
    meta: meta,
    trailing: dueText,
    trailingDanger: dueDanger,
    onTap: onTap,
    secondary: NzButton.secondary(
      label: returnLabel,
      size: NzSize.sm,
      expand: true,
      onPressed: onReturn,
    ),
    primary: NzButton.primary(
      label: approveLabel,
      size: NzSize.sm,
      expand: true,
      onPressed: onApprove,
    ),
  );
}

/// Atanmamış görev satırı (prototip ana sayfa "Atanmamış" ve görev listesi): başlık, alt
/// bilgi, [badge] (ör. bağımlılık kilidi), "Sorumlu bekliyor" ([waitingLabel]); altta
/// **Üstlen** ve **Ata**.
class NzUnassignedRow extends StatelessWidget {
  const NzUnassignedRow({
    super.key,
    required this.title,
    required this.claimLabel,
    required this.assignLabel,
    this.meta,
    this.waitingLabel,
    this.badge,
    this.onTap,
    this.onClaim,
    this.onAssign,
  });

  final String title;
  final String? meta;
  final String? waitingLabel;
  final Widget? badge;
  final String claimLabel;
  final String assignLabel;
  final VoidCallback? onTap;

  /// null → düğme gizli (yetki yok).
  final VoidCallback? onClaim;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) => _ActionRow(
    title: title,
    meta: meta,
    trailing: waitingLabel,
    badge: badge,
    onTap: onTap,
    secondary: onAssign == null
        ? null
        : NzButton.secondary(
            label: assignLabel,
            size: NzSize.sm,
            expand: true,
            onPressed: onAssign,
          ),
    primary: onClaim == null
        ? null
        : NzButton.primary(
            label: claimLabel,
            size: NzSize.sm,
            expand: true,
            onPressed: onClaim,
          ),
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.title,
    required this.meta,
    required this.trailing,
    required this.onTap,
    required this.secondary,
    required this.primary,
    this.trailingDanger = false,
    this.badge,
  });

  final String title;
  final String? meta;
  final String? trailing;
  final bool trailingDanger;
  final Widget? badge;
  final VoidCallback? onTap;
  final Widget? secondary;
  final Widget? primary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final meta = this.meta;
    final trailing = this.trailing;
    final badge = this.badge;
    final buttons = [?secondary, ?primary];
    return NzCard.outlined(
      size: NzSize.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: onTap != null,
            onTap: onTap,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: t.list.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (trailing != null) ...[
                        const Gap(NizamioSpacing.space2),
                        Text(
                          trailing,
                          style: t.caption.copyWith(
                            color: trailingDanger ? c.danger : c.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (meta != null || badge != null) ...[
                    const Gap(NizamioSpacing.space1),
                    Row(
                      children: [
                        if (badge != null) ...[
                          badge,
                          const Gap(NizamioSpacing.space2),
                        ],
                        if (meta != null)
                          Expanded(
                            child: Text(
                              meta,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.caption.copyWith(color: c.textMuted),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (buttons.isNotEmpty) ...[
            const Gap(NizamioSpacing.space3),
            Row(
              spacing: NizamioSpacing.space2,
              children: [for (final b in buttons) Expanded(child: b)],
            ),
          ],
        ],
      ),
    );
  }
}
