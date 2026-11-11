import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/home_dashboard.dart';
import 'home_grid_layout.dart';
import 'home_texts.dart';
import 'home_wide.dart';

/// İki ya da daha çok eşit sütun (prototip `grid`); bütün öğeler en uzun öğenin yüksekliğinde
/// (koordinatörlük kartları: adı iki satıra kayan kart diğerlerinden uzun durmaz).
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
  Widget build(BuildContext context) =>
      UniformGrid(columns: columns, gap: gap, children: children);
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

/// Özet kutuları (tamamlanma, devam eden, gecikmede, onay bekleyen): 2×2, geniş ana sayfada
/// tek satır ([columns] 4).
class HomeKpiGrid extends StatelessWidget {
  const HomeKpiGrid({
    super.key,
    required this.tasks,
    required this.onOpen,
    this.columns = 2,
  });

  final TaskTotals tasks;
  final int columns;

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
        columns: columns,
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

/// Hızlı işlem türü (kutucuk ve kısayol menüsü aynı listeyi kullanır). Görev açma Görevler
/// sayfasının "+" düğmesindedir; işlem geçmişi buradan açılır (ayrı kartı yok).
enum HomeQuickAction { history, meeting, deleted, report }

List<HomeQuickAction> homeQuickActions({required bool isAdmin}) => [
  for (final action in HomeQuickAction.values)
    if (action != HomeQuickAction.deleted || isAdmin) action,
];

/// Hızlı işlemler: başlık + ayraçlı tek kart ([HomeQuickActionsBar]).
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.onAction,
    required this.isAdmin,
  });

  final ValueChanged<HomeQuickAction> onAction;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiHomeQuickActions),
        const Gap(NizamioSpacing.gapMd),
        // Geniş düzendeki tek kart (ayraçlı dört bölme); yükseklik içerikten.
        IntrinsicHeight(
          child: HomeQuickActionsBar(
            onAction: onAction,
            compact: true,
            isAdmin: isAdmin,
          ),
        ),
      ],
    );
  }
}

IconData quickActionIcon(HomeQuickAction a) => switch (a) {
  HomeQuickAction.history => NzIcons.history,
  HomeQuickAction.meeting => NzIcons.video,
  HomeQuickAction.deleted => NzIcons.delete,
  HomeQuickAction.report => NzIcons.document,
};

String quickActionLabel(AppLocalizations l, HomeQuickAction a) => switch (a) {
  HomeQuickAction.history => l.uiHomeHistoryTitle,
  HomeQuickAction.meeting => l.uiHomeQaMeeting,
  HomeQuickAction.deleted => l.uiHomeDeletedShortcut,
  HomeQuickAction.report => l.uiHomeQaReport,
};

/// Kısayol menüsündeki uzun ad ("Toplantı oluştur").
String quickActionLongLabel(AppLocalizations l, HomeQuickAction a) =>
    switch (a) {
      HomeQuickAction.history => l.uiHomeHistoryOpen,
      HomeQuickAction.meeting => l.uiHomeQaMeetingLong,
      HomeQuickAction.deleted => l.uiHomeDeletedRecords,
      HomeQuickAction.report => l.uiHomeQaReportLong,
    };

/// Ekip: rol başına [HomeTeamTile] (rol rengi işaret ve pay çubuğudur). Yalnız [team]
/// bilinirken (yönetici özeti) kurulur.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiHomeTeam, trailing: l.teamSummary(dashboard, team)),
        const Gap(NizamioSpacing.gapMd),
        HomeGrid(
          columns: 3,
          gap: NizamioSpacing.space2,
          children: homeRoleTiles(context, team, onOpen, compact: true),
        ),
      ],
    );
  }
}
