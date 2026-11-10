import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/domain/admin_user_directory.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/scope/scope.dart';

import '../../connected_module_support.dart';

class _Repository implements OrganizationAdminRepository {
  final calls =
      <
        ({
          String? search,
          DepartmentRole? role,
          bool admin,
          String? program,
          String? department,
          String? cursor,
        })
      >[];
  Future<UserDirectoryPage> Function(String?, String?)? load;
  ApiError? failure;
  @override
  Future<UserDirectoryPage> listUsers({
    PageRequest page = const PageRequest(),
    DepartmentRole? role,
    bool companyAdminOnly = false,
    String? programId,
    String? departmentId,
    String? search,
    UserSortField? sortBy,
    SortDirection? sortOrder,
  }) async {
    calls.add((
      search: search,
      role: role,
      admin: companyAdminOnly,
      program: programId,
      department: departmentId,
      cursor: page.cursor,
    ));
    if (failure case final error?) throw error;
    return load?.call(search, page.cursor) ?? _page();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UserDirectoryPage _page({
  List<KnownUser> items = const [],
  String? cursor,
  int total = 1,
}) => UserDirectoryPage(
  items: items,
  nextCursor: cursor,
  total: total,
  roleCounts: const UserRoleCounts(
    all: 3,
    admins: 1,
    coordinators: 2,
    members: 2,
  ),
);

void main() {
  test(
    'şirket geneli ve örtüşen rol sayıları filtreli totalden ayrıdır',
    () async {
      final repo = _Repository();
      final c = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      c.listen(adminUsersProvider, (_, _) {});
      c.listen(adminUsersSummaryProvider, (_, _) {});
      await c.read(adminUsersProvider.future);
      expect(repo.calls, hasLength(1));
      expect(repo.calls.single.program, isNull);
      final q = c.read(adminUserQueryProvider);
      c.read(adminUserQueryProvider.notifier).set((
        search: '',
        role: AdminUserRoleFilter.admin,
        sort: q.sort,
        direction: q.direction,
      ));
      await c.read(adminUsersProvider.future);
      expect(repo.calls, hasLength(2));
      expect(repo.calls.last.admin, isTrue);
      final s = c.read(adminUsersSummaryProvider)!;
      expect(
        (
          s.total.value,
          s.all.value,
          s.admins!.value,
          s.coordinators.value,
          s.members.value,
        ),
        (1, 3, 1, 2, 2),
      );
    },
  );
  test('departman seçimi program ile sunucuya gider', () async {
    final repo = _Repository();
    final c = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    await c.read(adminUsersProvider.future);
    c.read(adminUserDepartmentsProvider.notifier).toggle('department');
    await c.read(adminUsersProvider.future);
    expect(repo.calls, hasLength(2));
    expect(
      (repo.calls.last.program, repo.calls.last.department),
      ('program', 'department'),
    );
  });
  test('boş sayfa dolu imleçle devam eder', () async {
    final repo = _Repository()
      ..load = (_, cursor) async => cursor == null
          ? _page(cursor: 'next')
          : _page(
              items: [
                KnownUser(
                  accountId: 'u1',
                  fullName: 'Ad',
                  memberships: const [],
                ),
              ],
            );
    final c = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    expect((await c.read(adminUsersProvider.future)).items, isEmpty);
    await c.read(adminUsersProvider.notifier).loadMore();
    expect(repo.calls, hasLength(2));
    expect(repo.calls.last.cursor, 'next');
    expect(
      c.read(adminUsersProvider).requireValue.items.single.accountId,
      'u1',
    );
  });
  test('gecikmiş eski sorgu sonucu yeni sorguya uygulanmaz', () async {
    final old = Completer<UserDirectoryPage>();
    final started = Completer<void>();
    final repo = _Repository()
      ..load = (search, _) {
        if (search == null) {
          started.complete();
          return old.future;
        }
        return Future.value(
          _page(
            items: [
              KnownUser(
                accountId: 'new',
                fullName: 'Yeni',
                memberships: const [],
              ),
            ],
          ),
        );
      };
    final c = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    final first = c.read(adminUsersProvider.future);
    await started.future.timeout(const Duration(seconds: 5));
    final q = c.read(adminUserQueryProvider);
    c.read(adminUserQueryProvider.notifier).set((
      search: 'Yeni',
      role: q.role,
      sort: q.sort,
      direction: q.direction,
    ));
    expect(
      (await c.read(adminUsersProvider.future)).items.single.accountId,
      'new',
    );
    old.complete(
      _page(
        items: [
          KnownUser(accountId: 'old', fullName: 'Eski', memberships: const []),
        ],
      ),
    );
    await first;
    expect(
      c
          .read(adminUsersProvider.notifier)
          .visible
          .requireValue
          .items
          .single
          .accountId,
      'new',
    );
    expect(repo.calls, hasLength(2));
  });
  test('yetki kaybı eski dizini gizler', () async {
    final repo = _Repository();
    final c = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    await c.read(adminUsersProvider.future);
    repo.failure = ApiError('organization.not_authorized', status: 403);
    await expectLater(
      c.read(adminUsersProvider.notifier).refresh(),
      throwsA(isA<ApiError>()),
    );
    expect(c.read(adminUsersProvider.notifier).visible.hasError, isTrue);
    expect(c.read(adminUsersProvider.notifier).directory, isNull);
  });
}
