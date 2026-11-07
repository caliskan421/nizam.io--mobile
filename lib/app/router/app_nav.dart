import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/display_brand.dart';
import '../../core/providers.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/page/nz_app_nav.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../features/identity/identity.dart';
import '../../features/scope/scope.dart';
import 'routes.dart';
import 'shell.dart' show ShellModule, moduleOf;
import 'split.dart';

/// [NzAppNav]'ın GoRouter gerçeklemesi (uygulama kökü sağlar). Modül hedefleri `go`; kayıt
/// açan niyetler (görev, koordinatörlük, arşiv klasörü) çift bölmedeki yığın kuralıyla
/// ([splitMove]): başka modülün kaydı bulunulan konumun izine itilir, geri izi kısaltıp açıldığı
/// sayfaya döner (koordinatörlüğün Görevler bölümünden açılan görev → geri o bölüm). Kabuk
/// dışı tam ekranlar (zaman çizelgesi, sohbet, profil) itilir.
class GoRouterAppNav implements NzAppNav {
  GoRouterAppNav(this._router, this._ref);

  final GoRouter _router;
  final WidgetRef _ref;

  String get _location => _router.routeInformationProvider.value.uri.path;

  /// Kabuk içi hedefler `go` ile açılır: alt sayfalar iç içe rota olduğundan yığın
  /// (dal kökü + alt sayfa) kurulur ve geri dal köküne döner; başka dala geçişte o dalın yığını.
  void _open(String target) => _router.go(target);

  /// Kayıt açılışı (prototip `tgo`): modülün kendi kaydı tabana oturur, başka modülün kaydı
  /// ize itilir, yığında geride varsa oraya dönülür. Tek bölmede son açılan kayıt hatırlanmaz.
  void _record(PaneEntry target) {
    final move = splitMove(
      _router.routeInformationProvider.value.uri,
      target,
      (_) => null,
    );
    if (move case SplitGo(:final location)) _router.go(location);
  }

  @override
  void openHome() => _router.go(const HomeRoute().location);

  @override
  void openHistory() => _open(const HistoryRoute().location);

  @override
  void openTasks({NzTaskView? view, List<String> people = const []}) =>
      _router.go(TasksRoute(view: view?.name, people: people).location);

  @override
  void openTask(String code) => _record(PaneEntry(PaneKind.task, code));

  @override
  void openCalendar() => _router.go(const CalendarRoute().location);

  @override
  void openTimeline({String? coordinatorship}) =>
      _router.push(TimelineRoute(coord: coordinatorship).location);

  @override
  void openCoordinatorships() =>
      _router.go(const CoordinatorshipsRoute().location);

  @override
  void openCoordinatorship(String code) =>
      _record(PaneEntry(PaneKind.coord, code));

  @override
  void openArchive() => _router.go(const ArchiveRoute().location);

  @override
  void openArchiveFolder(String code) =>
      _record(PaneEntry(PaneKind.folder, code));

  @override
  void openMessages() => _router.go(const MessagesRoute().location);

  @override
  void openChat(String id) => _router.push(ChatRoute(id: id).location);

  @override
  void openProfile() => _router.push(const ProfileRoute().location);

  @override
  void openMenu(BuildContext context) {
    final dashboard = _ref.read(homeDashboardControllerProvider).value;
    final program = _ref.read(currentProgramControllerProvider).value;
    final brand = displayBrand(_ref.read(flavorProvider));
    final l = context.l10n;
    final location = _location;
    final current = switch (moduleOf(location)) {
      ShellModule.coordinatorships => HomeModule.coordinatorships,
      ShellModule.archive => HomeModule.archive,
      ShellModule.messages => HomeModule.messages,
      ShellModule.calendar => HomeModule.calendar,
      null =>
        // Zaman çizelgesi görevler modülünün parçasıdır (prototip `ON.tasks`).
        location.startsWith(const TasksRoute().location) ||
                location.startsWith(const TimelineRoute().location)
            ? HomeModule.tasks
            : location.startsWith(const HomeRoute().location)
            ? HomeModule.home
            : null,
    };
    showHomeDrawer(
      context,
      current: current,
      greetingName: dashboard?.greetingName ?? '',
      greetingRole: dashboard?.greetingRole,
      greetingEmail: dashboard?.greetingEmail,
      programName: program?.name ?? dashboard?.demoProgramName,
      programYear: program?.year ?? dashboard?.demoProgramYear,
      version: brand.version,
      productName: brand.name,
      counts: dashboard?.counts,
      onProfile: openProfile,
      onChangeScope: () =>
          _ref.read(scopeSelectionControllerProvider.notifier).clear(),
      onSignOut: () => confirmSignOut(context, _ref),
      onModule: (m) {
        switch (m) {
          case HomeModule.home:
            openHome();
          case HomeModule.tasks:
            openTasks();
          case HomeModule.coordinatorships:
            openCoordinatorships();
          case HomeModule.archive:
            openArchive();
          case HomeModule.messages:
            openMessages();
          case HomeModule.calendar:
            openCalendar();
          default:
            NzToast.show(
              context,
              '${_moduleLabel(context, m)} ${l.uiHomeSoonTail}',
            );
        }
      },
    );
  }

  static String _moduleLabel(BuildContext context, HomeModule m) {
    final l = context.l10n;
    return switch (m) {
      HomeModule.home => l.uiHomeModuleHome,
      HomeModule.tasks => l.uiHomeModuleTasks,
      HomeModule.calendar => l.uiHomeModuleCalendar,
      HomeModule.memory => l.uiHomeModuleMemory,
      HomeModule.archive => l.uiHomeModuleArchive,
      HomeModule.meetings => l.uiHomeModuleMeetings,
      HomeModule.messages => l.uiHomeModuleMessages,
      HomeModule.sheets => l.uiHomeModuleSheets,
      HomeModule.users => l.uiHomeModuleUsers,
      HomeModule.coordinatorships => l.uiHomeCoordinatorships,
      HomeModule.season => l.uiHomeModuleSeason,
      HomeModule.simulation => l.uiHomeModuleSimulation,
      HomeModule.deleted => l.uiHomeDeletedRecords,
      HomeModule.help => l.uiHomeHelp,
    };
  }
}
