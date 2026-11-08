// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_ref_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRefList _$ChatRefListFromJson(Map<String, dynamic> json) => _ChatRefList(
  items: (json['items'] as List<dynamic>)
      .map((e) => ChatSharedRef.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$ChatRefListToJson(_ChatRefList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
