import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_uniform_grid.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/home_dashboard.dart';
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
          style: t.kicker.copyWith(
            color: context.colors.textMuted,
            fontWeight: FontWeight.w600,
          ),
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

/// Ana sayfa özet kutusu türü.
enum HomeKpi { done, inProgress, review, notStarted, late, dateRequest }

/// Telefon sırası (2 sütun): gecikme ve tarih talebi üstte; tarih talebi yalnız sayı bilinirken
/// (yönetici özeti).
List<HomeKpi> homeKpisNarrow(TaskTotals t) => [
  HomeKpi.late,
  if (t.dateRequests != null) HomeKpi.dateRequest,
  HomeKpi.notStarted,
  HomeKpi.review,
  HomeKpi.done,
  HomeKpi.inProgress,
];

/// Tek özet kutusu; dokunma → görev listesi o kutunun görünümüyle.
Widget homeKpiTile(
  BuildContext context,
  HomeKpi kpi,
  TaskTotals t,
  ValueChanged<NzTaskView> onOpen,
) {
  final l = context.l10n;
  final c = context.colors;
  double ratio(int a, int b) => b == 0 ? 0 : a / b;
  final (view, glyph, tone, label, value, progress) = switch (kpi) {
    HomeKpi.done => (
      NzTaskView.done,
      NzGlyphs.done,
      c.taskDone,
      l.uiHomeKpiDone,
      l.percent(ratio(t.done, t.total)),
      ratio(t.done, t.total),
    ),
    HomeKpi.inProgress => (
      NzTaskView.inProgress,
      NzGlyphs.inProgress,
      c.inProgress,
      l.uiHomeKpiDoing,
      '${t.inProgress}',
      ratio(t.inProgress, t.total),
    ),
    HomeKpi.review => (
      NzTaskView.review,
      NzGlyphs.review,
      c.warning,
      l.uiHomeKpiReview,
      '${t.awaitingApproval}',
      ratio(t.awaitingApproval, t.open),
    ),
    HomeKpi.notStarted => (
      NzTaskView.notStarted,
      NzGlyphs.notStarted,
      c.textMuted,
      l.uiTasksStatusTodo,
      '${t.notStarted}',
      ratio(t.notStarted, t.total),
    ),
    HomeKpi.late => (
      NzTaskView.late,
      NzGlyphs.late,
      c.danger,
      l.uiHomeKpiLate,
      '${t.late}',
      ratio(t.late, t.open),
    ),
    HomeKpi.dateRequest => (
      NzTaskView.dateRequest,
      NzGlyphs.dateRequest,
      c.warning,
      l.uiHomeKpiDateRequest,
      '${t.dateRequests ?? 0}',
      ratio(t.dateRequests ?? 0, t.open),
    ),
  };
  return NzKpiTile(
    glyph: glyph,
    tone: tone,
    label: label,
    value: value,
    valueColor: kpi == HomeKpi.late ? c.danger : null,
    progress: progress,
    onTap: () => onOpen(view),
    semanticLabel: '$label: $value. ${l.uiHomeOpenList}',
  );
}

/// Özet kutuları ızgarası ([kpis] sırasıyla, eşit yükseklikte).
class HomeKpiGrid extends StatelessWidget {
  const HomeKpiGrid({
    super.key,
    required this.tasks,
    required this.kpis,
    required this.onOpen,
    this.columns = 2,
  });

  final TaskTotals tasks;
  final List<HomeKpi> kpis;
  final int columns;
  final ValueChanged<NzTaskView> onOpen;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: context.l10n.uiHomeSummaryLabel,
    child: HomeGrid(
      columns: columns,
      gap: NizamioSpacing.gapMd,
      children: [for (final k in kpis) homeKpiTile(context, k, tasks, onOpen)],
    ),
  );
}

/// Hızlı işlem türü (kutucuk ve kısayol menüsü aynı listeyi kullanır). İşlem geçmişi buradan
/// açılır (ayrı kartı yok). Yeni görev ve üye ekle yalnız koordinatör görünümünde (yönetici
/// görünümünde görev açma Görevler sayfasının "+" düğmesindedir).
enum HomeQuickAction { history, meeting, deleted, report, newTask, member }

