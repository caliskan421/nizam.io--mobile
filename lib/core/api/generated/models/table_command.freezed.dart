// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
TableCommand _$TableCommandFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'set_team_role':
          return TableCommandSetTeamRole.fromJson(
            json
          );
                case 'set_project':
          return TableCommandSetProject.fromJson(
            json
          );
                case 'set_template':
          return TableCommandSetTemplate.fromJson(
            json
          );
                case 'move_table':
          return TableCommandMoveTable.fromJson(
            json
          );
                case 'propose_move':
          return TableCommandProposeMove.fromJson(
            json
          );
                case 'propose_copy':
          return TableCommandProposeCopy.fromJson(
            json
          );
                case 'withdraw_proposal':
          return TableCommandWithdrawProposal.fromJson(
            json
          );
                case 'convert_column':
          return TableCommandConvertColumn.fromJson(
            json
          );
                case 'move_row':
          return TableCommandMoveRow.fromJson(
            json
          );
                case 'move_column':
          return TableCommandMoveColumn.fromJson(
            json
          );
                case 'add_comment':
          return TableCommandAddComment.fromJson(
            json
          );
                case 'edit_comment':
          return TableCommandEditComment.fromJson(
            json
          );
                case 'delete_comment':
          return TableCommandDeleteComment.fromJson(
            json
          );
                case 'undo_cells':
          return TableCommandUndoCells.fromJson(
            json
          );
                case 'rename_table':
          return TableCommandRenameTable.fromJson(
            json
          );
                case 'delete_table':
          return TableCommandDeleteTable.fromJson(
            json
          );
                case 'add_column':
          return TableCommandAddColumn.fromJson(
            json
          );
                case 'rename_column':
          return TableCommandRenameColumn.fromJson(
            json
          );
                case 'resize_column':
          return TableCommandResizeColumn.fromJson(
            json
          );
                case 'delete_column':
          return TableCommandDeleteColumn.fromJson(
            json
          );
                case 'add_row':
          return TableCommandAddRow.fromJson(
            json
          );
                case 'delete_row':
          return TableCommandDeleteRow.fromJson(
            json
          );
                case 'grant':
          return TableCommandGrant.fromJson(
            json
          );
                case 'revoke':
          return TableCommandRevoke.fromJson(
            json
          );
                case 'set_cells':
          return TableCommandSetCells.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'TableCommand',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$TableCommand {

 Enum get kind;

  /// Serializes this TableCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCommand;
  return Object.hash(runtimeType,_this.kind);
}

@override
String toString() {
  final _this = this as TableCommand;
  return 'TableCommand(kind: ${_this.kind})';
}


}

/// @nodoc
class $TableCommandCopyWith<$Res>  {
$TableCommandCopyWith(TableCommand _, $Res Function(TableCommand) __);
}


