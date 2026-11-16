import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'table_library_controller.dart';
import 'tables_server.dart';

/// Explicit page/scope keys fence late responses; mutations invalidate folder pages.
final tableFolderPageProvider = FutureProvider.autoDispose
    .family<
      TablePageSlice<TableProjectEntry>,
      ({TableLocation location, String? cursor})
    >(
      (ref, key) async {
        ref.watch(sessionGenerationProvider);
        ref.watch(scopeStateProvider);
        ref.watch(tableLibraryWritesProvider.select((s) => s.revision));
        try {
          return await ref
              .watch(tablesRepositoryProvider)!
              .projects(key.location, cursor: key.cursor);
        } catch (error, stack) {
          reportUnexpected(error, stack, source: ReportSource.ui);
          rethrow;
        }
      },
      dependencies: [
        sessionGenerationProvider,
        scopeStateProvider,
        tableLibraryWritesProvider,
        tablesRepositoryProvider,
      ],
    );
