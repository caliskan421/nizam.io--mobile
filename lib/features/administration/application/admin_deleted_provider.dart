import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/providers.dart';
import 'admin_controller.dart';

final deletedAdminAccountsProvider = FutureProvider.autoDispose.family((
  ref,
  String? cursor,
) {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  return ref
      .watch(organizationAdminRepositoryProvider)
      .listDeletedAccounts(page: PageRequest(cursor: cursor));
});
final deletedAdminDepartmentsProvider = FutureProvider.autoDispose.family((
  ref,
  String? cursor,
) {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  return ref
      .watch(organizationAdminRepositoryProvider)
      .listDeletedDepartments(page: PageRequest(cursor: cursor));
});
