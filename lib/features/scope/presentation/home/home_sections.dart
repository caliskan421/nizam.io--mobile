import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/home_dashboard.dart';
import 'home_texts.dart';

/// İki ya da daha çok eşit sütun; satırdaki öğeler aynı yüksekliğe uzar (prototip `grid`).
class HomeGrid extends StatelessWidget {
  const HomeGrid({
    super.key,
    required this.columns,
    required this.gap,
    required this.children,
  });

  final int columns;
  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    spacing: gap,
    children: [
      for (var r = 0; r < children.length; r += columns)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: gap,
            children: [
              for (var i = r; i < r + columns; i++)
                Expanded(
                  child: i < children.length
                      ? children[i]
                      : const SizedBox.shrink(),
                ),
            ],
          ),
        ),
    ],
  );
}

/// Karşılama: tarih + "Merhaba" ve ad (ad tek satırda kesilir; tam ad okuyucuda).
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.name, required this.today});

  final String name;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.dateKicker(today),
          style: t.kicker.copyWith(color: context.colors.textMuted),
        ),
        const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
        Semantics(
          header: true,
          label: '${l.uiHomeGreeting} $name',
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.uiHomeGreeting, style: t.displayLg),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.displayLg,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 2×2 özet kutuları (tamamlanma, devam eden, gecikmede, onay bekleyen).
class HomeKpiGrid extends StatelessWidget {
  const HomeKpiGrid({super.key, required this.tasks, required this.onOpen});

  final TaskTotals tasks;

  /// Kutuya dokunma → görev listesi o kutunun görünümüyle (prototip `go.done/doing/late/review`).
  final ValueChanged<NzTaskView> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = tasks;
    double ratio(int a, int b) => b == 0 ? 0 : a / b;
    NzKpiTile tile({
      required NzTaskView view,
      required IconData icon,
      required Color tone,
      required String label,
      required String value,
      required double progress,
      required String caption,
      Color? valueColor,
    }) => NzKpiTile(
      icon: icon,
      tone: tone,
      label: label,
      value: value,
      valueColor: valueColor,
      progress: progress,
      caption: caption,
      onTap: () => onOpen(view),
      semanticLabel: '$label: $value. $caption. ${l.uiHomeOpenList}',
    );
    return Semantics(
      container: true,
      label: l.uiHomeSummaryLabel,
      child: HomeGrid(
        columns: 2,
        gap: NizamioSpacing.gapMd,
        children: [
          tile(
            view: NzTaskView.done,
            icon: NzIcons.check,
            tone: c.accentText,
            label: l.uiHomeKpiDone,
            value: l.percent(ratio(t.done, t.total)),
            progress: ratio(t.done, t.total),
            caption: l.kpiDoneCaption(t),
          ),
          tile(
            view: NzTaskView.inProgress,
            icon: NzIcons.bolt,
            tone: c.inProgress,
            label: l.uiHomeKpiDoing,
            value: '${t.inProgress}',
            progress: ratio(t.inProgress, t.total),
            caption: l.kpiDoingCaption(t),
          ),
          tile(
            view: NzTaskView.late,
            icon: NzIcons.warning,
            tone: c.danger,
            label: l.uiHomeKpiLate,
            value: '${t.late}',
            valueColor: c.danger,
            progress: ratio(t.late, t.open),
            caption: l.kpiLateCaption(t),
          ),
          tile(
            view: NzTaskView.review,
            icon: NzIcons.clock,
            tone: c.warning,
            label: l.uiHomeKpiReview,
            value: '${t.awaitingApproval}',
            progress: ratio(t.awaitingApproval, t.open),
            caption: l.uiHomeKpiReviewCaption,
          ),
        ],
      ),
    );
  }
}

/// Hızlı işlem türü (kutucuk ve kısayol menüsü aynı listeyi kullanır).
enum HomeQuickAction { task, meeting, invite, report }

/// Dört hızlı işlem kutucuğu.
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.onAction,
    this.canCreateTask = true,
  });

  final ValueChanged<HomeQuickAction> onAction;

  /// "Yeni görev" kutusu görünsün mü (seçili kapsamda görev açma yetkisi).
  final bool canCreateTask;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiHomeQuickActions),
        const Gap(NizamioSpacing.gapMd),
        HomeGrid(
          columns: 4,
          gap: NizamioSpacing.space2,
          children: [
            for (final a in HomeQuickAction.values)
              if (a != HomeQuickAction.task || canCreateTask)
                NzActionTile(
                  icon: quickActionIcon(a),
                  label: quickActionLabel(l, a),
                  primary: a == HomeQuickAction.task,
                  onPressed: () => onAction(a),
                ),
          ],
        ),
      ],
    );
  }
}

