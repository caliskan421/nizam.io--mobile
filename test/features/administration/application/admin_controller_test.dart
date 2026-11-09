import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _QueryOrganization extends _Organization {
  _QueryOrganization(this.load);
  final Future<PageSlice<KnownUser>> Function(PageRequest, String?) load;
  final requests = <({String? cursor, String? search})>[];
  @override
  Future<PageSlice<KnownUser>> listUsers({
    PageRequest page = const PageRequest(),
    dynamic role,
    String? search,
    dynamic sortBy,
    dynamic sortOrder,
  }) {
    requests.add((cursor: page.cursor, search: search));
    return load(page, search);
  }
}

class _Program implements ProgramAdminRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
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

  test('profil görünen kullanıcıyı ek liste isteği atmadan kullanır', () async {
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
      await container.read(adminUsersProvider.notifier).refresh();
      expect(
        (await container.read(adminUserProfileProvider('selected').future))
            ?.fullName,
        'Güncel',
      );
      expect(repo.requests.length, 2);
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
