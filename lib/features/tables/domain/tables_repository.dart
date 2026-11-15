import 'table_document.dart';

/// Tabloya ait açık kapsam; seçili departmana örtük düşmez.
class TableLocation {
  const TableLocation(this.programId, [this.departmentId = '']);
  final String programId;
  final String departmentId;
  bool get personal => departmentId.isEmpty;
}

class TableWriteReceipt {
  const TableWriteReceipt(this.tableId, this.schemaVersion);
  final String tableId;
  final int schemaVersion;
}

abstract interface class TablesRepository {
  Future<List<TableDocument>> list(TableLocation location, String accountId);
  Future<TableDocument> read(
    TableLocation location,
    String id,
    String accountId,
  );
  Future<TableWriteReceipt> create(
    TableLocation location,
    String name,
    String key,
  );
  Future<TableWriteReceipt> addColumn(
    TableLocation location,
    String id,
    TableField field,
    int schemaVersion,
    String key,
  );
  Future<void> grant(
    TableLocation location,
    String id,
    String person,
    TableAccess access,
    String key,
  );
  Future<void> setTeamRole(
    TableLocation location,
    String id,
    TableAccess access,
    String key,
  );
  Future<void> propose(
    TableLocation location,
    String id,
    String department,
    TableAccess access,
    String key,
  );
}
