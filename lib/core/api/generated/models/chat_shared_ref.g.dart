// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_shared_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatSharedRef _$ChatSharedRefFromJson(Map<String, dynamic> json) =>
    _ChatSharedRef(
      refId: json['ref_id'] as String,
      kind: ChatSharedRefKind.fromJson(json['kind'] as String),
      targetId: json['target_id'] as String,
      messageId: json['message_id'] as String,
      senderAccountId: json['sender_account_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChatSharedRefToJson(_ChatSharedRef instance) =>
    <String, dynamic>{
      'ref_id': instance.refId,
      'kind': _$ChatSharedRefKindEnumMap[instance.kind]!,
      'target_id': instance.targetId,
      'message_id': instance.messageId,
      'sender_account_id': instance.senderAccountId,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ChatSharedRefKindEnumMap = {
  ChatSharedRefKind.task: 'task',
  ChatSharedRefKind.department: 'department',
  ChatSharedRefKind.file: 'file',
  ChatSharedRefKind.$unknown: r'$unknown',
};
