// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_presence_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TablePresenceFrame _$TablePresenceFrameFromJson(Map<String, dynamic> json) =>
    _TablePresenceFrame(
      tableId: json['table_id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => Participants.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TablePresenceFrameToJson(_TablePresenceFrame instance) =>
    <String, dynamic>{
      'table_id': instance.tableId,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
    };
