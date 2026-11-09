import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache_owner.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../meetings/meetings.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
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
  DepartmentRole? role,
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
      role: null,
      sort: UserSortField.name,
      direction: SortDirection.asc,
    );
  }

  void set(AdminUserQuery query) => state = query;
}

class AdminUsersController extends AsyncNotifier<PageSlice<KnownUser>> {
  bool _busy = false;
  int _generation = 0;
  AdminUserQuery? _loadedQuery;
  final _clock = StaleClock();
  final _owner = CacheOwnership();
  AsyncValue<PageSlice<KnownUser>> get visible {
    final catalog = ref.read(taskCatalogControllerProvider);
    if (catalog.value?.access?.companyAdmin != true && !catalog.isLoading) {
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
    if (catalog.isReloading ||
        _loadedQuery != ref.read(adminUserQueryProvider)) {
      if (state.hasError && !state.isLoading) {
        return AsyncError(state.error!, state.stackTrace ?? StackTrace.current);
      }
      return const AsyncLoading();
    }
    final error = state.error;
    if (error is ApiError && error.code == 'organization.not_authorized') {
      return AsyncError(error, state.stackTrace ?? StackTrace.current);
    }
    return _owner.visible(ref, state);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> refreshIfStale() => _clock.refreshIfStale(state, refresh);
  @override
  Future<PageSlice<KnownUser>> build() async {
    final buildRef = ref;
    final generation = ++_generation;
    final owner = _owner.watch(buildRef);
    ref.watch(scopeStateProvider);
    final query = ref.watch(adminUserQueryProvider);
    final admin = await ref.watch(
      taskCatalogControllerProvider.selectAsync(
        (catalog) => catalog.access?.companyAdmin == true,
      ),
    );
    if (!admin) {
      throw ApiError('organization.not_authorized');
    }
    if (!buildRef.mounted || generation != _generation) {
      return PageSlice(items: []);
    }
    final page = await ref
        .watch(organizationAdminRepositoryProvider)
        .listUsers(
          search: query.search.isEmpty ? null : query.search,
          role: query.role,
          sortBy: query.sort,
          sortOrder: query.direction,
        );
    if (buildRef.mounted && generation == _generation) {
      _owner.markLoaded(buildRef, owner);
      _loadedQuery = query;
      if (_owner.owns(buildRef)) _clock.markFresh();
    }
    return page;
  }

  Future<void> loadMore() async {
    final current = visible.value;
    final generation = _generation;
    final buildRef = ref;
    final cursor = current?.nextCursor;
    if (_busy || state.isLoading || current == null || cursor == null) return;
    _busy = true;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    final query = ref.read(adminUserQueryProvider);
    try {
      final page = await ref
          .read(organizationAdminRepositoryProvider)
          .listUsers(
            page: PageRequest(cursor: cursor),
            search: query.search.isEmpty ? null : query.search,
            role: query.role,
            sortBy: query.sort,
            sortOrder: query.direction,
          );
      if (!buildRef.mounted ||
          generation != _generation ||
          session != ref.read(sessionGenerationProvider) ||
          scope != ref.read(scopeStateProvider) ||
          query != ref.read(adminUserQueryProvider)) {
        return;
      }
      state = AsyncData(
        PageSlice(
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor,
          truncated: page.truncated,
        ),
      );
    } finally {
      _busy = false;
    }
  }
}

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
      ref.invalidate(adminUsersProvider);
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
      final cached = ref.read(adminUsersProvider.notifier).visible.value;
      for (final user in cached?.items ?? const <KnownUser>[]) {
        if (user.accountId == id) return user;
      }
      final repo = ref.watch(organizationAdminRepositoryProvider);
      final query = ref.read(adminUserQueryProvider);
      final unfiltered = query.search.isEmpty && query.role == null;
      if (unfiltered && cached != null && cached.nextCursor == null) {
        return null;
      }
      String? cursor = unfiltered ? cached?.nextCursor : null;
      final cursors = <String>{};
      do {
        final page = await repo.listUsers(
          page: PageRequest(limit: 200, cursor: cursor),
          sortBy: query.sort,
          sortOrder: query.direction,
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
