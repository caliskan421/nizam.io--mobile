// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_note_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemNoteList _$WorkItemNoteListFromJson(Map<String, dynamic> json) =>
    _WorkItemNoteList(
      notes: (json['notes'] as List<dynamic>)
          .map((e) => WorkItemNote.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$WorkItemNoteListToJson(_WorkItemNoteList instance) =>
    <String, dynamic>{
      'notes': instance.notes.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
