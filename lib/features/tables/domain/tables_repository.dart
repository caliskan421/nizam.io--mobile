import 'table_document.dart';
import 'table_edit.dart';
import 'table_workspace.dart';

/// Tabloya ait açık kapsam; seçili departmana örtük düşmez.
class TableLocation {
  const TableLocation(this.programId, [this.departmentId = '']);
  final String programId;
  final String departmentId;
  bool get personal => departmentId.isEmpty;
  @override
  bool operator ==(Object other) =>
      other is TableLocation &&
      other.programId == programId &&
      other.departmentId == departmentId;
  @override
  int get hashCode => Object.hash(programId, departmentId);
}

class TableWriteReceipt {
  const TableWriteReceipt(this.tableId, this.schemaVersion);
  final String tableId;
  final int schemaVersion;
}

abstract interface class TablesRepository {
  Future<Map<TableDepartmentId, String>> departments(String program);
  Future<TableWorkspace> workspace(
    TableLocation location,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  });
  Future<TableOperationReceipt> execute(
    TableLocation location,
    String id,
    TableEdit edit,
    String key,
  );
  Future<TablePageSlice<TableProjectEntry>> projects(
    TableLocation location, {
    String? cursor,
  });
  Future<String> editProject(
    TableLocation location,
    String? id,
    String? name,
    String key,
  );
  Future<String> copy(
    TableLocation source,
    String id,
    TableLocation target, {
    required bool full,
    required String key,
    String? name,
    String? project,
  });
  Future<TablePageSlice<TableProposalEntry>> proposals(
    TableLocation location, {
    String? cursor,
  });
  Future<String?> decideProposal(
    TableLocation location,
    String id,
    bool approve,
    String key,
  );
  Future<TablePageSlice<TableCommentEntry>> comments(
    TableLocation location,
    String id, {
    String? row,
    String? cursor,
  });
  Future<TableChangePage> changes(TableLocation location, String id, int after);
  Stream<TableLiveEvent> watch(TableLocation location, String id);
  Future<void> presence(
    TableLocation location,
    String id, {
    String? row,
    String? column,
    bool leave = false,
  });
  Future<TableOperationReceipt> upload(
    TableLocation location,
    String id, {
    required String row,
    required String column,
    required int version,
    required String name,
    required Stream<List<int>> bytes,
    required int length,
    required String key,
  });
  Future<Stream<List<int>>> download(
    TableLocation location,
    String id,
    String attachment,
  );
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
