import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart' show taskCatalogControllerProvider, SeatRole;
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';

/// Üretimde tables_module tarafından bağlanır. Null yalnız prototip/test kapsamıdır.
final tablesRepositoryProvider = Provider<TablesRepository?>(
  (ref) => throw UnimplementedError(
    'tablesRepositoryProvider bileşim kökünde bağlanır',
  ),
);

class TableSharingChoices {
  const TableSharingChoices({
    required this.accountId,
    required this.people,
    required this.departments,
    required this.directDepartments,
    required this.memberships,
  });
  final String accountId;
  final Map<TablePersonId, String> people;
  final Map<TableDepartmentId, String> departments;
  final Set<String> directDepartments;
  final Map<TablePersonId, Set<String>> memberships;
  bool canPublish(String department) => directDepartments.contains(department);
  Map<TablePersonId, String> peopleIn(String? department) => {
    for (final e in people.entries)
      if (department == null ||
          (canPublish(department) &&
              memberships[e.key]?.contains(department) == true))
        e.key: e.value,
  };
}

final tableSharingChoicesProvider = FutureProvider<TableSharingChoices>((
  ref,
) async {
  ref.watch(sessionGenerationProvider);
  final program = ref.watch(scopeStateProvider).programId;
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  final access = catalog.access;
  if (access == null) throw ApiError('client.scope_missing');
  final departments = {
    for (final d in catalog.departments)
      if (access.companyAdmin ||
          access.seatsIn(program ?? '').any((s) => s.departmentId == d.id))
        TableDepartmentId(d.id): d.name,
  };
  return TableSharingChoices(
    accountId: catalog.me,
    people: {
      for (final person in catalog.people)
        if (person.id != catalog.me) TablePersonId(person.id): person.name,
    },
    departments: departments,
    directDepartments: {
      for (final key in departments.keys)
        for (final id in [key.value])
          if (access.companyAdmin ||
              access
                  .seatsIn(program ?? '')
                  .any(
                    (s) =>
                        s.departmentId == id && s.role == SeatRole.coordinator,
                  ))
            id,
    },
    memberships: {
      for (final person in catalog.people)
        TablePersonId(person.id): {
          for (final d in catalog.coordinatorships)
            if (d.leads.contains(person.id) || d.members.contains(person.id))
              d.code,
        },
    },
  );
}, retry: (_, _) => null);
