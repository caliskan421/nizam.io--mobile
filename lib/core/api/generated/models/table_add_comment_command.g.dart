// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_add_comment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableAddCommentCommand _$TableAddCommentCommandFromJson(
  Map<String, dynamic> json,
) => _TableAddCommentCommand(
  kind: TableAddCommentCommandKind.fromJson(json['kind'] as String),
  rowId: json['row_id'] as String,
  body: json['body'] as String,
  columnId: json['column_id'] as String?,
);

Map<String, dynamic> _$TableAddCommentCommandToJson(
  _TableAddCommentCommand instance,
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
