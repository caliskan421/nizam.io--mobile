import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache_owner.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/domain/turkish_collation.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../meetings/meetings.dart';
import '../../messages/messages.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../domain/admin_user_directory.dart';
import '../domain/organization_admin.dart';
import '../domain/organization_admin_repository.dart';
import '../domain/program_admin_repository.dart';

final organizationAdminRepositoryProvider =
    Provider<OrganizationAdminRepository>((ref) => throw UnimplementedError());
final programAdminRepositoryProvider = Provider<ProgramAdminRepository>(
  (ref) => throw UnimplementedError(),
);
final adminUsersProvider =
    AsyncNotifierProvider.autoDispose<
      AdminUsersController,
      PageSlice<KnownUser>
    >(AdminUsersController.new);

typedef AdminUserQuery = ({
  String search,
  AdminUserRoleFilter role,
  UserSortField sort,
  SortDirection direction,
});

final adminUserQueryProvider =
    NotifierProvider.autoDispose<AdminUserQueryController, AdminUserQuery>(
      AdminUserQueryController.new,
    );

class AdminUserQueryController extends Notifier<AdminUserQuery> {
  @override
  AdminUserQuery build() {
    ref.watch(sessionGenerationProvider);
    return (
      search: '',
      role: AdminUserRoleFilter.all,
      sort: UserSortField.name,
      direction: SortDirection.asc,
    );
  }

  void set(AdminUserQuery query) => state = query;
}

typedef _UserSourceQuery = ({
  String search,
  DepartmentRole? role,
  UserSortField sort,
  SortDirection direction,
});

class AdminUsersController extends AsyncNotifier<PageSlice<KnownUser>> {
  bool _busy = false;
  int _generation = 0;
  AdminUserQuery? _loadedQuery;
  _UserSourceQuery? _sourceQuery;
  _UserSourceQuery? _directoryQuery;
  PageSlice<KnownUser>? _source;
  PageSlice<KnownUser>? _directory;
  CacheOwner? _cachedOwner;
  final _clock = StaleClock();
  final _owner = CacheOwnership();

  /// Ana dizinin yüklenmiş sayfaları. Filtre sorguları küresel sayım diye sunulmaz.
  PageSlice<KnownUser>? get directory {
    final catalog = ref.read(taskCatalogControllerProvider);
    return !catalog.hasError &&
            !catalog.isReloading &&
            catalog.value?.access?.companyAdmin == true &&
            _owner.owns(ref)
        ? _directory
        : null;
  }

  AsyncValue<PageSlice<KnownUser>> get visible {
    final catalog = ref.read(taskCatalogControllerProvider);
    if (catalog.value?.access?.companyAdmin != true && !catalog.isLoading) {
      _clear();
      return AsyncError(
        ApiError('organization.not_authorized'),
        StackTrace.current,
      );
    }
    if (catalog.hasError) {
      return AsyncError(
        catalog.error!,
        catalog.stackTrace ?? StackTrace.current,
      );
    }
    final error = state.error;
    if (error is ApiError && error.code == 'organization.not_authorized') {
      _clear();
      return AsyncError(error, state.stackTrace ?? StackTrace.current);
    }
    if (catalog.isReloading ||
        _loadedQuery != ref.read(adminUserQueryProvider)) {
      if (state.hasError && !state.isLoading) {
        return AsyncError(state.error!, state.stackTrace ?? StackTrace.current);
      }
      return const AsyncLoading();
    }
    return _owner.visible(ref, state);
  }

  void _clear() {
    _source = null;
    _sourceQuery = null;
    _directory = null;
    _directoryQuery = null;
  }

  void invalidate() {
    _clear();
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    invalidate();
    await future;
  }

  Future<void> refreshIfStale() => _clock.refreshIfStale(state, refresh);

