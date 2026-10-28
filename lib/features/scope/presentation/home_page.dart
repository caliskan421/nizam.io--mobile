import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../identity/identity.dart';
import '../application/current_program_controller.dart';
import '../application/home_dashboard_controller.dart';
import '../application/scope_selection_controller.dart';
import '../domain/home_dashboard.dart';
import '../domain/program.dart';
import 'home/home_coordinatorships.dart';
import 'home/home_menus.dart';
import 'home/home_sections.dart';
import 'home/home_texts.dart';

export 'home/home_menus.dart' show HomeNavigation;

/// Ana sayfa (prototip `home`): cam üst çubuk (ürün, seçili program, bildirim, menü), karşılama,
/// özet kutuları, hızlı işlemler, ekip, işlem geçmişi, koordinatörlükler. Program adı S2
/// `GET /v1/program` yanıtından gelir (kapsam başlığının kanıtı); özet [HomeDashboardController]
/// (bugün geliştirme örneği). Alt menüde "Ana sayfa"ya yeniden dokunmak kısayol menüsünü açar.
/// Ekranı henüz olmayan hedefler açık yer tutucu bildirimine düşer.
class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.navigation});

  final HomeNavigation navigation;

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listenErrors(scopeSelectionControllerProvider, context)
      ..listenErrors(signOutProvider, context)
      ..listen(shellReselectEventsProvider, (_, next) {
        final dashboard = ref.read(homeDashboardControllerProvider).value;
        if (next?.tab != shellTab || dashboard == null) return;
        showHomeShortcuts(
          context,
          dashboard: dashboard,
          onOpenTask: navigation.openTask,
          onQuickAction: (a) => _quickAction(context, a),
          onOpenHistory: () => _soon(context, context.l10n.uiHomeHistoryTitle),
        );
      });
    final l = context.l10n;
    final programState = ref.watch(currentProgramControllerProvider);
    final program = programState.value;
    final dashboard = ref.watch(homeDashboardControllerProvider);
    final waiting = dashboard.value?.pending.length ?? 0;
    return NzPage.feed(
      onRetry: () => ref.invalidate(homeDashboardControllerProvider),
      topBar: NzTopBar(
        leading: NzBrandMark(monogram: l.uiHomeAppName.characters.first),
        title: l.uiHomeAppName,
        subtitle: program?.name,
        actions: [
          NzIconButton(
            icon: Icons.notifications_none_rounded,
            semanticLabel: l.notificationsLabel(waiting),
            dot: waiting > 0 ? context.colors.danger : null,
            onPressed: () => _soon(context, l.uiHomeNotifications),
          ),
          NzIconButton.glass(
            icon: Icons.menu_rounded,
            semanticLabel: l.uiHomeMenu,
            onPressed: () => _openDrawer(context, ref, program),
          ),
        ],
      ),
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
          onRetry: () => ref.invalidate(homeDashboardControllerProvider),
          data: (d) => _Feed(
            dashboard: d,
            navigation: navigation,
            onQuickAction: (a) => _quickAction(context, a),
            onHistory: () => _soon(context, l.uiHomeHistoryTitle),
          ),
        ),
      ],
    );
  }

  void _soon(BuildContext context, String what) =>
      NzToast.show(context, context.l10n.soon(what));

  void _quickAction(BuildContext context, HomeQuickAction a) =>
      a == HomeQuickAction.report
      ? _soon(context, quickActionLongLabel(context.l10n, a))
      : showQuickActionSheet(context, a);

  void _openDrawer(BuildContext context, WidgetRef ref, Program? program) {
    final dashboard = ref.read(homeDashboardControllerProvider).value;
    if (dashboard == null) return;
    final l = context.l10n;
    showHomeDrawer(
      context,
      greetingName: dashboard.greetingName,
      programName: program?.name,
      counts: dashboard.counts,
      onProfile: navigation.openProfile,
      onChangeScope: () =>
          ref.read(scopeSelectionControllerProvider.notifier).clear(),
      onSignOut: () => confirmSignOut(context, ref),
      onModule: (m) {
        switch (m) {
          case HomeModule.home:
            break;
          case HomeModule.tasks:
            navigation.openTasks();
          default:
            _soon(context, _moduleLabel(l, m));
        }
      },
    );
  }

  static String _moduleLabel(AppLocalizations l, HomeModule m) => switch (m) {
    HomeModule.home => l.uiHomeModuleHome,
    HomeModule.tracking => l.uiHomeModuleTracking,
    HomeModule.tasks => l.uiHomeModuleTasks,
    HomeModule.calendar => l.uiHomeModuleCalendar,
    HomeModule.memory => l.uiHomeModuleMemory,
    HomeModule.archive => l.uiHomeModuleArchive,
    HomeModule.meetings => l.uiHomeModuleMeetings,
    HomeModule.messages => l.uiHomeModuleMessages,
    HomeModule.sheets => l.uiHomeModuleSheets,
    HomeModule.requests => l.uiHomeModuleRequests,
    HomeModule.budget => l.uiHomeModuleBudget,
    HomeModule.users => l.uiHomeModuleUsers,
    HomeModule.coordinatorships => l.uiHomeCoordinatorships,
    HomeModule.season => l.uiHomeModuleSeason,
    HomeModule.simulation => l.uiHomeModuleSimulation,
    HomeModule.deleted => l.uiHomeDeletedRecords,
    HomeModule.help => l.uiHomeHelp,
  };
}

class _Feed extends StatelessWidget {
  const _Feed({
    required this.dashboard,
    required this.navigation,
    required this.onQuickAction,
    required this.onHistory,
  });

  final HomeDashboard dashboard;
  final HomeNavigation navigation;
  final ValueChanged<HomeQuickAction> onQuickAction;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final d = dashboard;
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeGreeting(name: d.greetingName, today: now),
        const Gap(NizamioSpacing.gapXl),
        HomeKpiGrid(tasks: d.tasks, onOpen: navigation.openTasks),
        const Gap(NizamioSpacing.gapXl),
        HomeQuickActions(onAction: onQuickAction),
        const Gap(NizamioSpacing.gapXl),
        HomeTeam(dashboard: d, onOpen: navigation.openTasks),
        const Gap(NizamioSpacing.gapXl),
        HomeHistoryCard(activity: d.lastActivity, now: now, onOpen: onHistory),
        const Gap(NizamioSpacing.gapXl),
        HomeCoordinatorships(
          items: d.coordinatorships,
          onOpen: navigation.openCoordinatorship,
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