IconData quickActionIcon(HomeQuickAction a) => switch (a) {
  HomeQuickAction.task => NzIcons.add,
  HomeQuickAction.meeting => NzIcons.video,
  HomeQuickAction.invite => NzIcons.personAdd,
  HomeQuickAction.report => NzIcons.document,
};

String quickActionLabel(AppLocalizations l, HomeQuickAction a) => switch (a) {
  HomeQuickAction.task => l.uiHomeQaTask,
  HomeQuickAction.meeting => l.uiHomeQaMeeting,
  HomeQuickAction.invite => l.uiHomeQaInvite,
  HomeQuickAction.report => l.uiHomeQaReport,
};

/// Kısayol menüsündeki uzun ad ("Toplantı oluştur").
String quickActionLongLabel(AppLocalizations l, HomeQuickAction a) =>
    switch (a) {
      HomeQuickAction.task => l.uiHomeQaTaskLong,
      HomeQuickAction.meeting => l.uiHomeQaMeetingLong,
      HomeQuickAction.invite => l.uiHomeQaInviteLong,
      HomeQuickAction.report => l.uiHomeQaReportLong,
    };

/// Ekip: rol başına sayı kutusu (rol rengi yalnız işarettir). Yalnız [team] bilinirken
/// (yönetici özeti) kurulur.
class HomeTeam extends StatelessWidget {
  const HomeTeam({
    super.key,
    required this.dashboard,
    required this.team,
    required this.onOpen,
  });

  final HomeDashboard dashboard;
  final TeamTotals team;

  /// Kutuya dokunma → görev listesi o ekip rolündeki kişilerle süzülmüş (koordinatör/üye).
  /// Yönetici kutusu yalnız sayıdır: yöneticilik ekip rolü değildir, süzgeç açmaz (F57).
  final ValueChanged<TeamRole> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    Widget tile(TeamRole r, Color dot, int n, String role) => NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.space3),
      onTap: r == TeamRole.admin ? null : () => onOpen(r),
      semanticLabel: r == TeamRole.admin
          ? '$n $role'
          : '$n $role. ${l.uiHomeOpenList}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: NizamioSpacing.space1,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            child: const Padding(padding: EdgeInsets.all(NizamioSize.dot / 2)),
          ),
          Text('$n', maxLines: 1, style: context.text.titleMd),
          Text(
            role,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.caption.copyWith(color: c.textMuted),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiHomeTeam, trailing: l.teamSummary(dashboard, team)),
        const Gap(NizamioSpacing.gapMd),
        HomeGrid(
          columns: 3,
          gap: NizamioSpacing.space2,
          children: [
            tile(TeamRole.admin, c.roleAdmin, team.admins, l.uiHomeRoleAdmin),
            tile(
              TeamRole.coordinator,
              c.roleCoordinator,
              team.coordinators,
              l.uiHomeRoleCoordinator,
            ),
            tile(
              TeamRole.member,
              c.roleMember,
              team.members,
              l.uiHomeRoleMember,
            ),
          ],
        ),
      ],
    );
  }
}

/// İşlem geçmişi giriş kartı.
class HomeHistoryCard extends StatelessWidget {
  const HomeHistoryCard({
    super.key,
    required this.activity,
    required this.now,
    required this.onOpen,
  });

  final LastActivity? activity;
  final DateTime now;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final a = activity;
    return NzCard.outlined(
      onTap: onOpen,
      semanticLabel: l.uiHomeHistoryOpen,
      child: Row(
        children: [
          const NzIconTile(icon: NzIcons.history),
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: NizamioSpacing.space1 / 2,
              children: [
                Text(
                  l.uiHomeHistoryTitle,
                  style: context.text.list.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (a != null)
                  Text(
                    l.lastActivity(a, now),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.caption.copyWith(color: c.textMuted),
                  ),
              ],
            ),
          ),
          const Gap(NizamioSpacing.space3),
          NzIcon(
            NzIcons.chevronRight,
            size: NizamioSize.iconSizeSm,
            color: c.textFaint,
          ),
        ],
      ),
    );
  }
}
