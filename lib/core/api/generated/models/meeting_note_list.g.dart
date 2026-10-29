// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_note_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingNoteList _$MeetingNoteListFromJson(Map<String, dynamic> json) =>
    _MeetingNoteList(
      items: (json['items'] as List<dynamic>)
          .map((e) => MeetingNote.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String,
    );

Map<String, dynamic> _$MeetingNoteListToJson(_MeetingNoteList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };
