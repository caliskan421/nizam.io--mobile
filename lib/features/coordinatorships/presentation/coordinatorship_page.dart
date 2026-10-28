import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../application/coordinatorship_profiles_controller.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_texts.dart';
import 'coordinatorship_tabs.dart';

/// Koordinatörlük ayrıntısı (prototip `cdetail`): mono kodlu üst çubuk + "diğer işlemler",
/// ad, kimlik satırı, "Ekibe mesaj" / "Görev ata", hap sekmeler (Genel, Birimler, Ekip,
/// Hakkında). Alt menüde modül sekmesine yeniden dokunmak diğer koordinatörlükleri listeler
/// (seçim sayfayı yerinde değiştirir).
class CoordinatorshipPage extends ConsumerWidget {
  const CoordinatorshipPage({super.key, required this.code});

  final String code;

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 2;

  void _retry(WidgetRef ref) => ref
    ..invalidate(taskCatalogControllerProvider)
    ..invalidate(coordinatorshipProfilesControllerProvider);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(coordinatorshipDetailProvider(code));
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      final d = ref.read(coordinatorshipDetailProvider(code)).value;
      if (next?.tab != shellTab || !visible || d == null) return;
      _showShortcuts(context, d);
    });
    final l = context.l10n;
    final d = detail.value;
    return NzPage.feed(
      onRetry: () => _retry(ref),
      topBar: NzTopBar.detail(
        code: code,
        actions: [
          NzIconButton(
            icon: Icons.more_vert_rounded,
            semanticLabel: l.uiCoordMoreActions,
            onPressed: d == null ? null : () => _showMoreActions(context, d),
          ),
        ],
      ),
      children: [
        NzAsyncView<CoordinatorshipDetail?>(
          value: detail,
          onRetry: () => _retry(ref),
          isEmpty: (d) => d == null,
          empty: NzEmptyState(title: l.uiCoordNotFound),
          data: (d) => _Body(detail: d!),
        ),
      ],
    );
  }

  void _showShortcuts(BuildContext context, CoordinatorshipDetail d) {
    final l = context.l10n;
    final nav = context.appNav;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiCoordShortcuts,
      entries: [
        NzFlyoutSection(l.uiCoordFlySectionList),
        for (final c in d.others)
          NzFlyoutItem(
            label: c.name,
            caption: l.coordFlyoutCaption(c),
            dot: c.late > 0 ? context.colors.danger : context.colors.accentText,
            selected: c.code == code,
            onSelected: () {
              if (c.code != code) nav.openCoordinatorship(c.code);
            },
          ),
        NzFlyoutItem(
          label: l.uiCoordFlyAllList,
          icon: Icons.list_rounded,
          onSelected: nav.openCoordinatorships,
        ),
      ],
    );
  }

  void _showMoreActions(BuildContext context, CoordinatorshipDetail d) {
    final l = context.l10n;
    final name = d.stats.name;
    void toast(String m) {
      if (context.mounted) NzToast.show(context, m);
    }

    NzBottomSheet.show<void>(
      context,
      title: l.coordMenuTitle(name),
      builder: (sheet) {
        NzMenuRow row(
          IconData icon,
          String label,
          VoidCallback then, {
          bool danger = false,
        }) => NzMenuRow(
          icon: icon,
          label: label,
          danger: danger,
          onTap: () {
            Navigator.of(sheet).pop();
            then();
          },
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzMenuGroup(
              rows: [
                row(
                  Icons.edit_outlined,
                  l.uiCoordMenuEdit,
                  () => toast('$name ${l.uiCoordToastEditTail}'),
                ),
                row(
                  Icons.event_outlined,
                  l.uiCoordMenuMeeting,
                  () => showMeetingSheet(context, coordinatorship: code),
                ),
                row(
                  Icons.account_tree_outlined,
                  l.uiCoordMenuParent,
                  () => toast(l.uiCoordToastParent),
                ),
              ],
            ),
            const Gap(NizamioSpacing.gapMd),
            NzMenuGroup(
              rows: [
                row(
                  Icons.merge_rounded,
                  l.uiCoordMenuMerge,
                  () => toast(l.uiCoordToastMerge),
                ),
                row(
                  Icons.remove_circle_outline_rounded,
                  l.uiCoordMenuDeactivate,
                  () => toast('$name ${l.uiCoordToastDeactivatedTail}'),
                  danger: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
    final code = d.stats.code;
    final view = ref.watch(coordinatorshipDetailControllerProvider(code));
    final commands = ref.read(
      coordinatorshipDetailControllerProvider(code).notifier,
    );
    const tabs = CoordinatorshipTab.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(d.stats.name, style: t.titleMd)),
        const Gap(NizamioSpacing.space1),
        Text.rich(
          TextSpan(
            text: l.coordIdentityLine(d),
            children: [
              TextSpan(
                text: l.uiCoordStateActive,
                style: t.caption.copyWith(
                  color: c.accentText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          style: t.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        Row(
          spacing: NizamioSpacing.space2,
          children: [
            Expanded(
              child: NzButton.secondary(
                label: l.uiCoordMessageTeam,
                icon: Icons.chat_bubble_outline_rounded,
                expand: true,
                onPressed: () => context.appNav.openChat(d.profile.chatId),
              ),
            ),
            Expanded(
              child: NzButton.primary(
                label: l.uiCoordAssignTask,
                icon: Icons.add_rounded,
                expand: true,
                onPressed: () =>
                    showNewTaskSheet(context, coordinatorship: code),
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.gapXl),
        NzPillTabs(
          semanticLabel: l.uiCoordTabsLabel,
          selected: tabs.indexOf(view.tab),
          onSelected: (i) => commands.selectTab(tabs[i]),
          tabs: [
            NzPillTab(label: l.uiCoordTabGeneral),
            NzPillTab(label: l.uiCoordTabUnits, count: d.profile.units.length),
            NzPillTab(label: l.uiCoordTabTeam, count: d.people),
            NzPillTab(label: l.uiCoordTabAbout),
          ],
        ),
        const Gap(NizamioSpacing.gapXl),
        switch (view.tab) {
          CoordinatorshipTab.general => CoordGeneralTab(detail: d),
          CoordinatorshipTab.units => CoordUnitsTab(detail: d),
          CoordinatorshipTab.team => CoordTeamTab(
            detail: d,
            membersOpen: view.membersOpen,
            onToggleMembers: commands.toggleMembers,
          ),
          CoordinatorshipTab.about => CoordAboutTab(detail: d),
        },
      ],
    );
  }
}
