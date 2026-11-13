// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_tab_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingTabCounts _$MeetingTabCountsFromJson(Map<String, dynamic> json) =>
    _MeetingTabCounts(
      upcoming: (json['upcoming'] as num).toInt(),
      past: (json['past'] as num).toInt(),
      deleted: (json['deleted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MeetingTabCountsToJson(_MeetingTabCounts instance) =>
    <String, dynamic>{
      'upcoming': instance.upcoming,
      'past': instance.past,
      'deleted': ?instance.deleted,
    };
