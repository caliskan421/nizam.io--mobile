import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/tables_client.dart';
import '../../../core/api/generated/export.dart' as api;
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../../../core/http/table_wire.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';

class ApiTablesRepository implements TablesRepository {
  ApiTablesRepository(this._dio);
  final Dio? Function() _dio;
  Dio get _http {
    final dio = _dio();
    if (dio == null) throw ApiError('client.server_not_verified');
    return dio;
  }

  TableApiExtras _scope(TableApiExtras meta, TableLocation scope) {
    if (scope.programId.isEmpty) throw ApiError('client.scope_missing');
    return scope.personal
        ? withProgram(meta, scope.programId)
        : withScope(meta, scope.programId, scope.departmentId);
  }

  @override
  Future<List<TableDocument>> list(
    TableLocation location,
    String accountId,
  ) async {
    final client = TablesClient(_http);
    final result = <TableDocument>[];
    final seen = <String>{};
    String? cursor;
    for (var page = 0; page < 100; page++) {
      final response = await apiCall(
        () => location.personal
            ? client.listPersonalTables(
                limit: 200,
                cursor: cursor,
                extras: _scope(
                  TablesClient.listPersonalTablesOpenapiExtras,
                  location,
                ),
              )
            : client.listTables(
                limit: 200,
                cursor: cursor,
                extras: _scope(TablesClient.listTablesOpenapiExtras, location),
              ),
      );
      for (final t in response.items) {
        _checkScope(t, location);
        result.add(_table(t, accountId));
      }
      cursor = response.nextCursor;
      if (cursor == null || cursor.isEmpty) return result;
      if (!seen.add(cursor)) throw invalidResponseError();
    }
    throw invalidResponseError();
  }

  void _checkScope(api.Table t, TableLocation scope) {
    if (t.programId != scope.programId ||
        t.departmentId != scope.departmentId) {
      throw invalidResponseError();
    }
  }

  TableDocument _table(api.Table t, String account) {
    if (!['personal', 'coordinatorship'].contains(t.space.json) ||
        (t.space.json == 'personal') != t.departmentId.isEmpty) {
      throw invalidResponseError();
    }
    return TableDocument(
      id: t.id,
      title: t.name,
      area: t.ownerId != account
          ? TableArea.shared
          : t.departmentId.isEmpty
          ? TableArea.personal
          : TableArea.coord,
      unit: t.departmentId,
      fields: const [],
      access: t.ownerId == account ? TableAccess.owner : TableAccess.view,
      teamAccess: t.teamRole?.json == 'editor'
          ? TableAccess.edit
          : t.teamRole?.json == 'viewer'
          ? TableAccess.view
          : TableAccess.off,
      remote: true,
      programId: t.programId,
      ownerId: t.ownerId,
    );
  }

  @override
  Future<TableDocument> read(
    TableLocation location,
    String id,
    String accountId,
  ) async {
    final wire = await getTableWirePreview(
      _http,
      id: id,
      personal: location.personal,
      extras: _scope(
        location.personal
            ? TablesClient.getPersonalTableOpenapiExtras
            : TablesClient.getTableOpenapiExtras,
        location,
      ),
    );
    if (wire.id != id ||
        wire.programId != location.programId ||
        wire.departmentId != location.departmentId ||
        !['personal', 'coordinatorship'].contains(wire.space) ||
        (wire.space == 'personal') != wire.departmentId.isEmpty) {
      throw invalidResponseError();
    }
    final fields = <TableField>[
      for (final c in wire.columns)
        if (_type(c.type) case final type?)
          TableField(id: c.id, name: c.name, type: type),
    ];
    return TableDocument(
      id: wire.id,
      title: wire.name,
      area: wire.ownerId != accountId
          ? TableArea.shared
          : location.personal
          ? TableArea.personal
          : TableArea.coord,
      unit: wire.departmentId,
      fields: const [],
      remote: true,
      programId: wire.programId,
      ownerId: wire.ownerId,
      access: wire.ownerId == accountId ? TableAccess.owner : TableAccess.view,
      teamAccess: wire.teamRole == 'editor'
          ? TableAccess.edit
          : wire.teamRole == 'viewer'
          ? TableAccess.view
          : TableAccess.off,
    ).copyWith(
      fields: fields,
      rows: [
        for (final row in wire.rowIds)
          TableRecord(
            id: row,
            cells: {
              for (final cell in wire.cells)
                if (cell.rowId == row && cell.value != null)
                  TableFieldId(cell.columnId): cell.value!,
            },
          ),
      ],
      previewHasMore: wire.hasMore,
    );
  }

