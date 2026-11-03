// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageRef _$ChatMessageRefFromJson(Map<String, dynamic> json) =>
    _ChatMessageRef(
      refId: json['ref_id'] as String,
      kind: ChatMessageRefKind.fromJson(json['kind'] as String),
      targetId: json['target_id'] as String,
    );

Map<String, dynamic> _$ChatMessageRefToJson(_ChatMessageRef instance) =>
    <String, dynamic>{
      'ref_id': instance.refId,
      'kind': _$ChatMessageRefKindEnumMap[instance.kind]!,
      'target_id': instance.targetId,
    };

const _$ChatMessageRefKindEnumMap = {
  ChatMessageRefKind.task: 'task',
  ChatMessageRefKind.department: 'department',
  ChatMessageRefKind.file: 'file',
  ChatMessageRefKind.$unknown: r'$unknown',
};
