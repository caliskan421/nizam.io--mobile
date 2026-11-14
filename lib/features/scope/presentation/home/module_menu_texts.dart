import 'package:flutter/widgets.dart';

import '../../../../core/domain/effective_role.dart';
import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../tasks/tasks.dart';
import '../../domain/module_menu.dart';

/// Modül menüsünün ve etkin görünümün metin, simge ve renk eşlemesi (tek yer): çekmece, ray,
/// alt kapsül ve "yakında" toast'ı buradan okur.
extension ModuleMenuTexts on AppLocalizations {
  /// Modül satırı etiketi; Üye görünümünde "Görevlerim" ve "Dosyalarım".
  String homeModuleLabel(HomeModule m, [EffectiveRole? role]) {
    final member = role == EffectiveRole.member;
    return switch (m) {
      HomeModule.home => uiHomeModuleHome,
      HomeModule.tasks => member ? uiHomeModuleMyTasks : uiHomeModuleTasks,
      HomeModule.calendar => uiHomeModuleCalendar,
      HomeModule.timeline => uiHomeModuleMyTimeline,
      HomeModule.memory => uiHomeModuleMemory,
      HomeModule.archive => member ? uiHomeModuleMyFiles : uiHomeModuleArchive,
      HomeModule.meetings => uiHomeModuleMeetings,
      HomeModule.messages => uiHomeModuleMessages,
      HomeModule.sheets => uiHomeModuleSheets,
      HomeModule.users => uiHomeModuleUsers,
      HomeModule.team => uiHomeModuleTeam,
      HomeModule.coordinatorships => uiHomeCoordinatorships,
      HomeModule.season => uiHomeModuleSeason,
      HomeModule.simulation => uiHomeModuleSimulation,
      HomeModule.deleted => uiHomeDeletedRecords,
      HomeModule.help => uiHomeHelp,
      HomeModule.assistant => uiHomeModuleAssistant,
    };
  }

  /// Grup başlığı; alt grup başlıksız (`null`).
  String? moduleGroupLabel(ModuleGroupKind kind) => switch (kind) {
    ModuleGroupKind.tracking => uiHomeGroupTracking,
    ModuleGroupKind.content => uiHomeGroupContent,
    ModuleGroupKind.admin => uiHomeGroupAdmin,
    ModuleGroupKind.team => uiHomeGroupTeam,
    ModuleGroupKind.lab => uiHomeGroupLab,
    ModuleGroupKind.footer => null,
  };

  /// Seçicideki rol adı ("Yönetici", "Koordinatör", "Üye").
  String effectiveRoleLabel(EffectiveRole r) => switch (r) {
    EffectiveRole.admin => uiHomeViewRoleAdmin,
    EffectiveRole.coordinator => uiHomeRoleCoordinator,
    EffectiveRole.member => uiHomeRoleMember,
  };

  /// Rol listesindeki açıklama.
  String effectiveRoleDescription(EffectiveRole r) => switch (r) {
    EffectiveRole.admin => uiHomeRoleAdminDesc,
    EffectiveRole.coordinator => uiHomeRoleCoordinatorDesc,
    EffectiveRole.member => uiHomeRoleMemberDesc,
  };

  /// Etkin görünüm başlığı ve rol değişimi toast'ı: "Koordinatör · Altyapı ve tesisat";
  /// yöneticide (ya da koordinatörlük adı bilinmiyorsa) yalnız rol.
  String viewCaption(EffectiveAccess view) =>
      [effectiveRoleLabel(view.role), ?view.departmentName].join(' · ');
}

/// Modül simgesi.
IconData homeModuleIcon(HomeModule m) => switch (m) {
  HomeModule.home => NzIcons.home,
  HomeModule.tasks => NzIcons.tasks,
  HomeModule.calendar => NzIcons.calendarMonth,
  HomeModule.timeline => NzIcons.timeline,
  HomeModule.memory || HomeModule.assistant => NzIcons.idea,
  HomeModule.archive => NzIcons.folder,
  HomeModule.meetings => NzIcons.video,
  HomeModule.messages => NzIcons.mail,
  HomeModule.sheets => NzIcons.sheets,
  HomeModule.users || HomeModule.team => NzIcons.group,
  HomeModule.coordinatorships => NzIcons.coordinatorships,
  HomeModule.season => NzIcons.calendar,
  HomeModule.simulation => NzIcons.science,
  HomeModule.deleted => NzIcons.delete,
  HomeModule.help => NzIcons.help,
};

/// Rol rengi (tema jetonu; nokta ve seçili kart kenarlığı).
Color effectiveRoleColor(NizamioColors c, EffectiveRole r) => switch (r) {
  EffectiveRole.admin => c.roleAdmin,
  EffectiveRole.coordinator => c.roleCoordinator,
  EffectiveRole.member => c.roleMember,
};
