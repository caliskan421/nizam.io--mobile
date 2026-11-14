import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_button.dart';
import '../buttons/nz_icon_button.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
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
    this.subtitle,
    this.dueText,
    this.dueDate,
    this.dueDanger = false,
    this.flat = false,
    this.inline = false,
    this.onTap,
    this.onReturn,
    this.onApprove,
  });

  final String title;

  /// Alt satır (koordinatörlük, alt görev ilerlemesi vb.).
  final String? meta;

  /// Başlığın hemen altında gri metin (ör. koordinatörlük adı); null → yok.
  final String? subtitle;

  /// Sağdaki bitiş metni ("3 gün geç", "bugün").
  final String? dueText;

  /// Sağ üstte kalın bitiş tarihi ("30 Eyl"; yalnız [flat]).
  final String? dueDate;

  /// Bitiş metni gecikme rengiyle.
  final bool dueDanger;

  /// true → kartsız tablo satırı ([NzTableCard] içinde): düğmeler alt satırın sağında, dar.
  final bool flat;

  /// [flat] ve geniş: tek çizgi (başlık solda, bitiş ortada, düğmeler sağda). false → dar:
  /// başlık üstte, altta bitiş hapı solda ve düğmeler sağda.
  final bool inline;
  final String returnLabel;
  final String approveLabel;
  final VoidCallback? onTap;

  /// null → düğme pasif (uçuşta ya da yetki yok).
  final VoidCallback? onReturn;
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    if (flat) {
      return _QueueFlatRow(
        title: title,
        caption: [?subtitle, ?meta].join(' · '),
        dueDate: dueDate,
        dueText: dueText,
        dueDanger: dueDanger,
        inline: inline,
        onTap: onTap,
        buttons: [
          NzButton.secondary(
            label: returnLabel,
            size: NzSize.sm,
            onPressed: onReturn,
          ),
          NzButton.primary(
            label: approveLabel,
            size: NzSize.sm,
            icon: NzIcons.check,
            onPressed: onApprove,
          ),
        ],
      );
    }
    return _ActionRow(
      title: title,
      subtitle: subtitle,
      meta: meta,
      trailing: dueText,
      trailingTitle: flat ? dueDate : null,
      trailingDanger: dueDanger,
      flat: flat,
      onTap: onTap,
      secondary: NzButton.secondary(
        label: returnLabel,
        size: NzSize.sm,
        expand: !flat,
        onPressed: onReturn,
      ),
      primary: NzButton.primary(
        label: approveLabel,
        size: NzSize.sm,
        icon: flat ? NzIcons.check : null,
        expand: !flat,
        onPressed: onApprove,
      ),
    );
  }
}

/// Onay kuyruğunun tablo (flat) satırı. [inline] (geniş): başlık + gri alt satır solda, bitiş
/// tarihi ve kalan/geçen gün ortada (ortalı), düğmeler sağda; sol altta boşluk kalmaz. Dar:
/// başlık tam genişlikte, altında bitiş hapı (tarih · kalan gün; gecikmede kırmızı zemin) solda
/// ve düğmeler sağda.
class _QueueFlatRow extends StatelessWidget {
  const _QueueFlatRow({
    required this.title,
    required this.caption,
    required this.dueDate,
    required this.dueText,
    required this.dueDanger,
    required this.inline,
    required this.onTap,
    required this.buttons,
  });

