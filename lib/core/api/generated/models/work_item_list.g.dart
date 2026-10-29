// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemList _$WorkItemListFromJson(Map<String, dynamic> json) =>
    _WorkItemList(
      items: (json['items'] as List<dynamic>)
          .map((e) => WorkItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$WorkItemListToJson(_WorkItemList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
