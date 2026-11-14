// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_add_column_command.dart';
import 'table_add_column_command_kind.dart';
import 'table_add_comment_command.dart';
import 'table_add_comment_command_kind.dart';
import 'table_add_row_command.dart';
import 'table_add_row_command_kind.dart';
import 'table_cell.dart';
import 'table_column_type.dart';
import 'table_command.dart';
import 'table_convert_column_command.dart';
import 'table_convert_column_command_kind.dart';
import 'table_delete_column_command.dart';
import 'table_delete_column_command_kind.dart';
import 'table_delete_command.dart';
import 'table_delete_command_kind.dart';
import 'table_delete_comment_command.dart';
import 'table_delete_comment_command_kind.dart';
import 'table_delete_row_command.dart';
import 'table_delete_row_command_kind.dart';
import 'table_edit_comment_command.dart';
import 'table_edit_comment_command_kind.dart';
import 'table_grant_command.dart';
import 'table_grant_command_kind.dart';
import 'table_grant_command_role.dart';
import 'table_move_column_command.dart';
import 'table_move_column_command_kind.dart';
import 'table_move_command.dart';
import 'table_move_command_kind.dart';
import 'table_move_command_target_space.dart';
import 'table_move_row_command.dart';
import 'table_move_row_command_kind.dart';
import 'table_propose_command.dart';
import 'table_propose_command_kind.dart';
import 'table_propose_command_role.dart';
import 'table_propose_command_target_space.dart';
import 'table_rename_column_command.dart';
import 'table_rename_column_command_kind.dart';
import 'table_rename_command.dart';
import 'table_rename_command_kind.dart';
import 'table_resize_column_command.dart';
import 'table_resize_column_command_kind.dart';
import 'table_revoke_command.dart';
import 'table_revoke_command_kind.dart';
import 'table_set_cells_command.dart';
import 'table_set_cells_command_kind.dart';
import 'table_set_project_command.dart';
import 'table_set_project_command_kind.dart';
import 'table_set_team_role_command.dart';
import 'table_set_team_role_command_kind.dart';
import 'table_set_team_role_command_role.dart';
import 'table_set_template_command.dart';
import 'table_set_template_command_kind.dart';
import 'table_undo_cells_command.dart';
import 'table_undo_cells_command_kind.dart';
import 'table_withdraw_proposal_command.dart';
import 'table_withdraw_proposal_command_kind.dart';

part 'table_command.freezed.dart';
part 'table_command.g.dart';

/// `kind` alanına göre ayrışan tek tablo komutu. Her varyantın zorunlu alanları kendi şemasındadır; eksik, `null` ya da sınır dışı alan 422 `tables.input_invalid`. Sütun komutları `expected_schema` (en az 1) ister; eksik/`null`/0 422, bayat şema 409 `tables.schema_conflict` alır (TABLES-K08). `grant`, `revoke`, `delete_table`, `set_team_role`, `set_project`, `set_template`, `move_table`, `propose_move`, `propose_copy` ve `withdraw_proposal` yalnız sahibe açıktır (TABLES-K02, TABLES-K12, TABLES-K13, TABLES-K16…K18). Proje komutları bu uçta değil proje ucundadır. Hedef alanları (`target_*`) yalnız taşıma ve öneri komutlarında kabul edilir; başka komutta 422.
@Freezed(unionKey: 'kind')
sealed class TableCommand with _$TableCommand {
  @FreezedUnionValue('set_team_role')
  const factory TableCommand.setTeamRole({
    required TableSetTeamRoleCommandKind kind,
    required TableSetTeamRoleCommandRole role,
  }) = TableCommandSetTeamRole;

  @FreezedUnionValue('set_project')
  const factory TableCommand.setProject({
    required TableSetProjectCommandKind kind,
    @JsonKey(name: 'project_id') String? projectId,
  }) = TableCommandSetProject;

  @FreezedUnionValue('set_template')
  const factory TableCommand.setTemplate({
    required TableSetTemplateCommandKind kind,
    required bool template,
  }) = TableCommandSetTemplate;

  @FreezedUnionValue('move_table')
  const factory TableCommand.moveTable({
    required TableMoveCommandKind kind,
    @JsonKey(name: 'target_space')
    required TableMoveCommandTargetSpace targetSpace,

    /// Yalnız `coordinatorship` hedefinde zorunlu; kişisel hedefte verilmez.
    @JsonKey(name: 'target_department_id') String? targetDepartmentId,

    /// Verilmezse tablo projesiz taşınır; verilmişse hedefteki silinmemiş proje (null/boş 422).
    @JsonKey(name: 'target_project_id') String? targetProjectId,
  }) = TableCommandMoveTable;

  @FreezedUnionValue('propose_move')
  const factory TableCommand.proposeMove({
    required TableProposeCommandKind kind,
    @JsonKey(name: 'target_space')
    required TableProposeCommandTargetSpace targetSpace,
    @JsonKey(name: 'target_department_id') required String targetDepartmentId,

    /// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
    @JsonKey(name: 'target_project_id') String? targetProjectId,
    TableProposeCommandRole? role,
  }) = TableCommandProposeMove;