  _UserSourceQuery _remoteQuery(AdminUserQuery query, TaskCatalog catalog) {
    final needle = trLower(query.search.trim());
    final matchesDepartment =
        needle.isNotEmpty &&
        catalog.coordinatorships.any((d) => trLower(d.name).contains(needle));
    return (
      search: matchesDepartment ? '' : query.search,
      role: switch (query.role) {
        AdminUserRoleFilter.coordinator => DepartmentRole.coordinator,
        AdminUserRoleFilter.member => DepartmentRole.member,
        _ => null,
      },
      sort: query.sort,
      direction: query.direction,
    );
  }

  PageSlice<KnownUser> _project(PageSlice<KnownUser> source) {
    final query = ref.read(adminUserQueryProvider);
    final departments = ref.read(adminUserDepartmentsProvider);
    final catalog = ref.read(taskCatalogControllerProvider).value;
    final program = ref.read(scopeStateProvider).programId;
    final adminIndex = query.role == AdminUserRoleFilter.admin
        ? ref.read(companyAdminIndexProvider)
        : null;
    final adminIds =
        adminIndex == null || adminIndex.isLoading || adminIndex.hasError
        ? null
        : adminIndex.value?.accountIds;
    return PageSlice(
      items: [
        for (final u in source.items)
          if (userHasRole(u, query.role, adminIds: adminIds) &&
              userMatchesDirectory(
                u,
                search: _sourceQuery?.search.isEmpty == true
                    ? query.search
                    : '',
                programId: program,
                departments: departments,
                departmentName: (id) => catalog?.coordinatorship(id)?.name,
              ))
            u,
      ],
      nextCursor: source.nextCursor,
      truncated:
          source.truncated ||
          (query.role == AdminUserRoleFilter.admin &&
              adminIndex?.value?.complete != true),
    );
  }

  bool _complete(PageSlice<KnownUser>? page) =>
      page != null && !page.hasMore && !page.truncated;

  @override
  Future<PageSlice<KnownUser>> build() async {
    try {
      final buildRef = ref;
      if (buildRef.isRefresh) _clear();
      final generation = ++_generation;
      final owner = _owner.watch(buildRef);
      if (_cachedOwner != owner) {
        _clear();
        _cachedOwner = owner;
      }
      final query = ref.watch(adminUserQueryProvider);
      ref.watch(adminUserDepartmentsProvider);
      // Varsayılan dizin admin lookup'u beklemez; lookup sonucu yalnız admin filtresini
      // yeniden hesaplatır. Diğer sekmeler aynı kaynağı kullanmaya devam eder.
      if (query.role == AdminUserRoleFilter.admin) {
        await ref.watch(companyAdminIndexProvider.future);
      }
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      if (catalog.access?.companyAdmin != true) {
        _clear();
        throw ApiError('organization.not_authorized');
      }
      if (!buildRef.mounted || generation != _generation) {
        return PageSlice.empty();
      }
      final remote = _remoteQuery(query, catalog);
      // Filtreli yenilemede de küresel sayının kaynağı kaybolmaz. Başlangıçta varsayılan
      // sorgu bu sayfayı doğrudan kullanır; ikinci aynı liste isteği yapılmaz.
      if (_directory == null) {
        final baseline = await ref
            .read(organizationAdminRepositoryProvider)
            .listUsers(sortBy: query.sort, sortOrder: query.direction);
        if (!buildRef.mounted || generation != _generation) {
          return PageSlice.empty();
        }
        _directory = baseline;
        _directoryQuery = (
          search: '',
          role: null,
          sort: query.sort,
          direction: query.direction,
        );
      }
      // Tam ana dizinde bütün filtreler yereldir. Kısmi dizinde sunucu ad/rol sorgusu
      // ve imleci korunur; departman-adı eşleşmesi ad sorgusuyla yanlış daraltılmaz.
      if (_directoryQuery?.sort == remote.sort &&
          _directoryQuery?.direction == remote.direction &&
          (_complete(_directory) ||
              (remote.search.isEmpty && remote.role == null))) {
        _source = _directory;
        _sourceQuery = (
          search: '',
          role: null,
          sort: remote.sort,
          direction: remote.direction,
        );
      } else if (_sourceQuery != remote || _source == null) {
        final page = await ref
            .read(organizationAdminRepositoryProvider)
            .listUsers(
              search: remote.search.isEmpty ? null : remote.search,
              role: remote.role,
              sortBy: remote.sort,
              sortOrder: remote.direction,
            );
        if (!buildRef.mounted || generation != _generation) {
          return PageSlice.empty();
        }
        _source = page;
        _sourceQuery = remote;
        if (remote.search.isEmpty && remote.role == null) {
          _directory = page;
          _directoryQuery = remote;
        }
      }
      _owner.markLoaded(buildRef, owner);
      _loadedQuery = query;
      if (_owner.owns(buildRef)) _clock.markFresh();
      return _project(_source!);
    } on ApiError catch (error) {
      if (error.code == 'organization.not_authorized') _clear();
      rethrow;
    }
  }

