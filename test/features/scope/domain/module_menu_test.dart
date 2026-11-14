// Menü tek tanımı: rol başına gruplar, ray ve alt kapsül yuvası (referans-envanteri §3.2–3.3).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/features/scope/domain/module_menu.dart';

/// Satır = [grup, ...modüller] (iç içe liste derin karşılaştırılır).
List<List<Object>> _table(EffectiveRole? r) => [
  for (final g in modulesFor(r)) [g.kind, ...g.modules],
];

void main() {
  const k = ModuleGroupKind.tracking;
  const c = ModuleGroupKind.content;

  test('koordinatör menüsü', () {
    expect(_table(EffectiveRole.coordinator), [
      [k, HomeModule.home, HomeModule.tasks, HomeModule.calendar],
      [
        c,
        HomeModule.meetings,
        HomeModule.archive,
        HomeModule.messages,
        HomeModule.sheets,
      ],
      [ModuleGroupKind.team, HomeModule.team],
      [ModuleGroupKind.footer, HomeModule.help],
    ]);
  });

  test('üye menüsü', () {
    expect(_table(EffectiveRole.member), [
      [
        k,
        HomeModule.home,
        HomeModule.tasks,
        HomeModule.calendar,
        HomeModule.timeline,
      ],
      [c, HomeModule.meetings, HomeModule.archive, HomeModule.messages],
      [ModuleGroupKind.team, HomeModule.team],
      [ModuleGroupKind.footer, HomeModule.help],
    ]);
  });

  test('yönetici bugünkü menü; bilinmeyen rolde yönetime özgü öğe yok', () {
    final admin = menuModulesOf(EffectiveRole.admin);
    expect(admin, containsAll([HomeModule.users, HomeModule.deleted]));
    expect(admin, isNot(contains(HomeModule.team)));
    expect(
      menuModulesOf(null),
      admin.difference({HomeModule.users, HomeModule.deleted}),
    );
    for (final r in [EffectiveRole.coordinator, EffectiveRole.member]) {
      expect(
        menuModulesOf(r).intersection({
          HomeModule.users,
          HomeModule.deleted,
          HomeModule.coordinatorships,
          HomeModule.simulation,
          HomeModule.memory,
        }),
        isEmpty,
        reason: '$r',
      );
    }
  });

  test('ray menüden süzülür', () {
    const adminRail = [
      HomeModule.home,
      HomeModule.tasks,
      HomeModule.calendar,
      HomeModule.coordinatorships,
      HomeModule.archive,
      HomeModule.messages,
    ];
    expect(railModulesFor(EffectiveRole.admin), adminRail);
    expect(railModulesFor(null), adminRail);
    expect(railModulesFor(EffectiveRole.coordinator), [
      HomeModule.home,
      HomeModule.tasks,
      HomeModule.calendar,
      HomeModule.meetings,
      HomeModule.archive,
      HomeModule.messages,
      HomeModule.sheets,
      HomeModule.team,
    ]);
    expect(railModulesFor(EffectiveRole.member), [
      HomeModule.home,
      HomeModule.tasks,
      HomeModule.calendar,
      HomeModule.meetings,
      HomeModule.archive,
      HomeModule.messages,
      HomeModule.team,
    ]);
  });

  test('alt kapsül yuvası: varsayılan ve adaylar', () {
    expect(defaultSlotFor(EffectiveRole.coordinator), HomeModule.team);
    expect(defaultSlotFor(EffectiveRole.member), HomeModule.team);
    expect(defaultSlotFor(EffectiveRole.admin), HomeModule.coordinatorships);
    expect(defaultSlotFor(null), HomeModule.coordinatorships);
    for (final r in [null, ...EffectiveRole.values]) {
      expect(slotModulesFor(r), contains(defaultSlotFor(r)), reason: '$r');
      expect(slotModulesFor(r), isNot(contains(HomeModule.home)));
    }
    expect(
      slotModulesFor(EffectiveRole.coordinator),
      isNot(contains(HomeModule.coordinatorships)),
    );
  });
}
