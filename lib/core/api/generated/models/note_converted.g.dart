// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_converted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteConverted _$NoteConvertedFromJson(Map<String, dynamic> json) =>
    _NoteConverted(
      workItemId: json['work_item_id'] as String,
      note: MeetingNote.fromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoteConvertedToJson(_NoteConverted instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'note': instance.note.toJson(),
    };
