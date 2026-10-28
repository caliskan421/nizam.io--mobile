import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/home_dashboard.dart';
import 'home_sections.dart';
import 'home_texts.dart';

/// Ana sayfadaki gezinme ve eylem hedefleri. Rota tanımları `app/router`'dadır (features app'i
/// import etmez, B2); kabuk tipli rotalarla doldurur. Henüz ekranı olmayan hedefler burada
/// değil, çağıran sayfada açık yer tutucuya (bildirim) düşer.
@immutable
class HomeNavigation {
  const HomeNavigation({
    required this.openTasks,
    required this.openTask,
    required this.openCoordinatorship,
    required this.openProfile,
  });

  /// Görev listesi (KPI, ekip, çekmece "Görevler").
  final VoidCallback openTasks;

  /// Tek görev (kod, ör. `ALT-7`).
  final ValueChanged<String> openTask;

  /// Koordinatörlük ayrıntısı (kod, ör. `ALT`).
  final ValueChanged<String> openCoordinatorship;
  final VoidCallback openProfile;
}

/// Alt menüde "Ana sayfa"ya yeniden dokununca açılan kısayol menüsü.
Future<void> showHomeShortcuts(
  BuildContext context, {
  required HomeDashboard dashboard,
  required ValueChanged<String> onOpenTask,
  required ValueChanged<HomeQuickAction> onQuickAction,
  required VoidCallback onOpenHistory,
}) {
  final l = context.l10n;
  final c = context.colors;
  return NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiHomeShortcuts,
    entries: [
      if (dashboard.pending.isNotEmpty) ...[
        NzFlyoutSection(l.uiHomeWaitingForYou),
        for (final p in dashboard.pending)
          NzFlyoutItem(
            label: p.title,
            caption: l.pendingCaption(p),
            dot: p.kind == PendingKind.dateChange ? c.warning : c.inProgress,
            onSelected: () => onOpenTask(p.taskCode),
          ),
      ],
      NzFlyoutSection(l.uiHomeQuickActions),
      for (final a in HomeQuickAction.values)
        NzFlyoutItem(
          label: quickActionLongLabel(l, a),
          icon: quickActionIcon(a),
          accent: a == HomeQuickAction.task,
          onSelected: () => onQuickAction(a),
        ),
      NzFlyoutSection(l.uiHomeGo),
      NzFlyoutItem(
        label: l.uiHomeHistoryTitle,
        icon: Icons.history_rounded,
        onSelected: onOpenHistory,
      ),
    ],
  );
}

/// Hızlı işlem alt sayfası: formlar sonraki adımın işidir; sayfa açılır, ne geleceğini söyler.
Future<void> showQuickActionSheet(BuildContext context, HomeQuickAction a) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: quickActionLongLabel(l, a),
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.uiHomeFormSoon,
          style: sheetContext.text.bodyMd.copyWith(
            color: sheetContext.colors.textMuted,
          ),
        ),
        const Gap(NizamioSpacing.space6),
        NzButton.secondary(
          label: l.uiCommonClose,
          expand: true,
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ],
    ),
  );
}

/// Çekmece satırının hedefi (ekranı olmayanlar yer tutucuya düşer).
enum HomeModule {
  home,
  tracking,
  tasks,
  calendar,
  memory,
  archive,
  meetings,
  messages,
  sheets,
  requests,
  budget,
  users,
  coordinatorships,
  season,
  simulation,
  deleted,
  help,
}

