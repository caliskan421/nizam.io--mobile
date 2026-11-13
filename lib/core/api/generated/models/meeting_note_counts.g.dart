// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_note_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingNoteCounts _$MeetingNoteCountsFromJson(Map<String, dynamic> json) =>
    _MeetingNoteCounts(
      all: (json['all'] as num).toInt(),
      converted: (json['converted'] as num).toInt(),
      mine: (json['mine'] as num).toInt(),
    );

Map<String, dynamic> _$MeetingNoteCountsToJson(_MeetingNoteCounts instance) =>
    <String, dynamic>{
      'all': instance.all,
      'converted': instance.converted,
      'mine': instance.mine,
    };
