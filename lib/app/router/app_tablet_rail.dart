import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/domain/effective_role.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/layout/layout.dart';
import '../../core/ui/page/nz_app_nav.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../core/ui/widgets/navigation/nz_tablet_rail.dart';
import '../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../core/ui/widgets/nz_icons.dart';
import '../../features/messages/messages.dart';
import '../../features/notifications/notifications.dart';
import '../../features/scope/scope.dart';
import '../../features/tasks/tasks.dart';
import 'split.dart';

RailModule? _railModuleOf(HomeModule m) => switch (m) {
  HomeModule.home => RailModule.home,
  HomeModule.tasks => RailModule.tasks,
  HomeModule.calendar => RailModule.calendar,
  HomeModule.coordinatorships => RailModule.coordinatorships,
  HomeModule.meetings => RailModule.meetings,
  HomeModule.archive => RailModule.archive,
  HomeModule.messages => RailModule.messages,
  HomeModule.sheets => RailModule.tables,
  HomeModule.users || HomeModule.team => RailModule.users,
  _ => null,
};

/// Uygulamanın tablet rayı: modüller, Mesajlar rozeti, bildirim zili, tüm modüller menüsü,
/// asistan. Kabuk ve tam ekran zaman çizelgesi aynı rayı kullanır.
class AppTabletRail extends ConsumerWidget {
  const AppTabletRail({
    super.key,
    required this.current,
    required this.onSelect,
  });

  /// Etkin modül (null → yok).
  final RailModule? current;
  final ValueChanged<RailModule> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final bell = watchNotificationBell(context, ref);
    final unread = ref.watch(messagesNavBadgeProvider);
    final view = ref.watch(effectiveAccessProvider);
    final role = view.known ? view.role : null;
    // Ray öğeleri menü tanımından ([railModulesFor]); etkin rol dışı modül rayda yok.
    final modules = [for (final m in railModulesFor(role)) ?_railModuleOf(m)];
    NzRailItem item(RailModule m) => switch (m) {
      RailModule.home => NzRailItem(
        icon: NzIcons.home,
        selectedIcon: NzIcons.homeFilled,
        label: l.uiRouterTabHome,
      ),
      RailModule.tasks => NzRailItem(
        icon: NzIcons.tasks,
        label: role == EffectiveRole.member
            ? l.homeModuleLabel(HomeModule.tasks, role)
            : l.uiRouterTabTasks,
      ),
      RailModule.calendar => NzRailItem(
        icon: NzIcons.calendar,
        selectedIcon: NzIcons.calendarFilled,
        label: l.uiHomeModuleCalendar,
      ),
      RailModule.coordinatorships => NzRailItem(
        icon: NzIcons.coordinatorships,
        label: l.uiRouterTabCoordinatorships,
      ),
      RailModule.archive => NzRailItem(
        icon: NzIcons.folder,
        selectedIcon: NzIcons.folderFilled,
        label: role == EffectiveRole.member
            ? l.homeModuleLabel(HomeModule.archive, role)
            : l.uiRouterTabArchive,
      ),
      RailModule.messages => NzRailItem(
        icon: NzIcons.messages,
        selectedIcon: NzIcons.messagesFilled,
        label: l.uiRouterTabMessages,
        badge: unread,
      ),
      RailModule.meetings => NzRailItem(
        icon: NzIcons.event,
        label: l.uiHomeModuleMeetings,
      ),
      RailModule.users => NzRailItem(
        icon: NzIcons.group,
        label: role == null || role == EffectiveRole.admin
            ? l.uiHomeModuleUsers
            : l.uiHomeModuleTeam,
      ),
      RailModule.tables => NzRailItem(
        icon: NzIcons.sheets,
        label: l.uiHomeModuleSheets,
      ),
    };
    final index = current == null ? -1 : modules.indexOf(current!);
    return NzTabletRail(
      semanticLabel: l.uiRouterNavLabel,
      brand: NzBrandMark(
        monogram: l.uiHomeAppName.characters.first,
        extent: NzTabletMetrics.railBrand,
      ),
      items: [for (final m in modules) item(m)],
      currentIndex: index < 0 ? null : index,
      onSelect: (i) => onSelect(modules[i]),
      bellLabel: bell.label,
      bellDot: bell.dot,
      menuLabel: l.uiRouterAllModules,
      onMenu: () => context.appNav.openMenu(context),
      assistantLabel: l.uiRouterAssistant,
      onBell: () => unawaited(showNotifications(context)),
      onAssistant: () => NzToast.show(context, l.uiRouterAssistantSoon),
    );
  }
}
