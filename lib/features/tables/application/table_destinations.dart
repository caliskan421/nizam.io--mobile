import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/table_document.dart';
import 'tables_server.dart';

final tableDestinationDepartmentsProvider = FutureProvider.autoDispose
    .family<Map<TableDepartmentId, String>, String>(
      (ref, program) async {
        ref.watch(sessionGenerationProvider);
        final catalog = await ref.watch(taskCatalogControllerProvider.future);
        if (catalog.access?.companyAdmin == true) {
          return ref.read(tablesRepositoryProvider)!.departments(program);
        }
        return {
          for (final s in catalog.access?.seatsIn(program) ?? <TeamSeat>[])
            if (s.role != SeatRole.unknown)
              TableDepartmentId(s.departmentId): s.departmentName,
        };
      },
      dependencies: [
        sessionGenerationProvider,
        taskCatalogControllerProvider,
        tablesRepositoryProvider,
      ],
    );
