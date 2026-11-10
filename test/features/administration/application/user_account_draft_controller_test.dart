import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/administration/application/user_account_draft_controller.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/scope/scope.dart';

import '../../connected_module_support.dart';

void main() {
  test('yüklü ekipler seçili programa iner ve kirli taslak yeniden okumada korunur', () {
    final c = moduleContainer();
    addTearDown(c.dispose);
    final provider = userAccountDraftProvider('u1');
    c.listen(provider, (_, _) {});
    final ctl = c.read(provider.notifier);
    final user = KnownUser(
      accountId: 'u1',
      fullName: 'İlk',
      memberships: const [],
      teams: const [
        UserMembership(
          programId: 'program',
          departmentId: 'd1',
          role: DepartmentRole.member,
        ),
        UserMembership(
          programId: 'other',
          departmentId: 'd2',
          role: DepartmentRole.coordinator,
        ),
      ],
    );
    ctl.initialize(user, email: 'a@b.test', companyAdmin: false);
    expect(c.read(provider)!.value.teams.single.departmentId, 'd1');
    ctl.setFullName('Yeni');
    ctl.initialize(user, email: 'b@b.test', companyAdmin: false);
    expect(c.read(provider)!.value.fullName, 'Yeni');
    expect(c.read(provider)!.value.email, 'a@b.test');
    expect(c.read(provider)!.dirty, isTrue);
  });
}
