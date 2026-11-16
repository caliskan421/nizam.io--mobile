import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/features/administration/domain/admin_user_directory.dart';
import 'package:nizamio/features/administration/domain/team_view.dart';

void main() {
  group('teamSourceFor (rol → veri kaynağı)', () {
    for (final (known, role, dept, expected) in [
      (true, EffectiveRole.admin, null, TeamSource.directory),
      (true, EffectiveRole.admin, 'd1', TeamSource.directory),
      (true, EffectiveRole.coordinator, 'd1', TeamSource.departmentMembers),
      (true, EffectiveRole.member, 'd1', TeamSource.departmentGroup),
      (true, EffectiveRole.coordinator, null, TeamSource.none),
      (true, EffectiveRole.member, '', TeamSource.none),
      (false, EffectiveRole.admin, null, TeamSource.none),
      (false, EffectiveRole.coordinator, 'd1', TeamSource.none),
    ]) {
      test('known=$known $role dept=$dept → $expected', () {
        expect(
          teamSourceFor(known: known, role: role, departmentId: dept),
          expected,
        );
      });
    }

    test('yalnız koordinatör ekleyebilir; üye listesi türetilmiş', () {
      expect(
        [for (final s in TeamSource.values) s.canAddMembers],
        [false, true, false, false],
      );
      expect(
        [for (final s in TeamSource.values) s.derived],
        [false, false, true, false],
      );
      expect(
        [for (final s in TeamSource.values) s.countsLoad],
        [false, true, false, false],
      );
    });
  });

  group('kullanıcı ayrıntısı sekme kümesi', () {
    test('yönetici dört sekme; koordinatörde Hesap ve Geçmiş yok', () {
      expect(TeamSource.directory.profileTabs, UserProfileTab.values);
      expect(TeamSource.departmentMembers.profileTabs, [
        UserProfileTab.tasks,
        UserProfileTab.files,
      ]);
      expect(TeamSource.departmentGroup.profileTabs, [UserProfileTab.tasks]);
      expect(TeamSource.none.profileTabs, isEmpty);
    });
  });

  group('Ekipten çıkar yetkisi', () {
    const member = TeamPerson(accountId: 'u1', name: 'Üye', lead: false);
    const lead = TeamPerson(accountId: 'k1', name: 'Koord', lead: true);

    test('koordinatör görünümü üyeyi çıkarabilir', () {
      expect(
        canRemoveFromTeam(TeamSource.departmentMembers, member, me: 'k1'),
        isTrue,
      );
    });

    test('koordinatör satırı, kendisi ve bilinmeyen kişi çıkarılamaz', () {
      expect(
        canRemoveFromTeam(TeamSource.departmentMembers, lead, me: 'x'),
        isFalse,
      );
      expect(
        canRemoveFromTeam(TeamSource.departmentMembers, member, me: 'u1'),
        isFalse,
      );
      expect(
        canRemoveFromTeam(TeamSource.departmentMembers, null, me: 'k1'),
        isFalse,
      );
    });

    test('yönetici dizini, üye görünümü ve bilinmeyen kaynakta yok', () {
      for (final s in [
        TeamSource.directory,
        TeamSource.departmentGroup,
        TeamSource.none,
      ]) {
        expect(canRemoveFromTeam(s, member, me: 'k1'), isFalse, reason: '$s');
      }
    });
  });

  group('TeamRoster', () {
    final roster = TeamRoster(
      source: TeamSource.departmentMembers,
      departmentId: 'd1',
      people: const [
        TeamPerson(accountId: 'u2', name: 'Zeynep', lead: false),
        TeamPerson(accountId: 'k1', name: 'Şule', lead: true),
        TeamPerson(accountId: 'u1', name: 'İlker', lead: false),
      ],
    );

    test('önce koordinatörler, sonra Türkçe ad sırası', () {
      expect([for (final p in roster.people) p.accountId], ['k1', 'u1', 'u2']);
    });

    test('rol bölücüsü sayıları ve süzgeç', () {
      expect([for (final r in teamRoleFilters) roster.countFor(r)], [3, 1, 2]);
      expect(
        [
          for (final p in roster.filter(role: AdminUserRoleFilter.member))
            p.accountId,
        ],
        ['u1', 'u2'],
      );
      expect(
        [for (final p in roster.filter(search: 'şu')) p.accountId],
        ['k1'],
      );
      expect(roster.filter(search: 'ilk').single.accountId, 'u1');
    });
  });
}
