// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Participants _$ParticipantsFromJson(Map<String, dynamic> json) =>
    _Participants(
      key: json['key'] as String,
      accountId: json['account_id'] as String,
      name: json['name'] as String,
      rowId: json['row_id'] as String,
      columnId: json['column_id'] as String,
    );

Map<String, dynamic> _$ParticipantsToJson(_Participants instance) =>
    <String, dynamic>{
      'key': instance.key,
      'account_id': instance.accountId,
      'name': instance.name,
      'row_id': instance.rowId,
      'column_id': instance.columnId,
    };
