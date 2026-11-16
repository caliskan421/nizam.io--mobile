import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart'
    show taskCatalogControllerProvider, SeatRole, PersonRole, EffectiveAccess;
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';

/// Üretimde tables_module tarafından bağlanır. Null yalnız prototip/test kapsamıdır.
final tablesRepositoryProvider = Provider<TablesRepository?>(
  (ref) => throw UnimplementedError(
    'tablesRepositoryProvider bileşim kökünde bağlanır',
  ),
);

enum TableSharingRole { admin, coordinator, member, unknown }

class TableSharingChoices {
  const TableSharingChoices({
    required this.accountId,
    required this.people,
    required this.departments,
    required this.directDepartments,
    required this.memberships,
    this.roles = const {},
    this.coordinators = const {},
    this.accountName,
  });
  final String accountId;
  final String? accountName;
  final Map<TablePersonId, TableSharingRole> roles;
  final Map<TableDepartmentId, Set<TablePersonId>> coordinators;
  final Map<TablePersonId, String> people;
  final Map<TableDepartmentId, String> departments;
  final Set<String> directDepartments;
  final Map<TablePersonId, Set<String>> memberships;
  bool canPublish(String department) => directDepartments.contains(department);

  /// Actual visible members, excluding admins who are only manual grant candidates.
  Map<TablePersonId, String> teamPeopleIn(String department) => {
    for (final e in people.entries)
      if (memberships[e.key]?.contains(department) == true) e.key: e.value,
  };
  Map<TablePersonId, String> peopleIn(String? department) => {
    for (final e in people.entries)
      if (department == null ||
          roles[e.key] == TableSharingRole.admin ||
          memberships[e.key]?.contains(department) == true)
        e.key: e.value,
  };
}

final tableSharingChoicesProvider = FutureProvider<TableSharingChoices>(
  (ref) async {
    ref.watch(sessionGenerationProvider);
    final scope = ref.watch(scopeStateProvider);
    final program = scope.programId;
    final catalog = await ref.watch(taskCatalogControllerProvider.future);
    final access = catalog.access;
    if (access == null || program == null) {
      throw ApiError('client.scope_missing');
    }
    final view = EffectiveAccess.of(access, scope).viewAccess!;
    final departments = {
      for (final d in catalog.departments)
        if (access.companyAdmin ||
            access
                .seatsIn(program)
                .any(
                  (s) => s.departmentId == d.id && s.role != SeatRole.unknown,
                ))
          TableDepartmentId(d.id): d.name,
    };
    return TableSharingChoices(
      accountId: catalog.me,
      accountName: catalog.people
          .where((p) => p.id == catalog.me)
          .firstOrNull
          ?.name,
      roles: {
        for (final p in catalog.people)
          TablePersonId(p.id): switch (p.role) {
            PersonRole.admin => TableSharingRole.admin,
            PersonRole.coordinator => TableSharingRole.coordinator,
            PersonRole.member => TableSharingRole.member,
          },
      },
      people: {
        for (final person in catalog.people)
          if (person.id != catalog.me) TablePersonId(person.id): person.name,
      },
      departments: departments,
      directDepartments: {
        for (final key in departments.keys)
          for (final id in [key.value])
            if (view.companyAdmin ||
                view
                    .seatsIn(program)
                    .any(
                      (s) =>
                          s.departmentId == id &&
                          s.role == SeatRole.coordinator,
                    ))
              id,
      },
      coordinators: {
        for (final d in catalog.coordinatorships)
          TableDepartmentId(d.code): {
            for (final id in d.leads) TablePersonId(id),
          },
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
  },
  retry: (_, _) => null,
  dependencies: [
    sessionGenerationProvider,
    scopeStateProvider,
    taskCatalogControllerProvider,
  ],
);
