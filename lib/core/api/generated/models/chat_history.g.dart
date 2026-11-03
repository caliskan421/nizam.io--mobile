// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatHistory _$ChatHistoryFromJson(Map<String, dynamic> json) => _ChatHistory(
  items: (json['items'] as List<dynamic>)
      .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  peerReadSeq: (json['peer_read_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChatHistoryToJson(_ChatHistory instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'peer_read_seq': ?instance.peerReadSeq,
    };
