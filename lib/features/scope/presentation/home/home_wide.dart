import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/home_dashboard.dart';
import 'home_sections.dart';

/// Tablette tam genişlik ana sayfa: içerik bu genişlikten itibaren geniş düzene geçer (özet
/// tek satır, hızlı işlemler ile ekip yan yana, koordinatörlükler 4'lü). Altında (telefon, 390 bölme, dikey tablet) dar düzen.
const homeWideMinWidth = 840.0;

/// Geniş düzende iki yarım sütun arası (özet ızgarasının sütun aralığıyla hizalı).
const homeWideGap = NizamioSpacing.gapMd;

/// Hızlı işlemler tek kartta: dört eşit bölme, aralarında ince ayraç (ikon kutusu + etiket).
/// Yükseklik çağırandan gelir (sınırlı olmalı; ör. [IntrinsicHeight]). Başlık (`hızlı
/// işlemler`) çağıranda: başlığın taban çizgisi hizası içsel ölçüye girmez. [compact] (telefon,
/// 390 bölme) etiketi küçük metinle çizer.
class HomeQuickActionsBar extends StatelessWidget {
  const HomeQuickActionsBar({
    super.key,
    required this.onAction,
    required this.isAdmin,
    this.compact = false,
  });

  final ValueChanged<HomeQuickAction> onAction;
  final bool isAdmin;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final actions = homeQuickActions(isAdmin: isAdmin);
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, a) in actions.indexed) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NizamioSpacing.space3,
                ),
                child: VerticalDivider(
                  width: NizamioSize.borderWidth,
                  thickness: NizamioSize.borderWidth,
                  color: c.border,
                ),
              ),
            Expanded(
              child: _QuickAction(
                icon: quickActionIcon(a),
                label: quickActionLabel(l, a),
                compact: compact,
                onPressed: () => onAction(a),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.compact,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(NizamioRadius.tile);
    return Semantics(
      container: true,
      button: true,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: NzPressable(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: NizamioSpacing.space3,
                horizontal: NizamioSpacing.space1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.surfaceOverlay,
                      borderRadius: radius,
                    ),
                    child: SizedBox.square(
                      dimension: NizamioSize.iconTileLg,
                      child: NzIcon(
                        icon,
                        size: NizamioSize.iconSizeSm,
                        color: c.text,
                      ),
                    ),
                  ),
                  Gap(compact ? NizamioSpacing.space2 : NizamioSpacing.space3),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: compact ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: compact ? context.text.caption : context.text.list,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ekip kutusu: işaret noktası, sayı, rol adı ve rolün toplamdaki payı (çubuk; toplam kutusunda
/// dolu). [onTap] null → yalnız sayı (toplam, yönetici). [compact] (telefon, 390 bölme) küçük
/// sayı ve dolgu. Izgarada eşit yükseklikte durur (çubuk alta yaslanır).
class HomeTeamTile extends StatelessWidget {
  const HomeTeamTile({
    super.key,
    required this.dot,
    required this.bar,
    required this.count,
    required this.total,
    required this.label,
    this.onTap,
    this.compact = false,
  });

  final Color dot;
  final Color bar;
  final int count;
  final int total;
  final String label;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    return NzCard.outlined(
      padding: EdgeInsets.all(
        compact ? NizamioSpacing.space3 : NizamioSpacing.rowPad,
      ),
      onTap: onTap,
      semanticLabel: onTap == null
          ? '$count $label'
          : '$count $label. ${l.uiHomeOpenList}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            child: const Padding(padding: EdgeInsets.all(NizamioSize.dot / 2)),
          ),
          Gap(compact ? NizamioSpacing.space1 : NizamioSpacing.space2),
          Text('$count', maxLines: 1, style: compact ? t.titleMd : t.titleLg),
          Text(
            label,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: t.caption.copyWith(color: context.colors.textMuted),
          ),
          const Spacer(),
          const Gap(NizamioSpacing.space3),
          NzProgressBar(value: total == 0 ? 0 : count / total, color: bar),
        ],
      ),
    );
  }
}

/// Ekip, geniş düzen (başlık çağıranda, bkz. [HomeQuickActionsBar]): toplam üye + rol başına
/// [HomeTeamTile]. Dokunma dar düzendeki gibi ([HomeTeam.onOpen]); toplam ve yönetici yalnız
/// sayıdır.
class HomeWideTeam extends StatelessWidget {
  const HomeWideTeam({super.key, required this.team, required this.onOpen});

  final TeamTotals team;
  final ValueChanged<TeamRole> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final total = team.users;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space2,
      children: [
        for (final w in [
          HomeTeamTile(
            dot: c.text,
            bar: c.textMuted,
            count: total,
            total: total,
            label: l.uiHomeTeamTotal,
          ),
          ...homeRoleTiles(context, team, onOpen),
        ])
          Expanded(child: w),
      ],
    );
  }
}

/// Rol kutuları (yönetici, koordinatör, üye); dar ve geniş düzen ortak.
List<Widget> homeRoleTiles(
  BuildContext context,
  TeamTotals team,
  ValueChanged<TeamRole> onOpen, {
  bool compact = false,
}) {
  final l = context.l10n;
  final c = context.colors;
  HomeTeamTile tile(TeamRole r, Color color, int n, String label) =>
      HomeTeamTile(
        dot: color,
        bar: color,
        count: n,
        total: team.users,
        label: label,
        compact: compact,
        // Yöneticilik ekip rolü değildir, süzgeç açmaz (F57).
        onTap: r == TeamRole.admin ? null : () => onOpen(r),
      );
  return [
    tile(TeamRole.admin, c.roleAdmin, team.admins, l.uiHomeRoleAdmin),
    tile(
      TeamRole.coordinator,
      c.roleCoordinator,
      team.coordinators,
      l.uiHomeRoleCoordinator,
    ),
    tile(TeamRole.member, c.roleMember, team.members, l.uiHomeRoleMember),
  ];
}
