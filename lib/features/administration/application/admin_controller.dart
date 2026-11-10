import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache_owner.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../meetings/meetings.dart';
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
  bool companyAdminOnly,
  String? programId,
  String? departmentId,
  UserSortField sort,
  SortDirection direction,
});

class AdminUsersController extends AsyncNotifier<PageSlice<KnownUser>> {
  bool _busy = false;
  int _generation = 0;
  AdminUserQuery? _loadedQuery;
  _UserSourceQuery? _sourceQuery;
  UserDirectoryPage? _source;
  CacheOwner? _cachedOwner;
  ({int session, String? program, String? department})? _realOwner;
  final _clock = StaleClock();
  final _owner = CacheOwnership();

  /// Ana dizinin yüklenmiş sayfaları. Filtre sorguları küresel sayım diye sunulmaz.
  PageSlice<KnownUser>? get directory {
    final catalog = ref.read(taskCatalogControllerProvider);
    return !catalog.hasError &&
            !catalog.isReloading &&
            catalog.value?.access?.companyAdmin == true &&
            _owner.owns(ref)
        ? _source
        : null;
  }

  AsyncValue<PageSlice<KnownUser>> get visible {
    final currentScope = ref.read(scopeControllerProvider).current;
    final currentOwner = (
      session: ref.read(sessionControllerProvider).generation,
      program: currentScope.programId,
      department: currentScope.departmentId,
    );
    if (currentOwner != _realOwner) return const AsyncLoading();
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
        _loadedQuery != ref.read(adminUserQueryProvider) ||
        _sourceQuery != _remoteQuery(ref.read(adminUserQueryProvider))) {
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

  _UserSourceQuery _remoteQuery(AdminUserQuery query) {
    final selected = ref.read(adminUserDepartmentsProvider);
    final department = selected.firstOrNull;
    return (
      search: query.search,
      role: switch (query.role) {
        AdminUserRoleFilter.coordinator => DepartmentRole.coordinator,
        AdminUserRoleFilter.member => DepartmentRole.member,
        _ => null,
      },
      companyAdminOnly: query.role == AdminUserRoleFilter.admin,
      programId: department == null
          ? null
          : ref.read(scopeStateProvider).programId,
      departmentId: department,
      sort: query.sort,
      direction: query.direction,
    );
  }

  @override
  Future<PageSlice<KnownUser>> build() async {
    try {
      final buildRef = ref;
      if (buildRef.isRefresh) _clear();
      final generation = ++_generation;
      final owner = _owner.watch(buildRef);
      final session = ref.read(sessionControllerProvider).generation;
      final scope = ref.read(scopeControllerProvider).current;
      bool live() {
        if (!buildRef.mounted || generation != _generation) return false;
        final current = ref.read(scopeControllerProvider).current;
        return session == ref.read(sessionControllerProvider).generation &&
            current.programId == scope.programId &&
            current.departmentId == scope.departmentId;
      }

      if (_cachedOwner != owner) {
        _clear();
        _cachedOwner = owner;
      }
      _realOwner = (
        session: session,
        program: scope.programId,
        department: scope.departmentId,
      );
      final query = ref.watch(adminUserQueryProvider);
      ref.watch(adminUserDepartmentsProvider);
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      if (catalog.access?.companyAdmin != true) {
        _clear();
        throw ApiError('organization.not_authorized');
      }
      if (!live()) {
        return PageSlice.empty();
      }
      final remote = _remoteQuery(query);
      if (_sourceQuery != remote || _source == null) {
        final page = await ref
            .read(organizationAdminRepositoryProvider)
            .listUsers(
              search: remote.search.isEmpty ? null : remote.search,
              role: remote.role,
              companyAdminOnly: remote.companyAdminOnly,
              programId: remote.programId,
              departmentId: remote.departmentId,
              sortBy: remote.sort,
              sortOrder: remote.direction,
            );
        if (!live()) {
          return PageSlice.empty();
        }
        _source = page;
        _sourceQuery = remote;
      }
      _owner.markLoaded(buildRef, owner);
      _realOwner = (
        session: session,
        program: scope.programId,
        department: scope.departmentId,
      );
      _loadedQuery = query;
      if (_owner.owns(buildRef)) _clock.markFresh();
      return _source!;
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
    final session = ref.read(sessionControllerProvider).generation;
    final scope = ref.read(scopeControllerProvider).current;
    try {
      final page = await ref
          .read(organizationAdminRepositoryProvider)
          .listUsers(
            page: PageRequest(cursor: cursor),
            search: remote.search.isEmpty ? null : remote.search,
            role: remote.role,
            companyAdminOnly: remote.companyAdminOnly,
            programId: remote.programId,
            departmentId: remote.departmentId,
            sortBy: remote.sort,
            sortOrder: remote.direction,
          );
      if (!buildRef.mounted ||
          generation != _generation ||
          session != ref.read(sessionControllerProvider).generation ||
          scope.programId !=
              ref.read(scopeControllerProvider).current.programId ||
          scope.departmentId !=
              ref.read(scopeControllerProvider).current.departmentId) {
        return;
      }
      final known = source.items.map((u) => u.accountId).toSet();
      _source = UserDirectoryPage(
        total: page.total,
        roleCounts: page.roleCounts,
        items: [
          ...source.items,
          ...page.items.where((u) => known.add(u.accountId)),
        ],
        nextCursor: page.nextCursor,
        truncated: source.truncated || page.truncated,
      );
      state = AsyncData(_source!);
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

/// Sayılar sunucunun rol dışı filtrelere göre hesapladığı role_counts ve filtreli total'dır.
final adminUsersSummaryProvider = Provider.autoDispose<AdminUsersSummary?>((
  ref,
) {
  ref.watch(adminUsersProvider);
  final controller = ref.read(adminUsersProvider.notifier);
  final value = controller.visible;
  if (value.isLoading || value.hasError) return null;
  final directory = controller._source;
  if (directory == null) return null;
  AdminUserCount count(int n) => AdminUserCount(n, exact: true);
  final counts = directory.roleCounts;
  return AdminUsersSummary(
    total: count(directory.total),
    all: count(counts.all),
    coordinators: count(counts.coordinators),
    members: count(counts.members),
    admins: count(counts.admins),
    matched: value.value == null || value.hasError
        ? null
        : count(directory.total),
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
    final session = ref.read(sessionControllerProvider).generation;
    final scope = ref.read(scopeControllerProvider).current;
    bool live() {
      if (!ref.mounted) return false;
      final current = ref.read(scopeControllerProvider).current;
      return session == ref.read(sessionControllerProvider).generation &&
          scope.programId == current.programId &&
          scope.departmentId == current.departmentId;
    }

    state = true;
    try {
      await call(
        ref.read(organizationAdminRepositoryProvider),
        ref.read(programAdminRepositoryProvider),
      );
      if (!live()) {
        throw ApiError('client.scope_changed');
      }
      ref.read(adminUsersProvider.notifier).invalidate();
      ref.invalidate(adminUserProfileProvider);
      ref.invalidate(currentProgramControllerProvider);
      ref.invalidate(homeDashboardControllerProvider);
      ref.invalidate(meetingsBoardControllerProvider);
      ref.invalidate(taskCatalogControllerProvider);
    } finally {
      if (live()) {
        state = false;
      }
    }
  }
}

final adminUserProfileProvider = FutureProvider.autoDispose
    .family<KnownUser?, String>((ref, id) async {
      ref.watch(sessionGenerationProvider);
      ref.watch(scopeStateProvider);
      final session = ref.read(sessionControllerProvider).generation;
      final scope = ref.read(scopeControllerProvider).current;
      bool live() {
        if (!ref.mounted) return false;
        final current = ref.read(scopeControllerProvider).current;
        return session == ref.read(sessionControllerProvider).generation &&
            scope.programId == current.programId &&
            scope.departmentId == current.departmentId;
      }

      final admin = await ref.watch(
        taskCatalogControllerProvider.selectAsync(
          (catalog) => catalog.access?.companyAdmin == true,
        ),
      );
      if (!live()) throw ApiError('client.scope_changed');
      if (!admin) {
        throw ApiError('organization.not_authorized');
      }
      final repo = ref.watch(organizationAdminRepositoryProvider);
      try {
        final user = await repo.readUser(id);
        if (!live()) throw ApiError('client.scope_changed');
        return user;
      } on ApiError catch (e) {
        if (!live()) throw ApiError('client.scope_changed');
        if (e.status == 404) return null;
        rethrow;
      }
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

  void toggle(String id) => state = state.contains(id) ? const {} : {id};
  void clear() => state = const {};
}
