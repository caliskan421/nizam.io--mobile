import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/layout/layout.dart';
import '../../core/ui/page/nz_app_nav.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../core/ui/widgets/navigation/nz_tablet_rail.dart';
import '../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../core/ui/widgets/nz_icons.dart';
import '../../features/messages/messages.dart';
import '../../features/notifications/notifications.dart';
import 'split.dart';

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
    return NzTabletRail(
      semanticLabel: l.uiRouterNavLabel,
      brand: NzBrandMark(
        monogram: l.uiHomeAppName.characters.first,
        extent: NzTabletMetrics.railBrand,
      ),
      items: [
        NzRailItem(
          icon: NzIcons.home,
          selectedIcon: NzIcons.homeFilled,
          label: l.uiRouterTabHome,
        ),
        NzRailItem(icon: NzIcons.tasks, label: l.uiRouterTabTasks),
        NzRailItem(
          icon: NzIcons.calendar,
          selectedIcon: NzIcons.calendarFilled,
          label: l.uiHomeModuleCalendar,
        ),
        NzRailItem(
          icon: NzIcons.coordinatorships,
          label: l.uiRouterTabCoordinatorships,
        ),
        NzRailItem(
          icon: NzIcons.folder,
          selectedIcon: NzIcons.folderFilled,
          label: l.uiRouterTabArchive,
        ),
        NzRailItem(
          icon: NzIcons.messages,
          selectedIcon: NzIcons.messagesFilled,
          label: l.uiRouterTabMessages,
          badge: unread,
        ),
      ],
      currentIndex: current?.railIndex,
      onSelect: (i) => onSelect(RailModule.values[i]),
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