  Future<void> loadMore() async {
    final source = _source;
    final remote = _sourceQuery;
    final cursor = source?.nextCursor;
    if (_busy ||
        state.isLoading ||
        visible.value == null ||
        source == null ||
        remote == null ||
        cursor == null) {
      return;
    }
    _busy = true;
    final generation = _generation;
    final buildRef = ref;
    try {
      final page = await ref
          .read(organizationAdminRepositoryProvider)
          .listUsers(
            page: PageRequest(cursor: cursor),
            search: remote.search.isEmpty ? null : remote.search,
            role: remote.role,
            sortBy: remote.sort,
            sortOrder: remote.direction,
          );
      if (!buildRef.mounted || generation != _generation) return;
      final known = source.items.map((u) => u.accountId).toSet();
      _source = PageSlice(
        items: [
          ...source.items,
          ...page.items.where((u) => known.add(u.accountId)),
        ],
        nextCursor: page.nextCursor,
        truncated: source.truncated || page.truncated,
      );
      if (remote.search.isEmpty && remote.role == null) _directory = _source;
      state = AsyncData(_project(_source!));
    } on ApiError catch (error, stack) {
      if (buildRef.mounted &&
          generation == _generation &&
          error.code == 'organization.not_authorized') {
        _clear();
        state = AsyncError(error, stack);
      }
      rethrow;
    } finally {
      _busy = false;
    }
  }
}

/// Sayılar aynı ana dizinin yüklü sayfalarından türetilir; imleç/kesilme varken alt
/// sınırdır. Rol kümeleri çokludur. Bilinmeyen admin sayısı null kalır.
final adminUsersSummaryProvider = Provider.autoDispose<AdminUsersSummary?>((
  ref,
) {
  ref.watch(adminUsersProvider);
  final controller = ref.read(adminUsersProvider.notifier);
  final value = controller.visible;
  final directory = controller.directory;
  if (directory == null) return null;
  final indexValue = ref.watch(companyAdminIndexProvider);
  final index = indexValue.isLoading || indexValue.hasError
      ? null
      : indexValue.value;
  final exact = !directory.hasMore && !directory.truncated;
  AdminUserCount count(int n) => AdminUserCount(n, exact: exact);
  return AdminUsersSummary(
    total: count(directory.items.length),
    all: count(directory.items.length),
    coordinators: count(
      directory.items
          .where((u) => userHasRole(u, AdminUserRoleFilter.coordinator))
          .length,
    ),
    members: count(
      directory.items
          .where((u) => userHasRole(u, AdminUserRoleFilter.member))
          .length,
    ),
    admins: index == null
        ? null
        : AdminUserCount(
            directory.items
                .where((u) => index.accountIds.contains(u.accountId))
                .length,
            exact: exact && index.complete,
          ),
    adminAccountIds: index?.accountIds,
    matched: value.value == null || value.hasError
        ? null
        : AdminUserCount(
            value.value!.items.length,
            exact: !value.value!.hasMore && !value.value!.truncated,
          ),
    shown: value.hasError ? const [] : value.value?.items ?? const [],
  );
});