  @FreezedUnionValue('propose_copy')
  const factory TableCommand.proposeCopy({
    required TableProposeCommandKind kind,
    @JsonKey(name: 'target_space')
    required TableProposeCommandTargetSpace targetSpace,
    @JsonKey(name: 'target_department_id') required String targetDepartmentId,

    /// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
    @JsonKey(name: 'target_project_id') String? targetProjectId,
    TableProposeCommandRole? role,
  }) = TableCommandProposeCopy;

  @FreezedUnionValue('withdraw_proposal')
  const factory TableCommand.withdrawProposal({
    required TableWithdrawProposalCommandKind kind,
  }) = TableCommandWithdrawProposal;

  @FreezedUnionValue('convert_column')
  const factory TableCommand.convertColumn({
    required TableConvertColumnCommandKind kind,
    required String id,
    required TableColumnType type,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = TableCommandConvertColumn;

  @FreezedUnionValue('move_row')
  const factory TableCommand.moveRow({
    required TableMoveRowCommandKind kind,
    required String id,
    @JsonKey(name: 'after_id') String? afterId,
  }) = TableCommandMoveRow;

  @FreezedUnionValue('move_column')
  const factory TableCommand.moveColumn({
    required TableMoveColumnCommandKind kind,
    required String id,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
    @JsonKey(name: 'after_id') String? afterId,
  }) = TableCommandMoveColumn;

  @FreezedUnionValue('add_comment')
  const factory TableCommand.addComment({
    required TableAddCommentCommandKind kind,
    @JsonKey(name: 'row_id') required String rowId,
    required String body,
    @JsonKey(name: 'column_id') String? columnId,
  }) = TableCommandAddComment;

  @FreezedUnionValue('edit_comment')
  const factory TableCommand.editComment({
    required TableEditCommentCommandKind kind,

    /// Yorum kimliği.
    required String id,
    required String body,
  }) = TableCommandEditComment;

  @FreezedUnionValue('delete_comment')
  const factory TableCommand.deleteComment({
    required TableDeleteCommentCommandKind kind,

    /// Yorum kimliği.
    required String id,
  }) = TableCommandDeleteComment;

  @FreezedUnionValue('undo_cells')
  const factory TableCommand.undoCells({
    required TableUndoCellsCommandKind kind,
    required int sequence,
  }) = TableCommandUndoCells;

  @FreezedUnionValue('rename_table')
  const factory TableCommand.renameTable({
    required TableRenameCommandKind kind,
    required String name,
  }) = TableCommandRenameTable;

  @FreezedUnionValue('delete_table')
  const factory TableCommand.deleteTable({
    required TableDeleteCommandKind kind,
  }) = TableCommandDeleteTable;

  @FreezedUnionValue('add_column')
  const factory TableCommand.addColumn({
    required TableAddColumnCommandKind kind,
    required String name,
    required TableColumnType type,
    required int width,
    @JsonKey(name: 'expected_schema') required int expectedSchema,

    /// Çoklu referans sütunu (TABLES-K14); yalnız `*_reference` tiplerinde true olabilir, aksi 422.
    @Default(false) bool multiple,
  }) = TableCommandAddColumn;

  @FreezedUnionValue('rename_column')
  const factory TableCommand.renameColumn({
    required TableRenameColumnCommandKind kind,

    /// Sütun kimliği.
    required String id,
    required String name,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = TableCommandRenameColumn;

  @FreezedUnionValue('resize_column')
  const factory TableCommand.resizeColumn({
    required TableResizeColumnCommandKind kind,

    /// Sütun kimliği.
    required String id,
    required int width,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = TableCommandResizeColumn;

  @FreezedUnionValue('delete_column')
  const factory TableCommand.deleteColumn({
    required TableDeleteColumnCommandKind kind,

    /// Sütun kimliği.
    required String id,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = TableCommandDeleteColumn;

  @FreezedUnionValue('add_row')
  const factory TableCommand.addRow({required TableAddRowCommandKind kind}) =
      TableCommandAddRow;

  @FreezedUnionValue('delete_row')
  const factory TableCommand.deleteRow({
    required TableDeleteRowCommandKind kind,

    /// Satır kimliği.
    required String id,
  }) = TableCommandDeleteRow;

  @FreezedUnionValue('grant')
  const factory TableCommand.grant({
    required TableGrantCommandKind kind,
    @JsonKey(name: 'account_id') required String accountId,
    required TableGrantCommandRole role,
  }) = TableCommandGrant;

  @FreezedUnionValue('revoke')
  const factory TableCommand.revoke({
    required TableRevokeCommandKind kind,
    @JsonKey(name: 'account_id') required String accountId,
  }) = TableCommandRevoke;

  @FreezedUnionValue('set_cells')
  const factory TableCommand.setCells({
    required TableSetCellsCommandKind kind,
    required List<TableCell> cells,
  }) = TableCommandSetCells;

  factory TableCommand.fromJson(Map<String, Object?> json) =>
      _$TableCommandFromJson(json);
}