/// Rapor telefonda üretilmez: rapor oluşturucu gelene dek kısayol (yönetici ve koordinatör
/// görünümü) "yakında" bildirimi gösterir; üye görünümünde yoktur. İşlem geçmişi ve
/// silinenler yalnız şirket yöneticisine (AUDIT-K10); toplantı yalnız açabilen etkin role
/// ([EffectiveAccess.canCreateMeeting]). [coordinator] (koordinatör görünümü) prototip sırasını
/// kullanır: Yeni görev ([canCreateTask]), Toplantı, Üye ekle ([canManageTeam]), Rapor. Liste boşsa
/// bölüm çizilmez.
List<HomeQuickAction> homeQuickActions({
  required bool isAdmin,
  required bool canMeet,
  bool coordinator = false,
  bool canCreateTask = false,
  bool canManageTeam = false,
}) => coordinator
    ? [
        if (canCreateTask) HomeQuickAction.newTask,
        if (canMeet) HomeQuickAction.meeting,
        if (canManageTeam) HomeQuickAction.member,
        if (isAdmin) HomeQuickAction.history,
        HomeQuickAction.report,
      ]
    : [
        for (final action in HomeQuickAction.values)
          if (switch (action) {
            HomeQuickAction.newTask || HomeQuickAction.member => false,
            HomeQuickAction.meeting => canMeet,
            HomeQuickAction.history ||
            HomeQuickAction.deleted ||
            HomeQuickAction.report => isAdmin,
          })
            action,
      ];

/// Hızlı işlemler: başlık + ayraçlı tek kart ([HomeQuickActionsBar]).
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.onAction,
    required this.actions,
  });

  final ValueChanged<HomeQuickAction> onAction;

  /// [homeQuickActions] sonucu (boş olmamalı).
  final List<HomeQuickAction> actions;

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
            actions: actions,
          ),
        ),
      ],
    );
  }
}

/// Dokunaç ikonu (tasarım çizgi ikonları); kısayol menüsü [quickActionIcon] kullanır.
NzGlyph quickActionGlyph(HomeQuickAction a) => switch (a) {
  HomeQuickAction.history => NzGlyphs.history,
  HomeQuickAction.meeting => NzGlyphs.meeting,
  HomeQuickAction.deleted => NzGlyphs.deleted,
  HomeQuickAction.report => NzGlyphs.report,
  HomeQuickAction.newTask => NzGlyphs.add,
  HomeQuickAction.member => NzGlyphs.personAdd,
};

IconData quickActionIcon(HomeQuickAction a) => switch (a) {
  HomeQuickAction.history => NzIcons.history,
  HomeQuickAction.meeting => NzIcons.video,
  HomeQuickAction.deleted => NzIcons.delete,
  HomeQuickAction.report => NzIcons.document,
  HomeQuickAction.newTask => NzIcons.add,
  HomeQuickAction.member => NzIcons.personAdd,
};

String quickActionLabel(AppLocalizations l, HomeQuickAction a) => switch (a) {
  HomeQuickAction.history => l.uiHomeHistoryTitle,
  HomeQuickAction.meeting => l.uiHomeQaMeeting,
  HomeQuickAction.deleted => l.uiHomeDeletedShortcut,
  HomeQuickAction.report => l.uiHomeQaReport,
  HomeQuickAction.newTask => l.uiHomeQaNewTask,
  HomeQuickAction.member => l.uiHomeQaMember,
};

/// Kısayol menüsündeki uzun ad ("Toplantı oluştur").
String quickActionLongLabel(AppLocalizations l, HomeQuickAction a) =>
    switch (a) {
      HomeQuickAction.history => l.uiHomeHistoryOpen,
      HomeQuickAction.meeting => l.uiHomeQaMeetingLong,
      HomeQuickAction.deleted => l.uiHomeDeletedRecords,
      HomeQuickAction.report => l.uiHomeQaReportLong,
      HomeQuickAction.newTask => l.uiHomeQaNewTask,
      HomeQuickAction.member => l.uiHomeQaMemberLong,
    };

/// Ekip: rol başına [HomeTeamTile] (rol rengi işaret ve pay çubuğudur). Yalnız [team]
/// bilinirken (yönetici özeti) kurulur.
class HomeTeam extends StatelessWidget {
  const HomeTeam({super.key, required this.team, required this.onOpen});

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
        NzKicker(l.uiHomeTeam),
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
