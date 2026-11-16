import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/table_document.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'tables_server.dart';

/// Read-only page for the row count; cards render only the first three rows.
/// A list refresh replaces the document key. No presence or SSE.
final tableCardPreviewProvider = FutureProvider.autoDispose
    .family<TableWorkspace, TableDocument>(
      (ref, document) async {
        ref.watch(sessionGenerationProvider);
        ref.watch(scopeStateProvider);
        final repository = ref.watch(tablesRepositoryProvider)!;
        final choices = await ref.watch(tableSharingChoicesProvider.future);
        return repository.workspace(
          TableLocation(document.programId, document.unit),
          document.id,
          choices.accountId,
          query: const TableReadQuery(limit: 100),
        );
      },
      dependencies: [
        sessionGenerationProvider,
        scopeStateProvider,
        tablesRepositoryProvider,
        tableSharingChoicesProvider,
      ],
    );
