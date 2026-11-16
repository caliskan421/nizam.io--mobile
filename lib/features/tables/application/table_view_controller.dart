import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/table_document.dart';

final tableHiddenColumnsProvider = NotifierProvider.autoDispose
    .family<TableHiddenColumns, Set<TableFieldId>, String>(
      TableHiddenColumns.new,
      dependencies: [sessionGenerationProvider, scopeStateProvider],
    );

/// Visibility is a view preference, never a destructive schema operation.
class TableHiddenColumns extends Notifier<Set<TableFieldId>> {
  TableHiddenColumns(this.id);
  final String id;
  @override
  Set<TableFieldId> build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return {};
  }

  void toggle(String column) {
    final key = TableFieldId(column);
    state = state.contains(key) ? ({...state}..remove(key)) : {...state, key};
  }
}
