// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignable_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignableList _$AssignableListFromJson(Map<String, dynamic> json) =>
    _AssignableList(
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => AssignableAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssignableListToJson(_AssignableList instance) =>
    <String, dynamic>{
      'accounts': ?instance.accounts?.map((e) => e.toJson()).toList(),
    };
