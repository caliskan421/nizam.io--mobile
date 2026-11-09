import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/domain/admin_user_directory.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/scope/scope.dart';

import '../../connected_module_support.dart';

KnownUser _user(String id, List<String> memberships, {String? name}) =>
    KnownUser(accountId: id, fullName: name ?? id, memberships: memberships);

class _Repository implements OrganizationAdminRepository {
  final calls = <({String? search, DepartmentRole? role, String? cursor})>[];
  List<KnownUser> users = [
    _user('me', ['program:department:koordinator', 'other:else:uye']),
    _user('member', ['program:department:uye']),
    _user('other', ['other:department:uye']),
  ];
  bool partial = false;
  ApiError? failure;
  @override
  Future<PageSlice<KnownUser>> listUsers({
    PageRequest page = const PageRequest(),
    DepartmentRole? role,
    String? search,
    UserSortField? sortBy,
    SortDirection? sortOrder,
  }) async {
    calls.add((search: search, role: role, cursor: page.cursor));
    if (failure case final error?) throw error;
    final items = users
        .where(
          (u) =>
              (search == null || u.fullName.contains(search)) &&
              (role == null || u.teams.any((m) => m.role == role)),
        )
        .toList();
    if (!partial) return PageSlice(items: items);
    return PageSlice(
      items: page.cursor == null
          ? items.take(1).toList()
          : items.skip(1).toList(),
      nextCursor: page.cursor == null ? 'next' : null,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('liste yenilemesindeki yetki kaybı önceki satırları ve dizin cacheini kaldırır', () async {
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
    final controller = c.read(adminUsersProvider.notifier);
    expect(controller.visible.hasError, isTrue);
    expect(controller.visible.hasValue, isFalse);
    expect(controller.directory, isNull);
    repo.failure = null;
    repo.users = [_user('new-owner', [])];
    c.invalidate(adminUsersProvider);
    await c.read(adminUsersProvider.future);
    expect(controller.visible.requireValue.items.single.accountId, 'new-owner');
  });

  test(
    'kesik admin indeksi tam kullanıcı dizininde de yalnız alt sınır sayılır',
    () async {
      final repo = _Repository();
      final c = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
          companyAdminIndexProvider.overrideWith(
            (ref) async => CompanyAdminIndex(['me'], complete: false),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(adminUsersProvider, (_, _) {});
      c.listen(adminUsersSummaryProvider, (_, _) {});
      await c.read(adminUsersProvider.future);
      await c.read(companyAdminIndexProvider.future);
      expect(c.read(adminUsersSummaryProvider)!.admins?.label, '1+');
    },
  );

  test('tam dizin çoklu rolleri sayar, arama ve rol değişiminde yeniden çağrı yapmaz', () async {
    final repo = _Repository();
    final c = moduleContainer(
      overrides: [
        organizationAdminRepositoryProvider.overrideWithValue(repo),
        companyAdminIndexProvider.overrideWith(
          (ref) async => CompanyAdminIndex(['me'], complete: true),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    c.listen(adminUsersSummaryProvider, (_, _) {});
    await c.read(adminUsersProvider.future);
    await c.read(companyAdminIndexProvider.future);
    final all = c.read(adminUsersSummaryProvider)!;
    expect(all.total.label, '3');
    expect(all.coordinators.value, 1);
    expect(
      all.members.value,
      3,
      reason: 'Koordinatör başka programda üye de olabilir',
    );
    expect(all.admins?.label, '1');
    final q = c.read(adminUserQueryProvider);
    c.read(adminUserQueryProvider.notifier).set((
      search: 'EKİP',
      role: AdminUserRoleFilter.member,
      sort: q.sort,
      direction: q.direction,
    ));
    final filtered = await c.read(adminUsersProvider.future);
    expect(filtered.items.map((u) => u.accountId), ['me', 'member']);
    expect(c.read(adminUsersSummaryProvider)!.all.label, '3');
    expect(c.read(adminUsersSummaryProvider)!.members.value, 3);
    expect(c.read(adminUsersSummaryProvider)!.matched?.label, '2');
    expect(repo.calls, hasLength(1));
    c.read(adminUserQueryProvider.notifier).set((
      search: '',
      role: AdminUserRoleFilter.admin,
      sort: q.sort,
      direction: q.direction,
    ));
    expect(
      (await c.read(adminUsersProvider.future)).items.single.accountId,
      'me',
    );
    expect(repo.calls, hasLength(1));
  });

  test(
    'kısmi dizinde sunucu ad ve rol sorgusu ile devam imleci korunur',
    () async {
      final repo = _Repository()..partial = true;
      final c = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      c.listen(adminUsersProvider, (_, _) {});
      await c.read(adminUsersProvider.future);
      final q = c.read(adminUserQueryProvider);
      c.read(adminUserQueryProvider.notifier).set((
        search: 'member',
        role: AdminUserRoleFilter.member,
        sort: q.sort,
        direction: q.direction,
      ));
      await c.read(adminUsersProvider.future);
      expect(repo.calls.last, (
        search: 'member',
        role: DepartmentRole.member,
        cursor: null,
      ));
      await c.read(adminUsersProvider.notifier).loadMore();
      expect(repo.calls.last, (
        search: 'member',
        role: DepartmentRole.member,
        cursor: 'next',
      ));
    },
  );

  test('kısmi departman-adı araması sonraki sayfadaki doğru program kişisini bulur', () async {
    final repo = _Repository()..partial = true;
    final c = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    await c.read(adminUsersProvider.future);
    final q = c.read(adminUserQueryProvider);
    c.read(adminUserQueryProvider.notifier).set((
      search: 'Ekip',
      role: AdminUserRoleFilter.all,
      sort: q.sort,
      direction: q.direction,
    ));
    await c.read(adminUsersProvider.future);
    await c.read(adminUsersProvider.notifier).loadMore();
    expect(
      c.read(adminUsersProvider).requireValue.items.map((u) => u.accountId),
      ['me', 'member'],
    );
    expect(repo.calls.every((call) => call.search == null), isTrue);
  });

  test(
    'filtreli yenileme ve açık invalidate küresel kaynağı yeniler',
    () async {
      final repo = _Repository();
      final c = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      c.listen(adminUsersProvider, (_, _) {});
      await c.read(adminUsersProvider.future);
      final q = c.read(adminUserQueryProvider);
      c.read(adminUserQueryProvider.notifier).set((
        search: 'new',
        role: q.role,
        sort: q.sort,
        direction: q.direction,
      ));
      await c.read(adminUsersProvider.future);
      repo.users.add(_user('new', ['program:department:uye']));
      await c.read(adminUsersProvider.notifier).refresh();
      expect(
        c.read(adminUsersProvider).requireValue.items.single.accountId,
        'new',
      );
      expect(c.read(adminUsersProvider.notifier).directory!.items.length, 4);
      repo.users.add(_user('newer', ['program:department:uye']));
      c.invalidate(adminUsersProvider);
      await c.read(adminUsersProvider.future);
      expect(c.read(adminUsersProvider).requireValue.items, hasLength(2));
    },
  );

  test('lookup hatası ana listeyi korur, kesik lookup kesin admin toplamı iddia etmez', () async {
    final repo = _Repository()..partial = true;
    final c = moduleContainer(
      overrides: [
        organizationAdminRepositoryProvider.overrideWithValue(repo),
        companyAdminIndexProvider.overrideWith(
          (ref) async => throw ApiError('client.timeout'),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(adminUsersProvider, (_, _) {});
    c.listen(adminUsersSummaryProvider, (_, _) {});
    await c.read(adminUsersProvider.future);
    await expectLater(
      c.read(companyAdminIndexProvider.future),
      throwsA(isA<ApiError>()),
    );
    expect(c.read(adminUsersSummaryProvider)!.admins, isNull);
    expect(c.read(adminUsersSummaryProvider)!.total.label, '1+');
    expect(
      c.read(adminUsersProvider).requireValue.items.single.accountId,
      'me',
    );
  });
}
