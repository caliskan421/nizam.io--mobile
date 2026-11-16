// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEntry _$AuditEntryFromJson(Map<String, dynamic> json) => _AuditEntry(
  entryId: json['entry_id'] as String,
  occurredAt: DateTime.parse(json['occurred_at'] as String),
  actorAccountId: json['actor_account_id'] as String?,
  actorFullName: json['actor_full_name'] as String?,
  subjectKind: json['subject_kind'] as String,
  subjectId: json['subject_id'] as String,
  actionCode: json['action_code'] as String,
  outcome: AuditEntryOutcome.fromJson(json['outcome'] as String),
  programId: json['program_id'] as String?,
  departmentId: json['department_id'] as String?,
  details: json['details'] as String?,
);

Map<String, dynamic> _$AuditEntryToJson(_AuditEntry instance) =>
    <String, dynamic>{
      'entry_id': instance.entryId,
      'occurred_at': instance.occurredAt.toIso8601String(),
      'actor_account_id': ?instance.actorAccountId,
      'actor_full_name': ?instance.actorFullName,
      'subject_kind': instance.subjectKind,
      'subject_id': instance.subjectId,
      'action_code': instance.actionCode,
      'outcome': _$AuditEntryOutcomeEnumMap[instance.outcome]!,
      'program_id': ?instance.programId,
      'department_id': ?instance.departmentId,
      'details': ?instance.details,
    };

const _$AuditEntryOutcomeEnumMap = {
  AuditEntryOutcome.succeeded: 'succeeded',
  AuditEntryOutcome.failed: 'failed',
  AuditEntryOutcome.$unknown: r'$unknown',
};