/// Adds pattern-matching-related methods to [TableCommand].
extension TableCommandPatterns on TableCommand {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TableCommandSetTeamRole value)?  setTeamRole,TResult Function( TableCommandSetProject value)?  setProject,TResult Function( TableCommandSetTemplate value)?  setTemplate,TResult Function( TableCommandMoveTable value)?  moveTable,TResult Function( TableCommandProposeMove value)?  proposeMove,TResult Function( TableCommandProposeCopy value)?  proposeCopy,TResult Function( TableCommandWithdrawProposal value)?  withdrawProposal,TResult Function( TableCommandConvertColumn value)?  convertColumn,TResult Function( TableCommandMoveRow value)?  moveRow,TResult Function( TableCommandMoveColumn value)?  moveColumn,TResult Function( TableCommandAddComment value)?  addComment,TResult Function( TableCommandEditComment value)?  editComment,TResult Function( TableCommandDeleteComment value)?  deleteComment,TResult Function( TableCommandUndoCells value)?  undoCells,TResult Function( TableCommandRenameTable value)?  renameTable,TResult Function( TableCommandDeleteTable value)?  deleteTable,TResult Function( TableCommandAddColumn value)?  addColumn,TResult Function( TableCommandRenameColumn value)?  renameColumn,TResult Function( TableCommandResizeColumn value)?  resizeColumn,TResult Function( TableCommandDeleteColumn value)?  deleteColumn,TResult Function( TableCommandAddRow value)?  addRow,TResult Function( TableCommandDeleteRow value)?  deleteRow,TResult Function( TableCommandGrant value)?  grant,TResult Function( TableCommandRevoke value)?  revoke,TResult Function( TableCommandSetCells value)?  setCells,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TableCommandSetTeamRole() when setTeamRole != null:
return setTeamRole(_that);case TableCommandSetProject() when setProject != null:
return setProject(_that);case TableCommandSetTemplate() when setTemplate != null:
return setTemplate(_that);case TableCommandMoveTable() when moveTable != null:
return moveTable(_that);case TableCommandProposeMove() when proposeMove != null:
return proposeMove(_that);case TableCommandProposeCopy() when proposeCopy != null:
return proposeCopy(_that);case TableCommandWithdrawProposal() when withdrawProposal != null:
return withdrawProposal(_that);case TableCommandConvertColumn() when convertColumn != null:
return convertColumn(_that);case TableCommandMoveRow() when moveRow != null:
return moveRow(_that);case TableCommandMoveColumn() when moveColumn != null:
return moveColumn(_that);case TableCommandAddComment() when addComment != null:
return addComment(_that);case TableCommandEditComment() when editComment != null:
return editComment(_that);case TableCommandDeleteComment() when deleteComment != null:
return deleteComment(_that);case TableCommandUndoCells() when undoCells != null:
return undoCells(_that);case TableCommandRenameTable() when renameTable != null:
return renameTable(_that);case TableCommandDeleteTable() when deleteTable != null:
return deleteTable(_that);case TableCommandAddColumn() when addColumn != null:
return addColumn(_that);case TableCommandRenameColumn() when renameColumn != null:
return renameColumn(_that);case TableCommandResizeColumn() when resizeColumn != null:
return resizeColumn(_that);case TableCommandDeleteColumn() when deleteColumn != null:
return deleteColumn(_that);case TableCommandAddRow() when addRow != null:
return addRow(_that);case TableCommandDeleteRow() when deleteRow != null:
return deleteRow(_that);case TableCommandGrant() when grant != null:
return grant(_that);case TableCommandRevoke() when revoke != null:
return revoke(_that);case TableCommandSetCells() when setCells != null:
return setCells(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TableCommandSetTeamRole value)  setTeamRole,required TResult Function( TableCommandSetProject value)  setProject,required TResult Function( TableCommandSetTemplate value)  setTemplate,required TResult Function( TableCommandMoveTable value)  moveTable,required TResult Function( TableCommandProposeMove value)  proposeMove,required TResult Function( TableCommandProposeCopy value)  proposeCopy,required TResult Function( TableCommandWithdrawProposal value)  withdrawProposal,required TResult Function( TableCommandConvertColumn value)  convertColumn,required TResult Function( TableCommandMoveRow value)  moveRow,required TResult Function( TableCommandMoveColumn value)  moveColumn,required TResult Function( TableCommandAddComment value)  addComment,required TResult Function( TableCommandEditComment value)  editComment,required TResult Function( TableCommandDeleteComment value)  deleteComment,required TResult Function( TableCommandUndoCells value)  undoCells,required TResult Function( TableCommandRenameTable value)  renameTable,required TResult Function( TableCommandDeleteTable value)  deleteTable,required TResult Function( TableCommandAddColumn value)  addColumn,required TResult Function( TableCommandRenameColumn value)  renameColumn,required TResult Function( TableCommandResizeColumn value)  resizeColumn,required TResult Function( TableCommandDeleteColumn value)  deleteColumn,required TResult Function( TableCommandAddRow value)  addRow,required TResult Function( TableCommandDeleteRow value)  deleteRow,required TResult Function( TableCommandGrant value)  grant,required TResult Function( TableCommandRevoke value)  revoke,required TResult Function( TableCommandSetCells value)  setCells,}){
final _that = this;
switch (_that) {
case TableCommandSetTeamRole():
return setTeamRole(_that);case TableCommandSetProject():
return setProject(_that);case TableCommandSetTemplate():
return setTemplate(_that);case TableCommandMoveTable():
return moveTable(_that);case TableCommandProposeMove():
return proposeMove(_that);case TableCommandProposeCopy():
return proposeCopy(_that);case TableCommandWithdrawProposal():
return withdrawProposal(_that);case TableCommandConvertColumn():
return convertColumn(_that);case TableCommandMoveRow():
return moveRow(_that);case TableCommandMoveColumn():
return moveColumn(_that);case TableCommandAddComment():
return addComment(_that);case TableCommandEditComment():
return editComment(_that);case TableCommandDeleteComment():
return deleteComment(_that);case TableCommandUndoCells():
return undoCells(_that);case TableCommandRenameTable():
return renameTable(_that);case TableCommandDeleteTable():
return deleteTable(_that);case TableCommandAddColumn():
return addColumn(_that);case TableCommandRenameColumn():
return renameColumn(_that);case TableCommandResizeColumn():
return resizeColumn(_that);case TableCommandDeleteColumn():
return deleteColumn(_that);case TableCommandAddRow():
return addRow(_that);case TableCommandDeleteRow():
return deleteRow(_that);case TableCommandGrant():
return grant(_that);case TableCommandRevoke():
return revoke(_that);case TableCommandSetCells():
return setCells(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TableCommandSetTeamRole value)?  setTeamRole,TResult? Function( TableCommandSetProject value)?  setProject,TResult? Function( TableCommandSetTemplate value)?  setTemplate,TResult? Function( TableCommandMoveTable value)?  moveTable,TResult? Function( TableCommandProposeMove value)?  proposeMove,TResult? Function( TableCommandProposeCopy value)?  proposeCopy,TResult? Function( TableCommandWithdrawProposal value)?  withdrawProposal,TResult? Function( TableCommandConvertColumn value)?  convertColumn,TResult? Function( TableCommandMoveRow value)?  moveRow,TResult? Function( TableCommandMoveColumn value)?  moveColumn,TResult? Function( TableCommandAddComment value)?  addComment,TResult? Function( TableCommandEditComment value)?  editComment,TResult? Function( TableCommandDeleteComment value)?  deleteComment,TResult? Function( TableCommandUndoCells value)?  undoCells,TResult? Function( TableCommandRenameTable value)?  renameTable,TResult? Function( TableCommandDeleteTable value)?  deleteTable,TResult? Function( TableCommandAddColumn value)?  addColumn,TResult? Function( TableCommandRenameColumn value)?  renameColumn,TResult? Function( TableCommandResizeColumn value)?  resizeColumn,TResult? Function( TableCommandDeleteColumn value)?  deleteColumn,TResult? Function( TableCommandAddRow value)?  addRow,TResult? Function( TableCommandDeleteRow value)?  deleteRow,TResult? Function( TableCommandGrant value)?  grant,TResult? Function( TableCommandRevoke value)?  revoke,TResult? Function( TableCommandSetCells value)?  setCells,}){
final _that = this;
switch (_that) {
case TableCommandSetTeamRole() when setTeamRole != null:
return setTeamRole(_that);case TableCommandSetProject() when setProject != null:
return setProject(_that);case TableCommandSetTemplate() when setTemplate != null:
return setTemplate(_that);case TableCommandMoveTable() when moveTable != null:
return moveTable(_that);case TableCommandProposeMove() when proposeMove != null:
return proposeMove(_that);case TableCommandProposeCopy() when proposeCopy != null:
return proposeCopy(_that);case TableCommandWithdrawProposal() when withdrawProposal != null:
return withdrawProposal(_that);case TableCommandConvertColumn() when convertColumn != null:
return convertColumn(_that);case TableCommandMoveRow() when moveRow != null:
return moveRow(_that);case TableCommandMoveColumn() when moveColumn != null:
return moveColumn(_that);case TableCommandAddComment() when addComment != null:
return addComment(_that);case TableCommandEditComment() when editComment != null:
return editComment(_that);case TableCommandDeleteComment() when deleteComment != null:
return deleteComment(_that);case TableCommandUndoCells() when undoCells != null:
return undoCells(_that);case TableCommandRenameTable() when renameTable != null:
return renameTable(_that);case TableCommandDeleteTable() when deleteTable != null:
return deleteTable(_that);case TableCommandAddColumn() when addColumn != null:
return addColumn(_that);case TableCommandRenameColumn() when renameColumn != null:
return renameColumn(_that);case TableCommandResizeColumn() when resizeColumn != null:
return resizeColumn(_that);case TableCommandDeleteColumn() when deleteColumn != null:
return deleteColumn(_that);case TableCommandAddRow() when addRow != null:
return addRow(_that);case TableCommandDeleteRow() when deleteRow != null:
return deleteRow(_that);case TableCommandGrant() when grant != null:
return grant(_that);case TableCommandRevoke() when revoke != null:
return revoke(_that);case TableCommandSetCells() when setCells != null:
return setCells(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TableSetTeamRoleCommandKind kind,  TableSetTeamRoleCommandRole role)?  setTeamRole,TResult Function( TableSetProjectCommandKind kind, @JsonKey(name: 'project_id')  String? projectId)?  setProject,TResult Function( TableSetTemplateCommandKind kind,  bool template)?  setTemplate,TResult Function( TableMoveCommandKind kind, @JsonKey(name: 'target_space')  TableMoveCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String? targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId)?  moveTable,TResult Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)?  proposeMove,TResult Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)?  proposeCopy,TResult Function( TableWithdrawProposalCommandKind kind)?  withdrawProposal,TResult Function( TableConvertColumnCommandKind kind,  String id,  TableColumnType type, @JsonKey(name: 'expected_schema')  int expectedSchema)?  convertColumn,TResult Function( TableMoveRowCommandKind kind,  String id, @JsonKey(name: 'after_id')  String? afterId)?  moveRow,TResult Function( TableMoveColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema, @JsonKey(name: 'after_id')  String? afterId)?  moveColumn,TResult Function( TableAddCommentCommandKind kind, @JsonKey(name: 'row_id')  String rowId,  String body, @JsonKey(name: 'column_id')  String? columnId)?  addComment,TResult Function( TableEditCommentCommandKind kind,  String id,  String body)?  editComment,TResult Function( TableDeleteCommentCommandKind kind,  String id)?  deleteComment,TResult Function( TableUndoCellsCommandKind kind,  int sequence)?  undoCells,TResult Function( TableRenameCommandKind kind,  String name)?  renameTable,TResult Function( TableDeleteCommandKind kind)?  deleteTable,TResult Function( TableAddColumnCommandKind kind,  String name,  TableColumnType type,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema,  bool multiple)?  addColumn,TResult Function( TableRenameColumnCommandKind kind,  String id,  String name, @JsonKey(name: 'expected_schema')  int expectedSchema)?  renameColumn,TResult Function( TableResizeColumnCommandKind kind,  String id,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema)?  resizeColumn,TResult Function( TableDeleteColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema)?  deleteColumn,TResult Function( TableAddRowCommandKind kind)?  addRow,TResult Function( TableDeleteRowCommandKind kind,  String id)?  deleteRow,TResult Function( TableGrantCommandKind kind, @JsonKey(name: 'account_id')  String accountId,  TableGrantCommandRole role)?  grant,TResult Function( TableRevokeCommandKind kind, @JsonKey(name: 'account_id')  String accountId)?  revoke,TResult Function( TableSetCellsCommandKind kind,  List<TableCell> cells)?  setCells,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TableCommandSetTeamRole() when setTeamRole != null:
return setTeamRole(_that.kind,_that.role);case TableCommandSetProject() when setProject != null:
return setProject(_that.kind,_that.projectId);case TableCommandSetTemplate() when setTemplate != null:
return setTemplate(_that.kind,_that.template);case TableCommandMoveTable() when moveTable != null:
return moveTable(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId);case TableCommandProposeMove() when proposeMove != null:
return proposeMove(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case TableCommandProposeCopy() when proposeCopy != null:
return proposeCopy(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case TableCommandWithdrawProposal() when withdrawProposal != null:
return withdrawProposal(_that.kind);case TableCommandConvertColumn() when convertColumn != null:
return convertColumn(_that.kind,_that.id,_that.type,_that.expectedSchema);case TableCommandMoveRow() when moveRow != null:
return moveRow(_that.kind,_that.id,_that.afterId);case TableCommandMoveColumn() when moveColumn != null:
return moveColumn(_that.kind,_that.id,_that.expectedSchema,_that.afterId);case TableCommandAddComment() when addComment != null:
return addComment(_that.kind,_that.rowId,_that.body,_that.columnId);case TableCommandEditComment() when editComment != null:
return editComment(_that.kind,_that.id,_that.body);case TableCommandDeleteComment() when deleteComment != null:
return deleteComment(_that.kind,_that.id);case TableCommandUndoCells() when undoCells != null:
return undoCells(_that.kind,_that.sequence);case TableCommandRenameTable() when renameTable != null:
return renameTable(_that.kind,_that.name);case TableCommandDeleteTable() when deleteTable != null:
return deleteTable(_that.kind);case TableCommandAddColumn() when addColumn != null:
return addColumn(_that.kind,_that.name,_that.type,_that.width,_that.expectedSchema,_that.multiple);case TableCommandRenameColumn() when renameColumn != null:
return renameColumn(_that.kind,_that.id,_that.name,_that.expectedSchema);case TableCommandResizeColumn() when resizeColumn != null:
return resizeColumn(_that.kind,_that.id,_that.width,_that.expectedSchema);case TableCommandDeleteColumn() when deleteColumn != null:
return deleteColumn(_that.kind,_that.id,_that.expectedSchema);case TableCommandAddRow() when addRow != null:
return addRow(_that.kind);case TableCommandDeleteRow() when deleteRow != null:
return deleteRow(_that.kind,_that.id);case TableCommandGrant() when grant != null:
return grant(_that.kind,_that.accountId,_that.role);case TableCommandRevoke() when revoke != null:
return revoke(_that.kind,_that.accountId);case TableCommandSetCells() when setCells != null:
return setCells(_that.kind,_that.cells);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TableSetTeamRoleCommandKind kind,  TableSetTeamRoleCommandRole role)  setTeamRole,required TResult Function( TableSetProjectCommandKind kind, @JsonKey(name: 'project_id')  String? projectId)  setProject,required TResult Function( TableSetTemplateCommandKind kind,  bool template)  setTemplate,required TResult Function( TableMoveCommandKind kind, @JsonKey(name: 'target_space')  TableMoveCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String? targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId)  moveTable,required TResult Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)  proposeMove,required TResult Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)  proposeCopy,required TResult Function( TableWithdrawProposalCommandKind kind)  withdrawProposal,required TResult Function( TableConvertColumnCommandKind kind,  String id,  TableColumnType type, @JsonKey(name: 'expected_schema')  int expectedSchema)  convertColumn,required TResult Function( TableMoveRowCommandKind kind,  String id, @JsonKey(name: 'after_id')  String? afterId)  moveRow,required TResult Function( TableMoveColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema, @JsonKey(name: 'after_id')  String? afterId)  moveColumn,required TResult Function( TableAddCommentCommandKind kind, @JsonKey(name: 'row_id')  String rowId,  String body, @JsonKey(name: 'column_id')  String? columnId)  addComment,required TResult Function( TableEditCommentCommandKind kind,  String id,  String body)  editComment,required TResult Function( TableDeleteCommentCommandKind kind,  String id)  deleteComment,required TResult Function( TableUndoCellsCommandKind kind,  int sequence)  undoCells,required TResult Function( TableRenameCommandKind kind,  String name)  renameTable,required TResult Function( TableDeleteCommandKind kind)  deleteTable,required TResult Function( TableAddColumnCommandKind kind,  String name,  TableColumnType type,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema,  bool multiple)  addColumn,required TResult Function( TableRenameColumnCommandKind kind,  String id,  String name, @JsonKey(name: 'expected_schema')  int expectedSchema)  renameColumn,required TResult Function( TableResizeColumnCommandKind kind,  String id,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema)  resizeColumn,required TResult Function( TableDeleteColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema)  deleteColumn,required TResult Function( TableAddRowCommandKind kind)  addRow,required TResult Function( TableDeleteRowCommandKind kind,  String id)  deleteRow,required TResult Function( TableGrantCommandKind kind, @JsonKey(name: 'account_id')  String accountId,  TableGrantCommandRole role)  grant,required TResult Function( TableRevokeCommandKind kind, @JsonKey(name: 'account_id')  String accountId)  revoke,required TResult Function( TableSetCellsCommandKind kind,  List<TableCell> cells)  setCells,}) {final _that = this;
switch (_that) {
case TableCommandSetTeamRole():
return setTeamRole(_that.kind,_that.role);case TableCommandSetProject():
return setProject(_that.kind,_that.projectId);case TableCommandSetTemplate():
return setTemplate(_that.kind,_that.template);case TableCommandMoveTable():
return moveTable(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId);case TableCommandProposeMove():
return proposeMove(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case TableCommandProposeCopy():
return proposeCopy(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case TableCommandWithdrawProposal():
return withdrawProposal(_that.kind);case TableCommandConvertColumn():
return convertColumn(_that.kind,_that.id,_that.type,_that.expectedSchema);case TableCommandMoveRow():
return moveRow(_that.kind,_that.id,_that.afterId);case TableCommandMoveColumn():
return moveColumn(_that.kind,_that.id,_that.expectedSchema,_that.afterId);case TableCommandAddComment():
return addComment(_that.kind,_that.rowId,_that.body,_that.columnId);case TableCommandEditComment():
return editComment(_that.kind,_that.id,_that.body);case TableCommandDeleteComment():
return deleteComment(_that.kind,_that.id);case TableCommandUndoCells():
return undoCells(_that.kind,_that.sequence);case TableCommandRenameTable():
return renameTable(_that.kind,_that.name);case TableCommandDeleteTable():
return deleteTable(_that.kind);case TableCommandAddColumn():
return addColumn(_that.kind,_that.name,_that.type,_that.width,_that.expectedSchema,_that.multiple);case TableCommandRenameColumn():
return renameColumn(_that.kind,_that.id,_that.name,_that.expectedSchema);case TableCommandResizeColumn():
return resizeColumn(_that.kind,_that.id,_that.width,_that.expectedSchema);case TableCommandDeleteColumn():
return deleteColumn(_that.kind,_that.id,_that.expectedSchema);case TableCommandAddRow():
return addRow(_that.kind);case TableCommandDeleteRow():
return deleteRow(_that.kind,_that.id);case TableCommandGrant():
return grant(_that.kind,_that.accountId,_that.role);case TableCommandRevoke():
return revoke(_that.kind,_that.accountId);case TableCommandSetCells():
return setCells(_that.kind,_that.cells);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TableSetTeamRoleCommandKind kind,  TableSetTeamRoleCommandRole role)?  setTeamRole,TResult? Function( TableSetProjectCommandKind kind, @JsonKey(name: 'project_id')  String? projectId)?  setProject,TResult? Function( TableSetTemplateCommandKind kind,  bool template)?  setTemplate,TResult? Function( TableMoveCommandKind kind, @JsonKey(name: 'target_space')  TableMoveCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String? targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId)?  moveTable,TResult? Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)?  proposeMove,TResult? Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)?  proposeCopy,TResult? Function( TableWithdrawProposalCommandKind kind)?  withdrawProposal,TResult? Function( TableConvertColumnCommandKind kind,  String id,  TableColumnType type, @JsonKey(name: 'expected_schema')  int expectedSchema)?  convertColumn,TResult? Function( TableMoveRowCommandKind kind,  String id, @JsonKey(name: 'after_id')  String? afterId)?  moveRow,TResult? Function( TableMoveColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema, @JsonKey(name: 'after_id')  String? afterId)?  moveColumn,TResult? Function( TableAddCommentCommandKind kind, @JsonKey(name: 'row_id')  String rowId,  String body, @JsonKey(name: 'column_id')  String? columnId)?  addComment,TResult? Function( TableEditCommentCommandKind kind,  String id,  String body)?  editComment,TResult? Function( TableDeleteCommentCommandKind kind,  String id)?  deleteComment,TResult? Function( TableUndoCellsCommandKind kind,  int sequence)?  undoCells,TResult? Function( TableRenameCommandKind kind,  String name)?  renameTable,TResult? Function( TableDeleteCommandKind kind)?  deleteTable,TResult? Function( TableAddColumnCommandKind kind,  String name,  TableColumnType type,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema,  bool multiple)?  addColumn,TResult? Function( TableRenameColumnCommandKind kind,  String id,  String name, @JsonKey(name: 'expected_schema')  int expectedSchema)?  renameColumn,TResult? Function( TableResizeColumnCommandKind kind,  String id,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema)?  resizeColumn,TResult? Function( TableDeleteColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema)?  deleteColumn,TResult? Function( TableAddRowCommandKind kind)?  addRow,TResult? Function( TableDeleteRowCommandKind kind,  String id)?  deleteRow,TResult? Function( TableGrantCommandKind kind, @JsonKey(name: 'account_id')  String accountId,  TableGrantCommandRole role)?  grant,TResult? Function( TableRevokeCommandKind kind, @JsonKey(name: 'account_id')  String accountId)?  revoke,TResult? Function( TableSetCellsCommandKind kind,  List<TableCell> cells)?  setCells,}) {final _that = this;
switch (_that) {
case TableCommandSetTeamRole() when setTeamRole != null:
return setTeamRole(_that.kind,_that.role);case TableCommandSetProject() when setProject != null:
return setProject(_that.kind,_that.projectId);case TableCommandSetTemplate() when setTemplate != null:
return setTemplate(_that.kind,_that.template);case TableCommandMoveTable() when moveTable != null:
return moveTable(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId);case TableCommandProposeMove() when proposeMove != null:
return proposeMove(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case TableCommandProposeCopy() when proposeCopy != null:
return proposeCopy(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case TableCommandWithdrawProposal() when withdrawProposal != null:
return withdrawProposal(_that.kind);case TableCommandConvertColumn() when convertColumn != null:
return convertColumn(_that.kind,_that.id,_that.type,_that.expectedSchema);case TableCommandMoveRow() when moveRow != null:
return moveRow(_that.kind,_that.id,_that.afterId);case TableCommandMoveColumn() when moveColumn != null:
return moveColumn(_that.kind,_that.id,_that.expectedSchema,_that.afterId);case TableCommandAddComment() when addComment != null:
return addComment(_that.kind,_that.rowId,_that.body,_that.columnId);case TableCommandEditComment() when editComment != null:
return editComment(_that.kind,_that.id,_that.body);case TableCommandDeleteComment() when deleteComment != null:
return deleteComment(_that.kind,_that.id);case TableCommandUndoCells() when undoCells != null:
return undoCells(_that.kind,_that.sequence);case TableCommandRenameTable() when renameTable != null:
return renameTable(_that.kind,_that.name);case TableCommandDeleteTable() when deleteTable != null:
return deleteTable(_that.kind);case TableCommandAddColumn() when addColumn != null:
return addColumn(_that.kind,_that.name,_that.type,_that.width,_that.expectedSchema,_that.multiple);case TableCommandRenameColumn() when renameColumn != null:
return renameColumn(_that.kind,_that.id,_that.name,_that.expectedSchema);case TableCommandResizeColumn() when resizeColumn != null:
return resizeColumn(_that.kind,_that.id,_that.width,_that.expectedSchema);case TableCommandDeleteColumn() when deleteColumn != null:
return deleteColumn(_that.kind,_that.id,_that.expectedSchema);case TableCommandAddRow() when addRow != null:
return addRow(_that.kind);case TableCommandDeleteRow() when deleteRow != null:
return deleteRow(_that.kind,_that.id);case TableCommandGrant() when grant != null:
return grant(_that.kind,_that.accountId,_that.role);case TableCommandRevoke() when revoke != null:
return revoke(_that.kind,_that.accountId);case TableCommandSetCells() when setCells != null:
return setCells(_that.kind,_that.cells);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TableCommandSetTeamRole implements TableCommand {
  const TableCommandSetTeamRole({required this.kind, required this.role});
  factory TableCommandSetTeamRole.fromJson(Map<String, dynamic> json) => _$TableCommandSetTeamRoleFromJson(json);

@override final  TableSetTeamRoleCommandKind kind;
 final  TableSetTeamRoleCommandRole role;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandSetTeamRoleCopyWith<TableCommandSetTeamRole> get copyWith => _$TableCommandSetTeamRoleCopyWithImpl<TableCommandSetTeamRole>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandSetTeamRoleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandSetTeamRole&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,role);
}

@override
String toString() {
    return 'TableCommand.setTeamRole(kind: $kind, role: $role)';
}


}

/// @nodoc
abstract mixin class $TableCommandSetTeamRoleCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandSetTeamRoleCopyWith(TableCommandSetTeamRole value, $Res Function(TableCommandSetTeamRole) _then) = _$TableCommandSetTeamRoleCopyWithImpl;
@useResult
$Res call({
 TableSetTeamRoleCommandKind kind, TableSetTeamRoleCommandRole role
});




}
/// @nodoc
class _$TableCommandSetTeamRoleCopyWithImpl<$Res>
    implements $TableCommandSetTeamRoleCopyWith<$Res> {
  _$TableCommandSetTeamRoleCopyWithImpl(this._self, this._then);

  final TableCommandSetTeamRole _self;
  final $Res Function(TableCommandSetTeamRole) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? role = null,}) {
  return _then(TableCommandSetTeamRole(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetTeamRoleCommandKind,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableSetTeamRoleCommandRole,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandSetProject implements TableCommand {
  const TableCommandSetProject({required this.kind, @JsonKey(name: 'project_id') this.projectId});
  factory TableCommandSetProject.fromJson(Map<String, dynamic> json) => _$TableCommandSetProjectFromJson(json);

@override final  TableSetProjectCommandKind kind;
@JsonKey(name: 'project_id') final  String? projectId;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandSetProjectCopyWith<TableCommandSetProject> get copyWith => _$TableCommandSetProjectCopyWithImpl<TableCommandSetProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandSetProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandSetProject&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,projectId);
}

@override
String toString() {
    return 'TableCommand.setProject(kind: $kind, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $TableCommandSetProjectCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandSetProjectCopyWith(TableCommandSetProject value, $Res Function(TableCommandSetProject) _then) = _$TableCommandSetProjectCopyWithImpl;
@useResult
$Res call({
 TableSetProjectCommandKind kind,@JsonKey(name: 'project_id') String? projectId
});




}
/// @nodoc
class _$TableCommandSetProjectCopyWithImpl<$Res>
    implements $TableCommandSetProjectCopyWith<$Res> {
  _$TableCommandSetProjectCopyWithImpl(this._self, this._then);

  final TableCommandSetProject _self;
  final $Res Function(TableCommandSetProject) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? projectId = freezed,}) {
  return _then(TableCommandSetProject(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetProjectCommandKind,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandSetTemplate implements TableCommand {
  const TableCommandSetTemplate({required this.kind, required this.template});
  factory TableCommandSetTemplate.fromJson(Map<String, dynamic> json) => _$TableCommandSetTemplateFromJson(json);

@override final  TableSetTemplateCommandKind kind;
 final  bool template;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandSetTemplateCopyWith<TableCommandSetTemplate> get copyWith => _$TableCommandSetTemplateCopyWithImpl<TableCommandSetTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandSetTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandSetTemplate&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.template, template) || other.template == template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,template);
}

@override
String toString() {
    return 'TableCommand.setTemplate(kind: $kind, template: $template)';
}


}

/// @nodoc
abstract mixin class $TableCommandSetTemplateCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandSetTemplateCopyWith(TableCommandSetTemplate value, $Res Function(TableCommandSetTemplate) _then) = _$TableCommandSetTemplateCopyWithImpl;
@useResult
$Res call({
 TableSetTemplateCommandKind kind, bool template
});




}
/// @nodoc
class _$TableCommandSetTemplateCopyWithImpl<$Res>
    implements $TableCommandSetTemplateCopyWith<$Res> {
  _$TableCommandSetTemplateCopyWithImpl(this._self, this._then);

  final TableCommandSetTemplate _self;
  final $Res Function(TableCommandSetTemplate) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? template = null,}) {
  return _then(TableCommandSetTemplate(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetTemplateCommandKind,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandMoveTable implements TableCommand {
  const TableCommandMoveTable({required this.kind, @JsonKey(name: 'target_space') required this.targetSpace, @JsonKey(name: 'target_department_id') this.targetDepartmentId, @JsonKey(name: 'target_project_id') this.targetProjectId});
  factory TableCommandMoveTable.fromJson(Map<String, dynamic> json) => _$TableCommandMoveTableFromJson(json);

@override final  TableMoveCommandKind kind;
@JsonKey(name: 'target_space') final  TableMoveCommandTargetSpace targetSpace;
/// Yalnız `coordinatorship` hedefinde zorunlu; kişisel hedefte verilmez.
@JsonKey(name: 'target_department_id') final  String? targetDepartmentId;
/// Verilmezse tablo projesiz taşınır; verilmişse hedefteki silinmemiş proje (null/boş 422).
@JsonKey(name: 'target_project_id') final  String? targetProjectId;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandMoveTableCopyWith<TableCommandMoveTable> get copyWith => _$TableCommandMoveTableCopyWithImpl<TableCommandMoveTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandMoveTableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandMoveTable&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetSpace, targetSpace) || other.targetSpace == targetSpace)&&(identical(other.targetDepartmentId, targetDepartmentId) || other.targetDepartmentId == targetDepartmentId)&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetSpace,targetDepartmentId,targetProjectId);
}

