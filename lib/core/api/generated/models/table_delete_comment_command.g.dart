// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_delete_comment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableDeleteCommentCommand _$TableDeleteCommentCommandFromJson(
  Map<String, dynamic> json,
) => _TableDeleteCommentCommand(
  kind: TableDeleteCommentCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
);

Map<String, dynamic> _$TableDeleteCommentCommandToJson(
  _TableDeleteCommentCommand instance,
) => <String, dynamic>{
  'kind': _$TableDeleteCommentCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
};

const _$TableDeleteCommentCommandKindEnumMap = {
  TableDeleteCommentCommandKind.deleteComment: 'delete_comment',
  TableDeleteCommentCommandKind.$unknown: r'$unknown',
};
