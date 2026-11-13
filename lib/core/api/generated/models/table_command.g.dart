// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableCommandSetTeamRole _$TableCommandSetTeamRoleFromJson(
  Map<String, dynamic> json,
) => TableCommandSetTeamRole(
  kind: TableSetTeamRoleCommandKind.fromJson(json['kind'] as String),
  role: TableSetTeamRoleCommandRole.fromJson(json['role'] as String),
);

Map<String, dynamic> _$TableCommandSetTeamRoleToJson(
  TableCommandSetTeamRole instance,
) => <String, dynamic>{
  'kind': _$TableSetTeamRoleCommandKindEnumMap[instance.kind]!,
  'role': _$TableSetTeamRoleCommandRoleEnumMap[instance.role]!,
};

const _$TableSetTeamRoleCommandKindEnumMap = {
  TableSetTeamRoleCommandKind.setTeamRole: 'set_team_role',
  TableSetTeamRoleCommandKind.$unknown: r'$unknown',
};

const _$TableSetTeamRoleCommandRoleEnumMap = {
  TableSetTeamRoleCommandRole.editor: 'editor',
  TableSetTeamRoleCommandRole.viewer: 'viewer',
  TableSetTeamRoleCommandRole.none: 'none',
  TableSetTeamRoleCommandRole.$unknown: r'$unknown',
};

TableCommandSetProject _$TableCommandSetProjectFromJson(
  Map<String, dynamic> json,
) => TableCommandSetProject(
  kind: TableSetProjectCommandKind.fromJson(json['kind'] as String),
  projectId: json['project_id'] as String?,
);

Map<String, dynamic> _$TableCommandSetProjectToJson(
  TableCommandSetProject instance,
) => <String, dynamic>{
  'kind': _$TableSetProjectCommandKindEnumMap[instance.kind]!,
  'project_id': ?instance.projectId,
};

const _$TableSetProjectCommandKindEnumMap = {
  TableSetProjectCommandKind.setProject: 'set_project',
  TableSetProjectCommandKind.$unknown: r'$unknown',
};

TableCommandSetTemplate _$TableCommandSetTemplateFromJson(
  Map<String, dynamic> json,
) => TableCommandSetTemplate(
  kind: TableSetTemplateCommandKind.fromJson(json['kind'] as String),
  template: json['template'] as bool,
);

Map<String, dynamic> _$TableCommandSetTemplateToJson(
  TableCommandSetTemplate instance,
) => <String, dynamic>{
  'kind': _$TableSetTemplateCommandKindEnumMap[instance.kind]!,
  'template': instance.template,
};

const _$TableSetTemplateCommandKindEnumMap = {
  TableSetTemplateCommandKind.setTemplate: 'set_template',
  TableSetTemplateCommandKind.$unknown: r'$unknown',
};

TableCommandMoveTable _$TableCommandMoveTableFromJson(
  Map<String, dynamic> json,
) => TableCommandMoveTable(
  kind: TableMoveCommandKind.fromJson(json['kind'] as String),
  targetSpace: TableMoveCommandTargetSpace.fromJson(
    json['target_space'] as String,
  ),
  targetDepartmentId: json['target_department_id'] as String?,
  targetProjectId: json['target_project_id'] as String?,
);

Map<String, dynamic> _$TableCommandMoveTableToJson(
  TableCommandMoveTable instance,
) => <String, dynamic>{
  'kind': _$TableMoveCommandKindEnumMap[instance.kind]!,
  'target_space': _$TableMoveCommandTargetSpaceEnumMap[instance.targetSpace]!,
  'target_department_id': ?instance.targetDepartmentId,
  'target_project_id': ?instance.targetProjectId,
};

const _$TableMoveCommandKindEnumMap = {
  TableMoveCommandKind.moveTable: 'move_table',
  TableMoveCommandKind.$unknown: r'$unknown',
};

const _$TableMoveCommandTargetSpaceEnumMap = {
  TableMoveCommandTargetSpace.personal: 'personal',
  TableMoveCommandTargetSpace.coordinatorship: 'coordinatorship',
  TableMoveCommandTargetSpace.$unknown: r'$unknown',
};

