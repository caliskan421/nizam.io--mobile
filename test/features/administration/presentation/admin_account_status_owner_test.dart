import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/administration/presentation/admin_user_account_operations.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../connected_module_support.dart';

class _Repository implements OrganizationAdminRepository {
  int disabled = 0;
  @override
  Future<AccountStatusChange> disableAccount(String accountId) async {
    disabled++;
    return const AccountStatusChange(
      status: AccountStatus.disabled,
      changed: true,
      revokedSessions: 1,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'onay sırasında departman değişirse eski hesap için yazma gönderilmez',
    (tester) async {
      final repo = _Repository();
      final container = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      container.listen(taskCatalogControllerProvider, (_, _) {});
      await container.read(taskCatalogControllerProvider.future);
      final user = KnownUser(
        accountId: 'another',
        fullName: 'Kişi',
        memberships: const [],
        accountStatus: AccountStatus.active,
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: testApp(AdminUserAccountOperations(user: user)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hesabı kapat'));
      await tester.pumpAndSettle();
      container.read(scopeControllerProvider).selectDepartment('other');
      await tester.tap(find.text('Onayla'));
      await tester.pumpAndSettle();
      expect(repo.disabled, 0);
    },
  );
}
