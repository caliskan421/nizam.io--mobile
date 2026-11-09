// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Participant _$ParticipantFromJson(Map<String, dynamic> json) => _Participant(
  accountId: json['account_id'] as String,
  fullName: json['full_name'] as String,
  teams: (json['teams'] as List<dynamic>)
      .map((e) => Teams.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ParticipantToJson(_Participant instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'teams': instance.teams.map((e) => e.toJson()).toList(),
    };
