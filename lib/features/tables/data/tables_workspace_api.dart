part of 'tables_api_repository.dart';

mixin _TableWorkspaceApi {
  Dio get _http;
  TableApiExtras _scope(TableApiExtras meta, TableLocation scope);
  Future<Map<TableDepartmentId, String>> departments(String program) async {
    final result = await apiCall(
      () => ProgramClient(_http).listProgramDepartments(
        extras: withProgram(
          ProgramClient.listProgramDepartmentsOpenapiExtras,
          program,
        ),
      ),
    );
    return {
      for (final d in result.data.departments)
        TableDepartmentId(d.departmentId): d.displayName,
    };
  }

  String _path(TableLocation l, String id) =>
      '${l.personal ? '/v1/personal/tables' : '/v1/tables'}/${Uri.encodeComponent(id)}';

  Future<TableWorkspace> workspace(
    TableLocation location,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    final wire = await getTableWorkspaceWire(
      _http,
      path: _path(location, id),
      extras: _scope(
        location.personal
            ? TablesClient.getPersonalTableOpenapiExtras
            : TablesClient.getTableOpenapiExtras,
        location,
      ),
      cursor: query.cursor,
      limit: query.limit,
      filters: [
        for (final f in query.filters)
          '${f.column}:${f.operator.name}${f.operator == TableQueryOperator.empty ? '' : ':${f.value ?? ''}'}',
      ],
      sorts: [
        for (final s in query.sorts)
          '${s.column}:${s.descending ? 'desc' : 'asc'}',
      ],
    );
    if (wire.id != id ||
        !['personal', 'coordinatorship'].contains(wire.space) ||
        (wire.space == 'personal') != location.personal ||
        wire.programId != location.programId ||
        wire.departmentId != location.departmentId) {
      throw invalidResponseError();
    }
    final columns = [
      for (final c in wire.columns)
        if (ApiTablesRepository._type(c.type) case final type?)
          TableColumnState(
            TableField(id: c.id, name: c.name, type: type),
            c.width,
            c.multiple,
            c.type!,
          ),
    ];
    final cells = [
      for (final c in wire.cells)
        TableCellState(
          row: c.rowId,
          column: c.columnId,
          value: c.raw is TableWireNumber
              ? TableDecimal((c.raw! as TableWireNumber).text)
              : c.raw,
          display: c.value == null ? '—' : '${c.value}',
          version: c.version,
          redacted: c.redacted,
        ),
    ];
    final doc = TableDocument(
      id: id,
      title: wire.name,
      area: wire.ownerId == account
          ? (location.personal ? TableArea.personal : TableArea.coord)
          : TableArea.shared,
      fields: [for (final c in columns) c.field],
      rows: [
        for (final r in wire.rowIds)
          TableRecord(
            id: r,
            cells: {
              for (final c in cells)
                if (c.row == r) TableFieldId(c.column): c.display,
            },
          ),
      ],
      unit: location.departmentId,
      remote: true,
      programId: location.programId,
      ownerId: wire.ownerId,
      projectId: wire.project,
      isTemplate: wire.template,
      access: wire.ownerId == account ? TableAccess.owner : TableAccess.view,
      teamAccess: wire.teamRole == 'editor'
          ? TableAccess.edit
          : wire.teamRole == 'viewer'
          ? TableAccess.view
          : TableAccess.off,
      previewHasMore: wire.hasMore,
    );
    return TableWorkspace(
      document: doc,
      schema: wire.schema,
      sequence: wire.sequence,
      columns: columns,
      cells: cells,
      cursor: wire.cursor,
      project: wire.project,
      template: wire.template,
      linkedTables: Map.unmodifiable({
        for (final entry in wire.tableReferences.entries)
          TableDocumentId(entry.key): entry.value,
      }),
      attachments: [
        for (final a in wire.attachments)
          TableAttachment(a.id, a.name, a.type, a.size),
      ],
    );
  }

  Future<TableOperationReceipt> execute(
    TableLocation location,
    String id,
    TableEdit edit,
    String key,
  ) async {
    if (edit is WriteTableCells &&
        (edit.cells.isEmpty ||
            edit.cells.length > 100 ||
            edit.cells.any(
              (c) =>
                  c.value is TableDecimal && !(c.value! as TableDecimal).valid,
            ))) {
      throw ApiError('tables.input_invalid');
    }
    final command = edit is WriteTableCells
        ? TableWireCommand.cells([
            for (final c in edit.cells)
              (
                row: c.row,
                column: c.column,
                value: c.value is TableDecimal
                    ? TableWireNumber((c.value! as TableDecimal).value)
                    : c.value,
                version: c.version,
              ),
          ])
        : TableWireCommand.fromGeneratedJson(_tableEditCommand(edit).toJson());
    final r = await postTableWireCommand(
      _http,
      id: id,
      personal: location.personal,
      key: key,
      command: command,
      extras: _scope(
        location.personal
            ? TablesClient.applyPersonalTableOperationOpenapiExtras
            : TablesClient.applyTableOperationOpenapiExtras,
        location,
      ),
    );
    if (r.schemaVersion < 1 ||
        r.sequence < 1 ||
        ((edit is AddTableRow ||
                (edit is EditTableColumn &&
                    edit.action == TableColumnAction.add)) &&
            (r.id == null || r.id!.isEmpty))) {
      throw invalidResponseError();
    }
    return TableOperationReceipt(
      table: r.tableId,
      sequence: r.sequence,
      schema: r.schemaVersion,
      id: r.id,
      skipped: r.skipped,
      skippedCells: [
        for (final s in r.skippedCells)
          TableSkippedCellInfo(s.row, s.column, s.reason),
      ],
    );
  }

  Future<TablePageSlice<TableProjectEntry>> projects(
    TableLocation l, {
    String? cursor,
  }) async {
    final client = TablesClient(_http);
    final p = await apiCall(
      () => l.personal
          ? client.listPersonalTableProjects(
              cursor: cursor,
              extras: _scope(
                TablesClient.listPersonalTableProjectsOpenapiExtras,
                l,
              ),
            )
          : client.listTableProjects(
              cursor: cursor,
              extras: _scope(TablesClient.listTableProjectsOpenapiExtras, l),
            ),
    );
    return TablePageSlice([
      for (final t in p.items) TableProjectEntry(t.id, t.name),
    ], p.nextCursor);
  }

  Future<String> editProject(
    TableLocation l,
    String? id,
    String? name,
    String key,
  ) async {
    final client = TablesClient(_http);
    final command = id == null
        ? api.TableProjectCommand.createProject(
            kind: api.TableCreateProjectCommandKind.createProject,
            name: name!,
          )
        : name == null
        ? api.TableProjectCommand.deleteProject(
            kind: api.TableDeleteProjectCommandKind.deleteProject,
            id: id,
          )
        : api.TableProjectCommand.renameProject(
            kind: api.TableRenameProjectCommandKind.renameProject,
            id: id,
            name: name,
          );
    final r = await apiCall(
      () => l.personal
          ? client.applyPersonalTableProjectCommand(
              idempotencyKey: key,
              body: command,
              extras: _scope(
                TablesClient.applyPersonalTableProjectCommandOpenapiExtras,
                l,
              ),
            )
          : client.applyTableProjectCommand(
              idempotencyKey: key,
              body: command,
              extras: _scope(
                TablesClient.applyTableProjectCommandOpenapiExtras,
                l,
              ),
            ),
    );
    return r.id;
  }

  Future<String> copy(
    TableLocation source,
    String id,
    TableLocation target, {
    required bool full,
    required String key,
    String? name,
    String? project,
  }) async {
    // Optional alanlar null yerine atlanır (sözleşme boş/null değeri reddeder).
    final body = api.TableCopyRequest(
      sourceTableId: id,
      sourceSpace: api.TableCopyRequestSourceSpace.fromJson(
        source.personal ? 'personal' : 'coordinatorship',
      ),
      sourceProgramId: source.programId,
      sourceDepartmentId: source.personal ? null : source.departmentId,
      mode: api.TableCopyRequestMode.fromJson(full ? 'full' : 'structure'),
      name: name,
      projectId: project,
    );
    final r = await postTableCopyWire(
      _http,
      personal: target.personal,
      key: key,
      body: body.toJson(),
      extras: _scope(
        target.personal
            ? TablesClient.copyTableToPersonalOpenapiExtras
            : TablesClient.copyTableToCoordinatorshipOpenapiExtras,
        target,
      ),
    );
    return r;
  }

  Future<TablePageSlice<TableProposalEntry>> proposals(
    TableLocation l, {
    String? cursor,
  }) async {
    final p = await apiCall(
      () => TablesClient(_http).listTableProposals(
        cursor: cursor,
        extras: _scope(TablesClient.listTableProposalsOpenapiExtras, l),
      ),
    );
    return TablePageSlice([
      for (final t in p.items)
        TableProposalEntry(
          id: t.id,
          title: t.title,
          kind: t.kind.json ?? '',
          status: t.status.json ?? '',
          rows: t.rowCount,
          columns: [for (final c in t.columns) c.name],
          proposer: t.proposerId,
          created: t.createdAt,
        ),
    ], p.nextCursor);
  }

  Future<String?> decideProposal(
    TableLocation l,
    String id,
    bool approve,
    String key,
  ) async {
    final r = await apiCall(
      () => TablesClient(_http).decideTableProposal(
        proposalId: id,
        idempotencyKey: key,
        body: api.TableProposalDecisionRequest(
          decision: approve
              ? api.TableProposalDecisionRequestDecision.approve
              : api.TableProposalDecisionRequestDecision.reject,
        ),
        extras: _scope(TablesClient.decideTableProposalOpenapiExtras, l),
      ),
    );
    return r.tableId;
  }
}