@override
String toString() {
    return 'TableCommand.moveTable(kind: $kind, targetSpace: $targetSpace, targetDepartmentId: $targetDepartmentId, targetProjectId: $targetProjectId)';
}


}

/// @nodoc
abstract mixin class $TableCommandMoveTableCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandMoveTableCopyWith(TableCommandMoveTable value, $Res Function(TableCommandMoveTable) _then) = _$TableCommandMoveTableCopyWithImpl;
@useResult
$Res call({
 TableMoveCommandKind kind,@JsonKey(name: 'target_space') TableMoveCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String? targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId
});




}
/// @nodoc
class _$TableCommandMoveTableCopyWithImpl<$Res>
    implements $TableCommandMoveTableCopyWith<$Res> {
  _$TableCommandMoveTableCopyWithImpl(this._self, this._then);

  final TableCommandMoveTable _self;
  final $Res Function(TableCommandMoveTable) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = freezed,Object? targetProjectId = freezed,}) {
  return _then(TableCommandMoveTable(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableMoveCommandTargetSpace,targetDepartmentId: freezed == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandProposeMove implements TableCommand {
  const TableCommandProposeMove({required this.kind, @JsonKey(name: 'target_space') required this.targetSpace, @JsonKey(name: 'target_department_id') required this.targetDepartmentId, @JsonKey(name: 'target_project_id') this.targetProjectId, this.role});
  factory TableCommandProposeMove.fromJson(Map<String, dynamic> json) => _$TableCommandProposeMoveFromJson(json);

@override final  TableProposeCommandKind kind;
@JsonKey(name: 'target_space') final  TableProposeCommandTargetSpace targetSpace;
@JsonKey(name: 'target_department_id') final  String targetDepartmentId;
/// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
@JsonKey(name: 'target_project_id') final  String? targetProjectId;
 final  TableProposeCommandRole? role;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandProposeMoveCopyWith<TableCommandProposeMove> get copyWith => _$TableCommandProposeMoveCopyWithImpl<TableCommandProposeMove>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandProposeMoveToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandProposeMove&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetSpace, targetSpace) || other.targetSpace == targetSpace)&&(identical(other.targetDepartmentId, targetDepartmentId) || other.targetDepartmentId == targetDepartmentId)&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetSpace,targetDepartmentId,targetProjectId,role);
}

