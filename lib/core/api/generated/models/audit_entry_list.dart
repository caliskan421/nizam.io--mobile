// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'audit_entry.dart';

part 'audit_entry_list.freezed.dart';
part 'audit_entry_list.g.dart';

@Freezed()
abstract class AuditEntryList with _$AuditEntryList {
  const factory AuditEntryList({
    required List<AuditEntry> entries,
    @JsonKey(name: 'next_cursor') required String? nextCursor,
  }) = _AuditEntryList;

  factory AuditEntryList.fromJson(Map<String, Object?> json) =>
      _$AuditEntryListFromJson(json);
}