  final String title;
  final String caption;
  final String? dueDate;
  final String? dueText;
  final bool dueDanger;
  final bool inline;
  final VoidCallback? onTap;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final tone = dueDanger ? c.danger : c.textMuted;
    final head = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: t.list.copyWith(fontWeight: FontWeight.w600),
        ),
        if (caption.isNotEmpty)
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.caption.copyWith(color: c.textMuted),
          ),
      ],
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, b) in buttons.indexed) ...[
          if (i > 0) const Gap(NizamioSpacing.space2),
          b,
        ],
      ],
    );
    Widget tappable(Widget child) => Semantics(
      button: onTap != null,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ),
    );
    final pad = const EdgeInsets.symmetric(
      horizontal: NizamioSpacing.space4,
      vertical: NizamioSpacing.space3,
    );
    if (inline) {
      return Padding(
        padding: pad,
        child: Row(
          children: [
            Expanded(flex: 5, child: tappable(head)),
            Expanded(
              flex: 3,
              child: tappable(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dueDate != null)
                      Text(
                        dueDate!,
                        style: t.list.copyWith(fontWeight: FontWeight.w600),
                      ),
                    if (dueText != null)
                      Text(dueText!, style: t.caption.copyWith(color: tone)),
                  ],
                ),
              ),
            ),
            actions,
          ],
        ),
      );
    }
    final pill = dueDate == null && dueText == null
        ? null
        : DecoratedBox(
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space3,
                vertical: NizamioSpacing.space1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NzIcon(NzIcons.calendar, size: 14, color: tone),
                  const Gap(NizamioSpacing.space2),
                  Flexible(
                    child: Text(
                      [?dueDate, ?dueText].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(
                        color: dueDanger ? c.danger : c.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
    return Padding(
      padding: pad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tappable(head),
          const Gap(NizamioSpacing.space3),
          Row(
            children: [
              Flexible(child: pill ?? const SizedBox.shrink()),
              const Spacer(),
              actions,
            ],
          ),
        ],
      ),
    );
  }
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
    this.flat = false,
    this.onTap,
    this.onClaim,
    this.onAssign,
  });

  final String title;
  final String? meta;
  final String? waitingLabel;

  /// true → kartsız tablo satırı: sağda **Üstlen** ve atama ikon düğmesi.
  final bool flat;
  final Widget? badge;
  final String claimLabel;
  final String assignLabel;
  final VoidCallback? onTap;

  /// null → düğme gizli (yetki yok).
  final VoidCallback? onClaim;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    final claim = onClaim;
    final assign = onAssign;
    if (flat) {
      return _ActionRow(
        title: title,
        meta: meta,
        trailing: null,
        badge: badge,
        flat: true,
        onTap: onTap,
        secondary: claim == null
            ? null
            : NzButton.secondary(
                label: claimLabel,
                size: NzSize.sm,
                onPressed: claim,
              ),
        primary: assign == null
            ? null
            : NzIconButton.circle(
                icon: NzIcons.personAdd,
                semanticLabel: assignLabel,
                onPressed: assign,
              ),
      );
    }
    return _ActionRow(
      title: title,
      meta: meta,
      trailing: waitingLabel,
      badge: badge,
      onTap: onTap,
      secondary: assign == null
          ? null
          : NzButton.secondary(
              label: assignLabel,
              size: NzSize.sm,
              expand: true,
              onPressed: assign,
            ),
      primary: claim == null
          ? null
          : NzButton.primary(
              label: claimLabel,
              size: NzSize.sm,
              expand: true,
              onPressed: claim,
            ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.title,
    required this.meta,
    required this.trailing,
    this.subtitle,
    required this.onTap,
    required this.secondary,
    required this.primary,
    this.trailingTitle,
    this.trailingDanger = false,
    this.flat = false,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final String? meta;
  final String? trailing;
  final String? trailingTitle;
  final bool trailingDanger;
  final bool flat;
  final Widget? badge;
  final VoidCallback? onTap;
  final Widget? secondary;
  final Widget? primary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final meta = this.meta;
    final subtitle = this.subtitle;
    final trailing = this.trailing;
    final trailingTitle = this.trailingTitle;
    final badge = this.badge;
    final buttons = [?secondary, ?primary];
    final metaRow = meta != null || badge != null
        ? Row(
            children: [
              if (badge != null) ...[badge, const Gap(NizamioSpacing.space2)],
              if (meta != null)
                Expanded(
                  child: Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (flat ? t.monoSm : t.caption).copyWith(
                      color: c.textMuted,
                    ),
                  ),
                ),
            ],
          )
        : null;
    final head = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.list.copyWith(fontWeight: FontWeight.w600),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.caption.copyWith(color: c.textMuted),
                ),
            ],
          ),
        ),
        if (trailing != null || trailingTitle != null) ...[
          const Gap(NizamioSpacing.space2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (trailingTitle != null)
                Text(
                  trailingTitle,
                  style: t.list.copyWith(fontWeight: FontWeight.w600),
                ),
              if (trailing != null)
                Text(
                  trailing,
                  style: t.caption.copyWith(
                    color: trailingDanger ? c.danger : c.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
    Widget tappable(Widget child) => Semantics(
      button: onTap != null,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ),
    );
    if (flat) {
      // Tablo satırı: başlık + bitiş; alt satırda kod solda, düğmeler sağda.
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space4,
          vertical: NizamioSpacing.space3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            tappable(head),
            const Gap(NizamioSpacing.space2),
            Row(
              children: [
                Expanded(child: tappable(metaRow ?? const SizedBox.shrink())),
                for (final b in buttons) ...[
                  const Gap(NizamioSpacing.space2),
                  b,
                ],
              ],
            ),
          ],
        ),
      );
    }
    return NzCard.outlined(
      size: NzSize.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tappable(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                head,
                if (metaRow != null) ...[
                  const Gap(NizamioSpacing.space1),
                  metaRow,
                ],
              ],
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
