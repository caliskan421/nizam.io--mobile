// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_account_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeletedAccountList _$DeletedAccountListFromJson(Map<String, dynamic> json) =>
    _DeletedAccountList(
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => DeletedAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$DeletedAccountListToJson(_DeletedAccountList instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
