// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableList _$TableListFromJson(Map<String, dynamic> json) => _TableList(
  items: (json['items'] as List<dynamic>)
      .map((e) => Table.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$TableListToJson(_TableList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