TableCommandProposeMove _$TableCommandProposeMoveFromJson(
  Map<String, dynamic> json,
) => TableCommandProposeMove(
  kind: TableProposeCommandKind.fromJson(json['kind'] as String),
  targetSpace: TableProposeCommandTargetSpace.fromJson(
    json['target_space'] as String,
  ),
  targetDepartmentId: json['target_department_id'] as String,
  targetProjectId: json['target_project_id'] as String?,
  role: json['role'] == null
      ? null
      : TableProposeCommandRole.fromJson(json['role'] as String),
);

Map<String, dynamic> _$TableCommandProposeMoveToJson(
  TableCommandProposeMove instance,
) => <String, dynamic>{
  'kind': _$TableProposeCommandKindEnumMap[instance.kind]!,
  'target_space':
      _$TableProposeCommandTargetSpaceEnumMap[instance.targetSpace]!,
  'target_department_id': instance.targetDepartmentId,
  'target_project_id': ?instance.targetProjectId,
  'role': ?_$TableProposeCommandRoleEnumMap[instance.role],
};

const _$TableProposeCommandKindEnumMap = {
  TableProposeCommandKind.proposeMove: 'propose_move',
  TableProposeCommandKind.proposeCopy: 'propose_copy',
  TableProposeCommandKind.$unknown: r'$unknown',
};

const _$TableProposeCommandTargetSpaceEnumMap = {
  TableProposeCommandTargetSpace.coordinatorship: 'coordinatorship',
  TableProposeCommandTargetSpace.$unknown: r'$unknown',
};

const _$TableProposeCommandRoleEnumMap = {
  TableProposeCommandRole.editor: 'editor',
  TableProposeCommandRole.viewer: 'viewer',
  TableProposeCommandRole.$unknown: r'$unknown',
};

TableCommandProposeCopy _$TableCommandProposeCopyFromJson(
  Map<String, dynamic> json,
) => TableCommandProposeCopy(
  kind: TableProposeCommandKind.fromJson(json['kind'] as String),
  targetSpace: TableProposeCommandTargetSpace.fromJson(
    json['target_space'] as String,
  ),
  targetDepartmentId: json['target_department_id'] as String,
  targetProjectId: json['target_project_id'] as String?,
  role: json['role'] == null
      ? null
      : TableProposeCommandRole.fromJson(json['role'] as String),
);

Map<String, dynamic> _$TableCommandProposeCopyToJson(
  TableCommandProposeCopy instance,
) => <String, dynamic>{
  'kind': _$TableProposeCommandKindEnumMap[instance.kind]!,
  'target_space':
      _$TableProposeCommandTargetSpaceEnumMap[instance.targetSpace]!,
  'target_department_id': instance.targetDepartmentId,
  'target_project_id': ?instance.targetProjectId,
  'role': ?_$TableProposeCommandRoleEnumMap[instance.role],
};

TableCommandWithdrawProposal _$TableCommandWithdrawProposalFromJson(
  Map<String, dynamic> json,
) => TableCommandWithdrawProposal(
  kind: TableWithdrawProposalCommandKind.fromJson(json['kind'] as String),
);

Map<String, dynamic> _$TableCommandWithdrawProposalToJson(
  TableCommandWithdrawProposal instance,
) => <String, dynamic>{
  'kind': _$TableWithdrawProposalCommandKindEnumMap[instance.kind]!,
};

const _$TableWithdrawProposalCommandKindEnumMap = {
  TableWithdrawProposalCommandKind.withdrawProposal: 'withdraw_proposal',
  TableWithdrawProposalCommandKind.$unknown: r'$unknown',
};

