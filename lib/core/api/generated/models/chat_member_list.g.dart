// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMemberList _$ChatMemberListFromJson(Map<String, dynamic> json) =>
    _ChatMemberList(
      items: (json['items'] as List<dynamic>)
          .map((e) => ChatMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      truncated: json['truncated'] as bool,
    );

Map<String, dynamic> _$ChatMemberListToJson(_ChatMemberList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'truncated': instance.truncated,
    };
