// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgendaItem _$AgendaItemFromJson(Map<String, dynamic> json) => _AgendaItem(
  agendaItemId: json['agenda_item_id'] as String,
  meetingId: json['meeting_id'] as String,
  title: json['title'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
  isChecked: json['is_checked'] as bool,
  checkedAt: json['checked_at'] == null
      ? null
      : DateTime.parse(json['checked_at'] as String),
  checkedByAccountId: json['checked_by_account_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AgendaItemToJson(_AgendaItem instance) =>
    <String, dynamic>{
      'agenda_item_id': instance.agendaItemId,
      'meeting_id': instance.meetingId,
      'title': instance.title,
      'sort_order': instance.sortOrder,
      'is_checked': instance.isChecked,
      'checked_at': ?instance.checkedAt?.toIso8601String(),
      'checked_by_account_id': ?instance.checkedByAccountId,
      'created_at': instance.createdAt.toIso8601String(),
    };
