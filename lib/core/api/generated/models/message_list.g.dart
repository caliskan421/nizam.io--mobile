// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageList _$MessageListFromJson(Map<String, dynamic> json) => _MessageList(
  items: (json['items'] as List<dynamic>)
      .map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String,
);

Map<String, dynamic> _$MessageListToJson(_MessageList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };
