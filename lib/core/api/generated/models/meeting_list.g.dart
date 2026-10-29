// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingList _$MeetingListFromJson(Map<String, dynamic> json) => _MeetingList(
  items: (json['items'] as List<dynamic>)
      .map((e) => Meeting.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String,
);

Map<String, dynamic> _$MeetingListToJson(_MeetingList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };
