import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/domain/effective_role.dart';
import '../../core/i18n/generated/app_localizations.dart';
import '../../core/ui/widgets/nz_icons.dart';
import '../../features/activity/activity.dart';
import '../../features/administration/administration.dart';
import '../../features/archive/archive.dart';
import '../../features/coordinatorships/coordinatorships.dart';
import '../../features/meetings/meetings.dart';
import '../../features/messages/messages.dart';
import '../../features/scope/scope.dart';
import '../../features/tasks/tasks.dart';
import 'routes.dart';

/// Alt menünün üçüncü öğesi: son girilen modül (README "Gezinme"). Üçü aynı kabuk dalındadır.
enum ShellModule {
  coordinatorships,
  archive,
  messages,
  calendar,
  meetings,
  users,
  tables,
}

/// Alt menü öğesinin görünümü (simge, etiket, etkinken alt yazı).
@immutable
class NzShellTab {
  const NzShellTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.caption,
    this.wide = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? caption;

  /// Uzun etiket (Koordinatörlükler): etkinken kapsül öğesi genişler.
  final bool wide;
}

/// Konumdan modül (modül dalı dışında null).
ShellModule? moduleOf(String location) {
  if (location.startsWith(const CoordinatorshipsRoute().location)) {
    return ShellModule.coordinatorships;
  }
  if (location.startsWith(const ArchiveRoute().location)) {
    return ShellModule.archive;
  }
  if (location.startsWith(const MessagesRoute().location)) {
    return ShellModule.messages;
  }
  if (location.startsWith(const CalendarRoute().location)) {
    return ShellModule.calendar;
  }
  if (location.startsWith(const MeetingsRoute().location)) {
    return ShellModule.meetings;
  }
  if (location.startsWith(const UsersRoute().location)) {
    return ShellModule.users;
  }
  if (location.startsWith(const TablesRoute().location)) {
    return ShellModule.tables;
  }
  return null;
}

/// Yuvanın modülü: son girilen modül etkin rolün menüsündeyse o, değilse rolün varsayılanı
/// ([defaultSlotFor]; Koordinatör ve Üye → Ekibim, Yönetici → Koordinatörlükler). Yuva adayları
/// menü tanımından süzülür ([slotModulesFor]).
ShellModule shellSlotFor(ShellModule? last, EffectiveRole? role) {
  final allowed = {for (final m in slotModulesFor(role)) ?_shellModuleOf(m)};
  if (last != null && allowed.contains(last)) return last;
  return _shellModuleOf(defaultSlotFor(role)) ?? ShellModule.coordinatorships;
}

ShellModule? _shellModuleOf(HomeModule m) => switch (m) {
  HomeModule.coordinatorships => ShellModule.coordinatorships,
  HomeModule.archive => ShellModule.archive,
  HomeModule.messages => ShellModule.messages,
  HomeModule.calendar => ShellModule.calendar,
  HomeModule.meetings => ShellModule.meetings,
  HomeModule.users || HomeModule.team => ShellModule.users,
  HomeModule.sheets => ShellModule.tables,
  _ => null,
};

/// Kabuk sekmeleri (sıra `routes.dart` dal sırasıyla birebir). Etiket ve alt yazı konuma, etkin
/// role ([role]; Üye → "Görevlerim", Koordinatör/Üye → "Ekibim") ve modüllerin özet
/// sağlayıcılarına göre.
List<NzShellTab> shellTabsFor(
  AppLocalizations l, {
  required String location,
  required ShellModule module,
  required WidgetRef ref,
  EffectiveRole? role,
}) {
  final inHistory = location.startsWith(const HistoryRoute().location);
  // Her zaman izlenir: işlem geçmişi kayıtları kabukla birlikte yüklenir (keepAlive), sayfaya
  // ilk girişte liste ilk karede dolu gelir (yükleniyor karesi/titreme yok).
  final historyCaption = ref.watch(activityNavCaptionProvider);
  return [
    NzShellTab(
      icon: NzIcons.home,
      selectedIcon: NzIcons.homeFilled,
      label: inHistory ? l.uiRouterTabHistory : l.uiRouterTabHome,
      caption: inHistory ? historyCaption : l.uiRouterTabHomeCaption,
    ),
    NzShellTab(
      icon: NzIcons.tasks,
      selectedIcon: NzIcons.tasks,
      label: role == EffectiveRole.member
          ? l.homeModuleLabel(HomeModule.tasks, role)
          : l.uiRouterTabTasks,
      caption: ref.watch(tasksNavCaptionProvider),
    ),
    switch (module) {
      ShellModule.users => NzShellTab(
        icon: NzIcons.group,
        selectedIcon: NzIcons.group,
        label: role == null || role == EffectiveRole.admin
            ? l.uiHomeModuleUsers
            : l.uiHomeModuleTeam,
        caption: ref.watch(adminUsersNavCaptionProvider),
      ),
      ShellModule.tables => NzShellTab(
        icon: NzIcons.sheets,
        selectedIcon: NzIcons.sheets,
        label: l.uiHomeModuleSheets,
      ),
      ShellModule.coordinatorships => NzShellTab(
        icon: NzIcons.coordinatorships,
        selectedIcon: NzIcons.coordinatorships,
        label: l.uiRouterTabCoordinatorships,
        caption: ref.watch(coordinatorshipsNavCaptionProvider),
        wide: true,
      ),
      ShellModule.archive => NzShellTab(
        icon: NzIcons.folder,
        selectedIcon: NzIcons.folderFilled,
        label: l.uiRouterTabArchive,
        caption: ref.watch(archiveNavCaptionProvider),
      ),
      ShellModule.messages => NzShellTab(
        icon: NzIcons.messages,
        selectedIcon: NzIcons.messagesFilled,
        label: l.uiRouterTabMessages,
        caption: ref.watch(messagesNavCaptionProvider),
      ),
      ShellModule.calendar => NzShellTab(
        icon: NzIcons.calendar,
        selectedIcon: NzIcons.calendarFilled,
        label: l.uiHomeModuleCalendar,
      ),
      ShellModule.meetings => NzShellTab(
        icon: NzIcons.event,
        selectedIcon: NzIcons.event,
        label: l.uiHomeModuleMeetings,
        caption: ref.watch(meetingsNavCaptionProvider),
      ),
    },
  ];
}