  static TableFieldType? _type(String? type) => switch (type) {
    'text' => TableFieldType.text,
    'number' => TableFieldType.number,
    'date' => TableFieldType.date,
    'phone' => TableFieldType.phone,
    'email' => TableFieldType.email,
    'checkbox' => TableFieldType.todo,
    'person_reference' => TableFieldType.person,
    'department_reference' => TableFieldType.unit,
    'task_reference' => TableFieldType.task,
    'file_reference' || 'attachment' => TableFieldType.file,
    'table_reference' => TableFieldType.link,
    _ => null,
  };
  @override
  Future<TableWriteReceipt> create(
    TableLocation location,
    String name,
    String key,
  ) async {
    final client = TablesClient(_http);
    final r = await apiCall(
      () => location.personal
          ? client.createPersonalTable(
              idempotencyKey: key,
              body: api.TableCreateRequest(name: name),
              extras: _scope(
                TablesClient.createPersonalTableOpenapiExtras,
                location,
              ),
            )
          : client.createTable(
              idempotencyKey: key,
              body: api.TableCreateRequest(name: name),
              extras: _scope(TablesClient.createTableOpenapiExtras, location),
            ),
    );
    return _receipt(r.tableId, r.schemaVersion);
  }

  TableWriteReceipt _receipt(String tableId, int schemaVersion) {
    if (tableId.isEmpty || schemaVersion < 1) {
      throw invalidResponseError();
    }
    return TableWriteReceipt(tableId, schemaVersion);
  }

  Future<TableWireReceipt> _apply(
    TableLocation location,
    String id,
    api.TableCommand command,
    String key,
  ) => postTableWireCommand(
    _http,
    id: id,
    personal: location.personal,
    key: key,
    command: TableWireCommand.fromGeneratedJson(command.toJson()),
    extras: _scope(
      location.personal
          ? TablesClient.applyPersonalTableOperationOpenapiExtras
          : TablesClient.applyTableOperationOpenapiExtras,
      location,
    ),
  );
  @override
  Future<TableWriteReceipt> addColumn(
    TableLocation location,
    String id,
    TableField field,
    int schemaVersion,
    String key,
  ) async {
    final type = switch (field.type) {
      TableFieldType.todo => 'checkbox',
      TableFieldType.person => 'person_reference',
      TableFieldType.unit => 'department_reference',
      TableFieldType.task => 'task_reference',
      TableFieldType.link => 'table_reference',
      TableFieldType.file => 'attachment',
      _ => field.type.name,
    };
    final r = await _apply(
      location,
      id,
      api.TableCommand.addColumn(
        kind: api.TableAddColumnCommandKind.addColumn,
        name: field.name,
        type: api.TableColumnType.fromJson(type),
        width: 180,
        expectedSchema: schemaVersion,
        multiple: false,
      ),
      key,
    );
    return _receipt(r.tableId, r.schemaVersion);
  }

  String _role(TableAccess access) {
    if (access != TableAccess.view && access != TableAccess.edit) {
      throw ApiError('tables.input_invalid');
    }
    return access == TableAccess.edit ? 'editor' : 'viewer';
  }

  @override
  Future<void> grant(
    TableLocation location,
    String id,
    String person,
    TableAccess access,
    String key,
  ) async {
    await _apply(
      location,
      id,
      api.TableCommand.grant(
        kind: api.TableGrantCommandKind.grant,
        accountId: person,
        role: api.TableGrantCommandRole.fromJson(_role(access)),
      ),
      key,
    );
  }

  @override
  Future<void> setTeamRole(
    TableLocation location,
    String id,
    TableAccess access,
    String key,
  ) async {
    await _apply(
      location,
      id,
      api.TableCommand.setTeamRole(
        kind: api.TableSetTeamRoleCommandKind.setTeamRole,
        role: api.TableSetTeamRoleCommandRole.fromJson(_role(access)),
      ),
      key,
    );
  }

  @override
  Future<void> propose(
    TableLocation location,
    String id,
    String department,
    TableAccess access,
    String key,
  ) async {
    await _apply(
      location,
      id,
      api.TableCommand.proposeMove(
        kind: api.TableProposeCommandKind.proposeMove,
        targetSpace: api.TableProposeCommandTargetSpace.coordinatorship,
        targetDepartmentId: department,
        role: api.TableProposeCommandRole.fromJson(_role(access)),
      ),
      key,
    );
  }
}
