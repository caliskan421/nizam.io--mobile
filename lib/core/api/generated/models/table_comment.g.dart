// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableComment _$TableCommentFromJson(Map<String, dynamic> json) =>
    _TableComment(
      id: json['id'] as String,
      rowId: json['row_id'] as String,
      columnId: json['column_id'] as String?,
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as String),
      mine: json['mine'] as bool,
      body: json['body'] as String,
      seq: (json['seq'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: json['edited_at'] == null
          ? null
          : DateTime.parse(json['edited_at'] as String),
    );

Map<String, dynamic> _$TableCommentToJson(_TableComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'row_id': instance.rowId,
      'column_id': ?instance.columnId,
      'author': ?_$AuthorEnumMap[instance.author],
      'mine': instance.mine,
      'body': instance.body,
      'seq': instance.seq,
      'created_at': instance.createdAt.toIso8601String(),
      'edited_at': ?instance.editedAt?.toIso8601String(),
    };

const _$AuthorEnumMap = {Author.me: 'me', Author.$unknown: r'$unknown'};
