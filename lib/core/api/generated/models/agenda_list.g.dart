// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgendaList _$AgendaListFromJson(Map<String, dynamic> json) => _AgendaList(
  items: (json['items'] as List<dynamic>)
      .map((e) => AgendaItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String,
);

Map<String, dynamic> _$AgendaListToJson(_AgendaList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };
