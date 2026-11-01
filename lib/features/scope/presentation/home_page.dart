import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
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
import 'home/home_texts.dart';
import 'root_top_bar.dart';

/// Ana sayfa (prototip `home`): cam üst çubuk (ürün, seçili program, bildirim, menü), karşılama,
/// özet kutuları, hızlı işlemler, ekip, işlem geçmişi, koordinatörlükler. Program adı S2
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
          dashboard: dashboard,
          onOpenTask: context.appNav.openTask,
          onQuickAction: (a) => _quickAction(context, a),
          onOpenHistory: context.appNav.openHistory,
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
      onRetry: retry,
      topBar: const RootTopBar(),
      children: [
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
    HomeQuickAction.task => showNewTaskSheet(context),
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
    // Tarih satırı ve "son işlem" göreli zamanı görev kataloğunun "bugün"üdür (örnek veride
    // prototip çapası 21 Ekim; gerçek kaynakta sunucu günü). Katalog yokken cihaz saati.
    final now =
        ref.watch(
          taskCatalogControllerProvider.select((c) => c.value?.today),
        ) ??
        DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeGreeting(name: d.greetingName, today: now),
        const Gap(NizamioSpacing.gapXl),
        HomeKpiGrid(
          tasks: d.tasks,
          onOpen: (view) => nav.openTasks(view: view),
        ),
        // Kesik katalogdan sayıldı: liste ekranıyla aynı uyarı.
        if (d.truncated) ...[
          const Gap(NizamioSpacing.space3),
          Text(
            context.l10n.uiListsTruncated,
            textAlign: TextAlign.center,
            style: context.text.bodySm.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ],
        const Gap(NizamioSpacing.gapXl),
        HomeQuickActions(onAction: onQuickAction),
        const Gap(NizamioSpacing.gapXl),
        // Kişi kümeleri ortak katalogdan; yalnız bu bölüm izler (katalog değişimi akışı kurmaz).
        // Ekip sayıları yalnız yönetici özetinde bilinir; yoksa kutu gizlenir.
        if (d.team case final team?) ...[
          Consumer(
            builder: (context, ref, _) {
              final people = ref.watch(homeTeamPeopleProvider);
              return HomeTeam(
                dashboard: d,
                team: team,
                onOpen: (role) =>
                    nav.openTasks(people: people?.of(role) ?? const []),
              );
            },
          ),
          const Gap(NizamioSpacing.gapXl),
        ],
        HomeHistoryCard(
          activity: d.lastActivity,
          now: now,
          onOpen: nav.openHistory,
        ),
        const Gap(NizamioSpacing.gapXl),
        HomeCoordinatorships(
          items: d.coordinatorships,
          onOpen: nav.openCoordinatorship,
        ),
        const Gap(NizamioSpacing.gapXl),
        Text(
          context.l10n.footerSummary(d),
          textAlign: TextAlign.center,
          style: context.text.caption.copyWith(color: context.colors.textMuted),
        ),
      ],
    );
  }
}
