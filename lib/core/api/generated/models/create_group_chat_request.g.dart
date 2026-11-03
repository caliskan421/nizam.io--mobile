// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateGroupChatRequest _$CreateGroupChatRequestFromJson(
  Map<String, dynamic> json,
) => _CreateGroupChatRequest(
  name: json['name'] as String,
  memberAccountIds: (json['member_account_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  source: json['source'] == null
      ? null
      : CreateGroupChatRequestSource.fromJson(json['source'] as String),
  sourceDepartmentId: json['source_department_id'] as String?,
);

Map<String, dynamic> _$CreateGroupChatRequestToJson(
  _CreateGroupChatRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'member_account_ids': instance.memberAccountIds,
  'source': ?_$CreateGroupChatRequestSourceEnumMap[instance.source],
  'source_department_id': ?instance.sourceDepartmentId,
};

const _$CreateGroupChatRequestSourceEnumMap = {
  CreateGroupChatRequestSource.none: 'none',
  CreateGroupChatRequestSource.department: 'department',
  CreateGroupChatRequestSource.program: 'program',
  CreateGroupChatRequestSource.$unknown: r'$unknown',
};
