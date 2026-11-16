// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'audit_entry_outcome.dart';

part 'audit_entry.freezed.dart';
part 'audit_entry.g.dart';

@Freezed()
abstract class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    @JsonKey(name: 'entry_id') required String entryId,
    @JsonKey(name: 'occurred_at') required DateTime occurredAt,

    /// Kurulum aracı/sistem işlemlerinde `null`.
    @JsonKey(name: 'actor_account_id') required String? actorAccountId,
    @JsonKey(name: 'actor_full_name') required String? actorFullName,
    @JsonKey(name: 'subject_kind') required String subjectKind,
    @JsonKey(name: 'subject_id') required String subjectId,

    /// Kararlı eylem kodu (ör. `work.item.transitioned`); görünen ad istemci sözlüğündedir.
    @JsonKey(name: 'action_code') required String actionCode,
    required AuditEntryOutcome outcome,
    @JsonKey(name: 'program_id') required String? programId,
    @JsonKey(name: 'department_id') required String? departmentId,

    /// Kararlı ayrıntı (ör. dosya adı, `acting_as=company_admin`); serbest metin taşımaz.
    required String? details,
  }) = _AuditEntry;

  factory AuditEntry.fromJson(Map<String, Object?> json) =>
      _$AuditEntryFromJson(json);
}