@override
String toString() {
    return 'TableCommand.proposeMove(kind: $kind, targetSpace: $targetSpace, targetDepartmentId: $targetDepartmentId, targetProjectId: $targetProjectId, role: $role)';
}


}

/// @nodoc
abstract mixin class $TableCommandProposeMoveCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandProposeMoveCopyWith(TableCommandProposeMove value, $Res Function(TableCommandProposeMove) _then) = _$TableCommandProposeMoveCopyWithImpl;
@useResult
$Res call({
 TableProposeCommandKind kind,@JsonKey(name: 'target_space') TableProposeCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId, TableProposeCommandRole? role
});




}
/// @nodoc
class _$TableCommandProposeMoveCopyWithImpl<$Res>
    implements $TableCommandProposeMoveCopyWith<$Res> {
  _$TableCommandProposeMoveCopyWithImpl(this._self, this._then);

  final TableCommandProposeMove _self;
  final $Res Function(TableCommandProposeMove) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = null,Object? targetProjectId = freezed,Object? role = freezed,}) {
  return _then(TableCommandProposeMove(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableProposeCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableProposeCommandTargetSpace,targetDepartmentId: null == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableProposeCommandRole?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandProposeCopy implements TableCommand {
  const TableCommandProposeCopy({required this.kind, @JsonKey(name: 'target_space') required this.targetSpace, @JsonKey(name: 'target_department_id') required this.targetDepartmentId, @JsonKey(name: 'target_project_id') this.targetProjectId, this.role});
  factory TableCommandProposeCopy.fromJson(Map<String, dynamic> json) => _$TableCommandProposeCopyFromJson(json);

@override final  TableProposeCommandKind kind;
@JsonKey(name: 'target_space') final  TableProposeCommandTargetSpace targetSpace;
@JsonKey(name: 'target_department_id') final  String targetDepartmentId;
/// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
@JsonKey(name: 'target_project_id') final  String? targetProjectId;
 final  TableProposeCommandRole? role;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandProposeCopyCopyWith<TableCommandProposeCopy> get copyWith => _$TableCommandProposeCopyCopyWithImpl<TableCommandProposeCopy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandProposeCopyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandProposeCopy&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetSpace, targetSpace) || other.targetSpace == targetSpace)&&(identical(other.targetDepartmentId, targetDepartmentId) || other.targetDepartmentId == targetDepartmentId)&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetSpace,targetDepartmentId,targetProjectId,role);
}

