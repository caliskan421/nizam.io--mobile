part of 'tables_api_repository.dart';

String _columnType(TableFieldType t) => switch (t) {
  TableFieldType.todo => 'checkbox',
  TableFieldType.person => 'person_reference',
  TableFieldType.unit => 'department_reference',
  TableFieldType.task => 'task_reference',
  TableFieldType.link => 'table_reference',
  TableFieldType.file => 'attachment',
  _ => t.name,
};
String _accessRole(TableAccess a) => switch (a) {
  TableAccess.edit => 'editor',
  TableAccess.view => 'viewer',
  _ => 'none',
};

api.TableCommand _tableEditCommand(TableEdit e) => switch (e) {
  RenameTable(:final name) => api.TableCommand.renameTable(
    kind: api.TableRenameCommandKind.renameTable,
    name: name,
  ),
  DeleteTable() => const api.TableCommand.deleteTable(
    kind: api.TableDeleteCommandKind.deleteTable,
  ),
  AddTableRow() => const api.TableCommand.addRow(
    kind: api.TableAddRowCommandKind.addRow,
  ),
  DeleteTableRow(:final id) => api.TableCommand.deleteRow(
    kind: api.TableDeleteRowCommandKind.deleteRow,
    id: id,
  ),
  MoveTableRow(:final id, :final after) => api.TableCommand.moveRow(
    kind: api.TableMoveRowCommandKind.moveRow,
    id: id,
    afterId: after,
  ),
  EditTableColumn() => _columnCommand(e),
  WriteTableCells() => throw StateError('Scalar cells use the wire adapter'),
  UndoTableCells(:final sequence) => api.TableCommand.undoCells(
    kind: api.TableUndoCellsCommandKind.undoCells,
    sequence: sequence,
  ),
  GrantTableAccess(:final account, :final access) =>
    access == TableAccess.off
        ? api.TableCommand.revoke(
            kind: api.TableRevokeCommandKind.revoke,
            accountId: account,
          )
        : api.TableCommand.grant(
            kind: api.TableGrantCommandKind.grant,
            accountId: account,
            role: api.TableGrantCommandRole.fromJson(_accessRole(access)),
          ),
  SetTableTeam(:final access) => api.TableCommand.setTeamRole(
    kind: api.TableSetTeamRoleCommandKind.setTeamRole,
    role: api.TableSetTeamRoleCommandRole.fromJson(_accessRole(access)),
  ),
  SetTableProject(:final id) => api.TableCommand.setProject(
    kind: api.TableSetProjectCommandKind.setProject,
    projectId: id ?? '',
  ),
  SetTableTemplate(:final enabled) => api.TableCommand.setTemplate(
    kind: api.TableSetTemplateCommandKind.setTemplate,
    template: enabled,
  ),
  TransferTable() => _transferCommand(e),
  EditTableComment() => switch (e.action) {
    TableCommentAction.add => api.TableCommand.addComment(
      kind: api.TableAddCommentCommandKind.addComment,
      rowId: e.row!,
      columnId: e.column,
      body: e.body,
    ),
    TableCommentAction.edit => api.TableCommand.editComment(
      kind: api.TableEditCommentCommandKind.editComment,
      id: e.id!,
      body: e.body,
    ),
    TableCommentAction.delete => api.TableCommand.deleteComment(
      kind: api.TableDeleteCommentCommandKind.deleteComment,
      id: e.id!,
    ),
  },
};

api.TableCommand _columnCommand(EditTableColumn e) => switch (e.action) {
  TableColumnAction.add => api.TableCommand.addColumn(
    kind: api.TableAddColumnCommandKind.addColumn,
    name: e.field.name,
    type: api.TableColumnType.fromJson(
      e.fileReference ? 'file_reference' : _columnType(e.field.type),
    ),
    width: e.width,
    expectedSchema: e.schema,
    multiple: e.multiple,
  ),
  TableColumnAction.rename => api.TableCommand.renameColumn(
    kind: api.TableRenameColumnCommandKind.renameColumn,
    id: e.field.id,
    name: e.field.name,
    expectedSchema: e.schema,
  ),
  TableColumnAction.resize => api.TableCommand.resizeColumn(
    kind: api.TableResizeColumnCommandKind.resizeColumn,
    id: e.field.id,
    width: e.width,
    expectedSchema: e.schema,
  ),
  TableColumnAction.delete => api.TableCommand.deleteColumn(
    kind: api.TableDeleteColumnCommandKind.deleteColumn,
    id: e.field.id,
    expectedSchema: e.schema,
  ),
  TableColumnAction.move => api.TableCommand.moveColumn(
    kind: api.TableMoveColumnCommandKind.moveColumn,
    id: e.field.id,
    afterId: e.after,
    expectedSchema: e.schema,
  ),
  TableColumnAction.convert => api.TableCommand.convertColumn(
    kind: api.TableConvertColumnCommandKind.convertColumn,
    id: e.field.id,
    type: api.TableColumnType.fromJson(
      e.fileReference ? 'file_reference' : _columnType(e.field.type),
    ),
    expectedSchema: e.schema,
  ),
};
api.TableCommand _transferCommand(TransferTable e) {
  final space = e.target.personal ? 'personal' : 'coordinatorship';
  return switch (e.action) {
    TableTransferAction.move => api.TableCommand.moveTable(
      kind: api.TableMoveCommandKind.moveTable,
      targetSpace: api.TableMoveCommandTargetSpace.fromJson(space),
      targetDepartmentId: e.target.personal ? null : e.target.departmentId,
      targetProjectId: e.project,
    ),
    TableTransferAction.proposeMove => api.TableCommand.proposeMove(
      kind: api.TableProposeCommandKind.proposeMove,
      targetSpace: api.TableProposeCommandTargetSpace.fromJson(space),
      targetDepartmentId: e.target.departmentId,
      targetProjectId: e.project,
      role: api.TableProposeCommandRole.fromJson(_accessRole(e.access)),
    ),
    TableTransferAction.proposeCopy => api.TableCommand.proposeCopy(
      kind: api.TableProposeCommandKind.proposeCopy,
      targetSpace: api.TableProposeCommandTargetSpace.fromJson(space),
      targetDepartmentId: e.target.departmentId,
      targetProjectId: e.project,
      role: api.TableProposeCommandRole.fromJson(_accessRole(e.access)),
    ),
    TableTransferAction.withdraw => const api.TableCommand.withdrawProposal(
      kind: api.TableWithdrawProposalCommandKind.withdrawProposal,
    ),
  };
}