final adminCommandProvider =
    NotifierProvider.autoDispose<AdminCommandController, bool>(
      AdminCommandController.new,
    );

class AdminCommandController extends Notifier<bool> {
  @override
  bool build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return false;
  }

  Future<void> run(
    Future<void> Function(
      OrganizationAdminRepository organization,
      ProgramAdminRepository program,
    )
    call,
  ) async {
    if (state) return;
    final catalogState = ref.read(taskCatalogControllerProvider);
    final catalog = catalogState.value;
    if (catalogState.isLoading || catalog?.access?.companyAdmin != true) {
      throw ApiError('organization.not_authorized');
    }
    state = true;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    try {
      await call(
        ref.read(organizationAdminRepositoryProvider),
        ref.read(programAdminRepositoryProvider),
      );
      if (!ref.mounted ||
          session != ref.read(sessionGenerationProvider) ||
          scope != ref.read(scopeStateProvider)) {
        throw ApiError('client.scope_changed');
      }
      ref.read(adminUsersProvider.notifier).invalidate();
      ref.invalidate(companyAdminIndexProvider);
      ref.invalidate(adminUserProfileProvider);
      ref.invalidate(currentProgramControllerProvider);
      ref.invalidate(homeDashboardControllerProvider);
      ref.invalidate(meetingsBoardControllerProvider);
      ref.invalidate(taskCatalogControllerProvider);
    } finally {
      if (ref.mounted &&
          session == ref.read(sessionGenerationProvider) &&
          scope == ref.read(scopeStateProvider)) {
        state = false;
      }
    }
  }
}

final adminUserProfileProvider = FutureProvider.autoDispose
    .family<KnownUser?, String>((ref, id) async {
      ref.watch(sessionGenerationProvider);
      ref.watch(scopeStateProvider);
      final admin = await ref.watch(
        taskCatalogControllerProvider.selectAsync(
          (catalog) => catalog.access?.companyAdmin == true,
        ),
      );
      if (!admin) {
        throw ApiError('organization.not_authorized');
      }
      await ref.watch(adminUsersProvider.future);
      if (!ref.mounted) return null;
      final controller = ref.read(adminUsersProvider.notifier);
      final cached = controller.directory ?? controller.visible.value;
      for (final user in [
        ...?cached?.items,
        ...?controller.visible.value?.items,
      ]) {
        if (user.accountId == id) return user;
      }
      final repo = ref.watch(organizationAdminRepositoryProvider);
      final query = ref.read(adminUserQueryProvider);
      final unfiltered =
          controller.directory != null ||
          (query.search.isEmpty && query.role == AdminUserRoleFilter.all);
      if (unfiltered && cached != null && cached.nextCursor == null) {
        return null;
      }
      String? cursor = unfiltered ? cached?.nextCursor : null;
      final cursors = <String>{};
      do {
        final page = await repo.listUsers(
          page: PageRequest(limit: 200, cursor: cursor),
          sortBy: controller._directoryQuery?.sort ?? query.sort,
          sortOrder: controller._directoryQuery?.direction ?? query.direction,
        );
        if (!ref.mounted) return null;
        for (final user in page.items) {
          if (user.accountId == id) return user;
        }
        cursor = page.nextCursor;
        if (cursor != null && !cursors.add(cursor)) {
          throw ApiError('client.invalid_response');
        }
      } while (cursor != null);
      return null;
    });

final adminUserDepartmentsProvider =
    NotifierProvider.autoDispose<AdminUserDepartmentsController, Set<String>>(
      AdminUserDepartmentsController.new,
    );

class AdminUserDepartmentsController extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return const {};
  }

  void toggle(String id) => state = Set.unmodifiable(
    state.contains(id) ? (Set<String>.of(state)..remove(id)) : {...state, id},
  );
  void clear() => state = const {};
}
