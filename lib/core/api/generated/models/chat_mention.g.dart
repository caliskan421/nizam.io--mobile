// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_mention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMention _$ChatMentionFromJson(Map<String, dynamic> json) => _ChatMention(
  kind: ChatMentionKind.fromJson(json['kind'] as String),
  targetId: json['target_id'] as String?,
);

Map<String, dynamic> _$ChatMentionToJson(_ChatMention instance) =>
    <String, dynamic>{
      'kind': _$ChatMentionKindEnumMap[instance.kind]!,
      'target_id': ?instance.targetId,
    };

const _$ChatMentionKindEnumMap = {
  ChatMentionKind.account: 'account',
  ChatMentionKind.department: 'department',
  ChatMentionKind.all: 'all',
  ChatMentionKind.$unknown: r'$unknown',
};
