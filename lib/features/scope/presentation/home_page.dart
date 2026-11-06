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
import 'home/home_coordinatorships.dart';
import 'home/home_menus.dart';
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
        final dashboard = ref.read(homeDashboardControllerProvider).value;
        // Yalnız görünen sayfa (yığının tepesi) kendi kısayol menüsünü açar.
        final visible = ModalRoute.of(context)?.isCurrent ?? true;
        if (next?.tab != shellTab || dashboard == null || !visible) return;
        showHomeShortcuts(
          context,
          onQuickAction: (a) => _quickAction(context, a),
        );
      });
    final programState = ref.watch(currentProgramControllerProvider);
    final dashboard = ref.watch(homeDashboardControllerProvider);
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
          skeletonOnReload: true,
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
    HomeQuickAction.invite => showInviteSheet(context),
    HomeQuickAction.report => _soon(
      context,
      quickActionLongLabel(context.l10n, a),
    ),
  };
}

class _Feed extends ConsumerWidget {
  const _Feed({required this.dashboard, required this.onQuickAction});

  final HomeDashboard dashboard;
  final ValueChanged<HomeQuickAction> onQuickAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = dashboard;
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
    Widget? team({required bool wide}) => switch (d.team) {
      null => null,
      final team => Consumer(
        builder: (context, ref, _) {
          final people = ref.watch(homeTeamPeopleProvider);
          void open(TeamRole role) =>
              nav.openTasks(people: people?.of(role) ?? const []);
          return wide
              ? HomeWideTeam(team: team, onOpen: open)
              : HomeTeam(dashboard: d, team: team, onOpen: open);
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
        final kpis = HomeKpiGrid(
          tasks: d.tasks,
          columns: wide ? 4 : 2,
          onOpen: (view) => nav.openTasks(view: view),
        );
        final coords = HomeCoordinatorships(
          items: d.coordinatorships,
          wide: wide,
          onOpen: nav.openCoordinatorship,
        );
        if (!wide) {
          final narrowTeam = team(wide: false);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              greeting,
              const Gap(NizamioSpacing.gapXl),
              kpis,
              ...truncated,
              const Gap(NizamioSpacing.gapXl),
              HomeQuickActions(onAction: onQuickAction),
              const Gap(NizamioSpacing.gapXl),
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
        final wideTeam = team(wide: true);
        final actions = HomeQuickActionsBar(onAction: onQuickAction);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            greeting,
            const Gap(NizamioSpacing.gapXl),
            kpis,
            ...truncated,
            const Gap(NizamioSpacing.gapXl),
            Row(
              children: [
                Expanded(child: NzKicker(context.l10n.uiHomeQuickActions)),
                if (d.team case final t?) ...[
                  const Gap(homeWideGap),
                  Expanded(
                    child: NzKicker(
                      context.l10n.uiHomeTeam,
                      trailing: context.l10n.teamSummary(d, t),
                    ),
                  ),
                ],
              ],
            ),
            const Gap(NizamioSpacing.gapMd),
            // Hızlı işlemler ile ekip aynı boyda (kısa olan uzar).
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: actions),
                  if (wideTeam != null) ...[
                    const Gap(homeWideGap),
                    Expanded(child: wideTeam),
                  ],
                ],
              ),
            ),
            const Gap(NizamioSpacing.gapXl),
            Divider(
              height: NizamioSize.borderWidth,
              thickness: NizamioSize.borderWidth,
              color: context.colors.border,
            ),
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
