import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/layout/nz_pane.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../identity/identity.dart';
import '../../tasks/tasks.dart';
import '../application/current_program_controller.dart';
import '../application/home_dashboard_controller.dart';
import '../application/home_team_people.dart';
import '../application/scope_selection_controller.dart';
import '../domain/home_dashboard.dart';
import 'home/home_coordinator.dart';
import 'home/home_coordinatorships.dart';
import 'home/home_member.dart';
import 'home/home_menus.dart';
import 'home/home_overview.dart';
import 'home/home_sections.dart';
import 'home/home_skeleton.dart';
import 'home/home_texts.dart';
import 'home/home_wide.dart';
import 'root_top_bar.dart';

/// Ana sayfa (prototip `home`): cam üst çubuk (ürün, seçili program, bildirim, menü), karşılama,
/// özet kutuları, hızlı işlemler (işlem geçmişi dahil), ekip, koordinatörlükler. Tablette tam genişlikte
/// geniş düzen (`home/home_wide.dart`). Program adı S2
/// `GET /v1/program` yanıtından gelir (kapsam başlığının kanıtı); özet [HomeDashboardController]
/// (bugün geliştirme örneği). Alt menüde "Ana sayfa"ya yeniden dokunmak kısayol menüsünü açar.
/// Gezinme [NzAppNav] ile (rota tanımları app'te); ekranı olmayan hedefler açık yer tutucu
/// bildirimine düşer.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listenErrors(scopeSelectionControllerProvider, context)
      ..listenErrors(signOutProvider, context)
      ..listen(shellReselectEventsProvider, (_, next) {
        final dashboard = ref
            .read(homeDashboardControllerProvider.notifier)
            .visible
            .value;
        // Yalnız görünen sayfa (yığının tepesi) kendi kısayol menüsünü açar.
        final visible = ModalRoute.of(context)?.isCurrent ?? true;
        if (next?.tab != shellTab || dashboard == null || !visible) return;
        final actions = _actionsFor(ref.read(effectiveAccessProvider));
        if (actions.isEmpty) return;
        showHomeShortcuts(
          context,
          onQuickAction: (a) => _quickAction(context, a),
          actions: actions,
        );
      });
    final programState = ref.watch(currentProgramControllerProvider);
    ref.watch(homeDashboardControllerProvider);
    // Başka hesabın/programın özeti görünmez (yükleniyor ya da yalnız hata).
    final dashboard = ref
        .read(homeDashboardControllerProvider.notifier)
        .visible;
    // Özet hatası katalog hatası olabilir (yönetici olmayan hesap); katalog da yeniden okunur.
    void retry() {
      if (ref.read(taskCatalogControllerProvider).hasError) {
        ref.invalidate(taskCatalogControllerProvider);
      }
      ref.invalidate(homeDashboardControllerProvider);
    }

    return NzPage.feed(
      // Tablette açık kayıt yokken sayfa tam genişliktir ([homeWideMinWidth] üstü geniş düzen).
      width: NzContentWidth.wide,
      onRetry: retry,
      // Aşağı çekme: özet (ve rol kaynağı katalog) yeniden okunur; eski özet yerinde kalır.
      onRefresh: () =>
          ref.read(homeDashboardControllerProvider.notifier).refresh(),
      onRevisit: () =>
          ref.read(homeDashboardControllerProvider.notifier).refreshIfStale(),
      topBar: const RootTopBar(),
      children: [
        // Tablet liste bölmesi: kök üst çubuk gizli, seçili program adı akışın başında.
        if (NzPaneScope.maybeOf(context)?.role == NzPaneRole.master)
          const RootProgramLine(bottom: NizamioSpacing.space3),
        // S2 (seçili program) hatası: üst çubukta program satırı yerine görünür hata + yeniden
        // dene (yalnız dokunuşla).
        if (programState.hasError && !programState.isLoading) ...[
          NzErrorState.inline(
            error: toApiError(programState.error!),
            onRetry: () => ref.invalidate(currentProgramControllerProvider),
          ),
          const Gap(NizamioSpacing.gapXl),
        ],
        NzAsyncView<HomeDashboard>(
          value: dashboard,
          onRetry: retry,
          loading: const HomeSkeleton(),
          data: (d) => _Feed(
            dashboard: d,
            onQuickAction: (a) => _quickAction(context, a),
          ),
        ),
      ],
    );
  }

  void _soon(BuildContext context, String what) =>
      NzToast.show(context, context.l10n.soon(what));

  void _quickAction(BuildContext context, HomeQuickAction a) => switch (a) {
    HomeQuickAction.history => context.appNav.openHistory(),
    HomeQuickAction.meeting => showMeetingSheet(context),
    HomeQuickAction.deleted => context.appNav.openDeletedTasks(),
    HomeQuickAction.report => _soon(
      context,
      quickActionLongLabel(context.l10n, a),
    ),
    // Ana sayfa hızlı işlemi: taslak (koordinatörlük, atananlar) korunur.
    HomeQuickAction.newTask => showNewTaskSheet(context),
    HomeQuickAction.member => showInviteSheet(context),
  };
}

