// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemNote _$WorkItemNoteFromJson(Map<String, dynamic> json) =>
    _WorkItemNote(
      noteId: json['note_id'] as String,
      workItemId: json['work_item_id'] as String,
      authorAccountId: json['author_account_id'] as String,
      authorFullName: json['author_full_name'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$WorkItemNoteToJson(_WorkItemNote instance) =>
    <String, dynamic>{
      'note_id': instance.noteId,
      'work_item_id': instance.workItemId,
      'author_account_id': instance.authorAccountId,
      'author_full_name': ?instance.authorFullName,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
