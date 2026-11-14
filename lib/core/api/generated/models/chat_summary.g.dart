// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatSummary _$ChatSummaryFromJson(Map<String, dynamic> json) => _ChatSummary(
  chatId: json['chat_id'] as String,
  kind: ChatKind.fromJson(json['kind'] as String),
  name: json['name'] as String?,
  source: ChatSource.fromJson(json['source'] as String),
  sourceDepartmentId: json['source_department_id'] as String?,
  autoKind: json['auto_kind'] == null
      ? null
      : ChatAutoKind.fromJson(json['auto_kind'] as String),
  createdByAccountId: json['created_by_account_id'] as String?,
  counterpartAccountId: json['counterpart_account_id'] as String?,
  counterpartName: json['counterpart_name'] as String?,
  lastSeq: (json['last_seq'] as num).toInt(),
  lastMessageAt: json['last_message_at'] == null
      ? null
      : DateTime.parse(json['last_message_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  unreadCount: (json['unread_count'] as num).toInt(),
  mentioned: json['mentioned'] as bool,
  lastMessage: json['last_message'] == null
      ? null
      : ChatLastMessage.fromJson(json['last_message'] as Map<String, dynamic>),
  autoDepartmentId: json['auto_department_id'] as String?,
  role: json['role'] == null ? null : ChatRole.fromJson(json['role'] as String),
  peerOnline: json['peer_online'] as bool?,
  peerLastSeenAt: json['peer_last_seen_at'] == null
      ? null
      : DateTime.parse(json['peer_last_seen_at'] as String),
);

Map<String, dynamic> _$ChatSummaryToJson(_ChatSummary instance) =>
    <String, dynamic>{
      'chat_id': instance.chatId,
      'kind': _$ChatKindEnumMap[instance.kind]!,
      'name': ?instance.name,
      'source': _$ChatSourceEnumMap[instance.source]!,
      'source_department_id': ?instance.sourceDepartmentId,
      'auto_kind': ?_$ChatAutoKindEnumMap[instance.autoKind],
      'created_by_account_id': ?instance.createdByAccountId,
      'counterpart_account_id': ?instance.counterpartAccountId,
      'counterpart_name': ?instance.counterpartName,
      'last_seq': instance.lastSeq,
      'last_message_at': ?instance.lastMessageAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'unread_count': instance.unreadCount,
      'mentioned': instance.mentioned,
      'last_message': ?instance.lastMessage?.toJson(),
      'auto_department_id': ?instance.autoDepartmentId,
      'role': ?_$ChatRoleEnumMap[instance.role],
      'peer_online': ?instance.peerOnline,
      'peer_last_seen_at': ?instance.peerLastSeenAt?.toIso8601String(),
    };

const _$ChatKindEnumMap = {
  ChatKind.direct: 'direct',
  ChatKind.group: 'group',
  ChatKind.$unknown: r'$unknown',
};

const _$ChatSourceEnumMap = {
  ChatSource.none: 'none',
  ChatSource.department: 'department',
  ChatSource.program: 'program',
  ChatSource.$unknown: r'$unknown',
};

const _$ChatAutoKindEnumMap = {
  ChatAutoKind.department: 'department',
  ChatAutoKind.general: 'general',
  ChatAutoKind.$unknown: r'$unknown',
};

const _$ChatRoleEnumMap = {
  ChatRole.admin: 'admin',
  ChatRole.founder: 'founder',
  ChatRole.member: 'member',
  ChatRole.$unknown: r'$unknown',
};
