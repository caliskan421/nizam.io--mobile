// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserList _$UserListFromJson(Map<String, dynamic> json) => _UserList(
  users: (json['users'] as List<dynamic>?)
      ?.map((e) => KnownUser.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$UserListToJson(_UserList instance) => <String, dynamic>{
  'users': ?instance.users?.map((e) => e.toJson()).toList(),
  'next_cursor': ?instance.nextCursor,
};
