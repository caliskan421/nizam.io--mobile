// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableChange _$TableChangeFromJson(Map<String, dynamic> json) => _TableChange(
  tableId: json['table_id'] as String,
  seq: (json['seq'] as num).toInt(),
  kind: TableChangeKind.fromJson(json['kind'] as String),
);

Map<String, dynamic> _$TableChangeToJson(_TableChange instance) =>
    <String, dynamic>{
      'table_id': instance.tableId,
      'seq': instance.seq,
      'kind': _$TableChangeKindEnumMap[instance.kind]!,
    };

const _$TableChangeKindEnumMap = {
  TableChangeKind.renameTable: 'rename_table',
  TableChangeKind.deleteTable: 'delete_table',
  TableChangeKind.addColumn: 'add_column',
  TableChangeKind.renameColumn: 'rename_column',
  TableChangeKind.resizeColumn: 'resize_column',
  TableChangeKind.deleteColumn: 'delete_column',
  TableChangeKind.moveColumn: 'move_column',
  TableChangeKind.addRow: 'add_row',
  TableChangeKind.deleteRow: 'delete_row',
  TableChangeKind.moveRow: 'move_row',
  TableChangeKind.setCells: 'set_cells',
  TableChangeKind.grant: 'grant',
  TableChangeKind.revoke: 'revoke',
  TableChangeKind.setTeamRole: 'set_team_role',
  TableChangeKind.setTemplate: 'set_template',
  TableChangeKind.setProject: 'set_project',
  TableChangeKind.uploadAttachment: 'upload_attachment',
  TableChangeKind.convertColumn: 'convert_column',
  TableChangeKind.moveTable: 'move_table',
  TableChangeKind.addComment: 'add_comment',
  TableChangeKind.editComment: 'edit_comment',
  TableChangeKind.deleteComment: 'delete_comment',
  TableChangeKind.undoCells: 'undo_cells',
  TableChangeKind.$unknown: r'$unknown',
};
