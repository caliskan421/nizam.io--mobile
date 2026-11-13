// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_edit_comment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableEditCommentCommand _$TableEditCommentCommandFromJson(
  Map<String, dynamic> json,
) => _TableEditCommentCommand(
  kind: TableEditCommentCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  body: json['body'] as String,
);

Map<String, dynamic> _$TableEditCommentCommandToJson(
  _TableEditCommentCommand instance,
) => <String, dynamic>{
  'kind': _$TableEditCommentCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'body': instance.body,
};

const _$TableEditCommentCommandKindEnumMap = {
  TableEditCommentCommandKind.editComment: 'edit_comment',
  TableEditCommentCommandKind.$unknown: r'$unknown',
};
