// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatList _$ChatListFromJson(Map<String, dynamic> json) => _ChatList(
  items: (json['items'] as List<dynamic>)
      .map((e) => ChatSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String,
);

Map<String, dynamic> _$ChatListToJson(_ChatList instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'next_cursor': instance.nextCursor,
};
