import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../domain/coordinatorship_board.dart';
import 'coord_detail_texts.dart';
import 'coord_widgets.dart';

/// Prototipin geniş düzen eşiği (`@container cd (min-width: 560px)`).
const coordWideWidth = 560.0;

/// Bölüm kartı yüzeyi: ortak kenarlı kart ([NzCard.outlined], özet kartlarıyla aynı yüzey);
/// satır vurguları köşelere taşmasın diye içerik kırpılır.
class CoordPanel extends StatelessWidget {
  const CoordPanel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => NzCard.outlined(
    padding: EdgeInsets.zero,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(NizamioRadius.card),
      child: Padding(padding: padding, child: child),
    ),
  );
}

/// Kenarlı satır grubu: satırlar arasında ince ayraç.
class CoordRows extends StatelessWidget {
  const CoordRows({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CoordPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const CoordRowDivider(),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// [CoordRows] satır ayracı (açılır ek satırlarda da aynı çizgi).
class CoordRowDivider extends StatelessWidget {
  const CoordRowDivider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
    height: NizamioSize.borderWidth,
    thickness: NizamioSize.borderWidth,
    indent: NizamioSpacing.rowPad,
    color: context.colors.border,
  );
}

/// Başlıklı blok: soluk mono başlık + içerik (prototip `.cd-blk` + `.cd-k`).
class CoordBlock extends StatelessWidget {
  const CoordBlock({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [NzKicker(label), const Gap(NizamioSpacing.space2), child],
  );
}

/// Bölüm üst satırı: solda sayım metni, sağda daire düğmeler (prototip `.cd-subhead`).
class CoordSubhead extends StatelessWidget {
  const CoordSubhead({super.key, required this.label, this.actions = const []});

  final Widget label;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Gap(NizamioSpacing.space1),
      Expanded(child: label),
      ...actions,
    ],
  );
}

/// Dokunulabilir liste satırı: öncü öğe, ana/alt metin, sağda sayı ve ok.
class CoordListRow extends StatelessWidget {
  const CoordListRow({
    super.key,
    required this.title,
    required this.onTap,
    this.leading,
    this.subtitle,
    this.subtitleColor,
    this.titleColor,
    this.trailing,
    this.chevron = true,
  });

  final String title;
  final VoidCallback onTap;
  final Widget? leading;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? titleColor;
  final String? trailing;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return CoordRow(
      onTap: onTap,
      semanticLabel: [title, ?subtitle, ?trailing].join(', '),
      minHeight: 58,
      child: Row(
        children: [
          if (leading case final l?) ...[l, const Gap(NizamioSpacing.space3)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.labelLg.copyWith(
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                if (subtitle case final s?)
                  Text(
                    s,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.caption.copyWith(
                      color: subtitleColor ?? c.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing case final n?) ...[
            const Gap(NizamioSpacing.space2),
            Text(n, style: t.monoSm.copyWith(color: c.textMuted)),
          ],
          if (chevron) ...[
            const Gap(NizamioSpacing.space2),
            NzIcon(
              NzIcons.chevronRight,
              size: NizamioSize.iconSizeSm,
              color: c.textFaint,
            ),
          ],
        ],
      ),
    );
  }
}

/// Kişi satırı (avatar + ad + açık/geciken).
class CoordPersonRow extends StatelessWidget {
  const CoordPersonRow({super.key, required this.person, required this.onTap});

  final CoordPerson person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = person;
    return CoordListRow(
      leading: NzAvatar.initials(name: p.name, extent: NzAvatarSize.md),
      title: p.name,
      subtitle: l.coordPersonSub(p),
      subtitleColor: p.late > 0 ? context.colors.danger : null,
      trailing: p.open > 0 ? '${p.open}' : null,
      onTap: onTap,
    );
  }
}

/// Dosya türü kutucuğu (prototip `.cd-kind`).
class CoordKindTile extends StatelessWidget {
  const CoordKindTile({super.key, required this.kind, this.large = false});

  final CoordFileKind kind;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final side = large ? 56.0 : 38.0;
    return Container(
      width: side,
      height: side,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(large ? 16 : 11),
      ),
      child: Text(
        context.l10n.coordKindTag(kind),
        style: context.text.monoSm.copyWith(
          fontSize: large ? 12 : 9.5,
          fontWeight: FontWeight.w700,
          color: coordKindColor(context, kind),
        ),
      ),
    );
  }
}

Color coordKindColor(BuildContext context, CoordFileKind k) {
  final c = context.colors;
  return switch (k) {
    CoordFileKind.pdf => c.danger,
    CoordFileKind.document => c.info,
    CoordFileKind.image => c.inProgress,
  };
}

/// Boş bölüm metni (prototip `.cd-empty`).
class CoordEmpty extends StatelessWidget {
  const CoordEmpty(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 28,
      horizontal: NizamioSpacing.space4,
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: context.text.bodyMd.copyWith(color: context.colors.textMuted),
    ),
  );
}
