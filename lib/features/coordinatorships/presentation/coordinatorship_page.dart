import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
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
import '../application/coordinatorship_form_controller.dart';
import '../application/coordinatorship_profiles_controller.dart';
import '../application/coordinatorships_controller.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_archive_meetings_tabs.dart';
import 'coord_detail_texts.dart';
import 'coord_form_sheet.dart';
import 'coord_general_tab.dart';
import 'coord_hero.dart';
import 'coord_people_sheet.dart';
import 'coord_tasks_tab.dart';
import 'coord_texts.dart';

/// Koordinatörlük ayrıntısı (prototip `cdetail`, telefon ve tablet sağ panel): kısa kodlu cam
/// üst çubuk + "diğer işlemler", kimlik ([CoordHero]), yapışkan segmentli bölümler
/// (Genel, Görevler, Üyeler, Arşiv, Toplantı). Alt menüde modül sekmesine yeniden dokunmak diğer
/// koordinatörlükleri listede seçili sıralamayla listeler.
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
      // Koordinatörlükler listesi yalnız tüm koordinatörlükleri gören görünümde (yönetici);
      // derin bağlantıyla gelen koordinatör/üyede kısayol menüsü yok.
      if (!ref.read(effectiveAccessProvider).seesAllDepartments) return;
      _showShortcuts(context, d, ref.read(coordinatorshipsControllerProvider));
    });
    final l = context.l10n;
    final d = detail.value;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final selectedTab = ref.watch(
      coordinatorshipDetailControllerProvider(code).select((v) => v.tab),
    );
    final manages = ref.watch(coordManagesTeamProvider(code));
    final tabs = coordinatorshipTabs(readsTeam: manages);
    final tab = tabs.contains(selectedTab) ? selectedTab : tabs.first;
    final ready = d != null && catalog != null;
    final tasks = ready ? catalog.tasksOf(code) : const <TaskItem>[];
    final pulse = CoordPulse.of(tasks);
    final people = ready
        ? coordPeople(d.stats.leads, d.stats.members, tasks)
        : const <CoordPerson>[];
    // Diğer ayrıntı sayfaları gibi: cam üst çubuk, içerik altından akar; bölümler çubuğun
    // altına yapışan cam şerit (prototip `.cd-tabwrap`, `position: sticky; top: 56px`).
    return NzPage.feed(
      width: NzContentWidth.wide,
      onRefresh: () => ref
          .read(coordinatorshipsControllerProvider.notifier)
          .refresh(code: code),
      // Tablet sağ bölmesi: kaynak gap 22, kimlik -6 → 16.
      paneLead: NizamioSpacing.space4,
      onRetry: () => _retry(ref),
      topBar: NzTopBar.detail(
        // Kullanıcıya kimlik (department_id) değil kısa etiket; kod yoksa yazı yok.
        code: d?.stats.shortCode,
        actions: [
          if (ref.watch(canManageCoordinatorshipsProvider) || manages)
            NzIconButton(
              icon: NzIcons.more,
              semanticLabel: l.uiCoordMoreActions,
              onPressed: d == null
                  ? null
                  : () => _showMoreActions(context, ref, d),
            ),
        ],
      ),
      pinned: !ready
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 8),
              child: NzPillTabs(
                semanticLabel: l.uiCoordTabsLabel,
                selected: tabs.indexOf(tab),
                onSelected: (i) => ref
                    .read(
                      coordinatorshipDetailControllerProvider(code).notifier,
                    )
                    .selectTab(tabs[i]),
                tabs: [
                  for (final t in tabs) NzPillTab(label: l.coordTabLabel(t)),
                ],
              ),
            ),
      afterKey: ValueKey(tab),
      after: !ready
          ? const []
          : [
              const Gap(NizamioSpacing.space3),
              switch (tab) {
                CoordinatorshipTab.general => CoordGeneralTab(
                  detail: d,
                  pulse: pulse,
                  people: people,
                  catalog: catalog,
                ),
                CoordinatorshipTab.tasks => CoordTasksTab(
                  code: code,
                  catalog: catalog,
                  people: people,
                ),
                CoordinatorshipTab.members => CoordMembersTab(
                  code: code,
                  people: people,
                ),
                CoordinatorshipTab.archive => CoordArchiveTab(
                  code: code,
                  catalog: catalog,
                ),
                CoordinatorshipTab.calendar => CoordCalendarTab(code: code),
              },
            ],
      children: [
        if (ready)
          CoordHero(detail: d, canAssign: manages)
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

  void _showMoreActions(
    BuildContext context,
    WidgetRef ref,
    CoordinatorshipDetail d,
  ) {
    final l = context.l10n;
    final name = d.stats.name;
    final canManage = ref.read(canManageCoordinatorshipsProvider);
    final managesTeam = ref.read(coordManagesTeamProvider(code));
    final canMeet = ref.read(effectiveAccessProvider).canCreateMeeting;

    NzBottomSheet.show<void>(
      context,
      title: l.coordMenuTitle(name),
      // Prototip: başlıksız işlem sayfası (tutamak + iki satır grubu); ad anlamsal etiket.
      showHeader: false,
      builder: (sheet) {
        NzMenuRow row(IconData icon, String label, VoidCallback then) =>
            NzMenuRow(
              icon: icon,
              label: label,
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
                // Bilgileri düzenle yalnız şirket yöneticisine (updateDepartment,
                // renameDepartmentLink).
                if (canManage)
                  row(NzIcons.edit, l.uiCoordMenuEdit, () {
                    if (context.mounted) {
                      showCoordinatorshipForm(context, ref, detail: d);
                    }
                  }),
                // Toplantı planla: yönetici ya da bu birimin koordinatörü (MEETINGS README),
                // etkin rol toplantı açabiliyorsa.
                if (managesTeam && canMeet)
                  row(
                    NzIcons.event,
                    l.uiCoordMenuMeeting,
                    () => showMeetingSheet(context, coordinatorship: code),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
