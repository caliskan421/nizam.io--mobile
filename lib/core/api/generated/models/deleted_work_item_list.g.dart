// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_work_item_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeletedWorkItemList _$DeletedWorkItemListFromJson(Map<String, dynamic> json) =>
    _DeletedWorkItemList(
      items: (json['items'] as List<dynamic>)
          .map((e) => DeletedWorkItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$DeletedWorkItemListToJson(
  _DeletedWorkItemList instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'next_cursor': ?instance.nextCursor,
};
