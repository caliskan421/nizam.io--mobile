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
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../application/coordinatorship_profiles_controller.dart';
import '../application/coordinatorships_controller.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_texts.dart';
import 'coordinatorship_tabs.dart';

/// Koordinatörlük ayrıntısı (prototip `cdetail`): kısa kodlu cam üst çubuk + "diğer işlemler",
/// ad, kimlik satırı, "Ekibe mesaj" / "Görev ata", yapışkan hap sekmeler (Genel, Birimler,
/// Ekip, Hakkında; prototip `position: sticky; top: 64px`). Alt menüde modül sekmesine yeniden
/// dokunmak diğer koordinatörlükleri listede seçili sıralamayla listeler.
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
      _showShortcuts(context, d, ref.read(coordinatorshipsControllerProvider));
    });
    final l = context.l10n;
    final d = detail.value;
    final view = ref.watch(coordinatorshipDetailControllerProvider(code));
    // Diğer ayrıntı sayfaları gibi: cam üst çubuk, içerik altından akar; sekmeler çubuğun
    // altına yapışan cam şerit (prototip `position: sticky; top: 64px`).
    return NzPage.feed(
      // Tablet sağ bölmesi: kaynak gap 22, kimlik -6 → 16.
      paneLead: NizamioSpacing.space4,
      onRetry: () => _retry(ref),
      topBar: NzTopBar.detail(
        // Kullanıcıya kimlik (department_id) değil kısa etiket; kod yoksa yazı yok.
        code: d?.stats.shortCode,
        actions: [
          NzIconButton(
            icon: NzIcons.more,
            semanticLabel: l.uiCoordMoreActions,
            onPressed: d == null ? null : () => _showMoreActions(context, d),
          ),
        ],
      ),
      pinned: d == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(
                top: NizamioSpacing.space4,
                bottom: NizamioSpacing.space3,
              ),
              child: _Tabs(detail: d),
            ),
      afterKey: ValueKey(view.tab),
      after: d == null
          ? const []
          : [
              switch (view.tab) {
                CoordinatorshipTab.general => CoordGeneralTab(detail: d),
                CoordinatorshipTab.units => CoordUnitsTab(detail: d),
                CoordinatorshipTab.team => CoordTeamTab(
                  detail: d,
                  membersOpen: view.membersOpen,
                  onToggleMembers: ref
                      .read(
                        coordinatorshipDetailControllerProvider(code).notifier,
                      )
                      .toggleMembers,
                ),
                CoordinatorshipTab.about => CoordAboutTab(detail: d),
              },
            ],
      children: [
        if (d != null)
          _Header(detail: d)
        else
          NzAsyncView<CoordinatorshipDetail?>(
            value: detail,
            onRetry: () => _retry(ref),
            isEmpty: (d) => d == null,
            empty: NzEmptyState(title: l.uiCoordNotFound),
            data: (_) => const SizedBox.shrink(),
          ),
      ],
    );
  }

  void _showShortcuts(
    BuildContext context,
    CoordinatorshipDetail d,
    CoordinatorshipSort sort,
  ) {
    final l = context.l10n;
    final nav = context.appNav;
    // Prototip: liste sayfasının o anki sıralaması (`coord.renderVals().cList`).
    final others = sortCoordinatorships(d.others, sort);
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiCoordShortcuts,
      entries: [
        NzFlyoutSection(l.uiCoordFlySectionList),
        for (final c in others)
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
          icon: NzIcons.list,
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
      // Prototip: başlıksız işlem sayfası (tutamak + iki satır grubu); ad anlamsal etiket.
      showHeader: false,
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
                  NzIcons.edit,
                  l.uiCoordMenuEdit,
                  () => toast('$name ${l.uiCoordToastEditTail}'),
                ),
                row(
                  NzIcons.event,
                  l.uiCoordMenuMeeting,
                  () => showMeetingSheet(context, coordinatorship: code),
                ),
                row(
                  NzIcons.hierarchy,
                  l.uiCoordMenuParent,
                  () => toast(l.uiCoordToastParent),
                ),
              ],
            ),
            const Gap(NizamioSpacing.gapMd),
            NzMenuGroup(
              rows: [
                row(
                  NzIcons.merge,
                  l.uiCoordMenuMerge,
                  () => toast(l.uiCoordToastMerge),
                ),
                row(
                  NzIcons.removeCircle,
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

/// Ad, kimlik satırı ve "Ekibe mesaj" / "Görev ata" düğmeleri.
class _Header extends StatelessWidget {
  const _Header({required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
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
                icon: NzIcons.messages,
                expand: true,
                onPressed: () => context.appNav.openChat(d.profile.chatId),
              ),
            ),
            Expanded(
              child: NzButton.primary(
                label: l.uiCoordAssignTask,
                icon: NzIcons.add,
                expand: true,
                onPressed: () =>
                    showNewTaskSheet(context, coordinatorship: d.stats.code),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Genel / Birimler / Ekip / Hakkında sekmeleri (yapışkan şerit).
class _Tabs extends ConsumerWidget {
  const _Tabs({required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final d = detail;
    final p = coordinatorshipDetailControllerProvider(d.stats.code);
    final tab = ref.watch(p.select((s) => s.tab));
    const tabs = CoordinatorshipTab.values;
    return NzPillTabs(
      semanticLabel: l.uiCoordTabsLabel,
      selected: tabs.indexOf(tab),
      onSelected: (i) => ref.read(p.notifier).selectTab(tabs[i]),
      tabs: [
        NzPillTab(label: l.uiCoordTabGeneral),
        NzPillTab(label: l.uiCoordTabUnits, count: d.profile.units.length),
        NzPillTab(label: l.uiCoordTabTeam, count: d.people),
        NzPillTab(label: l.uiCoordTabAbout),
      ],
    );
  }
}
