import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
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
    required this.actions,
    this.compact = false,
    this.title,
    this.columns = 0,
    this.tileAspect = 1,
  });

  final ValueChanged<HomeQuickAction> onAction;

  /// Izgara kipinde ([columns] > 0) kartın içinde çizilen başlık; satır kipinde başlık çağıranda.
  final String? title;

  /// 0 → tek satırda eşit bölmeler; >0 → o kadar sütunlu ızgara (koordinatör: 2×2, kareye yakın).
  final int columns;

  /// Izgara dokunacının en/boy oranı (1 = kare); null → içerik yüksekliğinde (ikon ve etiket
  /// alt alta, dar aralıkla; yönetici tableti).
  final double? tileAspect;

  /// [homeQuickActions] sonucu.
  final List<HomeQuickAction> actions;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final title = this.title;
    if (columns > 0) {
      // Izgara (koordinatör, tablet): başlık kartın içinde, kare dokunaçlar; ayraç yok.
      Widget cell(int j) => Expanded(
        child: j < actions.length
            ? _QuickTile(
                glyph: quickActionGlyph(actions[j]),
                label: quickActionLabel(l, actions[j]),
                aspect: tileAspect,
                onPressed: () => onAction(actions[j]),
              )
            : const SizedBox.shrink(),
      );
      Widget row(int i, {bool stretch = false}) => Row(
        crossAxisAlignment: stretch
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.center,
        children: [
          for (var j = i; j < i + columns; j++) ...[
            if (j > i) const Gap(NizamioSpacing.space2),
            cell(j),
          ],
        ],
      );
      return NzCard.outlined(
        padding: const EdgeInsets.all(NizamioSpacing.space3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              // "Genel durum" başlığıyla aynı biçim ve üst hiza.
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  title,
                  style: context.text.bodyMd.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.text,
                  ),
                ),
              ),
              const Gap(14),
            ],
            for (var i = 0; i < actions.length; i += columns) ...[
              if (i > 0) const Gap(NizamioSpacing.space2),
              if (tileAspect == null)
                // İçerik yüksekliğindeki dokunaçlar çiftin yüksekliğini satırlara eşit böler
                // (yalnız sınırlı yükseklikte: satırın `IntrinsicHeight`'ı).
                Expanded(child: row(i, stretch: true))
              else
                row(i),
            ],
          ],
        ),
      );
    }
    final row = IntrinsicHeight(
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
                glyph: quickActionGlyph(a),
                label: quickActionLabel(l, a),
                compact: compact,
                onPressed: () => onAction(a),
              ),
            ),
          ],
        ],
      ),
    );
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.space2),
      child: row,
    );
  }
}

/// Izgara dokunacı: kare, ince kenarlıklı; simge sol üstte, etiket sol altta (kalın).
class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.glyph,
    required this.label,
    required this.aspect,
    required this.onPressed,
  });

  final NzGlyph glyph;
  final double? aspect;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(NizamioRadius.tile);
    final fill = aspect != null;
    final tile = Material(
      color: c.surfaceOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.border, width: NizamioSize.borderWidth),
      ),
      // Basma vurgusu yok; geri bildirim [NzPressable] küçülmesidir.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(NizamioSpacing.space3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: fill
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              NzGlyphIcon(
                glyph,
                size: NizamioSize.iconSize,
                color: c.textMuted,
              ),
              if (!fill) const Gap(NizamioSpacing.space2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.list.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
    return Semantics(
      container: true,
      button: true,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: NzPressable(
        child: switch (aspect) {
          final a? => AspectRatio(aspectRatio: a, child: tile),
          null => tile,
        },
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.glyph,
    required this.label,
    required this.compact,
    required this.onPressed,
  });

  final NzGlyph glyph;
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
          // Basma vurgusu yok; geri bildirim [NzPressable] küçülmesidir.
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
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
                      child: Center(
                        child: NzGlyphIcon(
                          glyph,
                          size: NizamioSize.iconSizeSm,
                          color: c.text,
                        ),
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
    this.prefix = '',
  });

  /// Sayının önüne (kesik listede "≥").
  final String prefix;
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
          ? '$prefix$count $label'
          : '$prefix$count $label. ${l.uiHomeOpenList}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            child: const Padding(padding: EdgeInsets.all(NizamioSize.dot / 2)),
          ),
          Gap(compact ? NizamioSpacing.space1 : NizamioSpacing.space2),
          Text(
            '$prefix$count',
            maxLines: 1,
            style: compact ? t.titleMd : t.titleLg,
          ),
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