/// Sağdan açılan çekmece: hesap, kapsam (program) değiştirme, tüm modüller, çıkış.
Future<void> showHomeDrawer(
  BuildContext context, {
  required String greetingName,
  required String? programName,
  required ModuleCounts counts,
  required ValueChanged<HomeModule> onModule,
  required VoidCallback onProfile,
  required VoidCallback onChangeScope,
  required VoidCallback onSignOut,
}) {
  final l = context.l10n;
  return NzSideSheet.show<void>(
    context,
    semanticLabel: l.uiHomeMenu,
    builder: (sheet) {
      final c = sheet.colors;
      void close(VoidCallback then) {
        Navigator.of(sheet).pop();
        then();
      }

      Widget count(int n, {Color? fill, Color? ink}) => DecoratedBox(
        decoration: BoxDecoration(
          color: fill ?? c.surfaceOverlay,
          borderRadius: BorderRadius.circular(NizamioRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space2,
            vertical: NizamioSpacing.space1 / 2,
          ),
          child: Text(
            '$n',
            style: sheet.text.monoSm.copyWith(
              color: ink ?? c.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      NzMenuRow row(
        HomeModule m,
        IconData icon,
        String label, {
        Widget? trailing,
      }) => NzMenuRow(
        icon: icon,
        label: label,
        current: m == HomeModule.home,
        trailing: trailing,
        onTap: () => close(() => onModule(m)),
      );

      return ListView(
        padding: const EdgeInsets.fromLTRB(
          NizamioSpacing.rowPad,
          NizamioSpacing.space4,
          NizamioSpacing.rowPad,
          NizamioSpacing.space6,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label: '$greetingName, ${l.uiHomeProfile}',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => close(onProfile),
                    borderRadius: BorderRadius.circular(NizamioRadius.group),
                    child: Padding(
                      padding: const EdgeInsets.all(NizamioSpacing.space1),
                      child: Row(
                        children: [
                          NzAvatar.initials(name: greetingName),
                          const Gap(NizamioSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greetingName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: sheet.text.labelLg,
                                ),
                                Text(
                                  l.uiHomeProfile,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: sheet.text.caption.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              NzIconButton(
                icon: Icons.close_rounded,
                semanticLabel: l.uiCommonClose,
                size: NzSize.sm,
                onPressed: () => Navigator.of(sheet).pop(),
              ),
            ],
          ),
          const Gap(NizamioSpacing.gapLg),
          // Kapsam (program) değiştirme: prototipte sezon düğmesi; mevcut kapsam akışına bağlı.
          NzMenuGroup(
            rows: [
              NzMenuRow(
                icon: Icons.unfold_more_rounded,
                label: programName == null
                    ? l.uiScopeHomeChange
                    : '$programName · ${l.uiScopeHomeChange}',
                onTap: () => close(onChangeScope),
              ),
            ],
          ),
          const Gap(NizamioSpacing.gapLg),
          NzMenuGroup(
            label: l.uiHomeGroupTracking,
            rows: [
              row(HomeModule.home, Icons.home_outlined, l.uiHomeModuleHome),
              row(
                HomeModule.tracking,
                Icons.work_outline_rounded,
                l.uiHomeModuleTracking,
              ),
              row(
                HomeModule.tasks,
                Icons.checklist_rounded,
                l.uiHomeModuleTasks,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: NizamioSpacing.space1,
                  children: [
                    count(counts.tasksAwaitingApproval, ink: c.warning),
                    count(counts.lateTasks, fill: c.danger, ink: c.onDanger),
                  ],
                ),
              ),
              row(
                HomeModule.calendar,
                Icons.calendar_month_outlined,
                l.uiHomeModuleCalendar,
              ),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          NzMenuGroup(
            label: l.uiHomeGroupContent,
            rows: [
              row(
                HomeModule.memory,
                Icons.lightbulb_outline_rounded,
                l.uiHomeModuleMemory,
              ),
              row(
                HomeModule.archive,
                Icons.folder_outlined,
                l.uiHomeModuleArchive,
              ),
              row(
                HomeModule.meetings,
                Icons.videocam_outlined,
                l.uiHomeModuleMeetings,
              ),
              row(
                HomeModule.messages,
                Icons.mail_outline_rounded,
                l.uiHomeModuleMessages,
                trailing: count(counts.unreadMessages),
              ),
              row(
                HomeModule.sheets,
                Icons.table_chart_outlined,
                l.uiHomeModuleSheets,
              ),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          NzMenuGroup(
            label: l.uiHomeGroupAdmin,
            rows: [
              row(
                HomeModule.requests,
                Icons.assignment_turned_in_outlined,
                l.uiHomeModuleRequests,
                trailing: count(
                  counts.pendingRequests,
                  fill: c.warning,
                  ink: c.onWarning,
                ),
              ),
              row(
                HomeModule.budget,
                Icons.account_balance_wallet_outlined,
                l.uiHomeModuleBudget,
              ),
              row(HomeModule.users, Icons.group_outlined, l.uiHomeModuleUsers),
              row(
                HomeModule.coordinatorships,
                Icons.apartment_rounded,
                l.uiHomeCoordinatorships,
              ),
              row(HomeModule.season, Icons.flag_outlined, l.uiHomeModuleSeason),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          NzMenuGroup(
            label: l.uiHomeGroupLab,
            rows: [
              row(
                HomeModule.simulation,
                Icons.science_outlined,
                l.uiHomeModuleSimulation,
                trailing: NzBadge.neutral(label: l.uiHomeBeta, size: NzSize.sm),
              ),
            ],
          ),
          const Gap(NizamioSpacing.gapLg),
          NzMenuGroup(
            rows: [
              row(
                HomeModule.deleted,
                Icons.delete_outline_rounded,
                l.uiHomeDeletedRecords,
              ),
              row(HomeModule.help, Icons.help_outline_rounded, l.uiHomeHelp),
              NzMenuRow(
                icon: Icons.logout_rounded,
                label: l.uiIdentitySignOut,
                danger: true,
                onTap: () => close(onSignOut),
              ),
            ],
          ),
        ],
      );
    },
  );
}
