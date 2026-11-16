import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';

/// Convert dynamic team access into explicit grants before closing team access.
/// Completed steps survive partial errors; every retry uses its original key.
class TableTeamSharingJob {
  TableTeamSharingJob({
    required this.repository,
    required this.location,
    required this.table,
    required Map<TablePersonId, TableAccess> people,
    required TablePersonId changed,
    required TableAccess access,
  }) : _steps = [
         for (final entry in people.entries)
           GrantTableAccess(entry.key.value, entry.value),
         if (access == TableAccess.off) GrantTableAccess(changed.value, access),
         const SetTableTeam(TableAccess.off),
       ];
  final TablesRepository repository;
  final TableLocation location;
  final String table;
  final List<TableEdit> _steps;
  final _keys = <int, String>{};
  int _next = 0;
  TableOperationReceipt? _receipt;
  bool get started => _next > 0;

  Future<TableOperationReceipt> submit({
    required bool Function() isCurrent,
  }) async {
    while (_next < _steps.length) {
      if (!isCurrent()) throw ApiError('client.scope_changed');
      final receipt = await repository.execute(
        location,
        table,
        _steps[_next],
        _keys.putIfAbsent(_next, newRequestKey),
      );
      if (!isCurrent()) throw ApiError('client.scope_changed');
      _receipt = receipt;
      _next++;
    }
    return _receipt!;
  }
}
