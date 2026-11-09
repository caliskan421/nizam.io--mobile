import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
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

class AdminUsersController extends AsyncNotifier<PageSlice<KnownUser>> {
  bool _busy = false;
  @override
  Future<PageSlice<KnownUser>> build() async {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    final catalog = await ref.watch(taskCatalogControllerProvider.future);
    if (catalog.access?.companyAdmin != true) {
      throw ApiError('organization.not_authorized');
    }
    return ref.watch(organizationAdminRepositoryProvider).listUsers();
  }

  Future<void> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (_busy || current == null || cursor == null) return;
    _busy = true;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    try {
      final page = await ref
          .read(organizationAdminRepositoryProvider)
          .listUsers(page: PageRequest(cursor: cursor));
      if (!ref.mounted ||
          session != ref.read(sessionGenerationProvider) ||
          scope != ref.read(scopeStateProvider)) {
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
    final catalog = ref.read(taskCatalogControllerProvider).value;
    if (catalog?.access?.companyAdmin != true) {
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
