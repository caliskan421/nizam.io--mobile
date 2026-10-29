// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conference _$ConferenceFromJson(Map<String, dynamic> json) => _Conference(
  id: json['id'] as String,
  status: ConferenceStatus.fromJson(json['status'] as String),
  startedAt: DateTime.parse(json['started_at'] as String),
  startedByAccountId: json['started_by_account_id'] as String,
);

Map<String, dynamic> _$ConferenceToJson(_Conference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$ConferenceStatusEnumMap[instance.status]!,
      'started_at': instance.startedAt.toIso8601String(),
      'started_by_account_id': instance.startedByAccountId,
    };

const _$ConferenceStatusEnumMap = {
  ConferenceStatus.starting: 'starting',
  ConferenceStatus.live: 'live',
  ConferenceStatus.ending: 'ending',
  ConferenceStatus.$unknown: r'$unknown',
};
