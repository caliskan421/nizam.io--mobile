import 'package:meta/meta.dart';

import '../../../core/domain/effective_role.dart';

/// Uygulama modülü: çekmece satırı, tablet rayı öğesi ve telefon alt kapsülü yuvasının hedefi
/// (ekranı olmayanlar yer tutucu toast'a düşer).
enum HomeModule {
  home,
  tasks,
  calendar,

  /// Zaman çizelgem (Üye; mevcut zaman çizelgesi rotası).
  timeline,
  memory,
  archive,
  meetings,
  messages,
  sheets,
  users,

  /// Ekibim (Koordinatör, Üye): hedef rota Kullanıcılar sayfasıdır (rol kapısı/içeriği sayfa
  /// paketinde).
  team,
  coordinatorships,
  season,
  simulation,
  deleted,
  help,
  assistant,
}

/// Çekmece grubu (başlık metni sunumda).
enum ModuleGroupKind { tracking, content, admin, team, lab, footer }

/// Çekmecenin bir grubu: başlık türü + sıralı modüller. [ModuleGroupKind.footer] başlıksızdır;
/// "Çıkış yap" satırı modül değildir, sunum her zaman sona ekler.
@immutable
final class ModuleGroup {
  const ModuleGroup(this.kind, this.modules);
  final ModuleGroupKind kind;
  final List<HomeModule> modules;
}

/// Rolün menüsü: TEK tanım (referans-envanteri §3.2). Çekmece, tablet rayı ([railModulesFor])
/// ve telefon alt kapsülü yuvası ([slotModulesFor]) bundan süzülür. Uygulamada olmayan modül
/// ve "yakında" öğesi eklenmez (Yönetici menüsü bugünkü menüdür).
///
/// [role] `null`: erişim henüz bilinmiyor (katalog yüklenmedi) → bugünkü genel menü, yönetime
/// özgü öğeler (Kullanıcılar, Silinen kayıtlar) olmadan (fail-closed).
List<ModuleGroup> modulesFor(EffectiveRole? role) => switch (role) {
  EffectiveRole.admin || null => [
    const ModuleGroup(ModuleGroupKind.tracking, [
      HomeModule.home,
      HomeModule.tasks,
      HomeModule.calendar,
    ]),
    const ModuleGroup(ModuleGroupKind.content, [
      HomeModule.memory,
      HomeModule.assistant,
      HomeModule.archive,
      HomeModule.meetings,
      HomeModule.messages,
      HomeModule.sheets,
    ]),
    ModuleGroup(ModuleGroupKind.admin, [
      if (role == EffectiveRole.admin) HomeModule.users,
      HomeModule.coordinatorships,
    ]),
    const ModuleGroup(ModuleGroupKind.lab, [HomeModule.simulation]),
    ModuleGroup(ModuleGroupKind.footer, [
      if (role == EffectiveRole.admin) HomeModule.deleted,
      HomeModule.help,
    ]),
  ],
  EffectiveRole.coordinator => const [
    ModuleGroup(ModuleGroupKind.tracking, [
      HomeModule.home,
      HomeModule.tasks,
      HomeModule.calendar,
    ]),
    ModuleGroup(ModuleGroupKind.content, [
      HomeModule.meetings,
      HomeModule.archive,
      HomeModule.messages,
      HomeModule.sheets,
    ]),
    ModuleGroup(ModuleGroupKind.team, [HomeModule.team]),
    ModuleGroup(ModuleGroupKind.footer, [HomeModule.help]),
  ],
  EffectiveRole.member => const [
    ModuleGroup(ModuleGroupKind.tracking, [
      HomeModule.home,
      HomeModule.tasks,
      HomeModule.calendar,
      HomeModule.timeline,
    ]),
    ModuleGroup(ModuleGroupKind.content, [
      HomeModule.meetings,
      HomeModule.archive,
      HomeModule.messages,
    ]),
    ModuleGroup(ModuleGroupKind.team, [HomeModule.team]),
    ModuleGroup(ModuleGroupKind.footer, [HomeModule.help]),
  ],
};

/// Rolün menüsündeki bütün modüller (sırasız küme).
Set<HomeModule> menuModulesOf(EffectiveRole? role) => {
  for (final g in modulesFor(role)) ...g.modules,
};

const _railOrder = [
  HomeModule.home,
  HomeModule.tasks,
  HomeModule.calendar,
  HomeModule.coordinatorships,
  HomeModule.meetings,
  HomeModule.archive,
  HomeModule.messages,
  HomeModule.sheets,
  HomeModule.team,
];

/// Tablet rayının öğeleri (sıra): menüdeki modüllerden rayda yeri olanlar. Yönetici (ve
/// bilinmeyen) rayı bugünkü altı modüldür; Toplantılar ve Tablolar onda çekmeceden girilir.
List<HomeModule> railModulesFor(EffectiveRole? role) {
  final menu = menuModulesOf(role);
  final drawerOnly = role == EffectiveRole.admin || role == null;
  return [
    for (final m in _railOrder)
      if (menu.contains(m) &&
          !(drawerOnly && (m == HomeModule.meetings || m == HomeModule.sheets)))
        m,
  ];
}

const _slotCandidates = {
  HomeModule.coordinatorships,
  HomeModule.archive,
  HomeModule.messages,
  HomeModule.calendar,
  HomeModule.meetings,
  HomeModule.users,
  HomeModule.team,
  HomeModule.sheets,
};

/// Telefon alt kapsülünün üçüncü yuvasına girebilen modüller (son girilen modül yuvaya
/// yerleşir): menüdeki yuva adayları.
Set<HomeModule> slotModulesFor(EffectiveRole? role) =>
    menuModulesOf(role).intersection(_slotCandidates);

/// Yuvanın varsayılanı (henüz modül girilmemişken): Koordinatör ve Üye → Ekibim; Yönetici (ve
/// bilinmeyen) → Koordinatörlükler (prototip varsayılanı).
HomeModule defaultSlotFor(EffectiveRole? role) => switch (role) {
  EffectiveRole.coordinator || EffectiveRole.member => HomeModule.team,
  EffectiveRole.admin || null => HomeModule.coordinatorships,
};
