import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/administration/domain/program_admin_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

class _Organization implements OrganizationAdminRepository {
  @override
  Future<PageSlice<KnownUser>> listUsers({
    PageRequest page = const PageRequest(),
    dynamic role,
    String? search,
    dynamic sortBy,
    dynamic sortOrder,
  }) async => PageSlice(
    items: [
      KnownUser(
        accountId: page.cursor ?? 'first',
        fullName: 'Kullanıcı',
        memberships: const [],
      ),
    ],
    nextCursor: page.cursor == null ? 'next' : null,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Program implements ProgramAdminRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('kullanıcı sayfalama mevcut satırları korur', () async {
    final container = moduleContainer(
      overrides: [
        organizationAdminRepositoryProvider.overrideWithValue(_Organization()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(adminUsersProvider, (_, _) {});
    await container.read(adminUsersProvider.future);
    await container.read(adminUsersProvider.notifier).loadMore();
    expect(
      container
          .read(adminUsersProvider)
          .requireValue
          .items
          .map((u) => u.accountId),
      ['first', 'next'],
    );
  });
  test(
    'yönetim komutu tek uçuşludur, admin olmayan hesap çağrı yapamaz',
    () async {
      final container = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(
            _Organization(),
          ),
          programAdminRepositoryProvider.overrideWithValue(_Program()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(taskCatalogControllerProvider.future);
      container.listen(adminCommandProvider, (_, _) {});
      final pending = Completer<void>();
      var calls = 0;
      final controller = container.read(adminCommandProvider.notifier);
      final call = controller.run((o, p) {
        calls++;
        return pending.future;
      });
      await controller.run((o, p) async {
        calls++;
      });
      expect(calls, 1);
      pending.complete();
      await call;
      final member = moduleContainer(catalog: moduleCatalog(admin: false));
      addTearDown(member.dispose);
      await member.read(taskCatalogControllerProvider.future);
      await expectLater(
        member.read(adminCommandProvider.notifier).run((o, p) async {
          fail('yetkisiz çağrı');
        }),
        throwsA(isA<ApiError>()),
      );
    },
  );
}