@override
String toString() {
    return 'TableCommand.proposeCopy(kind: $kind, targetSpace: $targetSpace, targetDepartmentId: $targetDepartmentId, targetProjectId: $targetProjectId, role: $role)';
}


}

/// @nodoc
abstract mixin class $TableCommandProposeCopyCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandProposeCopyCopyWith(TableCommandProposeCopy value, $Res Function(TableCommandProposeCopy) _then) = _$TableCommandProposeCopyCopyWithImpl;
@useResult
$Res call({
 TableProposeCommandKind kind,@JsonKey(name: 'target_space') TableProposeCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId, TableProposeCommandRole? role
});




}
/// @nodoc
class _$TableCommandProposeCopyCopyWithImpl<$Res>
    implements $TableCommandProposeCopyCopyWith<$Res> {
  _$TableCommandProposeCopyCopyWithImpl(this._self, this._then);

  final TableCommandProposeCopy _self;
  final $Res Function(TableCommandProposeCopy) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = null,Object? targetProjectId = freezed,Object? role = freezed,}) {
  return _then(TableCommandProposeCopy(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableProposeCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableProposeCommandTargetSpace,targetDepartmentId: null == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableProposeCommandRole?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandWithdrawProposal implements TableCommand {
  const TableCommandWithdrawProposal({required this.kind});
  factory TableCommandWithdrawProposal.fromJson(Map<String, dynamic> json) => _$TableCommandWithdrawProposalFromJson(json);

@override final  TableWithdrawProposalCommandKind kind;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandWithdrawProposalCopyWith<TableCommandWithdrawProposal> get copyWith => _$TableCommandWithdrawProposalCopyWithImpl<TableCommandWithdrawProposal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandWithdrawProposalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandWithdrawProposal&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind);
}

@override
String toString() {
    return 'TableCommand.withdrawProposal(kind: $kind)';
}


}

/// @nodoc
abstract mixin class $TableCommandWithdrawProposalCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandWithdrawProposalCopyWith(TableCommandWithdrawProposal value, $Res Function(TableCommandWithdrawProposal) _then) = _$TableCommandWithdrawProposalCopyWithImpl;
@useResult
$Res call({
 TableWithdrawProposalCommandKind kind
});




}
/// @nodoc
class _$TableCommandWithdrawProposalCopyWithImpl<$Res>
    implements $TableCommandWithdrawProposalCopyWith<$Res> {
  _$TableCommandWithdrawProposalCopyWithImpl(this._self, this._then);

  final TableCommandWithdrawProposal _self;
  final $Res Function(TableCommandWithdrawProposal) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,}) {
  return _then(TableCommandWithdrawProposal(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableWithdrawProposalCommandKind,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandConvertColumn implements TableCommand {
  const TableCommandConvertColumn({required this.kind, required this.id, required this.type, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory TableCommandConvertColumn.fromJson(Map<String, dynamic> json) => _$TableCommandConvertColumnFromJson(json);

@override final  TableConvertColumnCommandKind kind;
 final  String id;
 final  TableColumnType type;
@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandConvertColumnCopyWith<TableCommandConvertColumn> get copyWith => _$TableCommandConvertColumnCopyWithImpl<TableCommandConvertColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandConvertColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandConvertColumn&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,type,expectedSchema);
}

@override
String toString() {
    return 'TableCommand.convertColumn(kind: $kind, id: $id, type: $type, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class $TableCommandConvertColumnCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandConvertColumnCopyWith(TableCommandConvertColumn value, $Res Function(TableCommandConvertColumn) _then) = _$TableCommandConvertColumnCopyWithImpl;
@useResult
$Res call({
 TableConvertColumnCommandKind kind, String id, TableColumnType type,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableCommandConvertColumnCopyWithImpl<$Res>
    implements $TableCommandConvertColumnCopyWith<$Res> {
  _$TableCommandConvertColumnCopyWithImpl(this._self, this._then);

  final TableCommandConvertColumn _self;
  final $Res Function(TableCommandConvertColumn) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? type = null,Object? expectedSchema = null,}) {
  return _then(TableCommandConvertColumn(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableConvertColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandMoveRow implements TableCommand {
  const TableCommandMoveRow({required this.kind, required this.id, @JsonKey(name: 'after_id') this.afterId});
  factory TableCommandMoveRow.fromJson(Map<String, dynamic> json) => _$TableCommandMoveRowFromJson(json);

@override final  TableMoveRowCommandKind kind;
 final  String id;
@JsonKey(name: 'after_id') final  String? afterId;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandMoveRowCopyWith<TableCommandMoveRow> get copyWith => _$TableCommandMoveRowCopyWithImpl<TableCommandMoveRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandMoveRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandMoveRow&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.afterId, afterId) || other.afterId == afterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,afterId);
}

@override
String toString() {
    return 'TableCommand.moveRow(kind: $kind, id: $id, afterId: $afterId)';
}


}

/// @nodoc
abstract mixin class $TableCommandMoveRowCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandMoveRowCopyWith(TableCommandMoveRow value, $Res Function(TableCommandMoveRow) _then) = _$TableCommandMoveRowCopyWithImpl;
@useResult
$Res call({
 TableMoveRowCommandKind kind, String id,@JsonKey(name: 'after_id') String? afterId
});




}
/// @nodoc
class _$TableCommandMoveRowCopyWithImpl<$Res>
    implements $TableCommandMoveRowCopyWith<$Res> {
  _$TableCommandMoveRowCopyWithImpl(this._self, this._then);

  final TableCommandMoveRow _self;
  final $Res Function(TableCommandMoveRow) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? afterId = freezed,}) {
  return _then(TableCommandMoveRow(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveRowCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,afterId: freezed == afterId ? _self.afterId : afterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandMoveColumn implements TableCommand {
  const TableCommandMoveColumn({required this.kind, required this.id, @JsonKey(name: 'expected_schema') required this.expectedSchema, @JsonKey(name: 'after_id') this.afterId});
  factory TableCommandMoveColumn.fromJson(Map<String, dynamic> json) => _$TableCommandMoveColumnFromJson(json);

@override final  TableMoveColumnCommandKind kind;
 final  String id;
@JsonKey(name: 'expected_schema') final  int expectedSchema;
@JsonKey(name: 'after_id') final  String? afterId;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandMoveColumnCopyWith<TableCommandMoveColumn> get copyWith => _$TableCommandMoveColumnCopyWithImpl<TableCommandMoveColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandMoveColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandMoveColumn&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema)&&(identical(other.afterId, afterId) || other.afterId == afterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,expectedSchema,afterId);
}

@override
String toString() {
    return 'TableCommand.moveColumn(kind: $kind, id: $id, expectedSchema: $expectedSchema, afterId: $afterId)';
}


}

/// @nodoc
abstract mixin class $TableCommandMoveColumnCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandMoveColumnCopyWith(TableCommandMoveColumn value, $Res Function(TableCommandMoveColumn) _then) = _$TableCommandMoveColumnCopyWithImpl;
@useResult
$Res call({
 TableMoveColumnCommandKind kind, String id,@JsonKey(name: 'expected_schema') int expectedSchema,@JsonKey(name: 'after_id') String? afterId
});




}
/// @nodoc
class _$TableCommandMoveColumnCopyWithImpl<$Res>
    implements $TableCommandMoveColumnCopyWith<$Res> {
  _$TableCommandMoveColumnCopyWithImpl(this._self, this._then);

  final TableCommandMoveColumn _self;
  final $Res Function(TableCommandMoveColumn) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? expectedSchema = null,Object? afterId = freezed,}) {
  return _then(TableCommandMoveColumn(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,afterId: freezed == afterId ? _self.afterId : afterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandAddComment implements TableCommand {
  const TableCommandAddComment({required this.kind, @JsonKey(name: 'row_id') required this.rowId, required this.body, @JsonKey(name: 'column_id') this.columnId});
  factory TableCommandAddComment.fromJson(Map<String, dynamic> json) => _$TableCommandAddCommentFromJson(json);

@override final  TableAddCommentCommandKind kind;
@JsonKey(name: 'row_id') final  String rowId;
 final  String body;
@JsonKey(name: 'column_id') final  String? columnId;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandAddCommentCopyWith<TableCommandAddComment> get copyWith => _$TableCommandAddCommentCopyWithImpl<TableCommandAddComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandAddCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandAddComment&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.body, body) || other.body == body)&&(identical(other.columnId, columnId) || other.columnId == columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,rowId,body,columnId);
}

@override
String toString() {
    return 'TableCommand.addComment(kind: $kind, rowId: $rowId, body: $body, columnId: $columnId)';
}


}

/// @nodoc
abstract mixin class $TableCommandAddCommentCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandAddCommentCopyWith(TableCommandAddComment value, $Res Function(TableCommandAddComment) _then) = _$TableCommandAddCommentCopyWithImpl;
@useResult
$Res call({
 TableAddCommentCommandKind kind,@JsonKey(name: 'row_id') String rowId, String body,@JsonKey(name: 'column_id') String? columnId
});




}
/// @nodoc
class _$TableCommandAddCommentCopyWithImpl<$Res>
    implements $TableCommandAddCommentCopyWith<$Res> {
  _$TableCommandAddCommentCopyWithImpl(this._self, this._then);

  final TableCommandAddComment _self;
  final $Res Function(TableCommandAddComment) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? rowId = null,Object? body = null,Object? columnId = freezed,}) {
  return _then(TableCommandAddComment(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddCommentCommandKind,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandEditComment implements TableCommand {
  const TableCommandEditComment({required this.kind, required this.id, required this.body});
  factory TableCommandEditComment.fromJson(Map<String, dynamic> json) => _$TableCommandEditCommentFromJson(json);

@override final  TableEditCommentCommandKind kind;
/// Yorum kimliği.
 final  String id;
 final  String body;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandEditCommentCopyWith<TableCommandEditComment> get copyWith => _$TableCommandEditCommentCopyWithImpl<TableCommandEditComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandEditCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandEditComment&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,body);
}

@override
String toString() {
    return 'TableCommand.editComment(kind: $kind, id: $id, body: $body)';
}


}

/// @nodoc
abstract mixin class $TableCommandEditCommentCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandEditCommentCopyWith(TableCommandEditComment value, $Res Function(TableCommandEditComment) _then) = _$TableCommandEditCommentCopyWithImpl;
@useResult
$Res call({
 TableEditCommentCommandKind kind, String id, String body
});




}
/// @nodoc
class _$TableCommandEditCommentCopyWithImpl<$Res>
    implements $TableCommandEditCommentCopyWith<$Res> {
  _$TableCommandEditCommentCopyWithImpl(this._self, this._then);

  final TableCommandEditComment _self;
  final $Res Function(TableCommandEditComment) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? body = null,}) {
  return _then(TableCommandEditComment(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableEditCommentCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandDeleteComment implements TableCommand {
  const TableCommandDeleteComment({required this.kind, required this.id});
  factory TableCommandDeleteComment.fromJson(Map<String, dynamic> json) => _$TableCommandDeleteCommentFromJson(json);

@override final  TableDeleteCommentCommandKind kind;
/// Yorum kimliği.
 final  String id;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandDeleteCommentCopyWith<TableCommandDeleteComment> get copyWith => _$TableCommandDeleteCommentCopyWithImpl<TableCommandDeleteComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandDeleteCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandDeleteComment&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'TableCommand.deleteComment(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class $TableCommandDeleteCommentCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandDeleteCommentCopyWith(TableCommandDeleteComment value, $Res Function(TableCommandDeleteComment) _then) = _$TableCommandDeleteCommentCopyWithImpl;
@useResult
$Res call({
 TableDeleteCommentCommandKind kind, String id
});




}
/// @nodoc
class _$TableCommandDeleteCommentCopyWithImpl<$Res>
    implements $TableCommandDeleteCommentCopyWith<$Res> {
  _$TableCommandDeleteCommentCopyWithImpl(this._self, this._then);

  final TableCommandDeleteComment _self;
  final $Res Function(TableCommandDeleteComment) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(TableCommandDeleteComment(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteCommentCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandUndoCells implements TableCommand {
  const TableCommandUndoCells({required this.kind, required this.sequence});
  factory TableCommandUndoCells.fromJson(Map<String, dynamic> json) => _$TableCommandUndoCellsFromJson(json);

@override final  TableUndoCellsCommandKind kind;
 final  int sequence;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandUndoCellsCopyWith<TableCommandUndoCells> get copyWith => _$TableCommandUndoCellsCopyWithImpl<TableCommandUndoCells>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandUndoCellsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandUndoCells&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,sequence);
}

@override
String toString() {
    return 'TableCommand.undoCells(kind: $kind, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class $TableCommandUndoCellsCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandUndoCellsCopyWith(TableCommandUndoCells value, $Res Function(TableCommandUndoCells) _then) = _$TableCommandUndoCellsCopyWithImpl;
@useResult
$Res call({
 TableUndoCellsCommandKind kind, int sequence
});




}
/// @nodoc
class _$TableCommandUndoCellsCopyWithImpl<$Res>
    implements $TableCommandUndoCellsCopyWith<$Res> {
  _$TableCommandUndoCellsCopyWithImpl(this._self, this._then);

  final TableCommandUndoCells _self;
  final $Res Function(TableCommandUndoCells) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? sequence = null,}) {
  return _then(TableCommandUndoCells(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableUndoCellsCommandKind,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandRenameTable implements TableCommand {
  const TableCommandRenameTable({required this.kind, required this.name});
  factory TableCommandRenameTable.fromJson(Map<String, dynamic> json) => _$TableCommandRenameTableFromJson(json);

@override final  TableRenameCommandKind kind;
 final  String name;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandRenameTableCopyWith<TableCommandRenameTable> get copyWith => _$TableCommandRenameTableCopyWithImpl<TableCommandRenameTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandRenameTableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandRenameTable&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name);
}

@override
String toString() {
    return 'TableCommand.renameTable(kind: $kind, name: $name)';
}


}

/// @nodoc
abstract mixin class $TableCommandRenameTableCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandRenameTableCopyWith(TableCommandRenameTable value, $Res Function(TableCommandRenameTable) _then) = _$TableCommandRenameTableCopyWithImpl;
@useResult
$Res call({
 TableRenameCommandKind kind, String name
});




}
/// @nodoc
class _$TableCommandRenameTableCopyWithImpl<$Res>
    implements $TableCommandRenameTableCopyWith<$Res> {
  _$TableCommandRenameTableCopyWithImpl(this._self, this._then);

  final TableCommandRenameTable _self;
  final $Res Function(TableCommandRenameTable) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,}) {
  return _then(TableCommandRenameTable(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandDeleteTable implements TableCommand {
  const TableCommandDeleteTable({required this.kind});
  factory TableCommandDeleteTable.fromJson(Map<String, dynamic> json) => _$TableCommandDeleteTableFromJson(json);

@override final  TableDeleteCommandKind kind;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandDeleteTableCopyWith<TableCommandDeleteTable> get copyWith => _$TableCommandDeleteTableCopyWithImpl<TableCommandDeleteTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandDeleteTableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandDeleteTable&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind);
}

@override
String toString() {
    return 'TableCommand.deleteTable(kind: $kind)';
}


}

/// @nodoc
abstract mixin class $TableCommandDeleteTableCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandDeleteTableCopyWith(TableCommandDeleteTable value, $Res Function(TableCommandDeleteTable) _then) = _$TableCommandDeleteTableCopyWithImpl;
@useResult
$Res call({
 TableDeleteCommandKind kind
});




}
/// @nodoc
class _$TableCommandDeleteTableCopyWithImpl<$Res>
    implements $TableCommandDeleteTableCopyWith<$Res> {
  _$TableCommandDeleteTableCopyWithImpl(this._self, this._then);

  final TableCommandDeleteTable _self;
  final $Res Function(TableCommandDeleteTable) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,}) {
  return _then(TableCommandDeleteTable(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteCommandKind,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandAddColumn implements TableCommand {
  const TableCommandAddColumn({required this.kind, required this.name, required this.type, required this.width, @JsonKey(name: 'expected_schema') required this.expectedSchema, this.multiple = false});
  factory TableCommandAddColumn.fromJson(Map<String, dynamic> json) => _$TableCommandAddColumnFromJson(json);

@override final  TableAddColumnCommandKind kind;
 final  String name;
 final  TableColumnType type;
 final  int width;
@JsonKey(name: 'expected_schema') final  int expectedSchema;
/// Çoklu referans sütunu (TABLES-K14); yalnız `*_reference` tiplerinde true olabilir, aksi 422.
@JsonKey() final  bool multiple;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandAddColumnCopyWith<TableCommandAddColumn> get copyWith => _$TableCommandAddColumnCopyWithImpl<TableCommandAddColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandAddColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandAddColumn&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema)&&(identical(other.multiple, multiple) || other.multiple == multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name,type,width,expectedSchema,multiple);
}

@override
String toString() {
    return 'TableCommand.addColumn(kind: $kind, name: $name, type: $type, width: $width, expectedSchema: $expectedSchema, multiple: $multiple)';
}


}

/// @nodoc
abstract mixin class $TableCommandAddColumnCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandAddColumnCopyWith(TableCommandAddColumn value, $Res Function(TableCommandAddColumn) _then) = _$TableCommandAddColumnCopyWithImpl;
@useResult
$Res call({
 TableAddColumnCommandKind kind, String name, TableColumnType type, int width,@JsonKey(name: 'expected_schema') int expectedSchema, bool multiple
});




}
/// @nodoc
class _$TableCommandAddColumnCopyWithImpl<$Res>
    implements $TableCommandAddColumnCopyWith<$Res> {
  _$TableCommandAddColumnCopyWithImpl(this._self, this._then);

  final TableCommandAddColumn _self;
  final $Res Function(TableCommandAddColumn) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,Object? type = null,Object? width = null,Object? expectedSchema = null,Object? multiple = null,}) {
  return _then(TableCommandAddColumn(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddColumnCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandRenameColumn implements TableCommand {
  const TableCommandRenameColumn({required this.kind, required this.id, required this.name, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory TableCommandRenameColumn.fromJson(Map<String, dynamic> json) => _$TableCommandRenameColumnFromJson(json);

@override final  TableRenameColumnCommandKind kind;
/// Sütun kimliği.
 final  String id;
 final  String name;
@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandRenameColumnCopyWith<TableCommandRenameColumn> get copyWith => _$TableCommandRenameColumnCopyWithImpl<TableCommandRenameColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandRenameColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandRenameColumn&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,name,expectedSchema);
}

@override
String toString() {
    return 'TableCommand.renameColumn(kind: $kind, id: $id, name: $name, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class $TableCommandRenameColumnCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandRenameColumnCopyWith(TableCommandRenameColumn value, $Res Function(TableCommandRenameColumn) _then) = _$TableCommandRenameColumnCopyWithImpl;
@useResult
$Res call({
 TableRenameColumnCommandKind kind, String id, String name,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableCommandRenameColumnCopyWithImpl<$Res>
    implements $TableCommandRenameColumnCopyWith<$Res> {
  _$TableCommandRenameColumnCopyWithImpl(this._self, this._then);

  final TableCommandRenameColumn _self;
  final $Res Function(TableCommandRenameColumn) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? name = null,Object? expectedSchema = null,}) {
  return _then(TableCommandRenameColumn(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandResizeColumn implements TableCommand {
  const TableCommandResizeColumn({required this.kind, required this.id, required this.width, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory TableCommandResizeColumn.fromJson(Map<String, dynamic> json) => _$TableCommandResizeColumnFromJson(json);

@override final  TableResizeColumnCommandKind kind;
/// Sütun kimliği.
 final  String id;
 final  int width;
@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandResizeColumnCopyWith<TableCommandResizeColumn> get copyWith => _$TableCommandResizeColumnCopyWithImpl<TableCommandResizeColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandResizeColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandResizeColumn&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,width,expectedSchema);
}

@override
String toString() {
    return 'TableCommand.resizeColumn(kind: $kind, id: $id, width: $width, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class $TableCommandResizeColumnCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandResizeColumnCopyWith(TableCommandResizeColumn value, $Res Function(TableCommandResizeColumn) _then) = _$TableCommandResizeColumnCopyWithImpl;
@useResult
$Res call({
 TableResizeColumnCommandKind kind, String id, int width,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableCommandResizeColumnCopyWithImpl<$Res>
    implements $TableCommandResizeColumnCopyWith<$Res> {
  _$TableCommandResizeColumnCopyWithImpl(this._self, this._then);

  final TableCommandResizeColumn _self;
  final $Res Function(TableCommandResizeColumn) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? width = null,Object? expectedSchema = null,}) {
  return _then(TableCommandResizeColumn(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableResizeColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandDeleteColumn implements TableCommand {
  const TableCommandDeleteColumn({required this.kind, required this.id, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory TableCommandDeleteColumn.fromJson(Map<String, dynamic> json) => _$TableCommandDeleteColumnFromJson(json);

@override final  TableDeleteColumnCommandKind kind;
/// Sütun kimliği.
 final  String id;
@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandDeleteColumnCopyWith<TableCommandDeleteColumn> get copyWith => _$TableCommandDeleteColumnCopyWithImpl<TableCommandDeleteColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandDeleteColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandDeleteColumn&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,expectedSchema);
}

@override
String toString() {
    return 'TableCommand.deleteColumn(kind: $kind, id: $id, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class $TableCommandDeleteColumnCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandDeleteColumnCopyWith(TableCommandDeleteColumn value, $Res Function(TableCommandDeleteColumn) _then) = _$TableCommandDeleteColumnCopyWithImpl;
@useResult
$Res call({
 TableDeleteColumnCommandKind kind, String id,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableCommandDeleteColumnCopyWithImpl<$Res>
    implements $TableCommandDeleteColumnCopyWith<$Res> {
  _$TableCommandDeleteColumnCopyWithImpl(this._self, this._then);

  final TableCommandDeleteColumn _self;
  final $Res Function(TableCommandDeleteColumn) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? expectedSchema = null,}) {
  return _then(TableCommandDeleteColumn(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandAddRow implements TableCommand {
  const TableCommandAddRow({required this.kind});
  factory TableCommandAddRow.fromJson(Map<String, dynamic> json) => _$TableCommandAddRowFromJson(json);

@override final  TableAddRowCommandKind kind;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandAddRowCopyWith<TableCommandAddRow> get copyWith => _$TableCommandAddRowCopyWithImpl<TableCommandAddRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandAddRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandAddRow&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind);
}

@override
String toString() {
    return 'TableCommand.addRow(kind: $kind)';
}


}

/// @nodoc
abstract mixin class $TableCommandAddRowCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandAddRowCopyWith(TableCommandAddRow value, $Res Function(TableCommandAddRow) _then) = _$TableCommandAddRowCopyWithImpl;
@useResult
$Res call({
 TableAddRowCommandKind kind
});




}
/// @nodoc
class _$TableCommandAddRowCopyWithImpl<$Res>
    implements $TableCommandAddRowCopyWith<$Res> {
  _$TableCommandAddRowCopyWithImpl(this._self, this._then);

  final TableCommandAddRow _self;
  final $Res Function(TableCommandAddRow) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,}) {
  return _then(TableCommandAddRow(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddRowCommandKind,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandDeleteRow implements TableCommand {
  const TableCommandDeleteRow({required this.kind, required this.id});
  factory TableCommandDeleteRow.fromJson(Map<String, dynamic> json) => _$TableCommandDeleteRowFromJson(json);

@override final  TableDeleteRowCommandKind kind;
/// Satır kimliği.
 final  String id;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandDeleteRowCopyWith<TableCommandDeleteRow> get copyWith => _$TableCommandDeleteRowCopyWithImpl<TableCommandDeleteRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandDeleteRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandDeleteRow&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'TableCommand.deleteRow(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class $TableCommandDeleteRowCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandDeleteRowCopyWith(TableCommandDeleteRow value, $Res Function(TableCommandDeleteRow) _then) = _$TableCommandDeleteRowCopyWithImpl;
@useResult
$Res call({
 TableDeleteRowCommandKind kind, String id
});




}
/// @nodoc
class _$TableCommandDeleteRowCopyWithImpl<$Res>
    implements $TableCommandDeleteRowCopyWith<$Res> {
  _$TableCommandDeleteRowCopyWithImpl(this._self, this._then);

  final TableCommandDeleteRow _self;
  final $Res Function(TableCommandDeleteRow) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(TableCommandDeleteRow(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteRowCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandGrant implements TableCommand {
  const TableCommandGrant({required this.kind, @JsonKey(name: 'account_id') required this.accountId, required this.role});
  factory TableCommandGrant.fromJson(Map<String, dynamic> json) => _$TableCommandGrantFromJson(json);

@override final  TableGrantCommandKind kind;
@JsonKey(name: 'account_id') final  String accountId;
 final  TableGrantCommandRole role;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandGrantCopyWith<TableCommandGrant> get copyWith => _$TableCommandGrantCopyWithImpl<TableCommandGrant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandGrantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandGrant&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,accountId,role);
}

@override
String toString() {
    return 'TableCommand.grant(kind: $kind, accountId: $accountId, role: $role)';
}


}

/// @nodoc
abstract mixin class $TableCommandGrantCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandGrantCopyWith(TableCommandGrant value, $Res Function(TableCommandGrant) _then) = _$TableCommandGrantCopyWithImpl;
@useResult
$Res call({
 TableGrantCommandKind kind,@JsonKey(name: 'account_id') String accountId, TableGrantCommandRole role
});




}
/// @nodoc
class _$TableCommandGrantCopyWithImpl<$Res>
    implements $TableCommandGrantCopyWith<$Res> {
  _$TableCommandGrantCopyWithImpl(this._self, this._then);

  final TableCommandGrant _self;
  final $Res Function(TableCommandGrant) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? accountId = null,Object? role = null,}) {
  return _then(TableCommandGrant(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableGrantCommandKind,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableGrantCommandRole,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandRevoke implements TableCommand {
  const TableCommandRevoke({required this.kind, @JsonKey(name: 'account_id') required this.accountId});
  factory TableCommandRevoke.fromJson(Map<String, dynamic> json) => _$TableCommandRevokeFromJson(json);

@override final  TableRevokeCommandKind kind;
@JsonKey(name: 'account_id') final  String accountId;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandRevokeCopyWith<TableCommandRevoke> get copyWith => _$TableCommandRevokeCopyWithImpl<TableCommandRevoke>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandRevokeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandRevoke&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,accountId);
}

@override
String toString() {
    return 'TableCommand.revoke(kind: $kind, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $TableCommandRevokeCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandRevokeCopyWith(TableCommandRevoke value, $Res Function(TableCommandRevoke) _then) = _$TableCommandRevokeCopyWithImpl;
@useResult
$Res call({
 TableRevokeCommandKind kind,@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class _$TableCommandRevokeCopyWithImpl<$Res>
    implements $TableCommandRevokeCopyWith<$Res> {
  _$TableCommandRevokeCopyWithImpl(this._self, this._then);

  final TableCommandRevoke _self;
  final $Res Function(TableCommandRevoke) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? accountId = null,}) {
  return _then(TableCommandRevoke(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRevokeCommandKind,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableCommandSetCells implements TableCommand {
  const TableCommandSetCells({required this.kind, required  List<TableCell> cells}): _cells = cells;
  factory TableCommandSetCells.fromJson(Map<String, dynamic> json) => _$TableCommandSetCellsFromJson(json);

@override final  TableSetCellsCommandKind kind;
 final  List<TableCell> _cells;
 List<TableCell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}


/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommandSetCellsCopyWith<TableCommandSetCells> get copyWith => _$TableCommandSetCellsCopyWithImpl<TableCommandSetCells>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommandSetCellsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommandSetCells&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.cells, _cells));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(_cells));
}

@override
String toString() {
    return 'TableCommand.setCells(kind: $kind, cells: $cells)';
}


}

/// @nodoc
abstract mixin class $TableCommandSetCellsCopyWith<$Res> implements $TableCommandCopyWith<$Res> {
  factory $TableCommandSetCellsCopyWith(TableCommandSetCells value, $Res Function(TableCommandSetCells) _then) = _$TableCommandSetCellsCopyWithImpl;
@useResult
$Res call({
 TableSetCellsCommandKind kind, List<TableCell> cells
});




}
/// @nodoc
class _$TableCommandSetCellsCopyWithImpl<$Res>
    implements $TableCommandSetCellsCopyWith<$Res> {
  _$TableCommandSetCellsCopyWithImpl(this._self, this._then);

  final TableCommandSetCells _self;
  final $Res Function(TableCommandSetCells) _then;

/// Create a copy of TableCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? cells = null,}) {
  return _then(TableCommandSetCells(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetCellsCommandKind,cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>,
  ));
}


}

// dart format on
