// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEntryList _$AuditEntryListFromJson(Map<String, dynamic> json) =>
    _AuditEntryList(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => AuditEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$AuditEntryListToJson(_AuditEntryList instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