/// Etkin görünümün hızlı işlemleri (kutucuklar ve kısayol menüsü aynı liste).
List<HomeQuickAction> _actionsFor(EffectiveAccess access) => homeQuickActions(
  isAdmin: access.canAdminister,
  canMeet: access.canCreateMeeting,
  coordinator: access.isCoordinatorView,
  canCreateTask: access.canCreateTask,
  canManageTeam: access.canManageTeam,
);

class _Feed extends ConsumerWidget {
  const _Feed({required this.dashboard, required this.onQuickAction});

  final HomeDashboard dashboard;
  final ValueChanged<HomeQuickAction> onQuickAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = dashboard;
    // Bölümler etkin görünümden seçilir (yönetici kuyrukları, koordinatör bölümleri).
    final access = ref.watch(effectiveAccessProvider);
    // Etkin rolün açabildikleri; boşsa (üye görünümü) bölüm çizilmez.
    final actions = _actionsFor(access);
    final quick = [
      if (actions.isNotEmpty) ...[
        HomeQuickActions(onAction: onQuickAction, actions: actions),
        const Gap(NizamioSpacing.gapXl),
      ],
    ];
    final nav = context.appNav;
    // Tarih satırı görev kataloğunun "bugün"üdür. Katalog yokken cihaz saati.
    final now =
        ref.watch(
          taskCatalogControllerProvider.select((c) => c.value?.today),
        ) ??
        DateTime.now();
    final greeting = HomeGreeting(name: d.greetingName, today: now);
    // Kesik katalogdan sayıldı: liste ekranıyla aynı uyarı.
    final truncated = [
      if (d.truncated) ...[
        const Gap(NizamioSpacing.space3),
        Text(
          context.l10n.uiListsTruncated,
          textAlign: TextAlign.center,
          style: context.text.bodySm.copyWith(color: context.colors.textMuted),
        ),
      ],
    ];
    // Kişi kümeleri ortak katalogdan; yalnız ekip bölümü izler (katalog değişimi akışı kurmaz).
    // Ekip sayıları yalnız yönetici özetinde bilinir; yoksa kutu gizlenir.
    // Geniş düzende yalnız rol kutuları (başlık ve hizalama çağıranda).
    Widget? team({required bool wide}) => switch (d.team) {
      null => null,
      final team => Consumer(
        builder: (context, ref, _) {
          final people = ref.watch(homeTeamPeopleProvider);
          void open(TeamRole role) =>
              nav.openTasks(people: people?.of(role) ?? const []);
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: NizamioSpacing.gapMd,
                  children: [
                    for (final w in homeRoleTiles(context, team, open))
                      Expanded(child: w),
                  ],
                )
              : HomeTeam(team: team, onOpen: open);
        },
      ),
    };
    final footer = Text(
      context.l10n.footerSummary(d),
      textAlign: TextAlign.center,
      style: context.text.caption.copyWith(color: context.colors.textMuted),
    );
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= homeWideMinWidth;
        final taskTotals = d.tasks;
        void openView(NzTaskView view) => nav.openTasks(view: view);
        final coords = HomeCoordinatorships(
          items: d.coordinatorships,
          truncated: d.truncated,
          wide: wide,
          onOpen: nav.openCoordinatorship,
        );
        // Üye: odak, iade, Görevlerim, Yaklaşanlar (KPI, genel durum, koordinatörlük kartı yok).
        if (access.isMemberView) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              greeting,
              const Gap(NizamioSpacing.space3),
              HomeViewLine(view: access),
              const Gap(NizamioSpacing.gapXl),
              HomeMemberFeed(wide: wide),
            ],
          );
        }
        if (access.isCoordinatorView) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              greeting,
              const Gap(NizamioSpacing.space3),
              HomeViewLine(view: access),
              const Gap(NizamioSpacing.gapXl),
              HomeCoordinatorFeed(
                wide: wide,
                // Geniş: başlık kart içinde 2×2 kare dokunaç; dar: yönetici ile aynı bileşen
                // (başlık + tek satır).
                quick: actions.isEmpty
                    ? null
                    : wide
                    ? HomeQuickActionsBar(
                        onAction: onQuickAction,
                        actions: actions,
                        title: context.l10n.uiHomeQuickActionsTitle,
                        columns: 2,
                      )
                    : HomeQuickActions(
                        onAction: onQuickAction,
                        actions: actions,
                      ),
              ),
            ],
          );
        }
        if (!wide) {
          final narrowTeam = team(wide: false);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              greeting,
              const Gap(NizamioSpacing.gapXl),
              const HomeOverview(),
              const Gap(NizamioSpacing.gapXl),
              HomeKpiGrid(
                tasks: taskTotals,
                kpis: homeKpisNarrow(taskTotals),
                onOpen: openView,
              ),
              ...truncated,
              const Gap(NizamioSpacing.gapXl),
              ...quick,
              if (narrowTeam != null) ...[
                narrowTeam,
                const Gap(NizamioSpacing.gapXl),
              ],
              coords,
              const Gap(NizamioSpacing.gapXl),
              footer,
            ],
          );
        }
        // Tablet: genel durum + 2×2 hızlı işlemler (aynı yükseklik); özet kutuları telefondaki
        // sırayla (gecikme, tarih talebi, başlamadı, onay; tamamlanma ve devam ekibin solunda).
        final quickCard = actions.isEmpty
            ? null
            : HomeQuickActionsBar(
                onAction: onQuickAction,
                actions: actions,
                title: context.l10n.uiHomeQuickActionsTitle,
                columns: 2,
                tileAspect: null,
              );
        final wideTeam = team(wide: true);
        // Telefondaki sıra: ilk dördü üst satır, kalanı ekibin yanında.
        final kpiOrder = homeKpisNarrow(taskTotals);
        final lower = LayoutBuilder(
          builder: (context, box) {
            const g = NizamioSpacing.gapMd;
            final col = (box.maxWidth - 3 * g) / 4;
            final right = 2 * col + g;
            // Görev kutuları solda (1. ve 2. sütun), ekip sağda; görev kutuları "Ekip" başlığı +
            // rol kutularının toplam yüksekliğinde.
            final tasks = kpiOrder.skip(4).toList();
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < 2; i++) ...[
                    if (i > 0) const Gap(g),
                    SizedBox(
                      width: col,
                      child: i < tasks.length
                          ? homeKpiTile(context, tasks[i], taskTotals, openView)
                          : null,
                    ),
                  ],
                  const Gap(g),
                  SizedBox(
                    width: right,
                    child: wideTeam == null
                        ? null
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              NzKicker(context.l10n.uiHomeTeam),
                              const Gap(NizamioSpacing.gapMd),
                              Expanded(child: wideTeam),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            greeting,
            const Gap(NizamioSpacing.gapXl),
            if (quickCard == null)
              const HomeOverview()
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(
                      flex: 5,
                      child: HomeOverview(legendGrid: true),
                    ),
                    const Gap(homeWideGap),
                    Expanded(flex: 3, child: quickCard),
                  ],
                ),
              ),
            const Gap(NizamioSpacing.gapXl),
            HomeKpiGrid(
              tasks: taskTotals,
              kpis: kpiOrder.take(4).toList(),
              columns: 4,
              onOpen: openView,
            ),
            ...truncated,
            const Gap(NizamioSpacing.gapXl),
            lower,
            const Gap(NizamioSpacing.gapXl),
            coords,
            const Gap(NizamioSpacing.gapXl),
            footer,
          ],
        );
      },
    );
  }
}