TableCommandConvertColumn _$TableCommandConvertColumnFromJson(
  Map<String, dynamic> json,
) => TableCommandConvertColumn(
  kind: TableConvertColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  type: TableColumnType.fromJson(json['type'] as String),
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableCommandConvertColumnToJson(
  TableCommandConvertColumn instance,
) => <String, dynamic>{
  'kind': _$TableConvertColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'type': _$TableColumnTypeEnumMap[instance.type]!,
  'expected_schema': instance.expectedSchema,
};

const _$TableConvertColumnCommandKindEnumMap = {
  TableConvertColumnCommandKind.convertColumn: 'convert_column',
  TableConvertColumnCommandKind.$unknown: r'$unknown',
};

const _$TableColumnTypeEnumMap = {
  TableColumnType.text: 'text',
  TableColumnType.number: 'number',
  TableColumnType.phone: 'phone',
  TableColumnType.email: 'email',
  TableColumnType.date: 'date',
  TableColumnType.checkbox: 'checkbox',
  TableColumnType.tableReference: 'table_reference',
  TableColumnType.personReference: 'person_reference',
  TableColumnType.departmentReference: 'department_reference',
  TableColumnType.taskReference: 'task_reference',
  TableColumnType.fileReference: 'file_reference',
  TableColumnType.attachment: 'attachment',
  TableColumnType.$unknown: r'$unknown',
};

TableCommandMoveRow _$TableCommandMoveRowFromJson(Map<String, dynamic> json) =>
    TableCommandMoveRow(
      kind: TableMoveRowCommandKind.fromJson(json['kind'] as String),
      id: json['id'] as String,
      afterId: json['after_id'] as String?,
    );

Map<String, dynamic> _$TableCommandMoveRowToJson(
  TableCommandMoveRow instance,
) => <String, dynamic>{
  'kind': _$TableMoveRowCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'after_id': ?instance.afterId,
};

const _$TableMoveRowCommandKindEnumMap = {
  TableMoveRowCommandKind.moveRow: 'move_row',
  TableMoveRowCommandKind.$unknown: r'$unknown',
};

TableCommandMoveColumn _$TableCommandMoveColumnFromJson(
  Map<String, dynamic> json,
) => TableCommandMoveColumn(
  kind: TableMoveColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  expectedSchema: (json['expected_schema'] as num).toInt(),
  afterId: json['after_id'] as String?,
);

Map<String, dynamic> _$TableCommandMoveColumnToJson(
  TableCommandMoveColumn instance,
) => <String, dynamic>{
  'kind': _$TableMoveColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'expected_schema': instance.expectedSchema,
  'after_id': ?instance.afterId,
};

const _$TableMoveColumnCommandKindEnumMap = {
  TableMoveColumnCommandKind.moveColumn: 'move_column',
  TableMoveColumnCommandKind.$unknown: r'$unknown',
};

TableCommandAddComment _$TableCommandAddCommentFromJson(
  Map<String, dynamic> json,
) => TableCommandAddComment(
  kind: TableAddCommentCommandKind.fromJson(json['kind'] as String),
  rowId: json['row_id'] as String,
  body: json['body'] as String,
  columnId: json['column_id'] as String?,
);

Map<String, dynamic> _$TableCommandAddCommentToJson(
  TableCommandAddComment instance,
) => <String, dynamic>{
  'kind': _$TableAddCommentCommandKindEnumMap[instance.kind]!,
  'row_id': instance.rowId,
  'body': instance.body,
  'column_id': ?instance.columnId,
};

const _$TableAddCommentCommandKindEnumMap = {
  TableAddCommentCommandKind.addComment: 'add_comment',
  TableAddCommentCommandKind.$unknown: r'$unknown',
};

TableCommandEditComment _$TableCommandEditCommentFromJson(
  Map<String, dynamic> json,
) => TableCommandEditComment(
  kind: TableEditCommentCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  body: json['body'] as String,
);

Map<String, dynamic> _$TableCommandEditCommentToJson(
  TableCommandEditComment instance,
) => <String, dynamic>{
  'kind': _$TableEditCommentCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'body': instance.body,
};

const _$TableEditCommentCommandKindEnumMap = {
  TableEditCommentCommandKind.editComment: 'edit_comment',
  TableEditCommentCommandKind.$unknown: r'$unknown',
};

TableCommandDeleteComment _$TableCommandDeleteCommentFromJson(
  Map<String, dynamic> json,
) => TableCommandDeleteComment(
  kind: TableDeleteCommentCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
);

Map<String, dynamic> _$TableCommandDeleteCommentToJson(
  TableCommandDeleteComment instance,
) => <String, dynamic>{
  'kind': _$TableDeleteCommentCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
};

const _$TableDeleteCommentCommandKindEnumMap = {
  TableDeleteCommentCommandKind.deleteComment: 'delete_comment',
  TableDeleteCommentCommandKind.$unknown: r'$unknown',
};

TableCommandUndoCells _$TableCommandUndoCellsFromJson(
  Map<String, dynamic> json,
) => TableCommandUndoCells(
  kind: TableUndoCellsCommandKind.fromJson(json['kind'] as String),
  sequence: (json['sequence'] as num).toInt(),
);

Map<String, dynamic> _$TableCommandUndoCellsToJson(
  TableCommandUndoCells instance,
) => <String, dynamic>{
  'kind': _$TableUndoCellsCommandKindEnumMap[instance.kind]!,
  'sequence': instance.sequence,
};

const _$TableUndoCellsCommandKindEnumMap = {
  TableUndoCellsCommandKind.undoCells: 'undo_cells',
  TableUndoCellsCommandKind.$unknown: r'$unknown',
};

TableCommandRenameTable _$TableCommandRenameTableFromJson(
  Map<String, dynamic> json,
) => TableCommandRenameTable(
  kind: TableRenameCommandKind.fromJson(json['kind'] as String),
  name: json['name'] as String,
);

Map<String, dynamic> _$TableCommandRenameTableToJson(
  TableCommandRenameTable instance,
) => <String, dynamic>{
  'kind': _$TableRenameCommandKindEnumMap[instance.kind]!,
  'name': instance.name,
};

const _$TableRenameCommandKindEnumMap = {
  TableRenameCommandKind.renameTable: 'rename_table',
  TableRenameCommandKind.$unknown: r'$unknown',
};

TableCommandDeleteTable _$TableCommandDeleteTableFromJson(
  Map<String, dynamic> json,
) => TableCommandDeleteTable(
  kind: TableDeleteCommandKind.fromJson(json['kind'] as String),
);

Map<String, dynamic> _$TableCommandDeleteTableToJson(
  TableCommandDeleteTable instance,
) => <String, dynamic>{'kind': _$TableDeleteCommandKindEnumMap[instance.kind]!};

const _$TableDeleteCommandKindEnumMap = {
  TableDeleteCommandKind.deleteTable: 'delete_table',
  TableDeleteCommandKind.$unknown: r'$unknown',
};

TableCommandAddColumn _$TableCommandAddColumnFromJson(
  Map<String, dynamic> json,
) => TableCommandAddColumn(
  kind: TableAddColumnCommandKind.fromJson(json['kind'] as String),
  name: json['name'] as String,
  type: TableColumnType.fromJson(json['type'] as String),
  width: (json['width'] as num).toInt(),
  expectedSchema: (json['expected_schema'] as num).toInt(),
  multiple: json['multiple'] as bool? ?? false,
);

Map<String, dynamic> _$TableCommandAddColumnToJson(
  TableCommandAddColumn instance,
) => <String, dynamic>{
  'kind': _$TableAddColumnCommandKindEnumMap[instance.kind]!,
  'name': instance.name,
  'type': _$TableColumnTypeEnumMap[instance.type]!,
  'width': instance.width,
  'expected_schema': instance.expectedSchema,
  'multiple': instance.multiple,
};

const _$TableAddColumnCommandKindEnumMap = {
  TableAddColumnCommandKind.addColumn: 'add_column',
  TableAddColumnCommandKind.$unknown: r'$unknown',
};

TableCommandRenameColumn _$TableCommandRenameColumnFromJson(
  Map<String, dynamic> json,
) => TableCommandRenameColumn(
  kind: TableRenameColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  name: json['name'] as String,
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableCommandRenameColumnToJson(
  TableCommandRenameColumn instance,
) => <String, dynamic>{
  'kind': _$TableRenameColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'name': instance.name,
  'expected_schema': instance.expectedSchema,
};

const _$TableRenameColumnCommandKindEnumMap = {
  TableRenameColumnCommandKind.renameColumn: 'rename_column',
  TableRenameColumnCommandKind.$unknown: r'$unknown',
};

TableCommandResizeColumn _$TableCommandResizeColumnFromJson(
  Map<String, dynamic> json,
) => TableCommandResizeColumn(
  kind: TableResizeColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  width: (json['width'] as num).toInt(),
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableCommandResizeColumnToJson(
  TableCommandResizeColumn instance,
) => <String, dynamic>{
  'kind': _$TableResizeColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'width': instance.width,
  'expected_schema': instance.expectedSchema,
};

const _$TableResizeColumnCommandKindEnumMap = {
  TableResizeColumnCommandKind.resizeColumn: 'resize_column',
  TableResizeColumnCommandKind.$unknown: r'$unknown',
};

TableCommandDeleteColumn _$TableCommandDeleteColumnFromJson(
  Map<String, dynamic> json,
) => TableCommandDeleteColumn(
  kind: TableDeleteColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableCommandDeleteColumnToJson(
  TableCommandDeleteColumn instance,
) => <String, dynamic>{
  'kind': _$TableDeleteColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'expected_schema': instance.expectedSchema,
};

const _$TableDeleteColumnCommandKindEnumMap = {
  TableDeleteColumnCommandKind.deleteColumn: 'delete_column',
  TableDeleteColumnCommandKind.$unknown: r'$unknown',
};

TableCommandAddRow _$TableCommandAddRowFromJson(Map<String, dynamic> json) =>
    TableCommandAddRow(
      kind: TableAddRowCommandKind.fromJson(json['kind'] as String),
    );

Map<String, dynamic> _$TableCommandAddRowToJson(TableCommandAddRow instance) =>
    <String, dynamic>{'kind': _$TableAddRowCommandKindEnumMap[instance.kind]!};

const _$TableAddRowCommandKindEnumMap = {
  TableAddRowCommandKind.addRow: 'add_row',
  TableAddRowCommandKind.$unknown: r'$unknown',
};

TableCommandDeleteRow _$TableCommandDeleteRowFromJson(
  Map<String, dynamic> json,
) => TableCommandDeleteRow(
  kind: TableDeleteRowCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
);

Map<String, dynamic> _$TableCommandDeleteRowToJson(
  TableCommandDeleteRow instance,
) => <String, dynamic>{
  'kind': _$TableDeleteRowCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
};

const _$TableDeleteRowCommandKindEnumMap = {
  TableDeleteRowCommandKind.deleteRow: 'delete_row',
  TableDeleteRowCommandKind.$unknown: r'$unknown',
};

TableCommandGrant _$TableCommandGrantFromJson(Map<String, dynamic> json) =>
    TableCommandGrant(
      kind: TableGrantCommandKind.fromJson(json['kind'] as String),
      accountId: json['account_id'] as String,
      role: TableGrantCommandRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$TableCommandGrantToJson(TableCommandGrant instance) =>
    <String, dynamic>{
      'kind': _$TableGrantCommandKindEnumMap[instance.kind]!,
      'account_id': instance.accountId,
      'role': _$TableGrantCommandRoleEnumMap[instance.role]!,
    };

const _$TableGrantCommandKindEnumMap = {
  TableGrantCommandKind.grant: 'grant',
  TableGrantCommandKind.$unknown: r'$unknown',
};

const _$TableGrantCommandRoleEnumMap = {
  TableGrantCommandRole.editor: 'editor',
  TableGrantCommandRole.viewer: 'viewer',
  TableGrantCommandRole.$unknown: r'$unknown',
};

TableCommandRevoke _$TableCommandRevokeFromJson(Map<String, dynamic> json) =>
    TableCommandRevoke(
      kind: TableRevokeCommandKind.fromJson(json['kind'] as String),
      accountId: json['account_id'] as String,
    );

Map<String, dynamic> _$TableCommandRevokeToJson(TableCommandRevoke instance) =>
    <String, dynamic>{
      'kind': _$TableRevokeCommandKindEnumMap[instance.kind]!,
      'account_id': instance.accountId,
    };

const _$TableRevokeCommandKindEnumMap = {
  TableRevokeCommandKind.revoke: 'revoke',
  TableRevokeCommandKind.$unknown: r'$unknown',
};

TableCommandSetCells _$TableCommandSetCellsFromJson(
  Map<String, dynamic> json,
) => TableCommandSetCells(
  kind: TableSetCellsCommandKind.fromJson(json['kind'] as String),
  cells: (json['cells'] as List<dynamic>)
      .map((e) => TableCell.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TableCommandSetCellsToJson(
  TableCommandSetCells instance,
) => <String, dynamic>{
  'kind': _$TableSetCellsCommandKindEnumMap[instance.kind]!,
  'cells': instance.cells.map((e) => e.toJson()).toList(),
};

const _$TableSetCellsCommandKindEnumMap = {
  TableSetCellsCommandKind.setCells: 'set_cells',
  TableSetCellsCommandKind.$unknown: r'$unknown',
};
