// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_ref_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRefSummary _$ChatRefSummaryFromJson(Map<String, dynamic> json) =>
    _ChatRefSummary(
      refId: json['ref_id'] as String,
      kind: ChatRefSummaryKind.fromJson(json['kind'] as String),
      targetId: json['target_id'] as String,
      chatId: json['chat_id'] as String,
      messageId: json['message_id'] as String,
      available: json['available'] as bool,
      task: json['task'] == null
          ? null
          : Task.fromJson(json['task'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : ChatRefSummaryDepartment.fromJson(
              json['department'] as Map<String, dynamic>,
            ),
      file: json['file'] == null
          ? null
          : File.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRefSummaryToJson(_ChatRefSummary instance) =>
    <String, dynamic>{
      'ref_id': instance.refId,
      'kind': _$ChatRefSummaryKindEnumMap[instance.kind]!,
      'target_id': instance.targetId,
      'chat_id': instance.chatId,
      'message_id': instance.messageId,
      'available': instance.available,
      'task': ?instance.task?.toJson(),
      'department': ?instance.department?.toJson(),
      'file': ?instance.file?.toJson(),
    };

const _$ChatRefSummaryKindEnumMap = {
  ChatRefSummaryKind.task: 'task',
  ChatRefSummaryKind.department: 'department',
  ChatRefSummaryKind.file: 'file',
  ChatRefSummaryKind.$unknown: r'$unknown',
};
