// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_chat_members_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddChatMembersRequest _$AddChatMembersRequestFromJson(
  Map<String, dynamic> json,
) => _AddChatMembersRequest(
  accountIds: (json['account_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AddChatMembersRequestToJson(
  _AddChatMembersRequest instance,
) => <String, dynamic>{'account_ids': instance.accountIds};
