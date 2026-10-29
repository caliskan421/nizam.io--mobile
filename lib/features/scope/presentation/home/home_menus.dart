import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/home_dashboard.dart';
import 'home_sections.dart';
import 'home_texts.dart';

// Tablet çekmecesi iç dolgusu (kaynak `aside`): üst 52, alt 28.
const _tabletTop = 52.0;
const _tabletBottom = 28.0;

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

/// Sağdan açılan uygulama çekmecesi: hesap, kapsam (program) değiştirme, tüm modüller, çıkış.
/// Kök sayfaların menü dairesinden (`NzAppNav.openMenu`) açılır; [current] bulunulan modül.
Future<void> showHomeDrawer(
  BuildContext context, {
  required HomeModule? current,
  required String greetingName,
  required String? programName,
  required ModuleCounts? counts,
  TeamRole? greetingRole,
  String? greetingEmail,
  int? programYear,
  String? version,
  String? productName,
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
      // Prototip başlığı: "Admin · e-posta"; bilinmiyorsa profil bağlantısının adı.
      final roleLabel = switch (greetingRole) {
        TeamRole.admin => l.uiHomeRoleAdmin,
        TeamRole.coordinator => l.uiHomeRoleCoordinator,
        TeamRole.member => l.uiHomeRoleMember,
        null => null,
      };
      final accountCaption = [?roleLabel, ?greetingEmail].join(' · ');
      void close(VoidCallback then) {
        Navigator.of(sheet).pop();
        then();
      }

      Widget? count(int? n, {Color? fill, Color? ink}) => n == null
          ? null
          : DecoratedBox(
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
        current: m == current,
        trailing: trailing,
        onTap: () => close(() => onModule(m)),
      );

      // Tablet (kaynak `aside` `padding: 52px 14px 28px`; durum çubuğu payı dahil 52).
      final tablet = NzTabletMetrics.tabletVisualAt(
        MediaQuery.sizeOf(context).width,
      );
      return ListView(
        padding: EdgeInsets.fromLTRB(
          NizamioSpacing.rowPad,
          tablet
              ? math.max(
                  NizamioSpacing.space4,
                  _tabletTop - MediaQuery.viewPaddingOf(context).top,
                )
              : NizamioSpacing.space4,
          NizamioSpacing.rowPad,
          tablet ? _tabletBottom : NizamioSpacing.space6,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label: '$greetingName, ${l.uiHomeProfile}',
                  hint: accountCaption.isEmpty ? null : accountCaption,
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => close(onProfile),
                    borderRadius: BorderRadius.circular(NizamioRadius.group),
                    child: Padding(
                      padding: const EdgeInsets.all(NizamioSpacing.space1),
                      child: Row(
                        children: [
                          if (tablet)
                            _TabletAvatar(name: greetingName)
                          else
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
                                  accountCaption.isEmpty
                                      ? l.uiHomeProfile
                                      : accountCaption,
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
              if (tablet)
                _TabletClose(
                  label: l.uiCommonClose,
                  onTap: () => Navigator.of(sheet).pop(),
                )
              else
                NzIconButton(
                  icon: Icons.close_rounded,
                  semanticLabel: l.uiCommonClose,
                  size: NzSize.sm,
                  onPressed: () => Navigator.of(sheet).pop(),
                ),
            ],
          ),
          const Gap(NizamioSpacing.gapLg),
          // Kapsam (program) kartı (prototip sezon düğmesi: violet monogram, ad, "2026 sezonu",
          // ↕); dokunuş mevcut kapsam değiştirme akışına bağlı.
          _SeasonCard(
            name: programName ?? l.uiScopeHomeChange,
            caption: l.seasonCaption(programYear, l.uiScopeHomeChange),
            onTap: () => close(onChangeScope),
          ),
          const Gap(NizamioSpacing.gapLg),
          NzMenuGroup(
            label: l.uiHomeGroupTracking,
            rows: [
              row(HomeModule.home, Icons.home_outlined, l.uiHomeModuleHome),
              // Kaynak tablet çekmecesinde "takip" grubu: Ana sayfa · Görevler · Takvim.
              if (!tablet)
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
                    ?count(counts?.tasksAwaitingApproval, ink: c.warning),
                    ?count(counts?.lateTasks, fill: c.danger, ink: c.onDanger),
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
                trailing: count(counts?.unreadMessages),
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
                  counts?.pendingRequests,
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
          if (version != null) ...[
            const Gap(NizamioSpacing.gapLg),
            Text(
              '${productName ?? l.uiHomeAppName} ${l.uiHomeVersionPrefix}$version',
              textAlign: TextAlign.center,
              style: sheet.text.monoSm.copyWith(color: c.textFaint),
            ),
          ],
        ],
      );
    },
  );
}

/// Çekmecedeki kapsam kartı: violet monogram karosu, program adı, alt satır, ↕ simgesi.
class _SeasonCard extends StatelessWidget {
  const _SeasonCard({
    required this.name,
    required this.caption,
    required this.onTap,
  });

  final String name;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    // Sayısal sözcükler ("2026") monograma girmez: "Örnek Sezon 2026" → "ÖS".
    final monogram = NzAvatar.initialsOf(
      name.split(' ').where((w) => int.tryParse(w) == null).join(' '),
    );
    return NzCard.filled(
      padding: const EdgeInsets.symmetric(
        horizontal: NizamioSpacing.space3,
        vertical: NizamioSpacing.gapMd,
      ),
      onTap: onTap,
      semanticLabel: '$name, $caption',
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: c.inProgress,
              borderRadius: BorderRadius.circular(NizamioRadius.tile),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: NizamioSize.controlSm - NizamioSpacing.space1,
                height: NizamioSize.controlSm - NizamioSpacing.space1,
              ),
              child: Center(
                child: Text(
                  monogram,
                  maxLines: 1,
                  style: t.caption.copyWith(
                    color: c.onInProgress,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          const Gap(NizamioSpacing.space3),
          NzIcon(
            Icons.unfold_more_rounded,
            size: NizamioSize.iconSizeSm,
            color: c.textFaint,
          ),
        ],
      ),
    );
  }
}

/// Tablet çekmecesi hesap avatarı (kaynak `rp-av` 44 / 15: `bg-overlay` daire, `ink` baş harf).
class _TabletAvatar extends StatelessWidget {
  const _TabletAvatar({required this.name});

  final String name;

  static const _extent = 44.0;
  static const _fontSize = 15.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final initials = words.isEmpty
        ? ''
        : words.take(2).map((w) => w.characters.first).join().toUpperCase();
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceOverlay,
          shape: BoxShape.circle,
        ),
        child: SizedBox.square(
          dimension: _extent,
          child: Center(
            child: Text(
              initials,
              style: context.text.labelLg.copyWith(
                fontSize: _fontSize,
                color: c.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tablet çekmecesi kapat düğmesi (kaynak 36 `bg-overlay` daire, 16 X).
class _TabletClose extends StatelessWidget {
  const _TabletClose({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.surfaceOverlay,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: NizamioSize.controlSm,
            child: Center(
              child: NzIcon(
                Icons.close_rounded,
                size: NizamioSize.iconSizeSm,
                color: c.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
