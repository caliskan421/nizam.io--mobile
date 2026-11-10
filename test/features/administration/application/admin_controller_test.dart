import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/administration/domain/program_admin_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

class _Organization implements OrganizationAdminRepository {
  @override
  Future<UserDirectoryPage> listUsers({
    PageRequest page = const PageRequest(),
    dynamic role,
    bool companyAdminOnly = false,
    String? programId,
    String? departmentId,
    String? search,
    dynamic sortBy,
    dynamic sortOrder,
  }) async => UserDirectoryPage(
    total: 2,
    roleCounts: const UserRoleCounts(
      all: 2,
      admins: 1,
      coordinators: 0,
      members: 0,
    ),
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

class _QueryOrganization extends _Organization {
  _QueryOrganization(this.load);
  final Future<PageSlice<KnownUser>> Function(PageRequest, String?) load;
  final requests = <({String? cursor, String? search})>[];
  int profileReads = 0;
  @override
  Future<KnownUser> readUser(String accountId) async {
    profileReads++;
    final page = await load(const PageRequest(), null);
    return page.items.firstWhere((u) => u.accountId == accountId);
  }

  @override
  Future<UserDirectoryPage> listUsers({
    PageRequest page = const PageRequest(),
    dynamic role,
    bool companyAdminOnly = false,
    String? programId,
    String? departmentId,
    String? search,
    dynamic sortBy,
    dynamic sortOrder,
  }) async {
    requests.add((cursor: page.cursor, search: search));
    final result = await load(page, search);
    return UserDirectoryPage(
      items: result.items,
      nextCursor: result.nextCursor,
      truncated: result.truncated,
      total: result.items.length,
      roleCounts: UserRoleCounts(
        all: result.items.length,
        admins: 0,
        coordinators: 0,
        members: 0,
      ),
    );
  }
}

class _Program implements ProgramAdminRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DelayedProfile extends _Organization {
  final started = Completer<void>();
  final response = Completer<KnownUser>();
  @override
  Future<KnownUser> readUser(String accountId) {
    started.complete();
    return response.future;
  }
}

void main() {
  test('kapsam değişince gecikmiş readUser yanıtı uygulanmaz', () async {
    final repo = _DelayedProfile();
    final container = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    container.listen(adminUserProfileProvider('u1'), (_, _) {});
    final old = container.read(adminUserProfileProvider('u1').future);
    await repo.started.future.timeout(const Duration(seconds: 5));
    container.read(scopeControllerProvider).selectDepartment('other');
    repo.response.complete(
      KnownUser(accountId: 'u1', fullName: 'Eski', memberships: const []),
    );
    await expectLater(old, throwsA(isA<ApiError>()));
  });
  test(
    'ilk liste hatası görünür kalır ve kullanıcı yenileyerek kurtarır',
    () async {
      var fail = true;
      final repo = _QueryOrganization((_, _) async {
        if (fail) throw ApiError('platform.rate_limited');
        return PageSlice(
          items: [
            KnownUser(
              accountId: 'recovered',
              fullName: 'Kullanıcı',
              memberships: const [],
            ),
          ],
        );
      });
      final container = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      container.listen(adminUsersProvider, (_, _) {});
      await expectLater(
        container.read(adminUsersProvider.future),
        throwsA(isA<ApiError>()),
      );
      final ctl = container.read(adminUsersProvider.notifier);
      expect(ctl.visible.hasError, isTrue);
      expect(ctl.visible.isLoading, isFalse);
      fail = false;
      await ctl.refresh();
      expect(ctl.visible.requireValue.items.single.accountId, 'recovered');
    },
  );

  test(
    'süzgeç değişince eski sayfalama yanıtı yeni listeye karışmaz',
    () async {
      final late = Completer<PageSlice<KnownUser>>();
      final repo = _QueryOrganization((page, search) async {
        if (page.cursor != null) return late.future;
        return PageSlice(
          items: [
            KnownUser(
              accountId: search ?? 'first',
              fullName: 'Kullanıcı',
              memberships: const [],
            ),
          ],
          nextCursor: search == null ? 'next' : null,
        );
      });
      final container = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      container.listen(adminUsersProvider, (_, _) {});
      await container.read(adminUsersProvider.future);
      final ctl = container.read(adminUsersProvider.notifier);
      final more = ctl.loadMore();
      final q = container.read(adminUserQueryProvider);
      container.read(adminUserQueryProvider.notifier).set((
        search: 'Yeni',
        role: q.role,
        sort: q.sort,
        direction: q.direction,
      ));
      await container.read(adminUsersProvider.future);
      late.complete(
        PageSlice(
          items: [
            KnownUser(
              accountId: 'old',
              fullName: 'Eski',
              memberships: const [],
            ),
          ],
        ),
      );
      await more;
      expect(
        container.read(adminUsersProvider).requireValue.items.single.accountId,
        'Yeni',
      );
      expect(repo.requests.last, (cursor: null, search: 'Yeni'));
    },
  );

  test('profil listeden bağımsız tek kullanıcı okur', () async {
    final repo = _QueryOrganization(
      (_, _) async => PageSlice(
        items: [
          KnownUser(
            accountId: 'selected',
            fullName: 'Seçili',
            memberships: const [],
          ),
        ],
        nextCursor: 'next',
      ),
    );
    final container = moduleContainer(
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    container.listen(adminUsersProvider, (_, _) {});
    await container.read(adminUsersProvider.future);
    container.listen(adminUserProfileProvider('selected'), (_, _) {});
    expect(
      (await container.read(adminUserProfileProvider('selected').future))
          ?.fullName,
      'Seçili',
    );
    expect(repo.requests.length, 1);
    expect(repo.profileReads, 1);
  });

  test(
    'gerçek liste yenilemesi profilin önbellekteki adını günceller',
    () async {
      var name = 'Önceki';
      final repo = _QueryOrganization(
        (_, _) async => PageSlice(
          items: [
            KnownUser(
              accountId: 'selected',
              fullName: name,
              memberships: const [],
            ),
          ],
        ),
      );
      final container = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      container.listen(adminUserProfileProvider('selected'), (_, _) {});
      expect(
        (await container.read(adminUserProfileProvider('selected').future))
            ?.fullName,
        'Önceki',
      );
      name = 'Güncel';
      container.invalidate(adminUserProfileProvider('selected'));
      expect(
        (await container.read(adminUserProfileProvider('selected').future))
            ?.fullName,
        'Güncel',
      );
      expect(repo.profileReads, 2);
    },
  );

  test('yetkisiz profil sunucudan kullanıcı listesi okumaz', () async {
    final repo = _QueryOrganization((_, _) async => PageSlice(items: []));
    final container = moduleContainer(
      catalog: moduleCatalog(admin: false),
      overrides: [organizationAdminRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    container.listen(adminUserProfileProvider('selected'), (_, _) {});
    await expectLater(
      container.read(adminUserProfileProvider('selected').future),
      throwsA(isA<ApiError>()),
    );
    expect(repo.requests, isEmpty);
  });

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
