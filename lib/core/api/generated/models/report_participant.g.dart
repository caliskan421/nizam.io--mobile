// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportParticipant _$ReportParticipantFromJson(Map<String, dynamic> json) =>
    _ReportParticipant(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$ReportParticipantToJson(_ReportParticipant instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'role': instance.role,
    };
